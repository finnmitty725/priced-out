# Decision Log

One line per economic or design assumption, with your reasoning. Interviewers will probe these; this becomes the methodology page.

| Date | Decision | Options considered | Reasoning |
|---|---|---|---|
| 2026-10-19 | Product is a live dashboard + monthly note, not a research paper | Research paper; dashboard; both | More useful, teaches practical skills, builds an audience |
| 2026-10-19 | Focus on young adults (25–34), all-in shelter cost | Median household (like Atlanta Fed HOAM) | Gap in existing trackers; matches my generation's problem |
| 2026-10-19 | Stack: R + Quarto + GitHub Actions + GitHub Pages | R Shiny, Python/Streamlit | Already know R; free; auto-refresh; Shiny is upgrade path |
| 2026-10-20 | Keep break-even mortgage rate as signature metric, framed as a live, young-buyer version of Zillow's July 2025 one-off (cite Zillow) | Keep as signature; demote to one of several | Concept isn't novel, but no one tracks it live for 25–34 earners at 5–10% down + PMI; citing prior work signals rigor |
| 2026-10-20 | Home values: Zillow ZHVI bottom tier (0–33rd pct) as headline, mid tier (33–67th) for comparison | Mid only; bottom only; both | Young first-time buyers mostly buy starter homes; mid tier keeps us comparable to Zillow/HOAM/NAHB |
| 2026-10-20 | Geography: top 100 metros by Zillow SizeRank (97 have data) | Top 100; top 150–200 | Covers ~2/3 of US population; income/energy data thinner for small metros; can expand later |
| 2026-10-20 | Defer Redfin to Week 7; MVP housing data = Zillow only | Defer; use stale June 2026 files; drop | Redfin's May 2026 Data Center redesign broke scriptable downloads (old S3 files frozen since June); MVP affordability math needs price, rent, rates, income only |
| 2026-11-04 | Income: ACS renter household median income (B25119_003) as headline; householder 25–44 median household income (B19049_003) as comparison | 25–44 only; renter only; 25–44 headline; renter headline | Each is biased in opposite directions (25–44 includes owners, dual earners, peak-earning 40s → too high; renters of all ages → too low). Showing both bounds the true young-renter figure, which matters for credibility and usefulness to the target audience. Upgrade path: ACS PUMS renters aged 25–34 (Week 7+) |
| 2026-11-04 | Down payment: 10% default; user slider later | 5%; 10%; user choice | Typical first-time buyer puts ~9–10% down; slider serves personalization feature |
| 2026-11-04 | Affordability threshold: 30% of gross income | 30%; 28/36 lender rule | Standard used by HUD, Atlanta Fed, Zillow, Redfin → comparable |
| 2026-11-04 | Property tax: metro effective rate = ACS median real estate taxes (B25103) ÷ median home value (B25077) | Flat ~1.1%; metro ACS rate | Rates vary ~5× across metros (Phoenix ~0.4%, Chicago ~2%) |
| 2026-11-04 | Insurance: metro median annual premium from ACS B25141 (mortgaged units), estimated from brackets | Flat 0.5% of value (Redfin); metro ACS | 'All-in' cost is a differentiator; premiums vary widely (climate risk) |
| 2026-11-04 | PMI: 0.6% of loan per year (flat) | 0.5%; 0.6%; 1% | Mid-range for ~10% down, decent credit; varies little by metro |
| 2026-11-04 | Scale 2024 ACS incomes to current month by FRED average hourly earnings growth (CES0500000003) | Leave as 2024; scale by wage growth | Avoid comparing 2026 prices to 2024 pay (Atlanta Fed also projects incomes) |
| 2026-11-04 | Plan: interactive sliders (down payment, savings, income) via Quarto Observable JS, Weeks 6–7 | Static only; Shiny; Quarto OJS | Runs in browser, free on GitHub Pages, no server |
| 2026-11-24 | **Audience pivot:** recent college grads / young people (~22–27) choosing which big metro to move to (not graduate students) | All young adults 25–34; recent grads | Clear audience with a real decision (which city, which offer); strong distribution via campus/LinkedIn; graduation-season timing |
| 2026-11-24 | **Primary lens: renting** (rent + utilities as share of entry-level pay); buying/break-even rate becomes secondary 'path to owning' section | Rent-first; buy-first | Recent grads overwhelmingly rent; ownership is a 5–10 yr goal |
| 2026-11-24 | **Income (supersedes 2026-11-04 renter/25–44 choice):** metro median earnings of bachelor's holders (ACS B20004_005) × national entry-level ratio from ACS PUMS, plus a user salary input | Bachelor's as-is; adjusted; salary input only | Individual (not household) earnings of degree holders match a grad far better; adjustment removes older workers; input lets users use their actual offer |
| 2026-11-24 | Entry-level ratio = 0.79 (full-time year-round bachelor's 22–27 median $55k ÷ all-earner bachelor's 25+ median $70k, ACS PUMS 2024 national) | 0.79 full-time; 0.61 all earners | Describes a grad taking a full-time offer; national $55k consistent with NY Fed early-career range. Limitation: assumes same ratio in every metro |
| 2026-11-24 | Keep 'path to owning' section (break-even rate, years to save) as secondary | Keep; drop | Only genuinely novel metric; markets/rates story; already built |
| 2026-11-24 | Savings rate for years-to-save: 10% of pay per year (user-adjustable later) | 5%; 10%; 15% | Realistic for a budgeting grad; Redfin uses 5% (more conservative) |
| 2026-11-24 | Rent shown solo (headline) and with 1 roommate (rent ÷ 2) | Solo; shared; both | Solo is clean and conservative; sharing is common for grads in big metros |

## Open decisions
- [x] Entry-level ratio → 0.79
- [x] Path to owning → keep
- [x] Savings rate → 10%
- [x] Rent → solo + 1 roommate
- [x] Break-even framing → keep as signature, cite Zillow (2026-10-20)
- [ ] Mortgage–Treasury spread frequency alignment (weekly vs daily) — by Week 6
- [ ] Display for metros unaffordable at any rate (n/a, negative, or required price cut)
- [x] Income → renter HH headline + 25–44 HH comparison (2026-11-04)
- [x] Income vintage → scale by avg hourly earnings growth
- [x] Down payment → 10% default + slider later
- [x] Threshold → 30% gross
- [x] Geography → top 100 by Zillow SizeRank (2026-10-20)
- [x] Home value series → bottom tier headline + mid tier comparison (2026-10-20)
- [x] Tax + insurance → ACS metro values
