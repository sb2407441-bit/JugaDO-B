<#
.SYNOPSIS
  Connect The Agency specialist roster (D:\Resources\agency-agents) into
  OpenWorker as personas — an awesome AI employee team.

.DESCRIPTION
  1. Reads a roster of agent slugs (one per line, '#' comments allowed).
  2. Scans the agency-agents repo for the matching agent definitions.
  3. Generates OpenWorker persona manifests (personas/agency/<slug>.md) with
     valid persona frontmatter (id, name, icon, family, tools, ...).
  4. Without -Approve: dry-run. Generates manifests and prints a consent
     table (id, name, family, tools, workspace) — nothing touches the server.
  5. With -Approve: installs the generated manifests into the running
     OpenWorker server via POST /v1/personas/install, then enables and
     surfaces each persona (POST /v1/personas/{id}).

.PARAMETER Approve
  Actually install + enable personas in OpenWorker. Without it, only the
  manifest generation and consent preview happen (safe, no server calls).

.PARAMETER RosterPath
  Path to the roster file. Default: scripts/agency-roster.txt

.PARAMETER AgencyRoot
  Path to the agency-agents repo. Default: D:\Resources\agency-agents

.PARAMETER OutDir
  Where generated persona manifests are written.
  Default: <workspace>\personas\agency

.PARAMETER ServerUrl
  OpenWorker server base URL. Default: http://127.0.0.1:8765

.PARAMETER Port
  Used to locate the sidecar token file (<state-dir>/sidecar-<port>.token).
  Default: 8765

.EXAMPLE
  .\scripts\install-agency-personas.ps1
  .\scripts\install-agency-personas.ps1 -Approve
#>

[CmdletBinding()]
param(
    [switch]$Approve,
    [switch]$All,
    [string]$RosterPath = "",
    [string]$AgencyRoot = "",
    [string]$OutDir = "",
    [string]$ServerUrl = "http://127.0.0.1:8765",
    [int]$Port = 8765
)

$ErrorActionPreference = "Stop"
$WorkspaceRoot = Split-Path $PSScriptRoot -Parent
if (-not $RosterPath) { $RosterPath = Join-Path $PSScriptRoot "agency-roster.txt" }
if (-not $OutDir) { $OutDir = Join-Path $WorkspaceRoot "personas\agency" }
if (-not $AgencyRoot) { $AgencyRoot = Join-Path $WorkspaceRoot "vendor\agency-agents" }

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# slugify: "Frontend Developer" -> "frontend-developer" (mirrors scripts/lib.sh)
function Get-Slug {
    param([string]$Name)
    $s = $Name.ToLowerInvariant()
    $s = [regex]::Replace($s, '[^a-z0-9]+', '-')
    $s = $s.Trim('-')
    return $s
}

# Read the YAML frontmatter block of an agent file into a hashtable.
function Get-Frontmatter {
    param([string]$Path)
    $lines = Get-Content -LiteralPath $Path -Encoding UTF8
    $fm = @{}
    $inFront = $false
    $fence = 0
    foreach ($line in $lines) {
        if ($line.TrimEnd() -eq '---') {
            $fence++
            if ($fence -ge 2) { break }
            $inFront = $true
            continue
        }
        if ($inFront) {
            $m = [regex]::Match($line, '^([A-Za-z0-9_-]+):\s*(.*)$')
            if ($m.Success) {
                $fm[$m.Groups[1].Value] = $m.Groups[2].Value.Trim()
            }
        }
    }
    return $fm
}

# Body = everything after the frontmatter fence.
function Get-Body {
    param([string]$Path)
    $lines = Get-Content -LiteralPath $Path -Encoding UTF8
    $fences = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i].TrimEnd() -eq '---') { $fences += $i }
    }
    if ($fences.Count -lt 2) { throw "Agent has invalid frontmatter: $Path" }
    return (($lines[($fences[1] + 1)..($lines.Count - 1)]) -join "`n").Trim()
}

# YAML plain scalars are fragile for descriptions containing a colon, #, or
# quotes. Quote every field sourced from an Agency Agent file instead.
function ConvertTo-YamlString {
    param([AllowNull()][string]$Value)
    $safe = if ($null -eq $Value) { '' } else { ($Value -replace "[\r\n]+", ' ').Trim() }
    return "'" + $safe.Replace("'", "''") + "'"
}

