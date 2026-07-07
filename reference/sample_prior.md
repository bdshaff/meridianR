# Draw from a Meridian model's prior and posterior

`sample_prior()` and `sample_posterior()` run Meridian's prior and MCMC
posterior sampling. Both **modify the model in place** (drawn samples
are merged into the model's ArviZ `inference_data`) and return the same
model object invisibly, so they compose with the native pipe.
[`fit()`](https://generics.r-lib.org/reference/fit.html) is a
convenience that runs both.

## Usage

``` r
sample_prior(model, n_draws = 500, seed = NULL)

sample_posterior(
  model,
  n_chains = 7,
  n_adapt = 500,
  n_burnin = 500,
  n_keep = 1000,
  seed = NULL,
  ...
)
```

## Arguments

- model:

  A `meridian_model` from
  [`meridian_model()`](https://bdshaff.github.io/meridianR/reference/meridian_model.md).

- n_draws:

  Number of prior draws.

- seed:

  Optional integer (or vector) random seed.

- n_chains:

  Number of MCMC chains (an integer, or a vector of integers to split
  sampling into several calls to reduce peak memory).

- n_adapt, n_burnin, n_keep:

  Number of adaptation, burn-in, and kept draws per chain.

- ...:

  Further arguments forwarded to Meridian's `sample_posterior()` (e.g.
  `max_tree_depth`, `parallel_iterations`).

## Value

The (modified) `meridian_model`, invisibly.

## See also

[`meridian_model()`](https://bdshaff.github.io/meridianR/reference/meridian_model.md),
[`fit()`](https://generics.r-lib.org/reference/fit.html)
