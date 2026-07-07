# Configure a Meridian model

`model_spec()` builds Meridian's `ModelSpec`, which controls the
adstock/lag structure, saturation, media-effect distribution, prior
types, spline knots, and calibration. Any argument left `NULL` uses
Meridian's own default. Attach custom priors by passing a
[`prior_distribution()`](https://bdshaff.github.io/meridianR/reference/prior_distribution.md)
to `prior`.

## Usage

``` r
model_spec(
  prior = NULL,
  media_effects_dist = NULL,
  hill_before_adstock = NULL,
  max_lag = NULL,
  unique_sigma_for_each_geo = NULL,
  paid_media_prior_type = NULL,
  rf_prior_type = NULL,
  knots = NULL,
  baseline_geo = NULL,
  holdout_id = NULL,
  adstock_decay_spec = NULL,
  saturation_spec = NULL,
  ...
)
```

## Arguments

- prior:

  A `meridian_prior` from
  [`prior_distribution()`](https://bdshaff.github.io/meridianR/reference/prior_distribution.md).

- media_effects_dist:

  `"log_normal"` (Meridian default) or `"normal"`.

- hill_before_adstock:

  Apply Hill saturation before adstock? Defaults to `FALSE` in Meridian.

- max_lag:

  Maximum adstock lag, in time periods (integer; Meridian default 8).

- unique_sigma_for_each_geo:

  Estimate a separate residual standard deviation per geo?

- paid_media_prior_type, rf_prior_type:

  How the paid-media and reach-and-frequency priors are parameterized,
  e.g. `"roi"`, `"mroi"`, `"contribution"`, or `"coefficient"`.

- knots:

  Number of spline knots (a single integer) or a vector of knot
  positions, controlling the time-varying baseline.

- baseline_geo:

  Baseline geo, given as a geo name or an integer index.

- holdout_id:

  Optional array/boolean matrix marking held-out observations for
  out-of-sample evaluation.

- adstock_decay_spec:

  Adstock decay function: `"geometric"` (default) or `"binomial"`, or a
  named list giving a function per channel.

- saturation_spec:

  Saturation function: `"hill"` (default), or a named list per channel.

- ...:

  Further arguments forwarded to `ModelSpec`, such as
  `media_prior_type`, `roi_calibration_period`,
  `organic_media_prior_type`, `non_media_treatments_prior_type`, or
  `enable_aks`.

## Value

A `meridian_model_spec` object.

## See also

[`prior_distribution()`](https://bdshaff.github.io/meridianR/reference/prior_distribution.md),
[`meridian_model()`](https://bdshaff.github.io/meridianR/reference/meridian_model.md)

## Examples

``` r
if (FALSE) { # \dontrun{
spec <- model_spec(
  prior              = prior_distribution(roi_m = prior_lognormal(0.2, 0.9)),
  max_lag            = 8,
  media_effects_dist = "log_normal"
)
} # }
```
