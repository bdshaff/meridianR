.onLoad <- function(libname, pkgname) {
  # Honor a backend selected via the `meridianR.backend` option (or an existing
  # MERIDIAN_BACKEND value) before Python starts. Meridian reads this
  # environment variable at import time to choose its TensorFlow or JAX backend.
  backend <- getOption(
    "meridianR.backend",
    default = Sys.getenv("MERIDIAN_BACKEND", unset = "")
  )
  if (nzchar(backend)) {
    Sys.setenv(MERIDIAN_BACKEND = tolower(backend))
  }

  # Prefer a persistent environment created by install_meridian(). If it exists,
  # hint reticulate to use it (this only records a preference; Python is not
  # started here).
  venv <- getOption("meridianR.virtualenv", default = "r-meridian")
  if (nzchar(venv) && reticulate::virtualenv_exists(venv)) {
    try(reticulate::use_virtualenv(venv, required = FALSE), silent = TRUE)
  }

  # Declare the Python dependency so reticulate can provision an environment
  # automatically on first use when no persistent environment (or an interpreter
  # set via RETICULATE_PYTHON) is configured.
  reticulate::py_require("google-meridian")

  # Populate the module handle declared in tethers.R with a lazy proxy. The
  # `<<-` superassignment updates the namespace binding while it is still
  # mutable inside .onLoad(). Python is NOT started here; the import is realized
  # on first access to `meridian$...`.
  meridian <<- reticulate::import("meridian", delay_load = list(
    on_load = function() configure_py_warnings()
  ))
}

.onAttach <- function(libname, pkgname) {
  # Warn (without starting Python) when RETICULATE_PYTHON is pinned to an
  # interpreter other than the Meridian environment -- a common cause of
  # "another version of Python has already been initialized" errors, e.g. when
  # an IDE selects a different interpreter.
  venv <- getOption("meridianR.virtualenv", default = "r-meridian")
  rp <- Sys.getenv("RETICULATE_PYTHON", unset = "")
  if (nzchar(rp) && !grepl(venv, rp, fixed = TRUE) &&
      reticulate::virtualenv_exists(venv)) {
    packageStartupMessage(
      sprintf(
        paste0(
          "meridianR: RETICULATE_PYTHON is set to '%s', not the '%s' environment.\n",
          "If Meridian fails to import, run reticulate::use_virtualenv(\"%s\", required = TRUE)\n",
          "before other code, or point your IDE's Python interpreter at that environment."
        ),
        rp, venv, venv
      )
    )
  }
}
