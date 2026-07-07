# ggplot2-native plots, built from the tidy analysis accessors in analysis.R.
# Each plot_*() returns a ggplot object the user can further customize.

meridian_colors <- c(
  "#4C72B0", "#55A868", "#C44E52", "#8172B2", "#CCB974", "#64B5CD"
)

# Minimal shared theme.
theme_meridian <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold"),
      legend.position = "bottom",
      panel.grid.minor = element_blank()
    )
}

# Reshape a long "metric" tibble (mean/ci_lo/ci_hi rows) to wide columns
# estimate/ci_lo/ci_hi, keyed by `id` columns. Base merge -> no extra deps.
pivot_ci <- function(df, value, id) {
  grab <- function(m, nm) {
    x <- df[df$metric == m, c(id, value), drop = FALSE]
    names(x)[names(x) == value] <- nm
    x
  }
  out <- grab("mean", "estimate")
  out <- merge(out, grab("ci_lo", "ci_lo"), by = id, all.x = TRUE)
  out <- merge(out, grab("ci_hi", "ci_hi"), by = id, all.x = TRUE)
  tibble::as_tibble(out)
}

# Order a factor column by an associated numeric column (for sorted bar charts).
order_factor <- function(df, col, by) {
  df <- df[order(df[[by]]), ]
  df[[col]] <- factor(df[[col]], levels = df[[col]])
  df
}

#' Plot expected versus actual KPI over time
#'
#' @param model A fitted `meridian_model` (or an [analyzer()]).
#' @param ... Passed to [expected_vs_actual()].
#' @return A ggplot object.
#' @family meridian plots
#' @export
plot_model_fit <- function(model, ...) {
  d <- expected_vs_actual(model, ...)
  d$time <- as.Date(d$time)
  expected <- pivot_ci(d, "expected", "time")
  actual <- unique(d[d$metric == "mean", c("time", "actual")])

  ggplot(expected, aes(x = .data$time)) +
    geom_ribbon(aes(ymin = .data$ci_lo, ymax = .data$ci_hi),
      alpha = 0.2, fill = meridian_colors[1]
    ) +
    geom_line(aes(y = .data$estimate, colour = "Expected"), linewidth = 0.7) +
    geom_line(data = actual, aes(y = .data$actual, colour = "Actual"), linewidth = 0.5) +
    scale_colour_manual(
      values = c(Expected = meridian_colors[1], Actual = "grey30"), name = NULL
    ) +
    labs(x = NULL, y = "KPI", title = "Model fit: expected vs. actual") +
    theme_meridian()
}

#' Plot return on investment by channel
#'
#' @param model A fitted `meridian_model` (or an [analyzer()]).
#' @param confidence_level Credible-interval width for the error bars.
#' @param ... Passed to [summary_metrics()].
#' @return A ggplot object.
#' @family meridian plots
#' @export
plot_roi <- function(model, confidence_level = 0.9, ...) {
  d <- summary_metrics(model, confidence_level = confidence_level, ...)
  d <- d[d$distribution == "posterior" & d$channel != "All Channels", ]
  w <- order_factor(pivot_ci(d, "roi", "channel"), "channel", "estimate")

  ggplot(w, aes(x = .data$channel, y = .data$estimate)) +
    geom_col(fill = meridian_colors[1], width = 0.7) +
    geom_errorbar(aes(ymin = .data$ci_lo, ymax = .data$ci_hi), width = 0.2) +
    coord_flip() +
    labs(x = NULL, y = "ROI", title = "Return on investment by channel") +
    theme_meridian()
}

#' Plot each channel's share of KPI contribution
#'
#' @param model A fitted `meridian_model` (or an [analyzer()]).
#' @param ... Passed to [summary_metrics()].
#' @return A ggplot object.
#' @family meridian plots
#' @export
plot_contribution <- function(model, ...) {
  d <- summary_metrics(model, ...)
  d <- d[d$distribution == "posterior" & d$metric == "mean" & d$channel != "All Channels", ]
  d <- order_factor(d, "channel", "pct_of_contribution")

  ggplot(d, aes(x = .data$channel, y = .data$pct_of_contribution)) +
    geom_col(fill = meridian_colors[2], width = 0.7) +
    coord_flip() +
    labs(x = NULL, y = "% of contribution", title = "Contribution to KPI by channel") +
    theme_meridian()
}