# Divisions that get a code (git-workspace) persona; the rest are knowledge.
$CodeDivisions = @('engineering', 'security', 'testing', 'game-development', 'gis', 'spatial-computing', 'specialized')

function Get-PersonaTools {
    param([string]$Division)
    if ($CodeDivisions -contains $Division) {
        return @('code_files', 'git', 'search', 'shell', 'todo')
    }
    return @('files', 'search', 'shell', 'todo')
}

# ---------------------------------------------------------------------------
# 1. Build slug -> agent index by scanning the agency-agents repo
# ---------------------------------------------------------------------------
Write-Host "Scanning $AgencyRoot for agent definitions..." -ForegroundColor Cyan

if (-not (Test-Path -LiteralPath $AgencyRoot)) {
    Write-Error "Agency root not found: $AgencyRoot (pass -AgencyRoot)"
}

$index = @{}
# Do not scan integrations: it contains rendered copies whose frontmatter has
# no division data, and it used to be selected before the source definition.
$divisions = @('academic', 'design', 'engineering', 'finance', 'game-development', 'gis', 'healthcare', 'marketing', 'paid-media', 'product', 'project-management', 'sales', 'security', 'spatial-computing', 'specialized', 'strategy', 'support', 'testing')
foreach ($div in $divisions) {
    $dir = Join-Path $AgencyRoot $div
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    Get-ChildItem -LiteralPath $dir -Filter *.md -File -Recurse | ForEach-Object {
        $file = $_.FullName
        $head = Get-Content -LiteralPath $file -TotalCount 1 -Encoding UTF8
        if ($head.TrimEnd() -ne '---') { return }  # not an agent file
        $fm = Get-Frontmatter $file
        $name = $fm['name']
        if (-not $name) { return }
        $slug = Get-Slug $name
        if ($slug -and -not $index.ContainsKey($slug)) {
            $index[$slug] = @{
                Path     = $file
                Division = $div
                Name     = $name
                Desc     = $fm['description']
                Emoji    = $fm['emoji']
                Vibe     = $fm['vibe']
            }
        }
    }
}
Write-Host "  Indexed $($index.Count) agents."

# ---------------------------------------------------------------------------
# 2. Read the roster
# ---------------------------------------------------------------------------
$roster = @()
if ($All) {
    $rendered = Join-Path $AgencyRoot 'integrations\opencode\agents'
    if (-not (Test-Path -LiteralPath $rendered)) { Write-Error "Full roster source missing: $rendered" }
    $roster = @(Get-ChildItem -LiteralPath $rendered -Filter *.md -File | Sort-Object Name | ForEach-Object { $_.BaseName })
} else {
    if (-not (Test-Path -LiteralPath $RosterPath)) { Write-Error "Roster file not found: $RosterPath (pass -RosterPath)" }
    foreach ($line in Get-Content -LiteralPath $RosterPath -Encoding UTF8) {
        $clean = $line -replace '#.*$', ''
        $clean = $clean.Trim()
        if ($clean) { $roster += $clean }
    }
}
Write-Host "  Roster: $($roster.Count) agents requested."

# ---------------------------------------------------------------------------
# 3. Generate persona manifests
# ---------------------------------------------------------------------------
New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

$manifests = @()
$missing = @()
foreach ($slug in $roster) {
    if (-not $index.ContainsKey($slug)) {
        $missing += $slug
        continue
    }
    $a = $index[$slug]

    if ($a.Emoji) { $icon = $a.Emoji } elseif ($a.Vibe) { $icon = 'sparkles' } else { $icon = 'briefcase' }
    $tagline = if ($a.Vibe) { $a.Vibe } elseif ($a.Desc) { $a.Desc } else { $a.Name }
    $tools = Get-PersonaTools $a.Division
    $family = if ($tools -contains 'code_files') { 'code' } else { 'knowledge' }
    $toolsList = '[' + (($tools | ForEach-Object { "'$_'" }) -join ', ') + ']'

    $body = Get-Body $a.Path
    $manifest = @(
        '---'
        "id: $(ConvertTo-YamlString $slug)"
        "name: $(ConvertTo-YamlString $a.Name)"
        "icon: $(ConvertTo-YamlString $icon)"
        "tagline: $(ConvertTo-YamlString $tagline)"
        "description: $(ConvertTo-YamlString $a.Desc)"
        "family: $family"
        "tools: $toolsList"
        'default_permission_mode: interactive'
        '---'
        ''
        $body
    ) -join "`n"

    $outFile = Join-Path $OutDir "$slug.md"
    [System.IO.File]::WriteAllText($outFile, $manifest, $utf8NoBom)

    $manifests += [PSCustomObject]@{
        Slug      = $slug
        Name      = $a.Name
        Division  = $a.Division
        Family    = $family
        Tools     = $toolsList
        Workspace = $(if ($family -eq 'code') { 'git' } else { 'deliverable' })
    }
}

