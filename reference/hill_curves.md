# Hill saturation curves

Hill saturation curves

## Usage

``` r
hill_curves(model, confidence_level = 0.9, n_bins = 25)
```

## Arguments

- model:

  A fitted `meridian_model` or a
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md).

- confidence_level:

  Width of the credible intervals (default 0.9).

- n_bins:

  Number of histogram bins for the media-units distribution.

## Value

A tibble with `channel`, `media_units`, `distribution`, `mean`, `ci_lo`,
`ci_hi`, and histogram columns.

## See also

Other analysis accessors:
[`adstock_decay()`](https://bdshaff.github.io/meridianR/reference/adstock_decay.md),
[`expected_vs_actual()`](https://bdshaff.github.io/meridianR/reference/expected_vs_actual.md),
[`predictive_accuracy()`](https://bdshaff.github.io/meridianR/reference/predictive_accuracy.md),
[`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md),
[`rhat_summary()`](https://bdshaff.github.io/meridianR/reference/rhat_summary.md),
[`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md)
