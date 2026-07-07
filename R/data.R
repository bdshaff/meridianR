#' Simulated weekly marketing-mix data
#'
#' A simulated geo-level panel used to demonstrate meridianR: weekly conversions
#' and marketing activity across four regions over two years. Conversions are
#' generated from a dominant, structured baseline (level, trend, and annual
#' seasonality) plus media effects with geometric adstock and Hill saturation and
#' a price control, so a fitted model recovers a good fit and a realistic media
#' contribution (~10-15%). It is **not** real data.
#'
#' @format A data frame with 416 rows (4 regions x 104 weeks) and 9 columns:
#' \describe{
#'   \item{region}{Geo identifier: "North", "South", "East", or "West".}
#'   \item{week}{Week start date (a `Date`).}
#'   \item{conversions}{Weekly KPI (conversions).}
#'   \item{population}{Region population, constant over time.}
#'   \item{tv_spend}{TV media spend.}
#'   \item{tv_impressions}{TV impressions (media execution metric).}
#'   \item{search_spend}{Search media spend.}
#'   \item{search_clicks}{Search clicks (media execution metric).}
#'   \item{price_index}{Price index control variable.}
#' }
#' @source Simulated; see `data-raw/sales.R`.
"sales"
