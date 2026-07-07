# Plot convergence diagnostics (max R-hat by parameter)

Plot convergence diagnostics (max R-hat by parameter)

## Usage

``` r
plot_rhat(model, bad_rhat_threshold = 1.1)
```

## Arguments

- model:

  A fitted `meridian_model` (or an
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md)).

- bad_rhat_threshold:

  Threshold drawn as a reference line.

## Value

A ggplot object.

## See also

Other meridian plots:
[`plot_adstock_decay()`](https://bdshaff.github.io/meridianR/reference/plot_adstock_decay.md),
[`plot_contribution()`](https://bdshaff.github.io/meridianR/reference/plot_contribution.md),
[`plot_hill_curves()`](https://bdshaff.github.io/meridianR/reference/plot_hill_curves.md),
[`plot_model_fit()`](https://bdshaff.github.io/meridianR/reference/plot_model_fit.md),
[`plot_response_curves()`](https://bdshaff.github.io/meridianR/reference/plot_response_curves.md),
[`plot_roi()`](https://bdshaff.github.io/meridianR/reference/plot_roi.md)
