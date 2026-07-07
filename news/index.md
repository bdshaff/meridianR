# Changelog

## meridianR 0.0.0.9000

Initial development release (data and modeling core).

- First public scaffold of the package.
- Python provisioning via
  [`reticulate::py_require()`](https://rstudio.github.io/reticulate/reference/py_require.html)
  with an
  [`install_meridian()`](https://bdshaff.github.io/meridianR/reference/install_meridian.md)
  helper;
  [`use_backend()`](https://bdshaff.github.io/meridianR/reference/use_backend.md)
  selects the TensorFlow or JAX backend.
- Data interface:
  [`as_meridian_input()`](https://bdshaff.github.io/meridianR/reference/as_meridian_input.md),
  the fluent
  [`input_data_builder()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
  with `with_*()` verbs, and faithful
  [`coord_to_columns()`](https://bdshaff.github.io/meridianR/reference/coord_to_columns.md)
  /
  [`csv_loader()`](https://bdshaff.github.io/meridianR/reference/csv_loader.md)
  /
  [`data_frame_loader()`](https://bdshaff.github.io/meridianR/reference/csv_loader.md)
  bindings.
- Model configuration:
  [`model_spec()`](https://bdshaff.github.io/meridianR/reference/model_spec.md),
  [`prior_distribution()`](https://bdshaff.github.io/meridianR/reference/prior_distribution.md),
  and the `prior_*()` distribution constructors.
- Fitting:
  [`meridian_model()`](https://bdshaff.github.io/meridianR/reference/meridian_model.md),
  [`sample_prior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md),
  [`sample_posterior()`](https://bdshaff.github.io/meridianR/reference/sample_prior.md),
  [`fit()`](https://generics.r-lib.org/reference/fit.html), and
  [`save_model()`](https://bdshaff.github.io/meridianR/reference/save_model.md)
  /
  [`load_model()`](https://bdshaff.github.io/meridianR/reference/save_model.md).
- S3 [`print()`](https://rdrr.io/r/base/print.html) /
  [`summary()`](https://rdrr.io/r/base/summary.html) for input data,
  model specifications, and models.
- Analysis layer:
  [`analyzer()`](https://bdshaff.github.io/meridianR/reference/analyzer.md)
  plus tidy accessors returning tibbles
  ([`summary_metrics()`](https://bdshaff.github.io/meridianR/reference/summary_metrics.md),
  [`response_curves()`](https://bdshaff.github.io/meridianR/reference/response_curves.md),
  [`hill_curves()`](https://bdshaff.github.io/meridianR/reference/hill_curves.md),
  [`adstock_decay()`](https://bdshaff.github.io/meridianR/reference/adstock_decay.md),
  [`expected_vs_actual()`](https://bdshaff.github.io/meridianR/reference/expected_vs_actual.md),
  [`rhat_summary()`](https://bdshaff.github.io/meridianR/reference/rhat_summary.md),
  [`predictive_accuracy()`](https://bdshaff.github.io/meridianR/reference/predictive_accuracy.md)).
- ggplot2-native plots
  ([`plot_model_fit()`](https://bdshaff.github.io/meridianR/reference/plot_model_fit.md),
  [`plot_roi()`](https://bdshaff.github.io/meridianR/reference/plot_roi.md),
  [`plot_contribution()`](https://bdshaff.github.io/meridianR/reference/plot_contribution.md),
  [`plot_response_curves()`](https://bdshaff.github.io/meridianR/reference/plot_response_curves.md),
  [`plot_hill_curves()`](https://bdshaff.github.io/meridianR/reference/plot_hill_curves.md),
  [`plot_adstock_decay()`](https://bdshaff.github.io/meridianR/reference/plot_adstock_decay.md),
  [`plot_rhat()`](https://bdshaff.github.io/meridianR/reference/plot_rhat.md))
  with
  [`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
  / [`plot()`](https://rdrr.io/r/graphics/plot.default.html) dispatch by
  `type`, plus
  [`model_report()`](https://bdshaff.github.io/meridianR/reference/model_report.md)
  for Meridian’s built-in HTML summary.
