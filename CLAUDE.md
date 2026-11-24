# Priced Out — Project Playbook

## What this is
A live, auto-updating public dashboard showing **recent college grads / young people (~22–27) choosing a big metro** what shelter really costs on an entry-level salary (rent + energy, and the path to owning), across 97 US metros, plus a monthly analyst note ("The Priced Out Report").

**One-line pitch:** A live tracker of what it really costs a new grad to live in each big US city — rent and utilities on an entry-level salary — plus a "break-even mortgage rate" showing when (if ever) they could buy there.

*(Audience pivoted 2026-11-24 from "young Americans 25–34, ownership-first" to "recent grads, rent-first" — see notes/decisions.md.)*

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
1. **New-grad lens:** entry-level pay (metro bachelor's median × PUMS entry ratio 0.79), rent solo vs with roommate, 10% down + PMI
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

## Current status (updated 2026-11-24)
- **Behind schedule:** calendar = Week 6; MVP (due Week 4) not live yet. Replan agreed in principle: Wk6 metrics + MVP dashboard live; Wk7 GitHub Actions + energy (electricity); Wk8 markets panel + methodology + first report; Wk9 launch. Deferred past Dec 19: full sliders, Redfin, PJM, equities.
- Installed: R 4.5.1, RStudio, Git, Quarto ✅, R pkgs `fredr`, `httr2`, `usethis`. Keys: FRED ✅ Census ✅ **EIA not yet** (Week 7).
- Pipeline ✅: `01_fred_pull.R` (MORTGAGE30US, DGS10, DFF, CES0500000003), `02_zillow_pull.R` (ZHVI bottom/mid, ZORI; 97 metros), `03_census_income.R` (bachelor's earnings B20004, renter/25–44 income for reference, tax rate, insurance grouped median, PUMS entry ratio), `04_metrics.R` → `data/processed/metrics_latest.csv` (grad pay, rent share solo/shared, starter-home own cost, years to save, break-even rate; self-check via stopifnot).
- First grad results (Nov 2026): median grad pay $58.3k; median solo rent 35% of pay; 13/97 metros rent-affordable solo; median break-even rate 4.26% vs 7.24%; 13 metros never affordable to buy.
- Known caveats: starter-home vs typical-rent comparison mismatch; New Orleans insurance top-coded ($4k+); Prop 13 understates CA tax for new buyers; insurance $ from typical homes overstates for starter homes.
- Next: commit; build `dashboard/` Quarto MVP (rankings table + metro detail + salary input box) and publish to GitHub Pages.
