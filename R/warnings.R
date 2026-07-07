# Route Python warnings through R.
#
# Meridian (and its dependencies) emit warnings via Python's `warnings.warn()`,
# which reticulate prints raw -- file path, line number, and source line
# included -- and which R's suppressWarnings()/withCallingHandlers() cannot see.
# configure_py_warnings() installs an R handler as Python's `showwarning`, so
# these surface as tidy R warnings of class "meridian_python_warning": they are
# cli-formatted, and can be caught or muffled with the usual R machinery.
#
# Installed automatically the first time Meridian is imported (see zzz.R).
# Disable with options(meridianR.reformat_warnings = FALSE).
configure_py_warnings <- function() {
  if (!isTRUE(getOption("meridianR.reformat_warnings", TRUE))) {
    return(invisible(FALSE))
  }
  warnings <- reticulate::import("warnings")
  warnings$showwarning <- function(message, category, filename, lineno,
                                   file = NULL, line = NULL) {
    tryCatch(
      {
        # `message` is a Python Warning instance; its str() is the clean text.
        # Pass it as data ({msg}) so braces in the message are not interpolated.
        msg <- reticulate::py_str(message)
        cli::cli_warn("{msg}", class = "meridian_python_warning")
      },
      error = function(e) NULL
    )
    invisible(NULL)
  }
  invisible(TRUE)
}
