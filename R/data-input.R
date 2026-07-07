#' Assemble Meridian input data from a data frame
#'
#' `as_meridian_input()` is the primary, one-call way to turn a long-format R
#' data frame into a Meridian `InputData` object. It drives Meridian's
#' `DataFrameInputDataBuilder` (see [input_data_builder()]) under the hood,
#' adding only the components you supply.
#'
#' The data must be in long format: one row per geo-by-time (or per time for a
#' national model), with columns for the KPI, population, media spend, and any
#' controls. Media, reach/frequency, organic media, and non-media treatments are
#' optional.
#'
#' If you supply `media_spend` but not `media`, spend is also used as the media
#' execution metric (a spend-based model). Channel labels default to the spend
#' column names; pass `media_channels` for nicer labels.
#'
#' @param data A long-format data frame.
#' @param kpi Name of the KPI column.
#' @param time Name of the time column (dates are coerced to ISO-8601 strings).
#' @param geo Name of the geo column. Ignored (and synthesized) when
#'   `national = TRUE`.
#' @param population Name of the per-geo population column. Synthesized as a
#'   constant when `national = TRUE` and absent.
#' @param media_spend Character vector of media spend columns.
#' @param media Character vector of media execution columns (e.g. impressions),
#'   aligned with `media_spend`. Defaults to `media_spend`.
#' @param media_channels Character vector of channel labels. Defaults to
#'   `media_spend`.
#' @param controls Character vector of control-variable columns.
#' @param revenue_per_kpi Name of the revenue-per-KPI column, if any.
#' @param reach,frequency,rf_spend Character vectors of reach, average-frequency,
#'   and spend columns for reach-and-frequency channels.
#' @param rf_channels Channel labels for R&F channels. Defaults to `reach`.
#' @param organic_media Character vector of organic-media columns.
#' @param non_media_treatments Character vector of non-media treatment columns.
#' @param kpi_type `"non_revenue"` (default) or `"revenue"`.
#' @param national If `TRUE`, treat the data as national (single geo): a geo
#'   column and constant population are synthesized when absent.
#'
#' @return A `meridian_input_data` object wrapping a Meridian `InputData`.
#' @seealso [input_data_builder()] for the step-by-step builder, and
#'   [meridian_model()] to fit a model on the result.
#' @export
#'
#' @examples
#' \dontrun{
#' input <- as_meridian_input(
#'   sales,
#'   kpi         = "conversions",
#'   time        = "week",
#'   geo         = "region",
#'   population  = "population",
#'   media_spend = c("tv_spend", "search_spend"),
#'   media       = c("tv_impressions", "search_clicks"),
#'   media_channels = c("TV", "Search"),
#'   controls    = "price_index"
#' )
#' input
#' }
as_meridian_input <- function(data,
                              kpi,
                              time = "time",
                              geo = "geo",
                              population = "population",
                              media_spend = NULL,
                              media = NULL,
                              media_channels = NULL,
                              controls = NULL,
                              revenue_per_kpi = NULL,
                              reach = NULL,
                              frequency = NULL,
                              rf_spend = NULL,
                              rf_channels = NULL,
                              organic_media = NULL,
                              non_media_treatments = NULL,
                              kpi_type = c("non_revenue", "revenue"),
                              national = FALSE) {
  kpi_type <- match.arg(kpi_type)
  ensure_meridian()
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame.")
  }

  # National models: synthesize a single geo and constant population if absent.
  if (isTRUE(national)) {
    if (is.null(geo) || !geo %in% names(data)) {
      geo <- "geo"
      data[[geo]] <- "national"
    }
    if (is.null(population) || !population %in% names(data)) {
      population <- "population"
      data[[population]] <- 1
    }
  }

  # Validate that referenced columns exist before touching Python.
  check_columns(data, c(
    named_cols("kpi", kpi),
    named_cols("time", time),
    named_cols("geo", geo),
    named_cols("population", population),
    named_cols("controls", controls),
    named_cols("media", media),
    named_cols("media_spend", media_spend),
    named_cols("revenue_per_kpi", revenue_per_kpi),
    named_cols("reach", reach),
    named_cols("frequency", frequency),
    named_cols("rf_spend", rf_spend),
    named_cols("organic_media", organic_media),
    named_cols("non_media_treatments", non_media_treatments)
  ))

  # Spend-as-exposure and channel-label defaults.
  if (!is.null(media_spend)) {
    media <- media %||% media_spend
    media_channels <- media_channels %||% media_spend
  }
  rf_channels <- rf_channels %||% reach

  # Convert once; the builder verbs pass the pandas object through.
  pdf <- df_to_pandas(data)

  builder <- input_data_builder(
    kpi_type = kpi_type,
    geo = geo,
    time = time,
    population = population,
    kpi = kpi,
    revenue_per_kpi = revenue_per_kpi %||% "revenue_per_kpi"
  )
  builder <- with_kpi(builder, pdf, kpi_col = kpi)
  builder <- with_population(builder, pdf, population_col = population)
  if (!is.null(revenue_per_kpi)) {
    builder <- with_revenue_per_kpi(builder, pdf, revenue_per_kpi_col = revenue_per_kpi)
  }
  if (!is.null(controls)) {
    builder <- with_controls(builder, pdf, control_cols = controls)
  }
  if (!is.null(media_spend)) {
    builder <- with_media(
      builder, pdf,
      media_cols = media, media_spend_cols = media_spend, media_channels = media_channels
    )
  }
  if (!is.null(reach)) {
    builder <- with_reach(
      builder, pdf,
      reach_cols = reach, frequency_cols = frequency,
      rf_spend_cols = rf_spend, rf_channels = rf_channels
    )
  }
  if (!is.null(organic_media)) {
    builder <- with_organic_media(builder, pdf, organic_media_cols = organic_media)
  }
  if (!is.null(non_media_treatments)) {
    builder <- with_non_media_treatments(
      builder, pdf,
      non_media_treatment_cols = non_media_treatments
    )
  }

  build_input_data(builder)
}

# S3 constructor: tag a Meridian InputData proxy for meridianR method dispatch.
new_meridian_input_data <- function(x) {
  add_class(x, "meridian_input_data")
}

# Build a NULL-safe named character vector tagging each column with the
# argument it came from (used to assemble the check_columns() input).
named_cols <- function(arg, values) {
  if (is.null(values) || !length(values)) {
    return(character(0))
  }
  values <- as.character(values)
  names(values) <- rep(arg, length(values))
  values
}

# Validate that named columns exist in `data`. `cols` is a named character
# vector where names are the argument each column came from (for messaging).
check_columns <- function(data, cols, call = rlang::caller_env()) {
  cols <- cols[!is.na(cols) & nzchar(cols)]
  if (!length(cols)) {
    return(invisible())
  }
  missing <- cols[!cols %in% names(data)]
  if (length(missing)) {
    args <- unique(names(missing))
    cli::cli_abort(
      c(
        "Columns referenced by {.arg {args}} are missing from {.arg data}.",
        "x" = "Not found: {.val {unname(missing)}}."
      ),
      call = call
    )
  }
  invisible()
}
