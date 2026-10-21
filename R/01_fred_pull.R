# 01_fred_pull.R
# Pulls the 30-year mortgage rate and 10-year Treasury yield from FRED
# and saves a tidy table to data/processed/fred_rates.csv

library(fredr)   # wrapper around the FRED API
library(dplyr)   # data manipulation
library(readr)   # fast, clean CSV writing
if (Sys.getenv("FRED_API_KEY") == "") {
  stop("FRED_API_KEY is not set. Add it to ~/.Renviron and restart R.")
}
series <- c(
  DFF          = "fed_funds",      # Effective federal funds rate, daily    
  MORTGAGE30US = "mortgage_30y",   # Freddie Mac PMMS, weekly (Thursdays)
  DGS10        = "treasury_10y"    # 10-yr constant-maturity Treasury, daily
)
rates_raw <- lapply(names(series), function(id) {
  fredr(series_id = id, observation_start = as.Date("2000-01-01"))
}) |>
  bind_rows()
rates <- rates_raw |>
  filter(!is.na(value)) |>
  mutate(series = unname(series[series_id])) |>
  select(date, series, series_id, value)
write_csv(rates, "data/processed/fred_rates.csv")

rates |>
  group_by(series) |>
  summarise(first = min(date), last = max(date), n = n(), latest = last(value))
