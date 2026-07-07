# Getting started with meridianR

`meridianR` is an R interface to [Google
Meridian](https://developers.google.com/meridian), a Bayesian Marketing
Mix Modeling (MMM) library. It wraps the Meridian Python package with
[reticulate](https://rstudio.github.io/reticulate/), pairing faithful
bindings to Meridian’s objects with an idiomatic R layer.

``` r

reticulate::use_virtualenv("~/.virtualenvs/r-meridian", required = TRUE)
library(meridianR)
meridian_version() 
```

## Installation

Meridian runs on Python (TensorFlow / TF-Probability). Install it once
into a persistent environment:

``` r

install_meridian()
```

If you skip this, `meridianR` still works: reticulate provisions an
environment automatically the first time you use a Meridian function.
Use `install_meridian(gpu = TRUE)` for the CUDA build or
`install_meridian(backend = "jax")` for the experimental JAX backend.

## Assemble input data

Meridian expects long-format data: one row per geo-by-time, with columns
for the KPI, population, media spend, and any controls.
[`as_meridian_input()`](https://bdshaff.github.io/meridianR/reference/as_meridian_input.md)
turns such a data frame into a Meridian `InputData` object.

``` r

data("sales")

input <- as_meridian_input(
  sales,
  kpi            = "conversions",
  time           = "week",
  geo            = "region",
  population     = "population",
  media_spend    = c("tv_spend", "search_spend"),
  media          = c("tv_impressions", "search_clicks"),
  media_channels = c("TV", "Search"),
  controls       = "price_index"
)
input
```

If you only have spend (no impressions), omit `media` and spend is used
as the media metric. For a national (single-geo) model, pass
`national = TRUE`.

For step-by-step control, use the fluent builder instead:

``` r

input <- input_data_builder("non_revenue", geo = "region", time = "week") |>
  with_kpi(sales, kpi_col = "conversions") |>
  with_population(sales) |>
  with_media(sales,
    media_cols       = c("tv_impressions", "search_clicks"),
    media_spend_cols = c("tv_spend", "search_spend"),
    media_channels   = c("TV", "Search")) |>
  build_input_data()
```

## Configure priors and the model specification

[`model_spec()`](https://bdshaff.github.io/meridianR/reference/model_spec.md)
controls the adstock/lag, saturation, and priors. Meridian’s defaults
are well chosen, so a minimal spec is often all you need:

``` r

spec <- model_spec(max_lag = 8, media_effects_dist = "log_normal")
spec
```

**Priors and KPI scale.** `conversions` is a non-revenue KPI and we did
not supply `revenue_per_kpi`, so Meridian places a prior on each
channel’s *total media contribution* by default – no per-channel
calibration needed. You can override priors with
[`prior_distribution()`](https://bdshaff.github.io/meridianR/reference/prior_distribution.md)
and the `prior_*()` constructors, but they must match your KPI’s scale.
In particular, an ROI prior such as `prior_lognormal(0.2, 0.9)` (median
ROI ~ 1.2) describes a **revenue** KPI, where ROI is dollars per dollar.
For a conversions KPI, ROI is *conversions* per dollar – typically far
below 1 – so that prior would be off by orders of magnitude and
massively over-credit media. Either keep the default, supply
`revenue_per_kpi` so ROI is dollar-based, or customize a scale-free
prior such as the adstock decay rate `alpha_m` (which always lives on
`[0, 1]`):

``` r

model_spec(
  max_lag = 8,
  prior   = prior_distribution(alpha_m = prior_beta(3, 3))
)
```

## Fit the model

Create the model, then draw from the prior and posterior.
[`fit()`](https://generics.r-lib.org/reference/fit.html) does both:

``` r

mmm <- meridian_model(input, spec)

fit(mmm, n_chains = 7, n_adapt = 500, n_burnin = 500, n_keep = 1000)

mmm
summary(mmm)
```

Sampling **modifies the model in place** (draws are stored on the
model’s ArviZ `inference_data`), so
[`sample_prior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md),
[`sample_posterior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md),
and [`fit()`](https://generics.r-lib.org/reference/fit.html) all return
the same model object.

## Save and reload

``` r

save_model(mmm, "mmm.pkl")
mmm <- load_model("mmm.pkl")
```

## Drop down to Python

Everything in Meridian is reachable through the `meridian` module
handle, the low-level escape hatch beneath the wrappers:

``` r

meridian$analysis$analyzer$Analyzer(mmm)
```

Analysis, visualization, and budget optimization wrappers build on this
foundation and arrive in subsequent releases.
