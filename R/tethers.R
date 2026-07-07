# Delayed handles to Python modules.
#
# These package-level bindings are `NULL` at build time and are populated in
# `.onLoad()` (see zzz.R) with lazy module proxies created by
# `reticulate::import(delay_load = TRUE)`. Importing meridianR therefore does
# not start Python; the underlying modules are imported on first access.

#' Direct handle to the Meridian Python module
#'
#' `meridian` is a module proxy that exposes the underlying
#' [Meridian](https://developers.google.com/meridian) Python package directly,
#' e.g. `meridian$model$model$Meridian` or `meridian$data$load$CsvDataLoader`.
#' It is the low-level escape hatch beneath the R wrappers: anything reachable
#' from Python is reachable here.
#'
#' The module is imported lazily. The first time you touch `meridian$...`,
#' reticulate initializes Python (provisioning an environment via
#' [install_meridian()] or [reticulate::py_require()] if needed).
#'
#' @return A Python module proxy (an object of class `python.builtin.module`).
#' @export
#'
#' @examples
#' \dontrun{
#' meridian$`__version__`
#' }
meridian <- NULL
