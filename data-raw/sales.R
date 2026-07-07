# Generates the `sales` example dataset: a simulated geo-level weekly MMM panel.
# Run with: source("data-raw/sales.R")
#
# The data-generating process mirrors Meridian's own model structure so a fitted
# model recovers sensible effects:
#   * a dominant, structured baseline (level + trend + annual seasonality),
#   * media with geometric adstock (carryover) and Hill saturation,
#   * media spend flighted at frequencies distinct from the baseline season, so
#     baseline and media are separable,
#   * a price control and low observation noise.
# Media accounts for ~20% of conversions by construction.

set.seed(2025)

regions <- c("North", "South", "East", "West")
pop <- c(North = 2.4e6, South = 1.8e6, East = 3.1e6, West = 1.2e6)
weeks <- seq(as.Date("2021-01-04"), by = 7, length.out = 104) # 2 years, weekly
n_wk <- length(weeks)
week_of_year <- as.integer(format(weeks, "%U"))

adstock <- function(x, alpha) {
  y <- x
  for (i in 2:length(x)) y[i] <- x[i] + alpha * y[i - 1]
  y
}
hill <- function(x, ec, slope) {
  z <- x / stats::median(x[x > 0])
  z^slope / (z^slope + ec^slope)
}

make_geo <- function(g) {
  s <- as.numeric(pop[g] / mean(pop))
  trend <- 0.25 * (seq_len(n_wk) - 1) / (n_wk - 1) # +25% over two years
  season <- 0.18 * sin(2 * pi * week_of_year / 52 - 0.7) # annual
  baseline <- 500 * s * (1 + trend + season) # dominant, structured

  # Media spend: sustained + flighting at frequencies distinct from the season.
  tv_spend <- pmax(50, 7000 * s * (1 + 0.20 * season) *
    (1 + 0.6 * sin(2 * pi * seq_len(n_wk) / 9 + 1)) * rlnorm(n_wk, 0, 0.12))
  search_spend <- pmax(20, 2800 * s * (1 + 0.08 * season) *
    (1 + 0.4 * sin(2 * pi * seq_len(n_wk) / 17)) * rlnorm(n_wk, 0, 0.10))

  # Adstock -> saturation, scaled to a target share of the baseline.
  tv_eff <- hill(adstock(tv_spend, 0.55), ec = 0.8, slope = 1.3)
  se_eff <- hill(adstock(search_spend, 0.30), ec = 0.6, slope = 1.1)
  tv_contrib <- 0.14 * mean(baseline) * (tv_eff / mean(tv_eff))
  se_contrib <- 0.07 * mean(baseline) * (se_eff / mean(se_eff))

  price_index <- rnorm(n_wk, 100, 4)
  conversions <- baseline + tv_contrib + se_contrib -
    1.5 * (price_index - 100) + rnorm(n_wk, 0, 0.02 * mean(baseline))

  data.frame(
    region = g,
    week = weeks,
    conversions = round(pmax(0, conversions)),
    population = as.numeric(pop[g]),
    tv_spend = round(tv_spend),
    tv_impressions = round(tv_spend * runif(n_wk, 45, 75)),
    search_spend = round(search_spend),
    search_clicks = round(search_spend * runif(n_wk, 8, 16)),
    price_index = round(price_index, 1)
  )
}

sales <- do.call(rbind, lapply(regions, make_geo))
sales <- sales[
  order(sales$region, sales$week),
  c(
    "region", "week", "conversions", "population",
    "tv_spend", "tv_impressions", "search_spend", "search_clicks", "price_index"
  )
]
rownames(sales) <- NULL

usethis::use_data(sales, overwrite = TRUE)
