# Decision Log

One line per economic or design assumption, with your reasoning. Interviewers will probe these; this becomes the methodology page.

| Date | Decision | Options considered | Reasoning |
|---|---|---|---|
| 2026-10-19 | Product is a live dashboard + monthly note, not a research paper | Research paper; dashboard; both | More useful, teaches practical skills, builds an audience |
| 2026-10-19 | Focus on young adults (25–34), all-in shelter cost | Median household (like Atlanta Fed HOAM) | Gap in existing trackers; matches my generation's problem |
| 2026-10-19 | Stack: R + Quarto + GitHub Actions + GitHub Pages | R Shiny, Python/Streamlit | Already know R; free; auto-refresh; Shiny is upgrade path |

## Open decisions (to settle in Weeks 2–3)
- [ ] Income measure: ACS median earnings ages 25–34? Renter household income? Both?
- [ ] Down payment assumption: 5%, 10%, or let user choose?
- [ ] Affordability threshold: 30% of income (standard) or 28%/36% lender rules?
- [ ] Geography: which ~100 metros (top 100 CBSAs by population)?
- [ ] Home value series: Zillow ZHVI all homes, or bottom-tier (starter homes)?
- [ ] How to estimate insurance and property tax by metro?
