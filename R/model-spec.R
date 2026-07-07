#' Configure a Meridian model
#'
#' `model_spec()` builds Meridian's `ModelSpec`, which controls the adstock/lag
#' structure, saturation, media-effect distribution, prior types, spline knots,
#' and calibration. Any argument left `NULL` uses Meridian's own default. Attach
#' custom priors by passing a [prior_distribution()] to `prior`.
#'
#' @param prior A `meridian_prior` from [prior_distribution()].
#' @param media_effects_dist `"log_normal"` (Meridian default) or `"normal"`.
#' @param hill_before_adstock Apply Hill saturation before adstock? Defaults to
#'   `FALSE` in Meridian.
#' @param max_lag Maximum adstock lag, in time periods (integer; Meridian
#'   default 8).
#' @param unique_sigma_for_each_geo Estimate a separate residual standard
#'   deviation per geo?
#' @param paid_media_prior_type,rf_prior_type How the paid-media and
#'   reach-and-frequency priors are parameterized, e.g. `"roi"`, `"mroi"`,
#'   `"contribution"`, or `"coefficient"`.
#' @param knots Number of spline knots (a single integer) or a vector of knot
#'   positions, controlling the time-varying baseline.
#' @param baseline_geo Baseline geo, given as a geo name or an integer index.
#' @param holdout_id Optional array/boolean matrix marking held-out
#'   observations for out-of-sample evaluation.
#' @param adstock_decay_spec Adstock decay function: `"geometric"` (default) or
#'   `"binomial"`, or a named list giving a function per channel.
#' @param saturation_spec Saturation function: `"hill"` (default), or a named
#'   list per channel.
#' @param ... Further arguments forwarded to `ModelSpec`, such as
#'   `media_prior_type`, `roi_calibration_period`, `organic_media_prior_type`,
#'   `non_media_treatments_prior_type`, or `enable_aks`.
#'
#' @return A `meridian_model_spec` object.
#' @seealso [prior_distribution()], [meridian_model()]
#' @export
#'
#' @examples
#' \dontrun{
#' spec <- model_spec(
#'   prior              = prior_distribution(roi_m = prior_lognormal(0.2, 0.9)),
#'   max_lag            = 8,
#'   media_effects_dist = "log_normal"
#' )
#' }
model_spec <- function(prior = NULL,
                       media_effects_dist = NULL,
                       hill_before_adstock = NULL,
                       max_lag = NULL,
                       unique_sigma_for_each_geo = NULL,
                       paid_media_prior_type = NULL,
                       rf_prior_type = NULL,
                       knots = NULL,
                       baseline_geo = NULL,
                       holdout_id = NULL,
                       adstock_decay_spec = NULL,
                       saturation_spec = NULL,
                       ...) {
  ensure_meridian()

  if (!is.null(knots)) {
    knots <- if (length(knots) == 1) as.integer(knots) else as.list(as.integer(knots))
  }
  if (is.numeric(baseline_geo)) {
    baseline_geo <- as.integer(baseline_geo)
  }

  args <- compact(list(
    prior = prior,
    media_effects_dist = media_effects_dist,
    hill_before_adstock = hill_before_adstock,
    max_lag = as_py_int(max_lag),
    unique_sigma_for_each_geo = unique_sigma_for_each_geo,
    paid_media_prior_type = paid_media_prior_type,
    rf_prior_type = rf_prior_type,
    knots = knots,
    baseline_geo = baseline_geo,
    holdout_id = holdout_id,
    adstock_decay_spec = adstock_decay_spec,
    saturation_spec = saturation_spec,
    ...
  ))

  spec <- do.call(meridian$model$spec$ModelSpec, args)
  add_class(spec, "meridian_model_spec")
}
