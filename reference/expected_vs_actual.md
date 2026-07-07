# Expected versus actual KPI over time

Expected versus actual KPI over time

## Usage

``` r
expected_vs_actual(
  model,
  aggregate_geos = TRUE,
  aggregate_times = FALSE,
  confidence_level = 0.9,
  ...
)
```

## Arguments

- model:

  A fitted `meridian_model` or a
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md).

- aggregate_geos, aggregate_times:

  Aggregate over geos / time periods? Defaults aggregate over geos
  (national fit) and keep time.

- confidence_level:

  Width of the credible intervals (default 0.9).

- ...:

  Further arguments passed to `expected_vs_actual_data()`.

## Value

A tibble with `time`, `metric` (`mean`/`ci_lo`/`ci_hi`), `expected`,
`baseline`, and `actual`.

## See also

Other analysis accessors:
[`adstock_decay()`](https://bdshaff.github.io/meridianR/reference/adstock_decay.md),
[`hill_curves()`](https://bdshaff.github.io/meridianR/reference/hill_curves.md),
[`predictive_accuracy()`](https://bdshaff.github.io/meridianR/reference/predictive_accuracy.md),
[`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md),
[`rhat_summary()`](https://bdshaff.github.io/meridianR/reference/rhat_summary.md),
[`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md)
