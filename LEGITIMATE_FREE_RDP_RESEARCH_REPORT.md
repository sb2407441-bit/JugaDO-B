# Legitimate Free RDP/VPS Resources Research Report

**Prepared:** August 13, 2026  
**Scope:** Authentic, legal, sustainable free RDP/VPS methods — no fraud, no gray-market services  
**Methodology:** Authoritative provider documentation, reputable tech publications, community-verified guides

---

## Executive Summary

| Category | Best Overall Option | Key Limitation |
|----------|---------------------|----------------|
| **Always-Free VPS (Linux)** | Oracle Cloud Always Free (4 ARM cores, 24 GB RAM, 200 GB, 10 TB/mo) | ARM architecture; capacity issues; idle reclamation |
| **Always-Free VPS (Windows RDP)** | Azure for Students (if eligible) / Oracle x86 (1 core, 1 GB) | Student verification required; x86 very limited |
| **Best Trial Credits** | Google Cloud ($300/90 days) + GCP Always Free e2-micro | US regions only for always-free |
| **Best Self-Hosted Remote Desktop** | RustDesk (TeamViewer-like) / MeshCentral (fleet mgmt) / Guacamole (browser gateway) | Requires your own VPS/server |
| **Best Student Pack** | GitHub Student Developer Pack ($200 DO + 50+ tools) | Requires .edu or verified enrollment |
| **Best Browser Isolation** | Kasm Workspaces Community Edition (5 concurrent sessions) | Resource-heavy; 5-session limit |

---

## 1. Legitimate Free VPS/RDP Providers (Always-Free Tiers)

### 1.1 Oracle Cloud Always Free — **Top Recommendation for Linux**

| Attribute | Details |
|-----------|---------|
| **Official URL** | https://www.oracle.com/cloud/free/ |
| **Compute** | Up to 4 Ampere A1 ARM cores (OCPU) — 24 GB RAM total |
| **Storage** | 200 GB Block Volume + 10 GB Object Storage |
| **Network** | 10 TB/month outbound |
| **OS Support** | Linux (Ubuntu, Oracle Linux, CentOS); Windows Server *requires paid license* |
| **Duration** | Forever (Always Free tier) |
| **Credit Card** | Required for identity verification ($1–2 auth hold, refunded) |
| **Regions** | Limited; home region locked at signup (Ashburn, Phoenix, London, etc.) |

**Key Constraints (from Oracle FAQ & community reports):**
- ARM architecture — x86 software (many Windows apps, some containers) won't run
- Signup frequently rejected (fraud prevention); try home IP, real info, different browser
- Idle instances reclaimed if CPU/RAM < 10% for 7+ days — add cron job to prevent
- No SLA; capacity not guaranteed ("Out of capacity" errors common)
- Windows Server images require BYOL (Bring Your Own License) — not free

**Sources:**
- Oracle Cloud Free Tier: https://www.oracle.com/cloud/free/
- Oracle Always Free Resources Doc: https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
- Community guide (1vps.com, 2026): https://1vps.com/free-vps-hosting
- InfraFree comparison (2026): https://infrafree.dev/en-us/category/compute

---

### 1.2 Google Cloud Platform (GCP) Always Free

| Attribute | Details |
|-----------|---------|
| **Official URL** | https://cloud.google.com/free |
| **Always Free VM** | 1 × e2-micro (2 shared vCPU, 1 GB RAM) |
| **Storage** | 30 GB Standard Persistent Disk |
| **Network** | 1 GB/month egress (US regions only) |
| **Regions** | us-west1 (Oregon), us-central1 (Iowa), us-east1 (S. Carolina) **only** |
| **Trial Credit** | $300 for 90 days (all regions, all services) |
| **Credit Card** | Required (verification only; no auto-charge after trial) |
| **Windows** | Not included in Always Free; trial credit covers Windows VMs |

**Limitations:**
- 1 GB RAM is very tight for Windows RDP; usable for Linux + xrdp/Guacamole
- 1 GB/month egress is extremely low — exceeds quickly with any proxy/VPN
- Always Free restricted to 3 US regions

**Sources:**
- GCP Free Tier: https://cloud.google.com/free
- SamNet guide (2026): https://www.samnet.dev/learn/guides/free-vps-guide

---

### 1.3 AWS Free Tier (12-Month Trial)

