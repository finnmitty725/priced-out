# Competitive Scan — Week 1 (2026-10-19)

Goal: check whether the differentiators in CLAUDE.md hold up, especially whether a metro-level "break-even mortgage rate" already exists.

## Headline finding
**The break-even mortgage rate concept already exists.** Zillow Research (July 29, 2025) solved for the mortgage rate that makes the typical home affordable to a median-income household in each metro:
- National answer: 4.43%
- 6 metros (NYC, LA, Miami, SF, San Diego, San Jose) are unaffordable **even at 0%**
- Assumptions: **20% down**, payment ≤ 30% of **median household income**, prices held constant
- It was a **one-off study**, not a live tracker. Local news has since redone it (e.g., KSL Utah, July 2026: SLC/Provo need < 2.3%).
- Homeabroad publishes a "rent-supported mortgage rate" for 375 metros: the rate at which a mortgage payment equals local rent. That is a different question from affordability-by-income, but the name is close.

→ We **cannot** claim we invented the metric. What may still be new is the **version** of it (see below).

## Tracker-by-tracker

| Tracker | Geography | Income measure | Down pmt | Costs included | Live? | Gap vs. Priced Out |
|---|---|---|---|---|---|---|
| **Atlanta Fed HOAM** | National, metro, county (since 2014) | Median household (ACS 1-yr, projected) | 10% | P&I, property tax, insurance, PMI | Yes, monthly | No age lens, no renters, no energy, no rate solve |
| **NAR HAI** | National, regions (+ first-time-buyer index) | Median family | 20% (FTB version: lower) | P&I only | Yes, monthly | Few metros, P&I only |
| **NAHB/Wells Fargo CHI** (replaced HOI in 2023) | National + 175 metros | HUD median family income | 10% | P&I, tax, insurance, PMI | Quarterly | No age lens, no energy |
| **Zillow / Redfin** | Metro | Median household | Usually 20% | Mostly P&I | Ad hoc reports + data | Break-even rate was a one-off; 20% down |
| **Harvard JCHS** | Metro maps (periodic) | Has done renters aged 25–34 (2013) and 25th/75th pct | Varies | P&I, tax, insurance | Annual / periodic | Not live; editions vary |
| **Pew (June 2026)** | Metro | Households headed by someone **under 40** | JCHS method | Price-to-income | One-off | Young lens exists but static |
| **USD Burnham-Moores HAI** | **385 metros**, quarterly | **Renter** and owner income | — | P&I, tax, insurance, **utilities**, maintenance | Quarterly | Closest competitor on "all-in" + renters. No age lens, no rate solve |
| **NerdWallet FTB report** (2020–24) | Large metros | ACS householders **25–44** | — | Price/income | Quarterly, appears discontinued | Young-ish lens, no rate solve |

## How each differentiator holds up

1. **Young-adult lens (25–34, 5–10% down, renters)**: **Partly taken.** Pew (under 40), NerdWallet (25–44) and JCHS (renters aged 25–34, 2013) have all done one-off versions. Nobody runs it as a live monthly series by metro. → Still a real gap, but say "live," not "first."
2. **All-in shelter cost (incl. energy)**: **Partly taken.** USD Burnham-Moores includes utilities for 385 metros quarterly, and Trulia did it once (2013 data). Nobody pairs it with *live* EIA prices or a separate energy breakdown. → Our angle is live energy prices plus an energy-market lens (data centers, gas), not just "includes utilities."
3. **Break-even mortgage rate**: **Not novel as a concept** (Zillow 2025). Still open: a **live, monthly** break-even rate per metro, computed for a **young earner at 5–10% down with PMI**, possibly an **all-in** version that includes energy. Zillow's figure assumed 20% down and household income, so young buyers' break-even rates are likely much lower, and often negative or infeasible.
4. **Personalization ("where can I afford")**: Lots of calculators exist (Zillow, NerdWallet, bank tools), but few rank 100+ metros on all-in cost. Not unique alone; useful as a feature.
5. **Markets lens**: No affordability tracker found that also shows the mortgage–Treasury spread, PJM capacity prices or homebuilder/utility equities. **Most distinctive part for a banking/markets audience.**

## Decisions for you to make (record in decisions.md)
- How to describe the break-even rate: "Zillow's 2025 one-off, rebuilt as a live tracker for young buyers" (honest, still strong) vs. dropping it as the signature metric.
- Whether to cite Zillow, USD Burnham-Moores and Atlanta Fed HOAM on the methodology page (recommended: yes; it signals rigor in interviews).
- How to show metros where even 0% isn't enough (Zillow labels them "unaffordable at any rate"). Options: show "n/a", show a negative number, or show the price cut needed instead.

## Sources
- Zillow Research, "Rate, Price Drops Won't Substantially Improve Affordability" (2025): https://www.zillow.com/research/rate-drops-35389/
- Fortune coverage (Aug 2025): https://fortune.com/2025/08/03/mortgage-rates-housing-affordability-us-cities-nyc-los-angeles/
- KSL Utah (2026): https://www.ksl.com/article/news/utah/how-low-do-mortgage-rates-need-to-go-to-make-buying-a-house-in-utah-affordable/51600459
- Homeabroad rent-supported mortgage rate: https://homeabroadinc.com/research/rent-supported-mortgage-rate-statistics/
- Atlanta Fed HOAM: https://www.atlantafed.org/research-and-data/data/home-ownership-affordability-monitor
- NAHB/Wells Fargo CHI: https://www.nahb.org/news-and-economics/housing-economics/indices/cost-of-housing-index
- C.A.R. first-time buyer HAI methodology: https://car.org/marketdata/data/ftbhaimethodology
- JCHS "Where can renters afford to own": https://www.jchs.harvard.edu/blog/interactive-map-where-can-renters-afford-to-own
- Pew, young adults & metro affordability (June 2026): https://www.pewresearch.org/short-reads/2026/06/24/buying-a-home-has-gotten-harder-for-young-adults-in-most-us-metro-areas/
- USD Burnham-Moores HAI: https://www.sandiego.edu/business/centers/burnham-moores-real-estate/news-media/housing-index.php
- HousingWire on Burnham-Moores: https://www.housingwire.com/articles/all-in-homeownership-costs-renters-affordability/
- NerdWallet FTB reports: https://www.nerdwallet.com/mortgages/studies/q12024-fthb-affordability

Caveat: several numbers come from news coverage, not the original methodology PDFs. Before the methodology page (Week 8), read the Zillow, HOAM and Burnham-Moores originals yourself.
