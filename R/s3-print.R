# Print / format / summary methods for meridianR's wrapped Python objects.
# These dispatch ahead of reticulate's own python.builtin.object methods because
# add_class() prepends the meridianR subclass to the object's class vector.

# --- internal accessors -------------------------------------------------------

is_py_none <- function(x) {
  is.null(x) || inherits(x, "python.builtin.NoneType")
}

# Coordinate values of an InputData xarray attribute, as an R vector or NULL.
input_coord <- function(x, name) {
  v <- reticulate::py_get_attr(x, name, silent = TRUE)
  if (is_py_none(v)) {
    return(NULL)
  }
  as.vector(reticulate::py_to_r(v$values))
}

# Names of the ArviZ inference-data groups present on a model.
model_groups <- function(model) {
  ic <- reticulate::py_get_attr(model, "inference_data", silent = TRUE)
  if (is_py_none(ic)) {
    return(character(0))
  }
  as.vector(reticulate::py_to_r(ic$groups()))
}

# chain/draw counts for the posterior group, or NULL if unfit.
posterior_dims <- function(model) {
  if (!"posterior" %in% model_groups(model)) {
    return(NULL)
  }
  sizes <- reticulate::py_to_r(model$inference_data$posterior$sizes)
  list(chains = sizes[["chain"]], draws = sizes[["draw"]])
}

# "Label: n (a, b, c, ...)" line for a channel/coordinate vector, or NULL.
count_line <- function(label, vec) {
  if (is.null(vec)) {
    return(NULL)
  }
  n <- length(vec)
  if (n == 0) {
    return(sprintf("%s: 0", label))
  }
  preview <- paste(vec[seq_len(min(6L, n))], collapse = ", ")
  if (n > 6) preview <- paste0(preview, ", ...")
  sprintf("%s: %d (%s)", label, n, preview)
}

# --- meridian_input_data ------------------------------------------------------

#' @export
print.meridian_input_data <- function(x, ...) {
  geos <- input_coord(x, "geo")
  times <- input_coord(x, "time")
  kpi_type <- tryCatch(
    reticulate::py_to_r(reticulate::py_get_attr(x, "kpi_type")),
    error = function(e) NA_character_
  )

  time_line <- if (!is.null(times) && length(times)) {
    sprintf("Time periods: %d (%s to %s)", length(times), times[1], times[length(times)])
  }

  lines <- compact(list(
    sprintf("KPI type: %s", kpi_type),
    count_line("Geos", geos),
    time_line,
    count_line("Media channels", input_coord(x, "media_channel")),
    count_line("RF channels", input_coord(x, "rf_channel")),
    count_line("Controls", input_coord(x, "control_variable")),
    count_line("Organic media", input_coord(x, "organic_media_channel")),
    count_line("Non-media treatments", input_coord(x, "non_media_channel"))
  ))

  cli::cli_text("{.strong <meridian_input_data>}")
  cli::cli_ul(unlist(lines))
  invisible(x)
}

# --- meridian_model_spec ------------------------------------------------------

#' @export
print.meridian_model_spec <- function(x, ...) {
  get1 <- function(name) {
    v <- reticulate::py_get_attr(x, name, silent = TRUE)
    if (is_py_none(v)) NULL else reticulate::py_to_r(v)
  }
  lines <- compact(list(
    sprintf("media_effects_dist: %s", get1("media_effects_dist")),
    sprintf("max_lag: %s", get1("max_lag")),
    sprintf("hill_before_adstock: %s", get1("hill_before_adstock")),
    sprintf("adstock_decay_spec: %s", get1("adstock_decay_spec")),
    sprintf("saturation_spec: %s", get1("saturation_spec")),
    if (!is.null(get1("paid_media_prior_type"))) {
      sprintf("paid_media_prior_type: %s", get1("paid_media_prior_type"))
    }
  ))
  cli::cli_text("{.strong <meridian_model_spec>}")
  cli::cli_ul(unlist(lines))
  invisible(x)
}

# --- meridian_model -----------------------------------------------------------

#' @export
print.meridian_model <- function(x, ...) {
  n_geos <- reticulate::py_to_r(reticulate::py_get_attr(x, "n_geos"))
  n_media <- reticulate::py_to_r(reticulate::py_get_attr(x, "n_media_channels"))
  n_rf <- reticulate::py_to_r(reticulate::py_get_attr(x, "n_rf_channels"))
  n_times <- reticulate::py_to_r(reticulate::py_get_attr(x, "n_times"))
  groups <- model_groups(x)
  post <- posterior_dims(x)

  status <- if (!is.null(post)) {
    sprintf("fitted (%d chains x %d draws)", post$chains, post$draws)
  } else if ("prior" %in% groups) {
    "prior sampled; posterior not yet sampled"
  } else {
    "not sampled"
  }

  cli::cli_text("{.strong <meridian_model>}")
  cli::cli_ul(c(
    sprintf("Data: %d geos x %d time periods", n_geos, n_times),
    sprintf("Channels: %d media, %d reach & frequency", n_media, n_rf),
    sprintf("Status: %s", status)
  ))
  invisible(x)
}

#' Summarize a fitted Meridian model
#'
#' Prints a compact overview of the model's data dimensions and sampling status,
#' and invisibly returns a list with that information.
#'
#' @param object A `meridian_model`.
#' @param ... Unused.
#'
#' @return A list with dimensions and sampling status, invisibly.
#' @export
summary.meridian_model <- function(object, ...) {
  info <- list(
    n_geos = reticulate::py_to_r(reticulate::py_get_attr(object, "n_geos")),
    n_times = reticulate::py_to_r(reticulate::py_get_attr(object, "n_times")),
    n_media_channels = reticulate::py_to_r(reticulate::py_get_attr(object, "n_media_channels")),
    n_rf_channels = reticulate::py_to_r(reticulate::py_get_attr(object, "n_rf_channels")),
    groups = model_groups(object),
    posterior = posterior_dims(object)
  )
  print(object)
  if (length(info$groups)) {
    cli::cli_text("Inference data groups: {.val {info$groups}}")
  }
  invisible(info)
}
