# Adstock decay curves

Adstock decay curves

## Usage

``` r
adstock_decay(model, confidence_level = 0.9)
```

## Arguments

- model:

  A fitted `meridian_model` or a
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md).

- confidence_level:

  Width of the credible intervals (default 0.9).

## Value

A tibble with `channel`, `time_units`, `distribution`, `mean`, `ci_lo`,
and `ci_hi`.

## See also

Other analysis accessors:
[`expected_vs_actual()`](https://bdshaff.github.io/meridianR/reference/expected_vs_actual.md),
[`hill_curves()`](https://bdshaff.github.io/meridianR/reference/hill_curves.md),
[`predictive_accuracy()`](https://bdshaff.github.io/meridianR/reference/predictive_accuracy.md),
[`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md),
[`rhat_summary()`](https://bdshaff.github.io/meridianR/reference/rhat_summary.md),
[`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md)
