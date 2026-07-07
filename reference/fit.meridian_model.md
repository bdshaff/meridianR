# Fit a Meridian model

Convenience wrapper that draws from the prior and then runs posterior
MCMC sampling, modifying `object` in place. Equivalent to calling
[`sample_prior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md)
followed by
[`sample_posterior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md).

## Usage

``` r
# S3 method for class 'meridian_model'
fit(
  object,
  prior_draws = 500,
  n_chains = 7,
  n_adapt = 500,
  n_burnin = 500,
  n_keep = 1000,
  seed = NULL,
  ...
)
```

## Arguments

- object:

  A `meridian_model` from
  [`meridian_model()`](https://bdshaff.github.io/meridianR/reference/meridian_model.md).

- prior_draws:

  Number of prior draws.

- n_chains, n_adapt, n_burnin, n_keep:

  Posterior MCMC settings, passed to
  [`sample_posterior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md).

- seed:

  Optional integer (or vector) random seed.

- ...:

  Further arguments forwarded to
  [`sample_posterior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md).

## Value

The fitted `meridian_model`, invisibly.
