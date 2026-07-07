# Conversion helpers between R and Meridian's Python objects. Every wrapper
# funnels argument marshalling through these so the call sites stay thin.

# Prepend an S3 subclass to a reticulate proxy so meridianR print/summary/plot
# methods dispatch on it, while leaving reticulate's `$`/`[[` access to the
# underlying Python object intact (its python.builtin.* classes stay in the
# class vector, so method forwarding still works).
add_class <- function(x, subclass) {
  class(x) <- unique(c(subclass, class(x)))
  x
}

# Remove NULL elements from a (named) list. Used to forward only user-supplied
# arguments as keyword arguments to Python constructors, letting Python defaults
# apply for everything omitted.
compact <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

# Coerce to a Python int (or pass through NULL). reticulate maps an R integer to
# a Python int, but an R double maps to a Python float, so integer-typed Python
# arguments must be coerced explicitly to avoid type errors.
as_py_int <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  as.integer(x)
}

# Ensure a value is passed to Python as a list/sequence rather than a scalar.
# Character/numeric vectors already convert to Python lists; this mostly guards
# length-1 vectors that should still be sequences (e.g. a single media column).
as_py_list <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  as.list(x)
}

# Convert an R data.frame to a pandas DataFrame suitable for Meridian's data
# builders. Date/time columns are rendered as ISO-8601 strings, which Meridian
# parses reliably regardless of R's date classes.
# --- Python -> R (tidy) -------------------------------------------------------

# Convert a pandas DataFrame (or an object reticulate already turned into a
# data.frame) into a tibble.
as_tibble_safe <- function(x) {
  df <- if (inherits(x, "python.builtin.object")) reticulate::py_to_r(x) else x
  tibble::as_tibble(df)
}

# xarray Dataset/DataArray -> tidy tibble, one row per coordinate combination,
# with the coordinates lifted out of the index into columns.
xr_to_tibble <- function(x) {
  as_tibble_safe(x$to_dataframe()$reset_index())
}

# pandas DataFrame -> tibble. Lifts a named or multi-level index into columns so
# nothing meaningful is dropped.
pd_to_tibble <- function(x) {
  idx <- reticulate::py_get_attr(x, "index", silent = TRUE)
  named <- !is.null(idx) &&
    (!is_py_none(reticulate::py_get_attr(idx, "name", silent = TRUE)) ||
      inherits(idx, "pandas.core.indexes.multi.MultiIndex"))
  # Lift a meaningful index into columns; otherwise drop the (possibly
  # non-unique) RangeIndex so reticulate does not warn about row names.
  x <- if (isTRUE(named)) x$reset_index() else x$reset_index(drop = TRUE)
  suppressWarnings(as_tibble_safe(x))
}

# --- R -> Python --------------------------------------------------------------

df_to_pandas <- function(data, arg = rlang::caller_arg(data), call = rlang::caller_env()) {
  # Pass through objects that are already Python (e.g. a pandas DataFrame),
  # so callers can convert once and reuse across several builder verbs.
  if (inherits(data, "python.builtin.object")) {
    return(data)
  }
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg {arg}} must be a data frame.", call = call)
  }
  data <- as.data.frame(data)
  for (nm in names(data)) {
    col <- data[[nm]]
    if (inherits(col, c("Date", "POSIXct", "POSIXt"))) {
      data[[nm]] <- format(col, "%Y-%m-%d")
    }
  }
  reticulate::r_to_py(data)
}