| Attribute | Details |
|-----------|---------|
| **Official URL** | https://aws.amazon.com/free/ |
| **Compute** | 750 hrs/mo t2.micro or t3.micro (1 vCPU, 1 GB RAM) |
| **Storage** | 30 GB EBS (General Purpose SSD) |
| **Network** | 15 GB/month outbound (first 12 months) |
| **Duration** | 12 months only — then pay-as-you-go |
| **Credit Card** | Required |
| **Windows** | Included in free tier (Windows Server t2.micro/t3.micro) |

**Limitations:**
- Not "always free" — expires after 12 months
- Easy to accidentally enable non-free services; watch billing dashboard
- t2/t3.micro burstable CPU — sustained workloads throttle

**Sources:**
- AWS Free Tier: https://aws.amazon.com/free/
- CloudPriceCheck comparison (2026): https://cloudpricecheck.com/free-tier

---

### 1.4 Microsoft Azure Free Tier

| Attribute | Details |
|-----------|---------|
| **Official URL** | https://azure.microsoft.com/free/ |
| **Always Free** | 750 hrs/mo B1S VM (1 vCPU, 1 GB RAM) for 12 months |
| **Storage** | 64 GB SSD (12 months) |
| **Network** | 15 GB/month outbound (12 months) |
| **Trial Credit** | $200 for 30 days |
| **Credit Card** | Required |
| **Windows** | B1S supports Windows Server |

**Limitations:**
- $200 credit expires in 30 days (shortest of major providers)
- Always-free VM only for 12 months
- Less generous compute than Oracle/GCP

**Sources:**
- Azure Free: https://azure.microsoft.com/free/
- SamNet guide (2026): https://www.samnet.dev/learn/guides/free-vps-guide

---

### 1.5 Other Notable Providers

| Provider | Free Offering | Best For | Link |
|----------|---------------|----------|------|
| **Fly.io** | $5/mo free compute credit (forever); 3 shared VMs, 256 MB each | Tiny containers, hobby apps | https://fly.io |
| **Railway** | $5 trial credit/mo | Small web apps, databases | https://railway.app |
| **Render** | Free static sites + limited compute | Static hosting, cron jobs | https://render.com |
| **IBM Cloud** | Limited Always Free (many services deprecated) | Legacy/learning only | https://www.ibm.com/cloud/free |
| **Alibaba Cloud** | Free tier for China-based users | China-region workloads | https://www.alibabacloud.com/free-tier |

---

## 2. Cloud Provider Free Tier Comparison Table (2026)

| Feature | **Oracle Cloud** | **Google Cloud** | **AWS** | **Azure** | **DigitalOcean** |
|---------|------------------|------------------|---------|-----------|------------------|
| **Always-Free Compute** | 4 ARM cores / 24 GB RAM | 1 e2-micro (1 GB) | ❌ (12-mo only) | ❌ (12-mo only) | ❌ |
| **Trial Credit** | $300 / 30 days | $300 / 90 days | ❌ | $200 / 30 days | $200 / 60 days |
| **Always-Free Storage** | 200 GB Block + 10 GB Obj | 30 GB PD | ❌ | ❌ | ❌ |
| **Always-Free Egress** | 10 TB/mo | 1 GB/mo (US only) | ❌ | ❌ | ❌ |
| **Windows Support** | BYOL only | Trial credit only | 12-mo free tier | 12-mo free tier | Trial credit only |
| **Regions (Always Free)** | Multiple (locked at signup) | 3 US only | N/A | N/A | N/A |
| **Credit Card Required** | Yes (verify) | Yes (verify) | Yes | Yes | Yes |
| **Idle Reclamation** | Yes (7 days <10%) | No | N/A | N/A | N/A |
| **Architecture** | ARM (Ampere) | x86 (shared) | x86 | x86 | x86 |

**Sources:**
- CloudPriceCheck (2026): https://cloudpricecheck.com/free-tier
- InfraFree (2026): https://infrafree.dev/en-us/category/compute
- Aatayyab comparison (2026): https://aatayyab.wordpress.com/2026/04/01/always-free-oracle-cloud-server-vps/

---

## 3. Educational / Student Programs

### 3.1 GitHub Student Developer Pack — **Best Overall Student Bundle**

| Attribute | Details |
|-----------|---------|
| **Official URL** | https://education.github.com/pack |
| **Eligibility** | Students 13+ with .edu email OR verified enrollment (student ID, transcript) |
| **Credit Card** | **Not required** for most offers |
| **Key Cloud Credits** | |
| • DigitalOcean | $200 credit (1 year) |
| • Microsoft Azure | $100 credit + 25+ free services (12 months) |
| • AWS Educate | $35–$100 AWS credits (via pack link) |
| • Heroku | $13/mo for 24 months (Hobby dynos) |
| • Namecheap | 1 year .me domain + SSL cert |
| • JetBrains | All IDEs free (IntelliJ, PyCharm, etc.) |
| • GitHub Codespaces | Free Pro tier (60 hrs/mo) |
| • Termius | Pro SSH client free |