Write-Host ""
Write-Host "Generated $($manifests.Count) persona manifests in $OutDir" -ForegroundColor Green
if ($missing.Count -gt 0) {
    Write-Host "  Skipped $($missing.Count) slugs not found in the agency repo:" -ForegroundColor Yellow
    Write-Host "    $($missing -join ', ')"
}

# ---------------------------------------------------------------------------
# 4. Consent table / dry run
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host ("{0,-28} {1,-24} {2,-10} {3,-10}" -f 'ID', 'NAME', 'FAMILY', 'WORKSPACE')
Write-Host ("{0,-28} {1,-24} {2,-10} {3,-10}" -f '--', '----', '------', '---------')
foreach ($m in $manifests) {
    Write-Host ("{0,-28} {1,-24} {2,-10} {3,-10}" -f $m.Slug, $m.Name, $m.Family, $m.Workspace)
}
Write-Host ""
Write-Host "Tools per persona:" -ForegroundColor Cyan
Write-Host "  code family      -> [code_files, git, search, shell, todo]  (git workspace)"
Write-Host "  knowledge family -> [files, search, shell, todo]            (deliverable workspace)"

if (-not $Approve) {
    Write-Host ""
    Write-Host "DRY RUN - nothing was installed." -ForegroundColor Yellow
    Write-Host "Review the consent table, then run with -Approve to install into OpenWorker at $ServerUrl" -ForegroundColor Yellow
    Write-Host "  .\scripts\install-agency-personas.ps1$(if ($All) { ' -All' }) -Approve"
    exit 0
}

# ---------------------------------------------------------------------------
# 5. Install into OpenWorker (approval granted)
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "Approval granted. Installing into OpenWorker at $ServerUrl ..." -ForegroundColor Green

$stateDir = $env:COWORKER_STATE_DIR
if (-not $stateDir) {
    $stateDir = Join-Path $env:APPDATA "coworker"
}
$tokenFile = Join-Path $stateDir "sidecar-$Port.token"
$token = $null
if (Test-Path -LiteralPath $tokenFile) {
    $token = (Get-Content -LiteralPath $tokenFile -Raw -Encoding UTF8).Trim()
    Write-Host "  Using sidecar token from $tokenFile"
} else {
    Write-Host "  No sidecar token at $tokenFile - calling unauthenticated." -ForegroundColor DarkYellow
}

$headers = @{ 'Content-Type' = 'application/json' }
if ($token) { $headers['X-OpenWorker-Token'] = $token }

$installBody = @{ dir = (Resolve-Path -LiteralPath $OutDir).Path } | ConvertTo-Json -Compress

try {
    $resp = Invoke-RestMethod -Uri "$ServerUrl/v1/personas/install" -Method Post -Headers $headers -Body $installBody
} catch {
    Write-Error "Install failed. Is the OpenWorker server running at $ServerUrl?`n$($_.Exception.Message)"
    exit 1
}

if (-not $resp.ok) {
    Write-Error "Server refused install: $($resp.error)"
    exit 1
}

$installed = @($resp.consent | ForEach-Object { $_.id })
Write-Host "  Server accepted $($installed.Count) personas (landed disabled, pending consent)."

# Enable + surface each newly installed persona.
$enabled = 0
foreach ($id in $installed) {
    if ($roster -notcontains $id) { continue }
    $enableBody = @{ enabled = $true; surfaced = $true } | ConvertTo-Json -Compress
    try {
        $upd = Invoke-RestMethod -Uri "$ServerUrl/v1/personas/$id" -Method Post -Headers $headers -Body $enableBody
        if ($upd.ok) { $enabled++ }
    } catch {
        Write-Host "  Failed to enable $id : $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
Write-Host ""
Write-Host "Enabled + surfaced $enabled personas. Your agency is now an OpenWorker employee team." -ForegroundColor Green
Write-Host "Open the OpenWorker app -> Personas to pick a specialist for a new session." -ForegroundColor Cyan
