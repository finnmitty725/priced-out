# 02_zillow_pull.R
# Downloads Zillow home values (ZHVI bottom + mid tier) and rents (ZORI)
# for the top 100 metros, reshapes wide -> long,
# and saves to data/processed/zillow_metro.csv

library(dplyr)
library(readr)
library(tidyr)   # pivot_longer() for wide -> long

base_url <- "https://files.zillowstatic.com/research/public_csvs/"

files <- c(
  zhvi_bottom = "zhvi/Metro_zhvi_uc_sfrcondo_tier_0.0_0.33_sm_sa_month.csv",   # starter homes (headline)
  zhvi_mid    = "zhvi/Metro_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_month.csv",  # typical home (comparison)
  zori        = "zori/Metro_zori_uc_sfrcondomfr_sm_sa_month.csv"               # typical rent
)

for (name in names(files)) {
  download.file(
    url      = paste0(base_url, files[[name]]),
    destfile = file.path("data/raw", paste0(name, ".csv")),
    mode     = "wb",
    quiet    = TRUE
  )
}

metros <- read_csv("data/raw/zhvi_mid.csv", show_col_types = FALSE) |>
  filter(RegionType == "msa", SizeRank <= 100) |>
  select(region_id = RegionID, metro = RegionName,
         state = StateName, size_rank = SizeRank)

read_zillow <- function(name) {
  read_csv(file.path("data/raw", paste0(name, ".csv")), show_col_types = FALSE) |>
    filter(RegionID %in% metros$region_id) |>
    pivot_longer(
      cols      = matches("^\\d{4}-\\d{2}-\\d{2}$"),
      names_to  = "date",
      values_to = "value"
    ) |>
    transmute(region_id = RegionID, date = as.Date(date), series = name, value) |>
    filter(!is.na(value))
}

zillow <- lapply(names(files), read_zillow) |>
  bind_rows() |>
  left_join(metros, by = "region_id") |>
  select(date, region_id, metro, state, size_rank, series, value)

write_csv(zillow, "data/processed/zillow_metro.csv")

zillow |>
  group_by(series) |>
  summarise(metros = n_distinct(region_id), first = min(date),
            last = max(date), n = n())