**Verification Alternatives (if no .edu):**
- Upload student ID / enrollment proof
- Professor-provided class join link (AWS Educate)
- Manual review by GitHub Education support (~3-5 days)

**Sources:**
- GitHub Student Pack: https://education.github.com/pack
- Cloud-tagged offers: https://education.github.com/pack?sort=popularity&tag=Cloud
- VPSWala student guide (2026): https://vpswala.org/blog/best-free-rdp-providers-for-students-no-credit-card-required

---

### 3.2 Azure for Students

| Attribute | Details |
|-----------|---------|
| **Official URL** | https://azure.microsoft.com/free/students |
| **Eligibility** | Full-time university students (18+) — verified via school email |
| **Credit Card** | **Not required** |
| **Offer** | $100 Azure credit (12 months) + 20+ free services monthly + 65+ always-free services |
| **Renewal** | Annual renewal while student status valid |
| **Windows RDP** | Native Windows Server VMs with RDP — best no-card Windows option |

**Sources:**
- Azure for Students: https://azure.microsoft.com/free/students
- Azure Student Resources: https://azure.microsoft.com/en-us/resources/students

---

### 3.3 AWS Educate

| Attribute | Details |
|-----------|---------|
| **Official URL** | https://aws.amazon.com/education/awseducate/ |
| **Eligibility** | Students 13+ / educators at accredited institutions |
| **Starter Account (No Card)** | $30–50 credits; 200+ services; learning labs; **no GPU/high-cost services** |
| **Full Account (Card Required)** | $100 credits; full AWS access including EC2 GPU |
| **Verification** | .edu email OR instructor join link |
| **Best For** | Learning AWS services, certifications, coursework |

**Sources:**
- AWS Educate Blog (2023): https://aws.amazon.com/blogs/aws/aws-educate-credits-training-content-and-collaboration-for-students-educators
- AWS re:Post student guide (2025): https://repost.aws/questions/QUdi80H8pOTTKFmwFjgks_YA/how-can-i-get-free-aws-credits-as-a-student-for-learning

---

### 3.4 Other Student Offers

| Program | Offer | Link |
|---------|-------|------|
| **DigitalOcean Student** | $100 credit (60 days) via GitHub Pack | https://www.digitalocean.com/community/questions/github-student-pack-695a823b-f867-4fd9-89a4-7a1f4b6e56aa |
| **JetBrains Student** | All IDEs free (1 year, renewable) | https://www.jetbrains.com/community/education/#students |
| **Namecheap Student** | Free .me domain + SSL (1 year) | Via GitHub Pack |
| **Microsoft Learn Sandbox** | Free temporary Azure labs (no card) | https://learn.microsoft.com/training/modules/ |

---

## 4. Open Source Self-Hosted Remote Desktop Solutions

> **Critical:** These require **your own server/VPS** (Oracle Free Tier, cheap $3-5 VPS, home lab). They are not "free RDP hosting" — they are **free software you host yourself**.

### 4.1 RustDesk — Best TeamViewer Alternative (Cross-Platform)

| Attribute | Details |
|-----------|---------|
| **License** | AGPL v3 (client + OSS server) |
| **GitHub** | https://github.com/rustdesk/rustdesk (110k+ stars) |
| **Website** | https://rustdesk.com/ |
| **Docs** | https://rustdesk.com/docs/en/self-host/ |
| **Components** | `hbbs` (ID/signaling server, TCP 21115–21118, UDP 21116) + `hbbr` (relay, TCP 21117, 21119) |
| **Platforms** | Windows, macOS, Linux, Android, iOS (controller only) |
| **Features** | Unattended access, file transfer, NAT traversal (hole punching), TLS encryption, custom key pinning |
| **Self-Host** | Docker Compose (2 containers); ~10 min setup on VPS |
| **Commercial** | Server Pro (web console, LDAP, 2FA, device groups) — paid, self-hosted |

**Quick Docker Compose (from RDP.sh guide):**
```yaml
services:
  hbbs:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbs
    command: hbbs
    network_mode: host
    volumes:
      - ./data:/root
    restart: unless-stopped
    depends_on:
      - hbbr
  hbbr:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbr
    command: hbbr
    network_mode: host
    volumes:
      - ./data:/root
    restart: unless-stopped
```
**Required Ports:** 21115–21119 TCP, 21116 UDP

