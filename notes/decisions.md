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

## Open decisions (to settle in Weeks 2–3)
- [x] Break-even framing → keep as signature, cite Zillow (2026-10-20)
- [ ] Mortgage–Treasury spread frequency alignment (weekly vs daily) — by Week 6
- [ ] Display for metros unaffordable at any rate (n/a, negative, or required price cut)
- [ ] Income measure: ACS median earnings ages 25–34? Renter household income? Both?
- [ ] Down payment assumption: 5%, 10%, or let user choose?
- [ ] Affordability threshold: 30% of income (standard) or 28%/36% lender rules?
- [x] Geography → top 100 by Zillow SizeRank (2026-10-20)
- [x] Home value series → bottom tier headline + mid tier comparison (2026-10-20)
- [ ] How to estimate insurance and property tax by metro?
