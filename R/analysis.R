# Analysis layer: an Analyzer binding plus tidy accessors that return tibbles.
#
# The Analyzer is imported with convert = FALSE so xarray/pandas results can be
# reshaped on the Python side (reset_index) before being converted to tibbles;
# see xr_to_tibble() / pd_to_tibble() in conversions.R. Every accessor routes its
# Analyzer call through analyzer_xr()/analyzer_pd().

# Build a convert = FALSE Analyzer from a fitted model.
new_analyzer <- function(model) {
  reticulate::import("meridian.analysis.analyzer", convert = FALSE)$Analyzer(model)
}

# Accept either a model or an existing analyzer.
as_analyzer <- function(x) {
  ensure_meridian()
  if (inherits(x, "meridian_analyzer")) x else new_analyzer(x)
}

# Run `fn(analyzer)` -- a direct `$` method call, which preserves reticulate's
# clean Python-exception surfacing -- and convert its result to a tibble.
analyzer_xr <- function(model, fn) {
  xr_to_tibble(fn(as_analyzer(model)))
}
analyzer_pd <- function(model, fn) {
  pd_to_tibble(fn(as_analyzer(model)))
}

#' Create a Meridian analyzer
#'
#' Wraps Meridian's `Analyzer`, the engine behind the tidy accessors in this
#' package ([summary_metrics()], [response_curves()], and friends). You rarely
#' need to call this directly -- the accessors accept a fitted model and build an
#' analyzer internally -- but reusing one analyzer across several calls avoids
#' repeated setup.
#'
#' @param model A fitted `meridian_model`.
#' @return A `meridian_analyzer` object.
#' @seealso [summary_metrics()], [response_curves()], [hill_curves()],
#'   [adstock_decay()], [rhat_summary()], [expected_vs_actual()]
#' @export
analyzer <- function(model) {
  ensure_meridian()
  add_class(new_analyzer(model), "meridian_analyzer")
}

#' Channel-level summary metrics
#'
#' Tidy per-channel metrics -- ROI, marginal ROI, incremental outcome, share of
#' contribution, effectiveness, CPIK, and more -- for the prior and posterior.
#'
#' @param model A fitted `meridian_model` or a [analyzer()].
#' @param confidence_level Width of the credible intervals (default 0.9).
#' @param aggregate_geos,aggregate_times Aggregate over geos / time periods?
#' @param selected_geos,selected_times Optional subsets of geos / times.
#' @param ... Further arguments passed to Meridian's `summary_metrics()`.
#'
#' @return A tibble in long form with `channel`, `metric`
#'   (`mean`/`median`/`ci_lo`/`ci_hi`), `distribution` (`prior`/`posterior`), and
#'   one column per metric (`roi`, `mroi`, `incremental_outcome`,
#'   `pct_of_contribution`, `effectiveness`, `cpik`, ...).
#' @family analysis accessors
#' @export
summary_metrics <- function(model,
                            confidence_level = 0.9,
                            aggregate_geos = TRUE,
                            aggregate_times = TRUE,
                            selected_geos = NULL,
                            selected_times = NULL,
                            ...) {
  analyzer_xr(model, function(a) a$summary_metrics(
    confidence_level = confidence_level,
    aggregate_geos = aggregate_geos,
    aggregate_times = aggregate_times,
    selected_geos = as_py_list(selected_geos),
    selected_times = as_py_list(selected_times),
    ...
  ))
}

#' Expected versus actual KPI over time
#'
#' @inheritParams summary_metrics
#' @param aggregate_geos,aggregate_times Aggregate over geos / time periods?
#'   Defaults aggregate over geos (national fit) and keep time.
#' @param ... Further arguments passed to `expected_vs_actual_data()`.
#'
#' @return A tibble with `time`, `metric` (`mean`/`ci_lo`/`ci_hi`), `expected`,
#'   `baseline`, and `actual`.
#' @family analysis accessors
#' @export
expected_vs_actual <- function(model,
                               aggregate_geos = TRUE,
                               aggregate_times = FALSE,
                               confidence_level = 0.9,
                               ...) {
  analyzer_xr(model, function(a) a$expected_vs_actual_data(
    aggregate_geos = aggregate_geos,
    aggregate_times = aggregate_times,
    confidence_level = confidence_level,
    ...
  ))
}