**Client Config:** ID Server = your.domain.com, Key = `cat /opt/rustdesk/data/id_ed25519.pub`

**Sources:**
- RustDesk Self-Host Docs: https://rustdesk.com/docs/en/self-host/
- RDP.sh tutorial (2026): https://rdp.sh/en/blog/self-host-rustdesk-server-on-a-vps-for-private-remote-desktop
- Haack's Networking guide (2024): https://tech.haacksnetworking.org/2024/11/02/setting-up-a-self-hosted-rustdesk-instance/
- Suar Services guide (2025): https://suar.services/install-and-configure-a-self-hosted-rustdesk-server

---

### 4.2 MeshCentral — Best Fleet Management / IT Admin Tool

| Attribute | Details |
|-----------|---------|
| **License** | Apache 2.0 (permissive — commercial use OK) |
| **GitHub** | https://github.com/Ylianst/MeshCentral |
| **Website** | https://meshcentral.com/ |
| **Docker Hub** | https://hub.docker.com/r/meshcentral/meshcentral |
| **Architecture** | Single Node.js app + SQLite (default) / MongoDB (optional) |
| **Features** | Remote desktop (HTML5), terminal, file mgmt, process mgmt, remote CMD/PowerShell, Wake-on-LAN, 2FA, LDAP, user groups, device inventory |
| **Deployment** | `npm install meshcentral` OR Docker Compose (single container) |
| **Best For** | Managing fleets (10–100+ devices), IT support, MSP use |
| **Limitations** | Not a quick point-to-point tool; agent-based; UI admin-oriented |

**Docker Compose (from SelfHostedNinja):**
```yaml
version: '3.7'
services:
  meshcentral:
    image: meshcentral/meshcentral
    container_name: meshcentral
    ports:
      - "443:443"
      - "80:80"
      - "4433:4433"
    volumes:
      - ./meshcentral-data:/meshcentral-data
    environment:
      - MESH_ADMINPASS=YourAdminPassword
    restart: always
```

**Sources:**
- MeshCentral GitHub Docker: https://github.com/Ylianst/MeshCentral/tree/master/docker
- SelfHostedNinja guide (2026): https://www.selfhostedninja.com/meshcentral-the-ultimate-self-hosting-setup
- OpenSourceIsAwesome wiki: https://wiki.opensourceisawesome.com/books/mesh-central/page/meshcentral-an-open-source-self-hosted-remote-machine-management-and-access-tool
- Kent Are blog (Traefik + MongoDB): https://www.kentare.no/blog/meshcentral-mongodb-traefik-docker

---

### 4.3 Apache Guacamole — Best Clientless Browser Gateway

| Attribute | Details |
|-----------|---------|
| **License** | Apache 2.0 |
| **Website** | https://guacamole.apache.org/ |
| **Docker Hub** | https://hub.docker.com/u/guacamole |
| **Architecture** | 3 containers: `guacamole` (web UI), `guacd` (protocol proxy), `postgres`/`mysql` (auth DB) |
| **Protocols** | RDP, VNC, SSH, Telnet (via protocol plugins) |
| **Client** | **Zero-client** — HTML5 browser only |
| **Best For** | Centralized access to existing RDP/SSH/VNC servers; security teams needing audited proxy |
| **Not For** | Connecting to unconfigured machines (no agent) |

**Docker Compose (official + community):**
- Official Docker guide: https://guacamole.apache.org/doc/gug/guacamole-docker.html
- Popular compose (PostgreSQL + nginx SSL): https://github.com/boschkundendienst/guacamole-docker-compose
- Minimal compose: https://github.com/code-loading/guacamole-docker-compose

**Key Setup Steps:**
1. Generate init DB: `docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgresql > initdb.sql`
2. Configure `guacamole.properties` via environment variables
3. Reverse proxy (nginx/Caddy/Traefik) for HTTPS

**Sources:**
- Official Docker install: https://guacamole.apache.org/doc/gug/guacamole-docker.html
- Docker Hub images: https://hub.docker.com/r/guacamole/guacamole
- Community compose (1.4k stars): https://github.com/boschkundendienst/guacamole-docker-compose
- Medium manual install: https://theko2fi.medium.com/apache-guacamole-manual-installation-with-docker-compose-222cef1894e3

---

### 4.4 Kasm Workspaces — Best Browser Isolation / Container Streaming

