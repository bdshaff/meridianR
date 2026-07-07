# Response curves (incremental outcome versus spend)

Response curves (incremental outcome versus spend)

## Usage

``` r
response_curves(
  model,
  confidence_level = 0.9,
  use_posterior = TRUE,
  spend_multipliers = NULL,
  ...
)
```

## Arguments

- model:

  A fitted `meridian_model` or a
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md).

- confidence_level:

  Width of the credible intervals (default 0.9).

- use_posterior:

  Use posterior (default) or prior draws.

- spend_multipliers:

  Optional numeric vector of spend multipliers at which to evaluate the
  curves.

- ...:

  Further arguments passed to `response_curves()`.

## Value

A tibble with `spend_multiplier`, `channel`, `metric`, `spend`, and
`incremental_outcome`.

## See also

Other analysis accessors:
[`adstock_decay()`](https://bdshaff.github.io/meridianR/reference/adstock_decay.md),
[`expected_vs_actual()`](https://bdshaff.github.io/meridianR/reference/expected_vs_actual.md),
[`hill_curves()`](https://bdshaff.github.io/meridianR/reference/hill_curves.md),
[`predictive_accuracy()`](https://bdshaff.github.io/meridianR/reference/predictive_accuracy.md),
[`rhat_summary()`](https://bdshaff.github.io/meridianR/reference/rhat_summary.md),
[`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md)
