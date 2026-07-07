# meridianR 0.0.0.9000

Initial development release (data and modeling core).

* First public scaffold of the package.
* Python provisioning via `reticulate::py_require()` with an `install_meridian()`
  helper; `use_backend()` selects the TensorFlow or JAX backend.
* Data interface: `as_meridian_input()`, the fluent `input_data_builder()` with
  `with_*()` verbs, and faithful `coord_to_columns()` / `csv_loader()` /
  `data_frame_loader()` bindings.
* Model configuration: `model_spec()`, `prior_distribution()`, and the
  `prior_*()` distribution constructors.
* Fitting: `meridian_model()`, `sample_prior()`, `sample_posterior()`, `fit()`,
  and `save_model()` / `load_model()`.
* S3 `print()` / `summary()` for input data, model specifications, and models.
* Analysis layer: `analyzer()` plus tidy accessors returning tibbles
  (`summary_metrics()`, `response_curves()`, `hill_curves()`, `adstock_decay()`,
  `expected_vs_actual()`, `rhat_summary()`, `predictive_accuracy()`).
* ggplot2-native plots (`plot_model_fit()`, `plot_roi()`, `plot_contribution()`,
  `plot_response_curves()`, `plot_hill_curves()`, `plot_adstock_decay()`,
  `plot_rhat()`) with `autoplot()` / `plot()` dispatch by `type`, plus
  `model_report()` for Meridian's built-in HTML summary.
