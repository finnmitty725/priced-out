# Priced Out — Project Playbook

## What this is
A live, auto-updating public dashboard tracking the **all-in cost of shelter for young Americans** (housing + energy + insurance) across 100+ US metros, plus a monthly analyst note ("The Priced Out Report").

**One-line pitch:** A live tracker of the all-in cost of shelter for young Americans — housing, energy, and insurance — with a forward-looking "break-even mortgage rate" for every city.

## Who I'm working with
- Economics major; career target is **banking & markets** (S&T / macro / rates / energy / RE coverage most aligned)
- Interests: energy & resource economics, housing affordability for their generation
- Skills: Excel, R (intermediate). Learning: APIs, Git/GitHub, Quarto, GitHub Actions
- Busy schedule: sessions of ~60–90 min, ~6–8 hrs/week
- Goal is to **learn and own every decision** — they must be able to defend any metric or line of code in an interview

## How we work
- **Teach mode** (new concepts: APIs, mortgage math, Git, pipelines): explain first, user writes/modifies code, Claude reviews.
- **Build mode** (boilerplate: styling, config, chart formatting): Claude does it and summarizes.
- User names the mode; if unstated, default to teach mode for anything conceptual, build mode for plumbing.
- **Economic assumptions are the user's call.** Claude proposes options with tradeoffs; user decides; record in `notes/decisions.md`.
- User writes a 3-line recap at the end of each session in `notes/learning-log.md`.
- **Never ask for or handle API keys in chat.** Keys live in `~/.Renviron` (never committed). `.gitignore` must exclude `.Renviron`, `.env`.
- Be honest about limits; push back on weak reasoning; invite pushback.
- README should state the project was built with AI-assisted development.

## Differentiators (vs. Atlanta Fed HOAM, NAR HAI, Zillow/Redfin, Harvard JCHS, NAHB)
1. **Young-adult lens:** income for ages 25–34, realistic 5–10% down + PMI, includes renters
2. **All-in shelter cost:** rent/mortgage + electricity + heating + insurance + property tax
3. **Signature metric — Break-even mortgage rate:** rate at which a typical young earner could afford the median home in each metro (verify novelty in Week 1)
4. **Personalization:** "Where can I afford?" — input salary/savings, ranks metros
5. **Markets lens:** rate-scenario sliders, mortgage–Treasury spread, data-center electricity watch, homebuilder/utility equities

## Tech stack
- R for data pulls & cleaning (`httr2`, `fredr`, `tidyverse`)
- Quarto dashboard → static site on GitHub Pages
- GitHub Actions for scheduled refresh (nightly)
- Upgrade path: R Shiny if richer interactivity needed

## Data sources
| Data | Source | Frequency |
|---|---|---|
| Home values, rents (metro) | Zillow Research (ZHVI, ZORI) | Monthly |
| Sales, inventory, DOM | Redfin Data Center | Weekly/Monthly |
| 30-yr mortgage, Treasuries, Fed funds | FRED API | Daily/Weekly |
| Income by metro & age | Census ACS API | Annual |
| Electricity prices, natural gas | EIA API v2 | Monthly/Daily |
| CPI components (rent, utilities) | BLS API | Monthly |
| Grid capacity prices | PJM | Per auction |

## Folder layout
- `R/` — pipeline scripts (one per source, plus metrics)
- `data/raw/` — downloaded source data (gitignored if large)
- `data/processed/` — cleaned tables used by the dashboard
- `dashboard/` — Quarto dashboard source
- `notes/` — decisions log, learning log, monthly reports, project brief

## Timeline (Oct 20 – Dec 19, 2026)
| Wk | Build | Skill |
|---|---|---|
| 1 | Competitive scan; GitHub, API keys, structure; first FRED pull | Git, APIs |
| 2 | Housing pipeline (Zillow, Redfin, mortgage rates) | Cleaning, joins |
| 3 | Affordability metrics engine (payment-to-income, down-payment years, break-even rate) | Housing finance math |
| 4 | **MVP live** — housing section, auto-updating | Quarto, GitHub Actions |
| 5 | Energy module (EIA, natural gas, data-center comparison) | Energy data |
| 6 | Markets panel; share with 10–15 users for feedback | Market indicators |
| 7 | Polish, metro comparison, mobile layout | Data viz |
| 8 | First Priced Out Report (Substack/LinkedIn) + methodology page | Writing |
| 9 | Buffer, fixes, resume/LinkedIn launch | — |

**Rule: a working version is live by Week 4.** Everything after is enhancement.

## Post-launch
- Monthly newsletter; target ~300–500 subscribers by spring 2027 as a demand signal
- Monetize only after traction (paid tier, custom reports, sponsorships)
- Compliance: once a bank offer is accepted, disclose the project; avoid specific stock recommendations in commentary
- Backlog ideas: threshold alerts, "best value metros" ranking, climate/insurance risk overlay, 12-month rent forecast

## Current status (updated 2026-10-20)
- Installed: R 4.5.1, RStudio, Git 2.39, R pkgs `fredr`, `httr2`, `usethis`. **Missing: Quarto** (needed by Week 4).
- GitHub: repo `finnmitty725/priced-out` (public), pushes via PAT stored with `gitcreds`. RStudio project `priced-out.Rproj`.
- API keys: FRED ✅ in `~/.Renviron`. **EIA, Census: not yet** — Census needed for Week 3.
- Week 1 ✅: competitive scan, git repo, `R/01_fred_pull.R` (MORTGAGE30US, DGS10, DFF since 2000).
- Week 2 ✅ (done early, 2026-10-20): `R/02_zillow_pull.R` → `data/processed/zillow_metro.csv` (ZHVI bottom + mid tier, ZORI; 97 metros = Zillow SizeRank ≤ 100). Redfin deferred to Week 7 (downloads broke after May 2026 redesign).
- Decisions made: break-even rate stays signature (cite Zillow 2025); bottom-tier headline + mid-tier comparison; top 100 metros. See `notes/decisions.md`.
- Known data quirk: zhvi_mid has 2 fewer rows than zhvi_bottom (a metro gap) — handle in Week 3.
- New competitor found: Redfin Housing Affordability Tracker (quarterly, metro, down-payment selector, no rate solve/age lens/energy).
- Next: Week 3 — get Census key; decide income measure (ACS 25–34 earnings vs household), down payment, threshold, tax/insurance; build `R/03_census_income.R` and `R/04_metrics.R` (payment-to-income, down-payment years, break-even rate via `uniroot`).
