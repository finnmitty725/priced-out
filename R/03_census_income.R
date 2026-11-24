# 03_census_income.R
# Pulls metro income, property tax, and home insurance from the Census ACS API,
# matches Census metros to our Zillow metros, and saves
# data/processed/census_metro.csv

library(dplyr)
library(readr)
library(httr2)   # build and send API requests by hand

census_key <- Sys.getenv("CENSUS_API_KEY")
if (census_key == "") {
  stop("CENSUS_API_KEY is not set. Add it to ~/.Renviron and restart R.")
}

acs_year <- 2024   # latest ACS 1-year release; bump when Census publishes a new one

# --- 1. Which Census variables we want -------------------------------------
vars <- c(
  B20004_005E = "earnings_bachelors", # median earnings, bachelor's degree holders 25+ (individual)
  B25119_003E = "income_renter",      # median household income, renters (kept for reference)
  B19049_003E = "income_hh_25_44",    # median household income, householder 25-44 (kept for reference)
  B25103_001E = "median_re_tax",      # median real estate taxes paid
  B25077_001E = "median_home_value"   # median home value (owner-occupied)
)

# Home insurance comes in 12 price brackets (mortgaged homes, yearly premium)
ins_vars   <- paste0("B25141_", sprintf("%03d", 3:14), "E")
bracket_lo <- c(0, 100, 300, 500,  800, 1000, 1500, 2000, 2500, 3000, 3500, 4000)
bracket_hi <- c(100, 300, 500, 800, 1000, 1500, 2000, 2500, 3000, 3500, 4000, NA)

# --- 2. Call the API ---------------------------------------------------------
resp <- request(paste0("https://api.census.gov/data/", acs_year, "/acs/acs1")) |>
  req_url_query(
    get   = paste(c("NAME", names(vars), ins_vars), collapse = ","),
    `for` = "metropolitan statistical area/micropolitan statistical area:*",
    key   = census_key
  ) |>
  req_perform() |>
  resp_body_json(simplifyVector = TRUE)

# Census returns a grid: row 1 = column names, the rest = data (all text)
acs <- as_tibble(resp[-1, ], .name_repair = "minimal")
names(acs) <- resp[1, ]
acs <- acs |> mutate(across(-NAME, as.numeric))

# --- 3. Estimate median insurance from bracket counts ------------------------
grouped_median <- function(counts) {
  if (anyNA(counts) || sum(counts) == 0) return(NA_real_)
  half  <- sum(counts) / 2
  cum   <- cumsum(counts)
  k     <- which(cum >= half)[1]               # bracket containing the middle home
  below <- if (k == 1) 0 else cum[k - 1]       # homes in brackets below it
  if (is.na(bracket_hi[k])) return(bracket_lo[k])   # top bracket is open-ended ($4,000+)
  bracket_lo[k] + (half - below) / counts[k] * (bracket_hi[k] - bracket_lo[k])
}
acs$insurance_annual <- apply(acs[, ins_vars], 1, grouped_median)

# --- 4. Tidy up and build a key that matches Zillow's metro names ------------
# Census: "Chicago-Naperville-Elgin, IL-IN-WI Metro Area"  ->  Zillow: "Chicago, IL"
acs <- acs |>
  rename(any_of(setNames(names(vars), vars))) |>
  transmute(
    census_name = NAME,
    match_key   = paste0(sub("[-,/].*$", "", NAME), ", ",
                         substr(sub("^[^,]*, ", "", NAME), 1, 2)),
    earnings_bachelors,
    income_renter,
    income_hh_25_44,
    tax_rate = median_re_tax / median_home_value,
    insurance_annual,
    acs_year = acs_year
  )

# --- 4b. Entry-level ratio from microdata (ACS PUMS, national) --------------
# Median full-time pay of bachelor's holders aged 22-27, divided by the
# median pay of ALL bachelor's holders 25+ (same definition as B20004 above)
get_pums <- function(ages) {
  resp <- request(paste0("https://api.census.gov/data/", acs_year, "/acs/acs1/pums")) |>
    req_url_query(get = "PERNP,PWGTP,WKHP,WKWN", SCHL = 21, AGEP = ages, key = census_key) |>
    req_perform() |>
    resp_body_json(simplifyVector = TRUE)
  people <- as_tibble(resp[-1, ], .name_repair = "minimal")
  names(people) <- resp[1, ]
  people |> mutate(across(everything(), as.numeric)) |> filter(PERNP > 0)
}

weighted_median <- function(x, w) {
  o <- order(x)
  x[o][which(cumsum(w[o]) >= sum(w) / 2)[1]]
}

young <- get_pums("22:27") |> filter(WKHP >= 35, WKWN >= 50)   # full-time, year-round
older <- get_pums("25:99")                                     # all earners, like B20004
entry_ratio <- weighted_median(young$PERNP, young$PWGTP) /
               weighted_median(older$PERNP, older$PWGTP)

acs <- acs |> mutate(entry_ratio = entry_ratio)

# --- 5. Keep only our Zillow metros and check every one matched --------------
zillow_metros <- read_csv("data/processed/zillow_metro.csv", show_col_types = FALSE) |>
  distinct(region_id, metro)

census_metro <- zillow_metros |>
  left_join(acs, by = c("metro" = "match_key"))

unmatched <- census_metro |> filter(is.na(census_name)) |> pull(metro)
if (length(unmatched) > 0) {
  warning("No Census match for: ", paste(unmatched, collapse = "; "))
}

write_csv(census_metro, "data/processed/census_metro.csv")

census_metro |>
  summarise(metros = n(), matched = sum(!is.na(census_name)),
            entry_ratio = first(entry_ratio),
            median_grad_earnings = median(earnings_bachelors, na.rm = TRUE),
            median_tax_rate = median(tax_rate, na.rm = TRUE),
            median_insurance = median(insurance_annual, na.rm = TRUE)) |>
  print(width = Inf)

