# Analyzing a fitted model

Once a model is fit (see
[`vignette("getting-started")`](https://bdshaff.github.io/meridianR/articles/getting-started.md)),
meridianR turns Meridian’s results into tidy tibbles and ggplot2 charts.

``` r

library(meridianR)
reticulate::use_virtualenv("r-meridian", required = TRUE)

input <- as_meridian_input(
  sales,
  kpi = "conversions", time = "week", geo = "region", population = "population",
  media_spend = c("tv_spend", "search_spend"), media_channels = c("TV", "Search"),
  controls = "price_index"
)

spec <- model_spec(max_lag = 8)

mmm <- meridian_model(input, spec)

fit(mmm, n_chains = 4, n_keep = 1000)
```

## Tidy metrics

Every accessor returns a tibble, so results flow straight into dplyr,
ggplot2, or `gt`.
[`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md)
gives per-channel ROI, marginal ROI, incremental outcome, contribution
share, effectiveness, and CPIK for the prior and posterior:

``` r

summary_metrics(mmm)

# Posterior ROI point estimates per channel
sm <- summary_metrics(mmm)
sm[sm$distribution == "posterior" & sm$metric == "mean", c("channel", "roi", "pct_of_contribution")]
```

Other accessors follow the same pattern:

``` r

response_curves(mmm)      # incremental outcome vs. spend
hill_curves(mmm)          # saturation curves
adstock_decay(mmm)        # carryover decay
expected_vs_actual(mmm)   # model fit over time
rhat_summary(mmm)         # convergence diagnostics
predictive_accuracy(mmm)  # R-squared, MAPE, wMAPE
```

Reuse one
[`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md)
across several calls to avoid repeated setup:

``` r

a <- analyzer(mmm)
summary_metrics(a)
response_curves(a)
```

## ggplot2 charts

Each `plot_*()` returns a ggplot object you can restyle like any other:

``` r

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
```

[`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
and [`plot()`](https://rdrr.io/r/graphics/plot.default.html) select a
chart by `type`:

``` r

autoplot(mmm, type = "response")
plot(mmm, type = "fit")
```

## Meridian’s built-in report

If you would rather have Meridian’s own two-page HTML summary,
[`model_report()`](https://bdshaff.github.io/meridianR/reference/model_report.md)
is an escape hatch:

``` r

model_report(mmm, "meridian_summary.html")
```
