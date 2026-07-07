#' Build Meridian input data with a fluent builder
#'
#' `input_data_builder()` creates a Meridian `DataFrameInputDataBuilder`, and the
#' `with_*()` verbs add each data component from one or more R data frames.
#' Finish the chain with [build_input_data()]. This is the flexible, pipe-
#' friendly path; for the common case, [as_meridian_input()] wraps the whole
#' chain in a single call.
#'
#' Each verb returns the (modified) builder, so calls compose with the native
#' pipe:
#'
#' ```r
#' input_data_builder("non_revenue") |>
#'   with_kpi(df) |>
#'   with_population(df) |>
#'   with_controls(df, control_cols = c("gqv", "competitor_sales")) |>
#'   with_media(df,
#'     media_cols       = c("tv_impressions", "search_clicks"),
#'     media_spend_cols = c("tv_spend", "search_spend"),
#'     media_channels   = c("TV", "Search")) |>
#'   build_input_data()
#' ```
#'
#' @param kpi_type Either `"non_revenue"` or `"revenue"`.
#' @param geo,time,media_time,population,kpi,revenue_per_kpi Default column names
#'   the builder uses when a specific `*_col` argument is not supplied to a verb.
#'
#' @return `input_data_builder()` and every `with_*()` verb return a
#'   `meridian_input_builder`. [build_input_data()] returns a
#'   `meridian_input_data` object.
#' @seealso [as_meridian_input()] for the one-call interface.
#' @export
input_data_builder <- function(kpi_type = c("non_revenue", "revenue"),
                               geo = "geo",
                               time = "time",
                               media_time = time,
                               population = "population",
                               kpi = "kpi",
                               revenue_per_kpi = "revenue_per_kpi") {
  kpi_type <- match.arg(kpi_type)
  ensure_meridian()
  builder <- meridian$data$data_frame_input_data_builder$DataFrameInputDataBuilder(
    kpi_type = kpi_type,
    default_geo_column = geo,
    default_time_column = time,
    default_media_time_column = media_time,
    default_population_column = population,
    default_kpi_column = kpi,
    default_revenue_per_kpi_column = revenue_per_kpi
  )
  add_class(builder, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @param builder A `meridian_input_builder` from [input_data_builder()].
#' @param data A data frame containing the referenced columns.
#' @param kpi_col,time_col,geo_col,population_col,revenue_per_kpi_col,media_time_col
#'   Optional column-name overrides; default to the builder's defaults.
#' @export
with_kpi <- function(builder, data, kpi_col = NULL, time_col = NULL, geo_col = NULL) {
  out <- builder$with_kpi(
    df_to_pandas(data),
    kpi_col = kpi_col, time_col = time_col, geo_col = geo_col
  )
  add_class(out, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @export
with_population <- function(builder, data, population_col = NULL, geo_col = NULL) {
  out <- builder$with_population(
    df_to_pandas(data),
    population_col = population_col, geo_col = geo_col
  )
  add_class(out, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @param control_cols Character vector of control-variable column names.
#' @export
with_controls <- function(builder, data, control_cols, time_col = NULL, geo_col = NULL) {
  out <- builder$with_controls(
    df_to_pandas(data),
    control_cols = as_py_list(control_cols), time_col = time_col, geo_col = geo_col
  )
  add_class(out, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @export
with_revenue_per_kpi <- function(builder, data, revenue_per_kpi_col = NULL,
                                 time_col = NULL, geo_col = NULL) {
  out <- builder$with_revenue_per_kpi(
    df_to_pandas(data),
    revenue_per_kpi_col = revenue_per_kpi_col, time_col = time_col, geo_col = geo_col
  )
  add_class(out, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @param media_cols Character vector of media *execution* columns (e.g.
#'   impressions or clicks).
#' @param media_spend_cols Character vector of media *spend* columns, aligned
#'   with `media_cols`.
#' @param media_channels Character vector of channel names for the media.
#' @export
with_media <- function(builder, data, media_cols, media_spend_cols, media_channels,
                       time_col = NULL, geo_col = NULL) {
  out <- builder$with_media(
    df_to_pandas(data),
    media_cols = as_py_list(media_cols),
    media_spend_cols = as_py_list(media_spend_cols),
    media_channels = as_py_list(media_channels),
    time_col = time_col, geo_col = geo_col
  )
  add_class(out, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @param reach_cols,frequency_cols,rf_spend_cols Character vectors of reach,
#'   average-frequency, and spend columns for reach-and-frequency channels.
#' @param rf_channels Character vector of channel names for the R&F channels.
#' @export
with_reach <- function(builder, data, reach_cols, frequency_cols, rf_spend_cols,
                       rf_channels, time_col = NULL, geo_col = NULL) {
  out <- builder$with_reach(
    df_to_pandas(data),
    reach_cols = as_py_list(reach_cols),
    frequency_cols = as_py_list(frequency_cols),
    rf_spend_cols = as_py_list(rf_spend_cols),
    rf_channels = as_py_list(rf_channels),
    time_col = time_col, geo_col = geo_col
  )
  add_class(out, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @param organic_media_cols Character vector of organic-media execution columns.
#' @param organic_media_channels Optional channel names for organic media.
#' @export
with_organic_media <- function(builder, data, organic_media_cols,
                               organic_media_channels = NULL,
                               media_time_col = NULL, geo_col = NULL) {
  out <- builder$with_organic_media(
    df_to_pandas(data),
    organic_media_cols = as_py_list(organic_media_cols),
    organic_media_channels = as_py_list(organic_media_channels),
    media_time_col = media_time_col, geo_col = geo_col
  )
  add_class(out, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @param non_media_treatment_cols Character vector of non-media treatment
#'   columns (e.g. promotions, price changes).
#' @export
with_non_media_treatments <- function(builder, data, non_media_treatment_cols,
                                      time_col = NULL, geo_col = NULL) {
  out <- builder$with_non_media_treatments(
    df_to_pandas(data),
    non_media_treatment_cols = as_py_list(non_media_treatment_cols),
    time_col = time_col, geo_col = geo_col
  )
  add_class(out, "meridian_input_builder")
}

#' @rdname input_data_builder
#' @export
build_input_data <- function(builder) {
  new_meridian_input_data(builder$build())
}
