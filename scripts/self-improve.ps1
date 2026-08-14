$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$logPath = Join-Path $root 'corporation\DECISION-LOG.md'
$outPath = Join-Path $root 'runtime-state\self-improve-report.md'

if (-not (Test-Path -LiteralPath $logPath)) {
    Write-Error "DECISION-LOG.md not found at $logPath"
}

$lines = Get-Content -LiteralPath $logPath
$text = Get-Content -LiteralPath $logPath -Raw

# --- Observe: split the log into entries ---
$entries = @()
$current = $null
foreach ($line in $lines) {
    if ($line -match '^##\s+\d{4}-\d{2}-\d{2}') {
        if ($current) { $entries += $current }
        $current = @{ Header = $line.Trim('#'); Body = @(); Slug = ($line -replace '^##\s+', '').Trim() }
    } elseif ($current) {
        $current.Body += $line
    }
}
if ($current) { $entries += $current }

# --- Analyze: structured signals ---
$patterns = @(
    @{ Name = 'visual QA unavailable (agent cannot view images)';  Regex = 'cannot (view|visually inspect|see) (images|screenshots|the|a)|no image input support|no browser tooling|agent cannot view' },
    @{ Name = 'manual / human QA follow-up requested';              Regex = 'human eye-check|visual review|manual QA|recommend a human' },
    @{ Name = 'placeholder content flagged';                        Regex = 'placeholder' },
    @{ Name = 'research gap / empty footprint reported honestly';   Regex = 'empty public footprint|no .*found|no verifiable|closest candidate' },
    @{ Name = 'risk or open item recorded';                         Regex = 'Known risks|open items|open risk' },
    @{ Name = 'external side-effect / credential gate invoked';     Regex = 'credential|approval|deploy|purchase|external-write' }
)

$signals = @()
foreach ($p in $patterns) {
    $m = [regex]::Matches($text, $p.Regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($m.Count -gt 0) {
        $signals += [pscustomobject]@{ Signal = $p.Name; Count = $m.Count }
    }
}

$routingOwners = @{}
foreach ($e in $entries) {
    foreach ($line in $e.Body) {
        if ($line -match '^\s*- Owner:\s*(.+)$') {
            $owner = $matches[1]
            if ($owner -match '^\s*([^(]+?)\s*\(') { $owner = $matches[1] }
            $owner = ($owner -split '\.')[0].Trim()
            if ($owner) {
                if ($routingOwners.ContainsKey($owner)) { $routingOwners[$owner]++ } else { $routingOwners[$owner] = 1 }
            }
        }
    }
}

$riskLines = @()
foreach ($e in $entries) {
    $capture = $false
    foreach ($line in $e.Body) {
        if ($line -match '^(\*\*Known limits:\*\*|\*\*Known risks|\*\*Known risks / open items)') { $capture = $true; continue }
        if ($line -match '^(\*\*Next owner|\*\*Outcome|\*\*Key decisions|\*\*QA evidence|##)') { $capture = $false }
        if ($capture -and $line -match '\S') { $riskLines += (($line.Trim() -replace '^\*\*\s*|\s*\*\*$','') -replace '^\-\s*','') }
    }
}

# --- Propose ---
$proposals = New-Object System.Collections.Generic.List[string]
$severity = 'info'
if ($signals | Where-Object { $_.Signal -like 'visual QA*' -and $_.Count -ge 2 }) {
    $proposals.Add('[HIGH] Visual-QA limitation recurs across entries. Consider adding screenshot/vision-capable QA tooling (Evidence Collector with rendered images, or browser-use screenshots) before DELIVER.')
    $severity = 'attention'
}
if ($signals | Where-Object { $_.Signal -like 'placeholder*' -and $_.Count -ge 1 }) {
    $proposals.Add('[MEDIUM] Placeholder content flagged. Add a placeholder/no-fake-data check to the Content QA gate in AGENTS.md section 5.3.')
}
if ($signals | Where-Object { $_.Signal -like 'research gap*' }) {
    $proposals.Add('[LOW] Honest empty-footprint reporting is working. Keep the cite-or-flag rule; no change required.')
}
if ($riskLines.Count -ge 3) {
    $proposals.Add("[INFO] $($riskLines.Count) known-risk lines recorded. Review the highest-frequency risk cluster before the next medium/high-risk task.")
}
if ($proposals.Count -eq 0) {
    $proposals.Add('No recurring friction detected. No governance change proposed this run (keep/revert: keep current state).')
}

# --- Report ---
$report = @"
# Self-Improvement Report

Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')
Source: `corporation/DECISION-LOG.md` ($($entries.Count) entries)

## Observed signals
$(if ($signals.Count) { ($signals | Sort-Object Count -Descending | ForEach-Object { "- $($_.Signal) -> $($_.Count)x" }) -join "`n" } else { '- none' })

## Routing load (owners)
$(if ($routingOwners.Count) { ($routingOwners.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object { "- $($_.Key): $($_.Value) tasks" }) -join "`n" } else { '- none' })

## Known-risk cluster
$(if ($riskLines.Count) { $riskLines | Select-Object -Unique | Select-Object -First 8 | ForEach-Object { "- $_" } | Out-String } else { '- none' })

## Proposed improvements
$($proposals -join "`n")

## Next step
Present proposals to the Corporate Chief of Staff. Apply only with approval; revert on regression (keep/revert rule, see corporation/SELF-IMPROVEMENT.md).
"@

New-Item -ItemType Directory -Path (Split-Path $outPath -Parent) -Force | Out-Null
$report | Set-Content -LiteralPath $outPath -Encoding UTF8
Write-Output "Report written: $outPath"
Write-Output "Entries analysed: $($entries.Count)"
$signals | Sort-Object Count -Descending | ForEach-Object { Write-Output ('  {0}x  {1}' -f $_.Count, $_.Signal) }