| Attribute | Details |
|-----------|---------|
| **License** | Community Edition: Free for non-commercial/non-profit (5 concurrent sessions) |
| **Website** | https://kasmweb.com/community-edition |
| **Architecture** | Single-server installer script (Docker + Kasm images) |
| **Features** | Containerized browsers, full Linux desktops, custom workspace images, SSO, 2FA, "Open in Isolation" browser extension |
| **Resource Needs** | Min: 2 vCPU / 4 GB RAM; Rec: 4 vCPU / 8 GB RAM / 50 GB disk for 5–10 sessions |
| **Session Limit** | 5 concurrent (Community Edition) |
| **Best For** | Secure browsing, disposable environments, malware analysis, admin consoles |

**Install:**
```bash
# On Ubuntu 22.04/24.04
wget https://kasm-static-content.s3.amazonaws.com/kasm_release_1.x.x.x.tar.gz
tar -xf kasm_release_*.tar.gz
sudo bash kasm_release/install.sh
```

**Sources:**
- Kasm Community Edition: https://kasmweb.com/community-edition
- Webnestify deployment (2026): https://webnestify.cloud/insights/cybersecurity-hardening/kasm-workspaces-browser-isolation/
- VirtualizationHowto guide (2024): https://www.virtualizationhowto.com/2024/02/kasm-workspaces-install-5-steps-to-run-your-linux-desktop-inside-a-docker-container
- Liquid Web config guide: https://www.liquidweb.com/blog/virtual-desktop-environment-configuring-kasm-workspaces

---

### 4.5 Other Notable Self-Hosted Tools

| Tool | License | Type | Best For | Link |
|------|---------|------|----------|------|
| **Remmina** | GPLv2 | Client only (Linux) | Unified RDP/VNC/SSH/SPICE client | https://remmina.org/ |
| **TigerVNC** | GPLv2 | VNC server/client | LAN/VLAN remote desktop + SSH tunnel | https://tigervnc.org/ |
| **Xpra** | GPLv2+ | Persistent apps | Remote individual apps (not full desktop) | https://xpra.org/ |
| **Sunshine/Moonlight** | GPLv3 | Game streaming | Low-latency game/app streaming (NVIDIA/AMD) | https://github.com/LizardByte/Sunshine |
| **HopToDesk** | GPLv3 | TeamViewer alt | Cross-platform, free custom client | https://hoptodesk.com/ |

---

## 5. Community-Shared Resources & Legitimate Free RDP Services

### 5.1 Legitimate No-Card Free RDP (Verified)

| Service | What You Get | Constraints | Legitimacy |
|---------|--------------|-------------|------------|
| **Azure for Students** | Windows Server VM + RDP, $100 credit | Student verification (.edu) | ✅ Microsoft official |
| **GitHub Codespaces** | 60 hrs/mo Linux dev container (browser VS Code) | GitHub account + student pack | ✅ GitHub official |
| **Gitpod** | 50 hrs/mo free workspace | GitHub/GitLab integration | ✅ Official |
| **Google Colab** | Free GPU/TPU notebooks (12 GB RAM) | Session timeouts, no persistent RDP | ✅ Google official |
| **Microsoft Learn Sandbox** | Temporary Azure labs (Windows/Linux) | Time-limited, guided exercises | ✅ Microsoft official |
| **AWS Skill Builder Labs** | Guided AWS labs (free tier) | Lab-specific, temporary | ✅ AWS official |

### 5.2 ⚠️ Gray-Market / High-Risk Services (AVOID)

| Red Flag | Why It's Dangerous |
|----------|-------------------|
| "Free lifetime Windows RDP admin access" | Windows licensing costs make this impossible legitimately |
| No company name, address, ToS, abuse contact | Anonymous = unaccountable |
| Requires custom EXE/RDP launcher download | Malware/credential theft vector |
| Shared public username/password lists | Stolen/compromised credentials |
| "Unlimited bandwidth/RAM/GPU free" | Economically impossible; likely crypto-mining botnet |
| Telegram/Discord-only distribution | No accountability, ephemeral |
| Payment workarounds (gift cards, crypto, referral spam) | Fraud indicators |

**Legitimate no-card Windows RDP essentially does not exist outside student programs.** Linux VPS + xrdp/Guacamole/RustDesk is the sustainable path.

**Sources:**
- TechBloat safety guide (2026): https://www.techbloat.com/8-best-free-rdp-server-hosting-without-credit-card-apr-2026.html
- UMA Technology warning (2026): https://umatechnology.org/8-best-free-rdp-server-hosting-without-credit-card-apr-2026
- VPSWala student guide (2026): https://vpswala.org/blog/best-free-rdp-providers-for-students-no-credit-card-required

---

## 6. Self-Hosted Options for Personal Use

### 6.1 Decision Matrix: Choose Your Architecture

