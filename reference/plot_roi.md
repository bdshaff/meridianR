# Plot return on investment by channel

Plot return on investment by channel

## Usage

``` r
plot_roi(model, confidence_level = 0.9, ...)
```

## Arguments

- model:

  A fitted `meridian_model` (or an
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md)).

- confidence_level:

  Credible-interval width for the error bars.

- ...:

  Passed to
  [`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md).

## Value

A ggplot object.

## See also

Other meridian plots:
[`plot_adstock_decay()`](https://bdshaff.github.io/meridianR/reference/plot_adstock_decay.md),
[`plot_contribution()`](https://bdshaff.github.io/meridianR/reference/plot_contribution.md),
[`plot_hill_curves()`](https://bdshaff.github.io/meridianR/reference/plot_hill_curves.md),
[`plot_model_fit()`](https://bdshaff.github.io/meridianR/reference/plot_model_fit.md),
[`plot_response_curves()`](https://bdshaff.github.io/meridianR/reference/plot_response_curves.md),
[`plot_rhat()`](https://bdshaff.github.io/meridianR/reference/plot_rhat.md)
