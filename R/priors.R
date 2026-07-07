#' Prior distributions for a Meridian model
#'
#' `prior_distribution()` builds Meridian's `PriorDistribution`, the container of
#' priors used by a [model_spec()]. Supply named priors built with the
#' `prior_*()` distribution constructors; anything you omit keeps Meridian's
#' default. The most commonly customized priors are the ROI priors `roi_m`
#' (media) and `roi_rf` (reach & frequency).
#'
#' Accepted names are the fields of Meridian's `PriorDistribution`, including:
#' `roi_m`, `roi_rf`, `mroi_m`, `mroi_rf`, `contribution_m`, `contribution_rf`,
#' `beta_m`, `beta_rf`, `alpha_m` (adstock), `ec_m`, `slope_m` (Hill saturation),
#' `sigma`, `tau_g_excl_baseline`, and `knot_values`.
#'
#' @param ... Named priors, e.g. `roi_m = prior_lognormal(0.2, 0.9)`.
#'
#' @return A `meridian_prior` object.
#' @seealso [prior_lognormal()] and friends for the distribution constructors;
#'   [model_spec()] to attach the priors to a model configuration.
#' @export
#'
#' @examples
#' \dontrun{
#' prior_distribution(
#'   roi_m  = prior_lognormal(0.2, 0.9),
#'   roi_rf = prior_lognormal(0.2, 0.9)
#' )
#' }
prior_distribution <- function(...) {
  ensure_meridian()
  spec <- do.call(meridian$model$prior_distribution$PriorDistribution, list(...))
  add_class(spec, "meridian_prior")
}

# Backend-aware access to the TensorFlow-Probability distributions module.
tfd <- function() {
  ensure_meridian()
  meridian$backend$tfd
}

# Construct a tfd distribution by class name, dropping NULL arguments.
tfd_dist <- function(cls, ...) {
  do.call(tfd()[[cls]], compact(list(...)))
}

#' Prior distribution constructors
#'
#' Thin, backend-aware wrappers over Meridian's TensorFlow-Probability
#' distributions (`meridian$backend$tfd`), for use inside [prior_distribution()].
#' They return a Python distribution object.
#'
#' @param loc,scale,low,high,concentration1,concentration0 Distribution
#'   parameters (numeric).
#' @param name Optional distribution name.
#'
#' @return A TensorFlow-Probability distribution (a Python object).
#' @name prior_constructors
#' @seealso [prior_distribution()]
NULL

#' @rdname prior_constructors
#' @export
prior_lognormal <- function(loc, scale, name = NULL) {
  tfd_dist("LogNormal", loc = loc, scale = scale, name = name)
}

#' @rdname prior_constructors
#' @export
prior_normal <- function(loc, scale, name = NULL) {
  tfd_dist("Normal", loc = loc, scale = scale, name = name)
}

#' @rdname prior_constructors
#' @export
prior_halfnormal <- function(scale, name = NULL) {
  tfd_dist("HalfNormal", scale = scale, name = name)
}

#' @rdname prior_constructors
#' @export
prior_truncated_normal <- function(loc, scale, low, high, name = NULL) {
  tfd_dist("TruncatedNormal", loc = loc, scale = scale, low = low, high = high, name = name)
}

#' @rdname prior_constructors
#' @export
prior_uniform <- function(low, high, name = NULL) {
  tfd_dist("Uniform", low = low, high = high, name = name)
}

#' @rdname prior_constructors
#' @export
prior_beta <- function(concentration1, concentration0, name = NULL) {
  tfd_dist("Beta", concentration1 = concentration1, concentration0 = concentration0, name = name)
}

#' @rdname prior_constructors
#' @export
prior_deterministic <- function(loc, name = NULL) {
  tfd_dist("Deterministic", loc = loc, name = name)
}
