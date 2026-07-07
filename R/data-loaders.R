# Faithful bindings to Meridian's column-mapping and data-loader classes, for
# users who want to load directly from a CSV or a pre-shaped data frame using
# Meridian's own CoordToColumns mapping.

#' Map data columns to Meridian coordinates
#'
#' Thin binding to Meridian's `CoordToColumns`, which tells a data loader which
#' columns hold each Meridian coordinate. Scalar fields take a single column
#' name; the media/control fields take character vectors.
#'
#' @param time,geo,kpi,population,revenue_per_kpi Single column names.
#' @param controls,media,media_spend,reach,frequency,rf_spend,non_media_treatments,organic_media,organic_reach,organic_frequency
#'   Character vectors of column names (or `NULL`).
#'
#' @return A `meridian_coord_to_columns` object.
#' @seealso [csv_loader()], [data_frame_loader()]
#' @export
coord_to_columns <- function(time = "time",
                             geo = "geo",
                             kpi = "kpi",
                             population = "population",
                             revenue_per_kpi = NULL,
                             controls = NULL,
                             media = NULL,
                             media_spend = NULL,
                             reach = NULL,
                             frequency = NULL,
                             rf_spend = NULL,
                             non_media_treatments = NULL,
                             organic_media = NULL,
                             organic_reach = NULL,
                             organic_frequency = NULL) {
  ensure_meridian()
  ctc <- meridian$data$load$CoordToColumns(
    time = time,
    geo = geo,
    kpi = kpi,
    population = population,
    revenue_per_kpi = revenue_per_kpi,
    controls = as_py_list(controls),
    media = as_py_list(media),
    media_spend = as_py_list(media_spend),
    reach = as_py_list(reach),
    frequency = as_py_list(frequency),
    rf_spend = as_py_list(rf_spend),
    non_media_treatments = as_py_list(non_media_treatments),
    organic_media = as_py_list(organic_media),
    organic_reach = as_py_list(organic_reach),
    organic_frequency = as_py_list(organic_frequency)
  )
  add_class(ctc, "meridian_coord_to_columns")
}

#' Load Meridian input data from a CSV file or data frame
#'
#' Faithful bindings to Meridian's `CsvDataLoader` and `DataFrameDataLoader`.
#' They return a loader object; call [load_input_data()] to produce the
#' `meridian_input_data`.
#'
#' @param csv_path Path to a CSV file (`csv_loader()`).
#' @param data A data frame (`data_frame_loader()`).
#' @param coord_to_columns A [coord_to_columns()] mapping.
#' @param kpi_type `"non_revenue"` (default) or `"revenue"`.
#' @param media_to_channel,media_spend_to_channel,reach_to_channel,frequency_to_channel,rf_spend_to_channel,organic_reach_to_channel,organic_frequency_to_channel
#'   Optional named lists mapping data columns to channel names.
#'
#' @return A `meridian_data_loader` object.
#' @seealso [load_input_data()], [as_meridian_input()]
#' @export
csv_loader <- function(csv_path,
                       coord_to_columns,
                       kpi_type = c("non_revenue", "revenue"),
                       media_to_channel = NULL,
                       media_spend_to_channel = NULL,
                       reach_to_channel = NULL,
                       frequency_to_channel = NULL,
                       rf_spend_to_channel = NULL,
                       organic_reach_to_channel = NULL,
                       organic_frequency_to_channel = NULL) {
  kpi_type <- match.arg(kpi_type)
  ensure_meridian()
  loader <- meridian$data$load$CsvDataLoader(
    csv_path = csv_path,
    coord_to_columns = coord_to_columns,
    kpi_type = kpi_type,
    media_to_channel = media_to_channel,
    media_spend_to_channel = media_spend_to_channel,
    reach_to_channel = reach_to_channel,
    frequency_to_channel = frequency_to_channel,
    rf_spend_to_channel = rf_spend_to_channel,
    organic_reach_to_channel = organic_reach_to_channel,
    organic_frequency_to_channel = organic_frequency_to_channel
  )
  add_class(loader, "meridian_data_loader")
}

#' @rdname csv_loader
#' @export
data_frame_loader <- function(data,
                              coord_to_columns,
                              kpi_type = c("non_revenue", "revenue"),
                              media_to_channel = NULL,
                              media_spend_to_channel = NULL,
                              reach_to_channel = NULL,
                              frequency_to_channel = NULL,
                              rf_spend_to_channel = NULL,
                              organic_reach_to_channel = NULL,
                              organic_frequency_to_channel = NULL) {
  kpi_type <- match.arg(kpi_type)
  ensure_meridian()
  loader <- meridian$data$load$DataFrameDataLoader(
    df = df_to_pandas(data),
    coord_to_columns = coord_to_columns,
    kpi_type = kpi_type,
    media_to_channel = media_to_channel,
    media_spend_to_channel = media_spend_to_channel,
    reach_to_channel = reach_to_channel,
    frequency_to_channel = frequency_to_channel,
    rf_spend_to_channel = rf_spend_to_channel,
    organic_reach_to_channel = organic_reach_to_channel,
    organic_frequency_to_channel = organic_frequency_to_channel
  )
  add_class(loader, "meridian_data_loader")
}

#' Realize input data from a loader
#'
#' Calls a loader's `.load()` method and wraps the result.
#'
#' @param loader A `meridian_data_loader` from [csv_loader()] or
#'   [data_frame_loader()].
#' @return A `meridian_input_data` object.
#' @export
load_input_data <- function(loader) {
  new_meridian_input_data(loader$load())
}
