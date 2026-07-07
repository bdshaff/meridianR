#' Create a Meridian model
#'
#' `meridian_model()` constructs Meridian's `Meridian` model object from input
#' data and an optional [model_spec()]. The model is *unfit* until you draw from
#' the prior and posterior with [sample_prior()] and [sample_posterior()] (or the
#' [fit()] convenience).
#'
#' @param input A `meridian_input_data` from [as_meridian_input()].
#' @param spec A `meridian_model_spec` from [model_spec()]. When `NULL`,
#'   Meridian's default specification is used.
#' @param ... Further arguments passed to the `Meridian` constructor (e.g.
#'   `inference_data`).
#'
#' @return A `meridian_model` object.
#' @seealso [sample_prior()], [sample_posterior()], [fit()]
#' @export
#'
#' @examples
#' \dontrun{
#' mmm <- meridian_model(input, model_spec(max_lag = 8))
#' fit(mmm, n_chains = 4, n_keep = 1000)
#' }
meridian_model <- function(input, spec = NULL, ...) {
  ensure_meridian()
  args <- compact(list(input_data = input, model_spec = spec, ...))
  mmm <- do.call(meridian$model$model$Meridian, args)
  add_class(mmm, "meridian_model")
}