| Your Need | Recommended Stack | Why |
|-----------|-------------------|-----|
| **Personal remote desktop (TeamViewer-like)** | Oracle Free Tier + RustDesk (self-hosted) | Best free compute; RustDesk = cross-platform, NAT traversal, unattended access |
| **Manage family/friends' computers** | Cheap VPS ($3–5/mo) + RustDesk or MeshCentral | Reliable relay; MeshCentral = fleet UI, file mgmt, 2FA |
| **Access home lab / self-hosted services** | Tailscale/WireGuard VPN + Guacamole (browser) | Zero trust; no exposed ports; HTML5 access |
| **Secure browsing / malware analysis** | Kasm Workspaces Community (on Oracle/cheap VPS) | Disposable browser containers; isolation |
| **Windows-specific apps (Office, Adobe)** | Azure for Students (if eligible) OR Oracle x86 (1 core/1GB) + Windows BYOL | Only legitimate free Windows paths |
| **Learning cloud/DevOps** | GitHub Student Pack → DigitalOcean $200 + AWS/GCP/Azure credits | Broadest service access for education |

---

### 6.2 Recommended Personal Stacks (2026)

#### Stack A: "Maximum Free Compute" (Linux-focused)
```
VPS: Oracle Cloud Always Free (4 ARM cores, 24 GB RAM)
Remote Access: RustDesk (self-hosted hbbs/hbbr on same VPS)
VPN: Tailscale (free personal) for secure relay access
Bonus: Run Guacamole in Docker for browser-based RDP/SSH to other VMs
```
**Cost:** $0/month (forever)  
**Best For:** Developers, homelab, containers, Linux workloads

#### Stack B: "Windows RDP for Students"
```
VPS: Azure for Students ($100 credit/year) → B1S/B2S Windows VM
Remote Access: Native RDP (mstsc) + Azure Bastion (free tier) for browser access
Backup: GitHub Student Pack → DigitalOcean $200 for Linux workloads
```
**Cost:** $0 (student verified)  
**Best For:** Students needing Windows Server / Office / Visual Studio

#### Stack C: "Reliable Low-Cost Production" ($3–5/mo)
```
VPS: Vultr / RackNerd / Hetzner (~$3–5/mo, x86, 2–4 GB RAM)
Remote Access: RustDesk (self-hosted) + Tailscale VPN
Windows: Add Windows Server license (~$16/mo on Vultr) OR run Linux + xrdp/Guacamole
```
**Cost:** $3–21/month  
**Best For:** Production workloads, guaranteed uptime, x86 compatibility

#### Stack D: "Home Lab / Always-On" (Hardware you own)
```
Hardware: Old laptop / mini PC / Raspberry Pi 4/5 / Intel NUC
OS: Ubuntu Server / Proxmox VE
Remote Access: Tailscale (VPN) + Guacamole (browser) + RustDesk (direct)
Services: Pi-hole, Home Assistant, Jellyfin, *arr stack, Gitea, etc.
```
**Cost:** Electricity only (~$2–10/mo)  
**Best For:** Privacy, data sovereignty, learning, 24/7 services

---

### 6.3 Security Hardening Checklist (Any Self-Hosted Setup)

- [ ] **SSH keys only** — disable password auth (`PasswordAuthentication no`)
- [ ] **Firewall** — UFW/iptables: allow only needed ports (22, 443, RustDesk 21115–21119)
- [ ] **Fail2Ban** — block brute force on SSH/RDP ports
- [ ] **TLS everywhere** — Caddy/Traefik/nginx + Let's Encrypt for all web UIs
- [ ] **Tailscale/WireGuard VPN** — restrict management ports to tailnet only
- [ ] **Automatic updates** — `unattended-upgrades` (Debian/Ubuntu) or `dnf-automatic` (RHEL)
- [ ] **Backup keys** — RustDesk `id_ed25519.pub` / private key; MeshCentral config; Guacamole DB
- [ ] **Monitor** — Uptime Kuma / Netdata / Prometheus + Grafana for visibility

---

## 7. Quick-Start Guides (Minimal Commands)

