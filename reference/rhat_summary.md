# Convergence diagnostics (R-hat) summary

Convergence diagnostics (R-hat) summary

## Usage

``` r
rhat_summary(model, bad_rhat_threshold = 1.2)
```

## Arguments

- model:

  A fitted `meridian_model` or a
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md).

- bad_rhat_threshold:

  R-hat above which a parameter is flagged.

## Value

A tibble with one row per parameter block: `param`, `n_params`,
`avg_rhat`, `max_rhat`, and `percent_bad_rhat`.

## See also

Other analysis accessors:
[`adstock_decay()`](https://bdshaff.github.io/meridianR/reference/adstock_decay.md),
[`expected_vs_actual()`](https://bdshaff.github.io/meridianR/reference/expected_vs_actual.md),
[`hill_curves()`](https://bdshaff.github.io/meridianR/reference/hill_curves.md),
[`predictive_accuracy()`](https://bdshaff.github.io/meridianR/reference/predictive_accuracy.md),
[`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md),
[`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md)
