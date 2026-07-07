# Prior distributions for a Meridian model

`prior_distribution()` builds Meridian's `PriorDistribution`, the
container of priors used by a
[`model_spec()`](https://bdshaff.github.io/meridianR/reference/model_spec.md).
Supply named priors built with the `prior_*()` distribution
constructors; anything you omit keeps Meridian's default. The most
commonly customized priors are the ROI priors `roi_m` (media) and
`roi_rf` (reach & frequency).

## Usage

``` r
prior_distribution(...)
```

## Arguments

- ...:

  Named priors, e.g. `roi_m = prior_lognormal(0.2, 0.9)`.

## Value

A `meridian_prior` object.

## Details

Accepted names are the fields of Meridian's `PriorDistribution`,
including: `roi_m`, `roi_rf`, `mroi_m`, `mroi_rf`, `contribution_m`,
`contribution_rf`, `beta_m`, `beta_rf`, `alpha_m` (adstock), `ec_m`,
`slope_m` (Hill saturation), `sigma`, `tau_g_excl_baseline`, and
`knot_values`.

## See also

[`prior_lognormal()`](https://bdshaff.github.io/meridianR/reference/prior_constructors.md)
and friends for the distribution constructors;
[`model_spec()`](https://bdshaff.github.io/meridianR/reference/model_spec.md)
to attach the priors to a model configuration.

## Examples

``` r
if (FALSE) { # \dontrun{
prior_distribution(
  roi_m  = prior_lognormal(0.2, 0.9),
  roi_rf = prior_lognormal(0.2, 0.9)
)
} # }
```
