# Department routing

| Need | Accountable role | Typical reviewers |
|---|---|---|
| Business priorities and cross-team work | Corporate Chief of Staff | business strategist, operations manager, project shepherd |
| Software delivery | gstack Delivery Director | product manager, software architect, test automation engineer |
| Current library/API guidance | Context7 Technical Librarian | senior developer, security architect |
| Internet/company/market research | Agent Reach Researcher | evidence collector, financial analyst, SEO specialist |
| Security or privacy | security architect | application security, privacy engineer, compliance auditor |
| Data/reporting | data engineer | data visualization engineer, statistician |
| Growth/sales/customer operations | business strategist | sales engineer, customer success, marketing specialist |
| Solar/energy or automotive operations | operations manager | ESG sustainability, IoT fleet, supply chain, finance, civil engineering |
| UI, frontend, or design-system work | frontend/design lead | UI/UX specialist, product designer, accessibility engineer, motion designer |
| Browser QA, extraction, or web workflow | browser automation lead | QA engineer, UX researcher, security architect |
| Security testing or threat validation | security architect | application security, privacy engineer, compliance auditor |
| SEO, content growth, or social operations | growth lead | SEO specialist, content strategist, customer success, compliance auditor |
| GIS, mapping, buildings, or spatial visualization | geospatial lead | civil engineer, data engineer, frontend engineer, solar/energy specialist |
| Voice UI or narrated media | voice/media lead | audio engineer, product designer, accessibility specialist |
| Model cost, fallback, or provider routing | platform architect | finance/operations, security architect, software architect |

Use specialists by their enabled OpenWorker persona ids in `personas/agency`. The directors create
handoff briefs; OpenWorker sessions and approvals perform the work.

## Resource selection

The detailed resource-to-capability mapping lives in `corporation/RESOURCE-CAPABILITY-MAP.md` and
the machine-readable registry in `corporation/RESOURCE_CATALOG.json`. Treat `connected` entries
as ready, `optional-adapter` entries as proposal-only, and `reference-only` entries as material to
consult rather than software to start. `reserved` entries require an explicit architecture and
isolation decision.
