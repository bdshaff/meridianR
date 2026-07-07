# Create a Meridian model

`meridian_model()` constructs Meridian's `Meridian` model object from
input data and an optional
[`model_spec()`](https://bdshaff.github.io/meridianR/reference/model_spec.md).
The model is *unfit* until you draw from the prior and posterior with
[`sample_prior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md)
and
[`sample_posterior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md)
(or the [`fit()`](https://generics.r-lib.org/reference/fit.html)
convenience).

## Usage

``` r
meridian_model(input, spec = NULL, ...)
```

## Arguments

- input:

  A `meridian_input_data` from
  [`as_meridian_input()`](https://bdshaff.github.io/meridianR/reference/as_meridian_input.md).

- spec:

  A `meridian_model_spec` from
  [`model_spec()`](https://bdshaff.github.io/meridianR/reference/model_spec.md).
  When `NULL`, Meridian's default specification is used.

- ...:

  Further arguments passed to the `Meridian` constructor (e.g.
  `inference_data`).

## Value

A `meridian_model` object.

## See also

[`sample_prior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md),
[`sample_posterior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md),
[`fit()`](https://generics.r-lib.org/reference/fit.html)

## Examples

``` r
if (FALSE) { # \dontrun{
mmm <- meridian_model(input, model_spec(max_lag = 8))
fit(mmm, n_chains = 4, n_keep = 1000)
} # }
```
