# Prior distribution constructors

Thin, backend-aware wrappers over Meridian's TensorFlow-Probability
distributions (`meridian$backend$tfd`), for use inside
[`prior_distribution()`](https://bdshaff.github.io/meridianR/reference/prior_distribution.md).
They return a Python distribution object.

## Usage

``` r
prior_lognormal(loc, scale, name = NULL)

prior_normal(loc, scale, name = NULL)

prior_halfnormal(scale, name = NULL)

prior_truncated_normal(loc, scale, low, high, name = NULL)

prior_uniform(low, high, name = NULL)

prior_beta(concentration1, concentration0, name = NULL)

prior_deterministic(loc, name = NULL)
```

## Arguments

- loc, scale, low, high, concentration1, concentration0:

  Distribution parameters (numeric).

- name:

  Optional distribution name.

## Value

A TensorFlow-Probability distribution (a Python object).

## See also

[`prior_distribution()`](https://bdshaff.github.io/meridianR/reference/prior_distribution.md)