### 7.1 RustDesk on Oracle Free Tier (5 minutes)
```bash
# 1. Provision Oracle ARM instance (Ubuntu 22.04)
# 2. SSH in, install Docker
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER && newgrp docker

# 3. Deploy RustDesk
mkdir -p /opt/rustdesk/data && cd /opt/rustdesk
cat > docker-compose.yml <<'EOF'
services:
  hbbs:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbs
    command: hbbs
    network_mode: host
    volumes: ["./data:/root"]
    restart: unless-stopped
    depends_on: [hbbr]
  hbbr:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbr
    command: hbbr
    network_mode: host
    volumes: ["./data:/root"]
    restart: unless-stopped
EOF
docker compose up -d

# 4. Open Oracle security list + UFW ports 21115–21119 TCP, 21116 UDP
# 5. Get key: cat /opt/rustdesk/data/id_ed25519.pub
# 6. Configure RustDesk clients with ID Server + Key
```

### 7.2 MeshCentral on Cheap VPS (5 minutes)
```bash
# On any Linux VPS (2 GB+ RAM recommended)
mkdir -p /opt/meshcentral && cd /opt/meshcentral
cat > docker-compose.yml <<'EOF'
version: '3.7'
services:
  meshcentral:
    image: meshcentral/meshcentral
    container_name: meshcentral
    ports: ["443:443", "80:80", "4433:4433"]
    volumes: ["./meshcentral-data:/meshcentral-data"]
    environment: [MESH_ADMINPASS=ChangeThisPassword]
    restart: always
EOF
docker compose up -d
# Access https://your-ip (accept self-signed cert or add reverse proxy)
```

### 7.3 Guacamole with PostgreSQL (15 minutes)
```bash
# Use community compose for production-ready setup
git clone https://github.com/boschkundendienst/guacamole-docker-compose.git
cd guacamole-docker-compose
./prepare.sh  # Generates DB init + self-signed cert
docker compose up -d
# Access https://your-ip:8443/guacamole (default guacadmin/guacadmin)
```

---

## 8. Sources & References (Cited in Report)

### Cloud Provider Official Pages
1. Oracle Cloud Free Tier: https://www.oracle.com/cloud/free/
2. Oracle Always Free Resources: https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
3. Google Cloud Free Tier: https://cloud.google.com/free
4. AWS Free Tier: https://aws.amazon.com/free/
5. Azure Free Tier: https://azure.microsoft.com/free/
6. Azure for Students: https://azure.microsoft.com/free/students
7. DigitalOcean Pricing: https://www.digitalocean.com/pricing
8. Fly.io Pricing: https://fly.io/pricing/

### Comparison & Review Sites (2024–2026)
9. 1vps.com Free VPS Hosting 2026: https://1vps.com/free-vps-hosting
10. InfraFree Best Free Cloud Compute 2026: https://infrafree.dev/en-us/category/compute
11. CloudPriceCheck Free Tier Comparison 2026: https://cloudpricecheck.com/free-tier
12. SamNet Free VPS Guide 2026: https://www.samnet.dev/learn/guides/free-vps-guide
13. Aatayyab Oracle Cloud Notes 2026: https://aatayyab.wordpress.com/2026/04/01/always-free-oracle-cloud-server-vps/
14. FreeVPS.edu.pl Top 5 Providers 2026: https://freevps.edu.pl/blog/top-5-free-vps-providers-2026
15. GitHub free-vps repo: https://github.com/savyasathe/free-vps

### Student Programs
16. GitHub Student Developer Pack: https://education.github.com/pack
17. GitHub Pack Cloud Offers: https://education.github.com/pack?sort=popularity&tag=Cloud
18. AWS Educate Blog: https://aws.amazon.com/blogs/aws/aws-educate-credits-training-content-and-collaboration-for-students-educators
19. AWS re:Post Student Credits: https://repost.aws/questions/QUdi80H8pOTTKFmwFjgks_YA/how-can-i-get-free-aws-credits-as-a-student-for-learning
20. DigitalOcean Student Query: https://www.digitalocean.com/community/questions/github-student-pack-695a823b-f867-4fd9-89a4-7a1f4b6e56aa

### Self-Hosted Remote Desktop Projects
21. RustDesk GitHub: https://github.com/rustdesk/rustdesk
22. RustDesk Self-Host Docs: https://rustdesk.com/docs/en/self-host/
23. RustDesk Server Pro: https://rustdesk.com/docs/en/self-host/rustdesk-server-pro/relay
24. MeshCentral GitHub: https://github.com/Ylianst/MeshCentral
25. MeshCentral Docker Hub: https://hub.docker.com/r/meshcentral/meshcentral
26. Apache Guacamole Website: https://guacamole.apache.org/
27. Guacamole Docker Guide: https://guacamole.apache.org/doc/gug/guacamole-docker.html
28. Guacamole Docker Hub: https://hub.docker.com/u/guacamole
29. Kasm Workspaces Community: https://kasmweb.com/community-edition

