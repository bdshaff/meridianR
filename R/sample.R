#' Draw from a Meridian model's prior and posterior
#'
#' `sample_prior()` and `sample_posterior()` run Meridian's prior and MCMC
#' posterior sampling. Both **modify the model in place** (drawn samples are
#' merged into the model's ArviZ `inference_data`) and return the same model
#' object invisibly, so they compose with the native pipe. [fit()] is a
#' convenience that runs both.
#'
#' @param model A `meridian_model` from [meridian_model()].
#' @param n_draws Number of prior draws.
#' @param n_chains Number of MCMC chains (an integer, or a vector of integers to
#'   split sampling into several calls to reduce peak memory).
#' @param n_adapt,n_burnin,n_keep Number of adaptation, burn-in, and kept draws
#'   per chain.
#' @param seed Optional integer (or vector) random seed.
#' @param ... Further arguments forwarded to Meridian's `sample_posterior()`
#'   (e.g. `max_tree_depth`, `parallel_iterations`).
#'
#' @return The (modified) `meridian_model`, invisibly.
#' @seealso [meridian_model()], [fit()]
#' @export
sample_prior <- function(model, n_draws = 500, seed = NULL) {
  ensure_meridian()
  model$sample_prior(n_draws = as_py_int(n_draws), seed = as_py_int(seed))
  invisible(model)
}

#' @rdname sample_prior
#' @export
sample_posterior <- function(model,
                             n_chains = 7,
                             n_adapt = 500,
                             n_burnin = 500,
                             n_keep = 1000,
                             seed = NULL,
                             ...) {
  ensure_meridian()
  model$sample_posterior(
    n_chains = as_py_int(n_chains),
    n_adapt = as_py_int(n_adapt),
    n_burnin = as_py_int(n_burnin),
    n_keep = as_py_int(n_keep),
    seed = as_py_int(seed),
    ...
  )
  invisible(model)
}

#' Fit a Meridian model
#'
#' Convenience wrapper that draws from the prior and then runs posterior MCMC
#' sampling, modifying `object` in place. Equivalent to calling [sample_prior()]
#' followed by [sample_posterior()].
#'
#' @param object A `meridian_model` from [meridian_model()].
#' @param prior_draws Number of prior draws.
#' @param n_chains,n_adapt,n_burnin,n_keep Posterior MCMC settings, passed to
#'   [sample_posterior()].
#' @param seed Optional integer (or vector) random seed.
#' @param ... Further arguments forwarded to [sample_posterior()].
#'
#' @return The fitted `meridian_model`, invisibly.
#' @method fit meridian_model
#' @export
fit.meridian_model <- function(object,
                               prior_draws = 500,
                               n_chains = 7,
                               n_adapt = 500,
                               n_burnin = 500,
                               n_keep = 1000,
                               seed = NULL,
                               ...) {
  sample_prior(object, n_draws = prior_draws, seed = seed)
  sample_posterior(
    object,
    n_chains = n_chains, n_adapt = n_adapt, n_burnin = n_burnin, n_keep = n_keep,
    seed = seed, ...
  )
  invisible(object)
}
