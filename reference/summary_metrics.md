# Channel-level summary metrics

Tidy per-channel metrics – ROI, marginal ROI, incremental outcome, share
of contribution, effectiveness, CPIK, and more – for the prior and
posterior.

## Usage

``` r
summary_metrics(
  model,
  confidence_level = 0.9,
  aggregate_geos = TRUE,
  aggregate_times = TRUE,
  selected_geos = NULL,
  selected_times = NULL,
  ...
)
```

## Arguments

- model:

  A fitted `meridian_model` or a
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md).

- confidence_level:

  Width of the credible intervals (default 0.9).

- aggregate_geos, aggregate_times:

  Aggregate over geos / time periods?

- selected_geos, selected_times:

  Optional subsets of geos / times.

- ...:

  Further arguments passed to Meridian's `summary_metrics()`.

## Value

A tibble in long form with `channel`, `metric`
(`mean`/`median`/`ci_lo`/`ci_hi`), `distribution` (`prior`/`posterior`),
and one column per metric (`roi`, `mroi`, `incremental_outcome`,
`pct_of_contribution`, `effectiveness`, `cpik`, ...).

## See also

Other analysis accessors:
[`adstock_decay()`](https://bdshaff.github.io/meridianR/reference/adstock_decay.md),
[`expected_vs_actual()`](https://bdshaff.github.io/meridianR/reference/expected_vs_actual.md),
[`hill_curves()`](https://bdshaff.github.io/meridianR/reference/hill_curves.md),
[`predictive_accuracy()`](https://bdshaff.github.io/meridianR/reference/predictive_accuracy.md),
[`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md),
[`rhat_summary()`](https://bdshaff.github.io/meridianR/reference/rhat_summary.md)
