# autoplot() / plot() dispatch for a fitted model, routing to the plot_*() family.

plot_types <- c("fit", "roi", "contribution", "response", "hill", "adstock", "rhat")

plot_dispatch <- function(x, type, ...) {
  fun <- switch(type,
    fit = plot_model_fit,
    roi = plot_roi,
    contribution = plot_contribution,
    response = plot_response_curves,
    hill = plot_hill_curves,
    adstock = plot_adstock_decay,
    rhat = plot_rhat
  )
  fun(x, ...)
}

#' Plot a fitted Meridian model
#'
#' `autoplot()` builds a ggplot for a fitted model, and `plot()` draws it. The
#' `type` argument selects which chart, dispatching to the `plot_*()` family
#' (e.g. [plot_model_fit()], [plot_roi()], [plot_response_curves()]).
#'
#' @param object,x A fitted `meridian_model`.
#' @param type One of `"fit"`, `"roi"`, `"contribution"`, `"response"`, `"hill"`,
#'   `"adstock"`, or `"rhat"`.
#' @param ... Passed to the underlying `plot_*()` function.
#'
#' @return `autoplot()` returns a ggplot object; `plot()` draws it and returns it
#'   invisibly.
#' @method autoplot meridian_model
#' @export
#'
#' @examples
#' \dontrun{
#' autoplot(mmm, type = "roi")
#' plot(mmm, type = "response")
#' }
autoplot.meridian_model <- function(object, type = plot_types, ...) {
  type <- match.arg(type, plot_types)
  plot_dispatch(object, type, ...)
}

#' @rdname autoplot.meridian_model
#' @method plot meridian_model
#' @export
plot.meridian_model <- function(x, type = plot_types, ...) {
  p <- autoplot.meridian_model(x, type = match.arg(type, plot_types), ...)
  print(p)
  invisible(p)
}