#' Plot response curves (incremental outcome versus spend)
#'
#' @param model A fitted `meridian_model` (or an [analyzer()]).
#' @param ... Passed to [response_curves()].
#' @return A ggplot object.
#' @family meridian plots
#' @export
plot_response_curves <- function(model, ...) {
  d <- response_curves(model, ...)
  w <- pivot_ci(d, "incremental_outcome", c("channel", "spend_multiplier", "spend"))
  w <- w[!is.na(w$estimate), ]

  ggplot(w, aes(x = .data$spend, y = .data$estimate, colour = .data$channel, fill = .data$channel)) +
    geom_ribbon(aes(ymin = .data$ci_lo, ymax = .data$ci_hi), alpha = 0.15, colour = NA) +
    geom_line(linewidth = 0.7) +
    scale_x_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +
    labs(
      x = "Spend", y = "Incremental outcome", colour = NULL, fill = NULL,
      title = "Response curves"
    ) +
    theme_meridian()
}

#' Plot Hill saturation curves
#'
#' @param model A fitted `meridian_model` (or an [analyzer()]).
#' @param ... Passed to [hill_curves()].
#' @return A ggplot object.
#' @family meridian plots
#' @export
plot_hill_curves <- function(model, ...) {
  d <- hill_curves(model, ...)
  d <- d[d$distribution == "posterior" & !is.na(d$mean), ]

  ggplot(d, aes(x = .data$media_units, y = .data$mean, colour = .data$channel, fill = .data$channel)) +
    geom_ribbon(aes(ymin = .data$ci_lo, ymax = .data$ci_hi), alpha = 0.15, colour = NA) +
    geom_line(linewidth = 0.7) +
    labs(
      x = "Media units", y = "Hill saturation", colour = NULL, fill = NULL,
      title = "Hill saturation curves"
    ) +
    theme_meridian()
}

#' Plot adstock decay curves
#'
#' @param model A fitted `meridian_model` (or an [analyzer()]).
#' @param ... Passed to [adstock_decay()].
#' @return A ggplot object.
#' @family meridian plots
#' @export
plot_adstock_decay <- function(model, ...) {
  d <- adstock_decay(model, ...)
  d <- d[d$distribution == "posterior" & !is.na(d$mean), ]

  ggplot(d, aes(x = .data$time_units, y = .data$mean, colour = .data$channel, fill = .data$channel)) +
    geom_ribbon(aes(ymin = .data$ci_lo, ymax = .data$ci_hi), alpha = 0.15, colour = NA) +
    geom_line(linewidth = 0.7) +
    labs(
      x = "Time units", y = "Adstock weight", colour = NULL, fill = NULL,
      title = "Adstock decay"
    ) +
    theme_meridian()
}

#' Plot convergence diagnostics (max R-hat by parameter)
#'
#' @param model A fitted `meridian_model` (or an [analyzer()]).
#' @param bad_rhat_threshold Threshold drawn as a reference line.
#' @return A ggplot object.
#' @family meridian plots
#' @export
plot_rhat <- function(model, bad_rhat_threshold = 1.1) {
  d <- rhat_summary(model)
  d <- order_factor(d, "param", "max_rhat")

  ggplot(d, aes(x = .data$param, y = .data$max_rhat)) +
    geom_point(colour = meridian_colors[1], size = 2) +
    geom_hline(yintercept = bad_rhat_threshold, linetype = "dashed", colour = "grey50") +
    coord_flip() +
    labs(x = NULL, y = "Max R-hat", title = "Convergence: max R-hat by parameter") +
    theme_meridian()
}