#' Response curves (incremental outcome versus spend)
#'
#' @inheritParams summary_metrics
#' @param use_posterior Use posterior (default) or prior draws.
#' @param spend_multipliers Optional numeric vector of spend multipliers at which
#'   to evaluate the curves.
#' @param ... Further arguments passed to `response_curves()`.
#'
#' @return A tibble with `spend_multiplier`, `channel`, `metric`, `spend`, and
#'   `incremental_outcome`.
#' @family analysis accessors
#' @export
response_curves <- function(model,
                            confidence_level = 0.9,
                            use_posterior = TRUE,
                            spend_multipliers = NULL,
                            ...) {
  analyzer_xr(model, function(a) a$response_curves(
    confidence_level = confidence_level,
    use_posterior = use_posterior,
    spend_multipliers = if (is.null(spend_multipliers)) NULL else as.list(as.numeric(spend_multipliers)),
    ...
  ))
}

#' Hill saturation curves
#'
#' @inheritParams summary_metrics
#' @param n_bins Number of histogram bins for the media-units distribution.
#'
#' @return A tibble with `channel`, `media_units`, `distribution`, `mean`,
#'   `ci_lo`, `ci_hi`, and histogram columns.
#' @family analysis accessors
#' @export
hill_curves <- function(model, confidence_level = 0.9, n_bins = 25) {
  analyzer_pd(model, function(a) a$hill_curves(
    confidence_level = confidence_level, n_bins = as_py_int(n_bins)
  ))
}

#' Adstock decay curves
#'
#' @inheritParams summary_metrics
#'
#' @return A tibble with `channel`, `time_units`, `distribution`, `mean`,
#'   `ci_lo`, and `ci_hi`.
#' @family analysis accessors
#' @export
adstock_decay <- function(model, confidence_level = 0.9) {
  analyzer_pd(model, function(a) a$adstock_decay(confidence_level = confidence_level))
}

#' Convergence diagnostics (R-hat) summary
#'
#' @param model A fitted `meridian_model` or a [analyzer()].
#' @param bad_rhat_threshold R-hat above which a parameter is flagged.
#'
#' @return A tibble with one row per parameter block: `param`, `n_params`,
#'   `avg_rhat`, `max_rhat`, and `percent_bad_rhat`.
#' @family analysis accessors
#' @export
rhat_summary <- function(model, bad_rhat_threshold = 1.2) {
  t <- analyzer_pd(model, function(a) a$rhat_summary(bad_rhat_threshold = bad_rhat_threshold))
  keep <- intersect(
    c("param", "n_params", "avg_rhat", "max_rhat", "percent_bad_rhat"),
    names(t)
  )
  t[keep]
}

#' Predictive accuracy metrics
#'
#' @inheritParams summary_metrics
#' @param ... Further arguments passed to `predictive_accuracy()`.
#'
#' @return A tibble of predictive-accuracy metrics (e.g. R-squared, MAPE, wMAPE)
#'   by evaluation set.
#' @family analysis accessors
#' @export
predictive_accuracy <- function(model, ...) {
  analyzer_xr(model, function(a) a$predictive_accuracy(...))
}

#' Write Meridian's HTML model-results summary
#'
#' An escape hatch to Meridian's own two-page HTML summary report (via its
#' `Summarizer`), for when you want the built-in report instead of the tidy
#' accessors and ggplot2 charts in this package.
#'
#' @param model A fitted `meridian_model`.
#' @param path Output HTML file path.
#' @param start_date,end_date Optional date strings (e.g. `"2022-01-03"`) that
#'   limit the reporting window.
#'
#' @return `path`, invisibly.
#' @export
model_report <- function(model, path = "meridian_summary.html",
                         start_date = NULL, end_date = NULL) {
  ensure_meridian()
  path <- normalizePath(path, mustWork = FALSE)
  summarizer <- meridian$analysis$summarizer$Summarizer(model)
  summarizer$output_model_results_summary(
    filename = basename(path),
    filepath = dirname(path),
    start_date = start_date,
    end_date = end_date
  )
  cli::cli_alert_success("Wrote model results summary to {.path {path}}.")
  invisible(path)
}
