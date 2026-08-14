# Human AI (formerly OpenWorker) — Deployment Risk Assessment & Operations Guide

*Generated: 2026-08-14*

---

## 1. Critical Deployment Errors to Watch

### 1.1 Authentication & Token Issues
| Error | Cause | Mitigation |
|-------|-------|------------|
| `401 Unauthorized` on all API calls | GUI baked stale token; server restarted without Vite restart | Token reuse implemented in `run.py:_ensure_api_token`; restart both server + Vite together |
| `403 Forbidden` on WebSocket | Token mismatch or missing `sec-websocket-protocol` | Ensure Vite reads token at startup via `__COWORKER_DEV_TOKEN__` |
| `401` on `/v1/settings`, `/v1/personas`, `/v1/sessions` | GUI token not sent (empty `apiToken()`) | Vite config reads `sidecar-8765.token` at dev startup |

### 1.2 Provider Routing Errors
| Error | Cause | Mitigation |
|-------|-------|------------|
| `429 Rate limit exceeded` (Gemini) | Free tier daily quota exhausted | Chain falls through: OmniRoute → LLM7 → Gemini → Groq |
| `413 Request too large` (Groq) | TPM 8000 limit vs ~18k token requests | Size guard in `router.py` skips Groq for >7000 token prompts |
| `400 Multiple tool calls with same id` (HF Gateway) | Duplicate `call_0` IDs in history | Fixed in `openai_provider.py:_sanitize_messages` + `_unique_call_ids` |
| `404 Not Found` on OmniRoute models | OmniRoute gateway not running | Ensure `npm run dev` in `D:\Resources\OmniRoute` on port 20128 |

### 1.3 Model Chain Issues
| Issue | Cause | Fix |
|-------|-------|-----|
| Session stuck on old model | Session model not refreshed from chain | New sessions get chain; existing sessions need manual switch |
| OmniRoute models not in picker | Matrix not updated | Added 40+ OmniRoute entries to `matrix.py` |
| Free-tier models missing | Provider not registered | LLM7 (keyless), SambaNova, HuggingFace registered |

### 1.4 Windows-Specific Issues
| Issue | Cause | Workaround |
|-------|-------|------------|
| `test_standalone_server_token_file_is_user_only` fails | POSIX `0o600` mode check fails on Windows | Known pre-existing; token file permissions work correctly |
| `test_workspace_command_trust_controls_live_engine` fails | WinError 32 file lock | Known pre-existing; trust works in practice |
| PowerShell `Set-Content` writes BOM | Breaks `json.loads` | Use Python for JSON file writes |

---

## 2. Logical Issues to Avoid

### 2.1 Architecture & Design
- **Don't hardcode model chains in multiple places** → Single source: `prefs.json` `default_model` + `config.toml` `model`
- **Don't assume provider order is static** → Chain is dynamic; UI shows current chain from server
- **Don't cache tokens in clients** → File-backed clients must re-read on 401
- **Don't skip size guards** → Groq 413s burn quota and delay fallback

### 2.2 Session Management
- **Don't persist test sessions** → Clean up via `DELETE /v1/sessions/{id}` after verification
- **Don't reuse session IDs across tests** → Use unique IDs (`live-test-1`, `omni-test-1`, etc.)
- **Don't assume fresh session = default chain** → Verify via `ready.model` event

### 2.3 Provider Integration
- **Don't add providers without matrix entries** → GUI picker needs `matrix.py` labels + context windows
- **Don't use keyless providers for production without fallback** → LLM7/SambaNova are free but rate-limited
- **Don't ignore tool-call ID sanitization** → HF Gateway and other compat backends need `_sanitize_messages`

### 2.4 State & Persistence
- **Don't write JSON via PowerShell `Set-Content`** → BOM breaks parsing; use Python
- **Don't assume `state_dir()` is static** → Respects `COWORKER_STATE_DIR` env var
- **Don't delete token file manually** → Server regenerates; GUI will 401 until Vite restart

---

## 3. Operational Runbooks

### 3.1 Daily Startup Sequence
```powershell
# 1. Start OmniRoute gateway (keep running)
cd D:\Resources\OmniRoute
npm run dev  # Port 20128

# 2. Start Human AI server
cd D:\OPENWORKER
.\.venv\Scripts\python.exe -m coworker.server.run --cwd D:\OPENWORKER --port 8765

# 3. Start GUI (Vite dev server)
cd D:\OPENWORKER\surfaces\gui
node node_modules\vite\bin\vite.js --port 5175 --strictPort
```

### 3.2 Restart Server (preserves token)
```powershell
# Kill old server
Get-Process -Name python | Where-Object {$_.CommandLine -match "coworker.server.run"} | Stop-Process -Force

# Restart - token file is REUSED (no 401 for GUI)
.\.venv\Scripts\python.exe -m coworker.server.run --cwd D:\OPENWORKER --port 8765
```

### 3.3 Restart GUI (re-reads token)
```powershell
# Kill old Vite
Get-Process -Name node | Where-Object {$_.CommandLine -match "vite"} | Stop-Process -Force

# Restart - bakes current token
cd D:\OPENWORKER\surfaces\gui
node node_modules\vite\bin\vite.js --port 5175 --strictPort
```

### 3.4 Add SambaNova Key (when available)
1. Get free token from https://cloud.sambanova.ai
2. GUI → Settings → Providers → SambaNova → Paste key
3. Add to chain via Settings → Models → Add model: `sambanova:DeepSeek-V3.2`

### 3.5 Verify Health
```powershell
# API health
$tok = (Get-Content "$env:APPDATA\coworker\sidecar-8765.token").Trim()
Invoke-RestMethod "http://127.0.0.1:8765/v1/health" -Headers @{"x-openworker-token"=$tok}

# GUI
Invoke-WebRequest "http://localhost:5175"

# OmniRoute
Invoke-WebRequest "http://127.0.0.1:20128/v1/models" -Headers @{"Authorization"="Bearer <key>"}
```

---

## 4. Known Limitations (Accepted Risks)

| Limitation | Impact | Acceptance |
|------------|--------|------------|
| OmniRoute must run separately | Extra process to manage | Low - single `npm run dev` |
| Vite token staleness on manual token delete | 401 until Vite restart | Low - rare operation |
| GUI model chip lags after mid-turn fall-through | Cosmetic only | Low - refresh fixes |
| No virtual scroll for 300+ models | Client-side list | Medium - current ~150 models OK |
| SambaNova requires manual key | Free tier needs token | Low - one-time setup |
| Slack relay tests timeout | External dependency | Accepted - not core functionality |

---

## 5. Monitoring Checklist (Per Session)

- [ ] `GET /v1/health` returns 200 with model chain
- [ ] `GET /v1/settings` returns full model list with labels
- [ ] GUI loads at `:5175` with 0 console errors
- [ ] Model picker opens, shows grouped providers, search works
- [ ] New session → persona picker → folder picker all functional
- [ ] Agent turn completes with tools (write_file, read_file)
- [ ] No 429/413/400 in server logs
- [ ] Token file stable across restarts

---

## 6. Escalation Contacts

| Issue | Owner | Channel |
|-------|-------|---------|
| Server crashes / 500s | Platform Architect | Immediate |
| OmniRoute gateway down | Platform Architect | Within 15 min |
| Provider 429/413 storms | Platform Architect | Within 30 min |
| GUI 401/403 persistent | Frontend Lead | Immediate |
| Data loss / session corruption | Corporate Chief of Staff | Immediate |

---

*This document is living — update after each deployment or incident.*