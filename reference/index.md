# Package index

## Installation & environment

Provision Meridian’s Python dependencies and select a backend.

- [`install_meridian()`](https://bdshaff.github.io/meridianR/reference/install_meridian.md)
  : Install Meridian and its Python dependencies
- [`use_backend()`](https://bdshaff.github.io/meridianR/reference/use_backend.md)
  : Select the Meridian compute backend
- [`meridian_available()`](https://bdshaff.github.io/meridianR/reference/meridian_available.md)
  : Is the Meridian Python package available?
- [`meridian_version()`](https://bdshaff.github.io/meridianR/reference/meridian_version.md)
  : Installed Meridian version
- [`meridian`](https://bdshaff.github.io/meridianR/reference/meridian.md)
  : Direct handle to the Meridian Python module

## Input data

Assemble Meridian input data from R data frames.

- [`as_meridian_input()`](https://bdshaff.github.io/meridianR/reference/as_meridian_input.md)
  : Assemble Meridian input data from a data frame
- [`input_data_builder()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`with_kpi()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`with_population()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`with_controls()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`with_revenue_per_kpi()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`with_media()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`with_reach()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`with_organic_media()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`with_non_media_treatments()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  [`build_input_data()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  : Build Meridian input data with a fluent builder
- [`coord_to_columns()`](https://bdshaff.github.io/meridianR/reference/coord_to_columns.md)
  : Map data columns to Meridian coordinates
- [`csv_loader()`](https://bdshaff.github.io/meridianR/reference/csv_loader.md)
  [`data_frame_loader()`](https://bdshaff.github.io/meridianR/reference/csv_loader.md)
  : Load Meridian input data from a CSV file or data frame
- [`load_input_data()`](https://bdshaff.github.io/meridianR/reference/load_input_data.md)
  : Realize input data from a loader

## Model specification & priors

- [`model_spec()`](https://bdshaff.github.io/meridianR/reference/model_spec.md)
  : Configure a Meridian model
- [`prior_distribution()`](https://bdshaff.github.io/meridianR/reference/prior_distribution.md)
  : Prior distributions for a Meridian model
- [`prior_lognormal()`](https://bdshaff.github.io/meridianR/reference/prior_constructors.md)
  [`prior_normal()`](https://bdshaff.github.io/meridianR/reference/prior_constructors.md)
  [`prior_halfnormal()`](https://bdshaff.github.io/meridianR/reference/prior_constructors.md)
  [`prior_truncated_normal()`](https://bdshaff.github.io/meridianR/reference/prior_constructors.md)
  [`prior_uniform()`](https://bdshaff.github.io/meridianR/reference/prior_constructors.md)
  [`prior_beta()`](https://bdshaff.github.io/meridianR/reference/prior_constructors.md)
  [`prior_deterministic()`](https://bdshaff.github.io/meridianR/reference/prior_constructors.md)
  : Prior distribution constructors

## Fitting & serialization

- [`meridian_model()`](https://bdshaff.github.io/meridianR/reference/meridian_model.md)
  : Create a Meridian model
- [`sample_prior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md)
  [`sample_posterior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md)
  : Draw from a Meridian model's prior and posterior
- [`fit(`*`<meridian_model>`*`)`](https://bdshaff.github.io/meridianR/reference/fit.meridian_model.md)
  : Fit a Meridian model
- [`summary(`*`<meridian_model>`*`)`](https://bdshaff.github.io/meridianR/reference/summary.meridian_model.md)
  : Summarize a fitted Meridian model
- [`save_model()`](https://bdshaff.github.io/meridianR/reference/save_model.md)
  [`load_model()`](https://bdshaff.github.io/meridianR/reference/save_model.md)
  : Save and load a Meridian model

## Analysis

Tidy per-channel metrics and curves from a fitted model.

- [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md)
  : Create a Meridian analyzer
- [`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md)
  : Channel-level summary metrics
- [`expected_vs_actual()`](https://bdshaff.github.io/meridianR/reference/expected_vs_actual.md)
  : Expected versus actual KPI over time
- [`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md)
  : Response curves (incremental outcome versus spend)
- [`hill_curves()`](https://bdshaff.github.io/meridianR/reference/hill_curves.md)
  : Hill saturation curves
- [`adstock_decay()`](https://bdshaff.github.io/meridianR/reference/adstock_decay.md)
  : Adstock decay curves
- [`rhat_summary()`](https://bdshaff.github.io/meridianR/reference/rhat_summary.md)
  : Convergence diagnostics (R-hat) summary
- [`predictive_accuracy()`](https://bdshaff.github.io/meridianR/reference/predictive_accuracy.md)
  : Predictive accuracy metrics

## Plots & reports

ggplot2-native charts and Meridian’s HTML summary.

- [`autoplot(`*`<meridian_model>`*`)`](https://bdshaff.github.io/meridianR/reference/autoplot.meridian_model.md)
  [`plot(`*`<meridian_model>`*`)`](https://bdshaff.github.io/meridianR/reference/autoplot.meridian_model.md)
  : Plot a fitted Meridian model
- [`plot_model_fit()`](https://bdshaff.github.io/meridianR/reference/plot_model_fit.md)
  : Plot expected versus actual KPI over time
- [`plot_roi()`](https://bdshaff.github.io/meridianR/reference/plot_roi.md)
  : Plot return on investment by channel
- [`plot_contribution()`](https://bdshaff.github.io/meridianR/reference/plot_contribution.md)
  : Plot each channel's share of KPI contribution
- [`plot_response_curves()`](https://bdshaff.github.io/meridianR/reference/plot_response_curves.md)
  : Plot response curves (incremental outcome versus spend)
- [`plot_hill_curves()`](https://bdshaff.github.io/meridianR/reference/plot_hill_curves.md)
  : Plot Hill saturation curves
- [`plot_adstock_decay()`](https://bdshaff.github.io/meridianR/reference/plot_adstock_decay.md)
  : Plot adstock decay curves
- [`plot_rhat()`](https://bdshaff.github.io/meridianR/reference/plot_rhat.md)
  : Plot convergence diagnostics (max R-hat by parameter)
- [`model_report()`](https://bdshaff.github.io/meridianR/reference/model_report.md)
  : Write Meridian's HTML model-results summary

## Data

- [`sales`](https://bdshaff.github.io/meridianR/reference/sales.md) :
  Simulated weekly marketing-mix data

## Reexports

- [`reexports`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`import`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`py_require`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`py_config`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`r_to_py`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`py_to_r`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`use_python`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`use_virtualenv`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`use_condaenv`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`fit`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  [`autoplot`](https://bdshaff.github.io/meridianR/reference/reexports.md)
  : Objects exported from other packages
