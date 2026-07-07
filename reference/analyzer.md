# Create a Meridian analyzer

Wraps Meridian's `Analyzer`, the engine behind the tidy accessors in
this package
([`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md),
[`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md),
and friends). You rarely need to call this directly – the accessors
accept a fitted model and build an analyzer internally – but reusing one
analyzer across several calls avoids repeated setup.

## Usage

``` r
analyzer(model)
```

## Arguments

- model:

  A fitted `meridian_model`.

## Value

A `meridian_analyzer` object.

## See also

[`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md),
[`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md),
[`hill_curves()`](https://bdshaff.github.io/meridianR/reference/hill_curves.md),
[`adstock_decay()`](https://bdshaff.github.io/meridianR/reference/adstock_decay.md),
[`rhat_summary()`](https://bdshaff.github.io/meridianR/reference/rhat_summary.md),
[`expected_vs_actual()`](https://bdshaff.github.io/meridianR/reference/expected_vs_actual.md)
