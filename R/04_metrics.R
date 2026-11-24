# 04_metrics.R
# Combines FRED, Zillow, and Census data into affordability metrics
# for a recent college grad in each metro, and saves
# data/processed/metrics_latest.csv

library(dplyr)
library(readr)

# --- 1. Assumptions (every number here is logged in notes/decisions.md) -----
max_share    <- 0.30   # housing should cost at most 30% of gross pay
down_pct     <- 0.10   # down payment on a starter home
pmi_rate     <- 0.006  # private mortgage insurance, % of loan per year
savings_rate <- 0.10 # share of pay saved each year toward a down payment
term_months  <- 360    # 30-year mortgage

# --- 2. Load the processed data ---------------------------------------------
fred   <- read_csv("data/processed/fred_rates.csv",   show_col_types = FALSE)
zillow <- read_csv("data/processed/zillow_metro.csv", show_col_types = FALSE)
census <- read_csv("data/processed/census_metro.csv", show_col_types = FALSE)

# Today's 30-year mortgage rate (as a decimal, e.g. 0.0724)
latest_mortgage <- fred |> filter(series == "mortgage_30y") |> slice_max(date, n = 1)
mortgage_rate   <- latest_mortgage$value / 100

# Wage growth since the Census survey year, to bring 2024 pay up to today
ahe         <- fred |> filter(series == "avg_hourly_earnings")
acs_year    <- census$acs_year[1]
ahe_latest  <- ahe |> slice_max(date, n = 1) |> pull(value)
ahe_base    <- ahe |> filter(format(date, "%Y") == as.character(acs_year)) |> pull(value) |> mean()
wage_growth <- ahe_latest / ahe_base

# Latest month of Zillow data, one column per series
zillow_latest <- zillow |>
  filter(date == max(date)) |>
  select(region_id, series, value) |>
  tidyr::pivot_wider(names_from = series, values_from = value)

# --- 3. Mortgage math --------------------------------------------------------
# Monthly principal + interest on a fixed-rate loan
mortgage_payment <- function(loan, annual_rate, n = term_months) {
  r <- annual_rate / 12
  if (r == 0) return(loan / n)
  loan * r * (1 + r)^n / ((1 + r)^n - 1)
}

# The mortgage rate at which total monthly cost = 30% of pay
# NA  = unaffordable even at 0%;  capped at 25% if affordable at any realistic rate
break_even_rate <- function(price, monthly_pay, tax_rate, insurance_annual) {
  loan      <- price * (1 - down_pct)
  fixed     <- price * tax_rate / 12 + insurance_annual / 12 + loan * pmi_rate / 12
  pi_budget <- max_share * monthly_pay - fixed
  if (is.na(pi_budget) || pi_budget <= mortgage_payment(loan, 0)) return(NA_real_)
  if (pi_budget >= mortgage_payment(loan, 0.25)) return(0.25)
  uniroot(function(r) mortgage_payment(loan, r) - pi_budget, lower = 0, upper = 0.25)$root
}

# --- 4. Build the metrics, one row per metro ---------------------------------
metrics_full <- census |>
  left_join(zillow_latest, by = "region_id") |>
  rowwise() |>
  mutate(
    # Pay: local bachelor's median -> entry level -> today's dollars
    grad_pay     = earnings_bachelors * entry_ratio * wage_growth,
    monthly_pay  = grad_pay / 12,

    # Renting (headline)
    rent_solo          = zori,
    rent_shared        = zori / 2,
    rent_share_solo    = rent_solo / monthly_pay,
    rent_share_shared  = rent_shared / monthly_pay,
    pay_needed_solo    = rent_solo / max_share * 12,

    # Owning a starter home (path to owning)
    starter_price      = zhvi_bottom,
    loan               = starter_price * (1 - down_pct),
    own_cost           = mortgage_payment(loan, mortgage_rate) +
                         starter_price * tax_rate / 12 +
                         insurance_annual / 12 +
                         loan * pmi_rate / 12,
    own_share          = own_cost / monthly_pay,
    years_to_save      = starter_price * down_pct / (grad_pay * savings_rate),
    break_even         = break_even_rate(starter_price, monthly_pay, tax_rate, insurance_annual),
    rate_gap           = mortgage_rate - break_even
  ) |>
  ungroup()

# --- 5. Sanity check: at the break-even rate, cost must equal exactly 30% ----
check <- metrics_full |> filter(!is.na(break_even), break_even < 0.25) |> slice(1)
cost_at_break_even <- mortgage_payment(check$loan, check$break_even) +
  check$starter_price * check$tax_rate / 12 +
  check$insurance_annual / 12 +
  check$loan * pmi_rate / 12
stopifnot(abs(cost_at_break_even / check$monthly_pay - max_share) < 0.001)

# --- 6. Save -----------------------------------------------------------------
metrics <- metrics_full |>
  mutate(mortgage_rate = mortgage_rate,
         rate_date     = latest_mortgage$date,
         zillow_date   = max(zillow$date)) |>
  select(region_id, metro, grad_pay, rent_solo, rent_shared, rent_share_solo,
         rent_share_shared, pay_needed_solo, starter_price, own_cost, own_share,
         years_to_save, break_even, rate_gap, mortgage_rate, rate_date, zillow_date)

write_csv(metrics, "data/processed/metrics_latest.csv")

metrics |>
  summarise(metros = n(),
            mortgage_rate = first(mortgage_rate),
            median_grad_pay = median(grad_pay),
            median_rent_share_solo = median(rent_share_solo, na.rm = TRUE),
            rent_affordable_solo = sum(rent_share_solo <= max_share, na.rm = TRUE),
            own_affordable_today = sum(own_share <= max_share, na.rm = TRUE),
            never_affordable = sum(is.na(break_even)),
            median_break_even = median(break_even, na.rm = TRUE)) |>
  print(width = Inf)