### Tutorials & Deployment Guides
30. RDP.sh RustDesk Tutorial 2026: https://rdp.sh/en/blog/self-host-rustdesk-server-on-a-vps-for-private-remote-desktop
31. Haack's Networking RustDesk 2024: https://tech.haacksnetworking.org/2024/11/02/setting-up-a-self-hosted-rustdesk-instance/
32. Suar Services RustDesk 2025: https://suar.services/install-and-configure-a-self-hosted-rustdesk-server
33. SelfHostedNinja MeshCentral 2026: https://www.selfhostedninja.com/meshcentral-the-ultimate-self-hosting-setup
34. OpenSourceIsAwesome MeshCentral Wiki: https://wiki.opensourceisawesome.com/books/mesh-central/page/meshcentral-an-open-source-self-hosted-remote-machine-management-and-access-tool
35. Kent Are MeshCentral + Traefik: https://www.kentare.no/blog/meshcentral-mongodb-traefik-docker
36. Webnestify Kasm Workspaces 2026: https://webnestify.cloud/insights/cybersecurity-hardening/kasm-workspaces-browser-isolation/
37. VirtualizationHowto Kasm 2024: https://www.virtualizationhowto.com/2024/02/kasm-workspaces-install-5-steps-to-run-your-linux-desktop-inside-a-docker-container
38. Liquid Web Kasm Config: https://www.liquidweb.com/blog/virtual-desktop-environment-configuring-kasm-workspaces
39. Boschkundendienst Guacamole Compose: https://github.com/boschkundendienst/guacamole-docker-compose
40. Code-Loading Minimal Guacamole: https://github.com/code-loading/guacamole-docker-compose

### Safety & Scam Warnings
41. TechBloat Free RDP Safety 2026: https://www.techbloat.com/8-best-free-rdp-server-hosting-without-credit-card-apr-2026.html
42. UMA Technology Warning 2026: https://umatechnology.org/8-best-free-rdp-server-hosting-without-credit-card-apr-2026
43. VPSWala Student Guide 2026: https://vpswala.org/blog/best-free-rdp-providers-for-students-no-credit-card-required
44. sobrii.io Open Source Remote Desktop 2026: https://sobrii.io/blog/open-source-remote-desktop
45. ComputingForGeeks Open Source Tools 2026: https://computingforgeeks.com/best-open-source-remote-desktop-tools

---

## 9. Summary Recommendations by Use Case

| Use Case | Primary Recommendation | Fallback |
|----------|------------------------|----------|
| **Linux server, forever free** | Oracle Cloud Always Free (ARM) | GCP e2-micro (US only) |
| **Windows RDP, student** | Azure for Students ($100 credit) | GitHub Pack → AWS Educate / Azure |
| **Windows RDP, non-student** | Cheap VPS ($3–5/mo) + Windows license | Oracle x86 (1 core/1GB) — very limited |
| **TeamViewer replacement** | Oracle Free Tier + self-hosted RustDesk | Tailscale + RustDesk on home hardware |
| **IT fleet management** | MeshCentral on $5 VPS or Oracle | RustDesk Server Pro (paid) |
| **Browser-based RDP/SSH gateway** | Guacamole on Oracle/cheap VPS | Apache Guacamole on home server |
| **Secure browser isolation** | Kasm Workspaces CE on 4 vCPU/8 GB VPS | Cloudflare Browser Isolation (paid) |
| **Learning cloud/DevOps** | GitHub Student Pack (all credits) | AWS/GCP/Azure individual free tiers |
| **Zero-cost, maximum privacy** | Home hardware + Tailscale + Guacamole/RustDesk | Oracle Free Tier + VPN |

---

## 10. Final Notes

1. **Oracle Cloud is the only "always free" VPS with meaningful compute** — but ARM architecture and signup friction are real barriers.
2. **Legitimate free Windows RDP requires student status** (Azure for Students) or paid Windows licensing. No legitimate provider gives free Windows Server + RDP to general public.
3. **Self-hosted open source tools (RustDesk, MeshCentral, Guacamole) are the sustainable path** — you control the server, data, and access. Pair with Oracle Free Tier or a $3–5 VPS.
4. **Avoid any "free RDP" service requiring custom downloads, shared credentials, or anonymous operators** — these are credential harvesting / malware vectors.
5. **GitHub Student Developer Pack is the highest-value single signup** — unlocks $200 DigitalOcean, $100 Azure, AWS credits, JetBrains IDEs, domains, and 50+ tools.

---

*Report compiled from authoritative sources as of August 2026. Cloud free tiers change periodically; verify current terms at provider URLs before committing resources.*