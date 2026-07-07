# TensorFlow's autograph writes `__autograph_generated_file*.py` and
# `__pycache__` into Python's temp directory during sampling. Under R CMD check
# that is the check's TMPDIR, so it is reported as leftover detritus. Remove it
# after the suite. (These Python-touching tests skip on CRAN, so this only
# affects local and CI runs.)
withr::defer(
  {
    ok <- tryCatch(meridian_available(), error = function(e) FALSE)
    if (isTRUE(ok)) {
      pytmp <- reticulate::import("tempfile")$gettempdir()
      junk <- list.files(
        pytmp,
        pattern = "^(__autograph_generated_file|__pycache__)",
        full.names = TRUE
      )
      unlink(junk, recursive = TRUE, force = TRUE)
    }
  },
  teardown_env()
)
