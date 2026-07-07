# meridianR

An R interface to [Google
Meridian](https://developers.google.com/meridian), a Bayesian Marketing
Mix Modeling (MMM) library. meridianR wraps the Meridian Python package
with [reticulate](https://rstudio.github.io/reticulate/), following the
design of [keras3](https://keras3.posit.co/): faithful bindings to
Meridian’s data, model, and analysis objects, plus an idiomatic R layer
with tidy data in and out, S3
[`print()`](https://rdrr.io/r/base/print.html)/[`summary()`](https://rdrr.io/r/base/summary.html),
and pipe-friendly verbs.

## Installation

Install the development version from GitHub:

``` r

# install.packages("pak")
pak::pak("bdshaff/meridianR")
```

Then provision the Python side (TensorFlow / TF-Probability) once:

``` r

library(meridianR)
install_meridian()
```

`install_meridian(gpu = TRUE)` installs the CUDA build;
`install_meridian(backend = "jax")` uses the experimental JAX backend.
If you skip this step, reticulate provisions an environment
automatically on first use.

## Quick start

``` r

library(meridianR)

# 1. Assemble input data from a long-format data frame
input <- as_meridian_input(
  sales,
  kpi            = "conversions",
  time           = "week",
  geo            = "region",
  population     = "population",
  media_spend    = c("tv_spend", "search_spend"),
  media_channels = c("TV", "Search"),
  controls       = "price_index"
)

# 2. Configure priors and the model specification
spec <- model_spec(
  prior   = prior_distribution(roi_m = prior_lognormal(0.2, 0.9)),
  max_lag = 8
)

# 3. Fit
mmm <- meridian_model(input, spec)
fit(mmm, n_chains = 7, n_keep = 1000)

summary(mmm)
```

See
[`vignette("getting-started")`](https://bdshaff.github.io/meridianR/articles/getting-started.md)
for the full walkthrough.

## Choosing the Python environment

Meridian needs Python \>= 3.10, and meridianR installs it into the
`r-meridian` virtual environment. reticulate can only bind **one**
Python per R session, and an interpreter pinned by `RETICULATE_PYTHON`
or your IDE takes precedence over meridianR’s default. If another Python
is initialized first you will see:

    ERROR: The requested version of Python (...) cannot be used, as another version
    of Python (...) has already been initialized.

To fix it, point reticulate at `r-meridian` **before** anything else
touches Python, then restart R:

- In **RStudio**: Tools -\> Global Options -\> Python -\> Select -\>
  Virtual Environments -\> `r-meridian` (or set it per project), then
  restart the session.

- In a **fresh session**, as the first line:

  ``` r

  reticulate::use_virtualenv("r-meridian", required = TRUE)
  library(meridianR)
  ```

meridianR warns at load time when `RETICULATE_PYTHON` points elsewhere.

## Python warnings

Meridian emits warnings through Python’s `warnings` module, which
normally print raw (file path, line number, and all). meridianR reroutes
them so they appear as ordinary R warnings of class
`meridian_python_warning` – cli-formatted and silenceable with
[`suppressWarnings()`](https://rdrr.io/r/base/warning.html). To keep the
raw Python output instead, set
`options(meridianR.reformat_warnings = FALSE)` before first use.

## Status

meridianR is in early development. The current release covers the **data
and modeling core** — data loading, model specification, priors, and
MCMC fitting. Analysis (tidy metrics and ggplot2 charts) and budget
optimization are on the roadmap.

Everything in Meridian remains reachable through the `meridian` module
handle, the low-level escape hatch beneath the wrappers.
