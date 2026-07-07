# Installation and Python environment management.

#' Install Meridian and its Python dependencies
#'
#' Creates (or reuses) a persistent Python virtual environment and installs the
#' `google-meridian` package together with the backend of your choice. Once
#' installed, meridianR will use this environment automatically in future
#' sessions.
#'
#' If you skip this step, meridianR still works: [reticulate::py_require()] (set
#' up on load) will provision an ephemeral environment containing Meridian the
#' first time Python is used. `install_meridian()` is recommended when you want
#' a reusable environment, GPU support, or the experimental JAX backend.
#'
#' @param envname Name of (or path to) the virtual environment to install into.
#'   Defaults to `"r-meridian"`.
#' @param ... Additional arguments passed to [reticulate::py_install()].
#' @param backend Compute backend to provision: `"tensorflow"` (default) or the
#'   experimental `"jax"` backend. The JAX backend pulls in the
#'   `google-meridian[jax]` extra and is recorded as the default backend for
#'   future sessions (see [use_backend()]).
#' @param gpu Logical; if `TRUE`, install the CUDA GPU build
#'   (`google-meridian[and-cuda]`). Ignored on platforms without CUDA support.
#' @param python_version Python version constraint used when creating a new
#'   environment. Meridian requires Python >= 3.10.
#' @param new_env If `TRUE`, any existing environment of the same name is
#'   removed before installing. Defaults to `TRUE` only for the default
#'   `"r-meridian"` environment.
#'
#' @return The environment name, invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Default CPU / TensorFlow install
#' install_meridian()
#'
#' # GPU build
#' install_meridian(gpu = TRUE)
#'
#' # Experimental JAX backend
#' install_meridian(backend = "jax")
#' }
install_meridian <- function(envname = "r-meridian",
                             ...,
                             backend = c("tensorflow", "jax"),
                             gpu = FALSE,
                             python_version = ">=3.10",
                             new_env = identical(envname, "r-meridian")) {
  backend <- match.arg(backend)
  pkg <- meridian_pip_spec(backend = backend, gpu = gpu)

  if (isTRUE(new_env) && reticulate::virtualenv_exists(envname)) {
    reticulate::virtualenv_remove(envname, confirm = FALSE)
  }

  reticulate::py_install(
    packages = pkg,
    envname = envname,
    pip = TRUE,
    python_version = python_version,
    ...
  )

  options(meridianR.virtualenv = envname, meridianR.backend = backend)

  cli::cli_alert_success("Installed {.val {pkg}} into virtualenv {.val {envname}}.")
  cli::cli_alert_info(
    "Restart R to use it, or call reticulate::use_virtualenv({.val {envname}}) first."
  )
  invisible(envname)
}

# Build the pip requirement string with the appropriate extras.
meridian_pip_spec <- function(backend = "tensorflow", gpu = FALSE) {
  extras <- character()
  if (isTRUE(gpu)) extras <- c(extras, "and-cuda")
  if (identical(backend, "jax")) extras <- c(extras, "jax")
  if (length(extras)) {
    sprintf("google-meridian[%s]", paste(extras, collapse = ","))
  } else {
    "google-meridian"
  }
}

#' Select the Meridian compute backend
#'
#' Meridian can run on a TensorFlow (default) or an experimental JAX backend.
#' The backend is read from the `MERIDIAN_BACKEND` environment variable when the
#' Meridian Python module is first imported, so for a reliable switch call
#' `use_backend()` *before* any other meridianR function in a session. If
#' Meridian is already loaded, `use_backend()` additionally attempts a runtime
#' switch, which may not take full effect until the session is restarted.
#'
#' @param backend `"tensorflow"` or `"jax"`.
#'
#' @return The selected backend, invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' use_backend("jax")
#' }
use_backend <- function(backend = c("tensorflow", "jax")) {
  backend <- match.arg(backend)
  options(meridianR.backend = backend)
  Sys.setenv(MERIDIAN_BACKEND = backend)

  if (meridian_available()) {
    meridian$backend$config$set_backend(backend)
    cli::cli_alert_info(
      "Meridian is already loaded; backend switched to {.val {backend}} at runtime. Restart R if you hit backend errors."
    )
  } else {
    cli::cli_alert_success("Meridian backend set to {.val {backend}}.")
  }
  invisible(backend)
}

#' Is the Meridian Python package available?
#'
#' Checks whether the `meridian` Python module can be imported in the active
#' reticulate configuration. The first call may initialize Python (and, if no
#' environment is configured, trigger [reticulate::py_require()] provisioning).
#'
#' @return `TRUE` or `FALSE`.
#' @export
meridian_available <- function() {
  reticulate::py_module_available("meridian")
}

#' Installed Meridian version
#'
#' @return A string with the Meridian Python package version.
#' @export
meridian_version <- function() {
  ensure_meridian()
  reticulate::py_to_r(meridian[["__version__"]])
}

# Internal: error helpfully if Meridian cannot be imported, distinguishing
# "not installed" from "the wrong Python interpreter is active" (a common
# reticulate pitfall when an IDE or RETICULATE_PYTHON pins another environment).
ensure_meridian <- function(call = rlang::caller_env()) {
  if (meridian_available()) {
    return(invisible(TRUE))
  }

  venv <- getOption("meridianR.virtualenv", default = "r-meridian")
  cfg <- tryCatch(reticulate::py_config(), error = function(e) NULL)
  active <- if (!is.null(cfg)) {
    sprintf("%s (Python %s)", cfg$python, cfg$version)
  } else {
    "none initialized"
  }

  msg <- c("Meridian could not be imported.", "i" = "Active Python: {active}.")
  if (reticulate::virtualenv_exists(venv)) {
    msg <- c(
      msg,
      "i" = "Meridian is installed in the {.val {venv}} environment, but a different Python is active.",
      ">" = "Restart R, then run {.code reticulate::use_virtualenv(\"{venv}\", required = TRUE)} before anything else -- or set your IDE's Python interpreter to that environment."
    )
  } else {
    msg <- c(
      msg,
      "i" = "Install it with {.run meridianR::install_meridian()}, or point reticulate at an existing environment with {.fn reticulate::use_virtualenv} and restart R."
    )
  }
  cli::cli_abort(msg, call = call)
}
