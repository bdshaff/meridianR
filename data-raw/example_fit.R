# Reference end-to-end fit on the bundled `sales` dataset.
#
# Reproduces a good model fit (R^2 ~ 0.99, media contribution ~11%) with a plain
# default specification. The key points, versus a mis-specified run:
#   * do NOT set a mis-scaled ROI prior. `roi_m = prior_lognormal(0.2, 0.9)` is a
#     *revenue*-KPI prior (ROI in $/$); `conversions` is non-revenue, so ROI is
#     conversions/$ (<< 1) and that prior massively over-credits media.
#   * do NOT force too few `knots`. The default (flexible) baseline is needed to
#     capture trend + seasonality; e.g. knots = 4 over 104 weeks collapses the fit.
#
# Run with: source("data-raw/example_fit.R")

library(meridianR)
library(ggplot2)
# During development from source, use instead:
#   devtools::load_all()

# Bind the Meridian environment before anything else starts Python (see
# ?install_meridian and the "Choosing the Python environment" section of README).
reticulate::use_virtualenv("r-meridian", required = TRUE)

# 1. Assemble input from the bundled `sales` dataset.
input <- as_meridian_input(
  sales,
  kpi            = "conversions",
  time           = "week",
  geo            = "region",
  population     = "population",
  media_spend    = c("tv_spend", "search_spend"),
  media_channels = c("TV", "Search"),
  controls       = "price_index"
)

# 2. Default specification: no custom roi_m prior, default (flexible) knots.
spec <- model_spec(max_lag = 8, saturation_spec = "none")

spec

# 3. Fit. These are small, fast settings; for a production run use something like
#    n_chains = 4, n_adapt = 500, n_burnin = 500, n_keep = 1000.
mmm <- meridian_model(input, spec)
fit(mmm, prior_draws = 200, n_chains = 2, n_adapt = 200, n_burnin = 200, n_keep = 300, seed = 1)

# 4. Diagnostics: per-channel contribution / ROI, and predictive accuracy.
sm <- summary_metrics(mmm)
print(sm[
  sm$distribution == "posterior" & sm$metric == "mean",
  c("channel", "pct_of_contribution", "roi")
])

print(predictive_accuracy(mmm))

# 5. Expected vs. actual fit.
print(plot_model_fit(mmm))

response_curves(mmm)      # incremental outcome vs. spend
hill_curves(mmm)          # saturation curves
adstock_decay(mmm)        # carryover decay
expected_vs_actual(mmm)   # model fit over time
rhat_summary(mmm)         # convergence diagnostics
predictive_accuracy(mmm)  # R-squared, MAPE, wMAPE

library(ggplot2)

plot_model_fit(mmm)
plot_roi(mmm)
plot_contribution(mmm)
plot_response_curves(mmm)
plot_hill_curves(mmm)
plot_adstock_decay(mmm)
plot_rhat(mmm)

# Customize freely -- it's just ggplot2
plot_roi(mmm) + labs(title = "Channel ROI, 90% CI") + theme_bw()

# No Hill saturation anywhere — media enters with adstock only (linear in adstocked media)
spec <- model_spec(max_lag = 8, saturation_spec = "none")

# Or disable it per channel (named by your media_channels labels)
spec <- model_spec(max_lag = 8, saturation_spec = list(TV = "none", Search = "hill"))
