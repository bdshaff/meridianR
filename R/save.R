#' Save and load a Meridian model
#'
#' `save_model()` serializes a Meridian model -- including its inference data --
#' to a file, and `load_model()` restores it. Thin bindings to Meridian's
#' `save_mmm()` and `load_mmm()`.
#'
#' @param model A `meridian_model`.
#' @param path File path to write to or read from.
#'
#' @return `save_model()` returns `path` invisibly; `load_model()` returns a
#'   `meridian_model`.
#' @export
#'
#' @examples
#' \dontrun{
#' save_model(mmm, "mmm.pkl")
#' mmm2 <- load_model("mmm.pkl")
#' }
save_model <- function(model, path) {
  ensure_meridian()
  meridian$model$model$save_mmm(model, path)
  invisible(path)
}

#' @rdname save_model
#' @export
load_model <- function(path) {
  ensure_meridian()
  add_class(meridian$model$model$load_mmm(path), "meridian_model")
}
