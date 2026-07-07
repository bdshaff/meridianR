# Re-exported reticulate helpers, so common environment- and conversion-related
# tasks are available without attaching reticulate explicitly.

#' @importFrom reticulate import
#' @export
reticulate::import

#' @importFrom reticulate py_require
#' @export
reticulate::py_require

#' @importFrom reticulate py_config
#' @export
reticulate::py_config

#' @importFrom reticulate r_to_py
#' @export
reticulate::r_to_py

#' @importFrom reticulate py_to_r
#' @export
reticulate::py_to_r

#' @importFrom reticulate use_python
#' @export
reticulate::use_python

#' @importFrom reticulate use_virtualenv
#' @export
reticulate::use_virtualenv

#' @importFrom reticulate use_condaenv
#' @export
reticulate::use_condaenv

#' @importFrom generics fit
#' @export
generics::fit

#' @importFrom ggplot2 autoplot
#' @export
ggplot2::autoplot
