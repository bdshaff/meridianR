# Write Meridian's HTML model-results summary

An escape hatch to Meridian's own two-page HTML summary report (via its
`Summarizer`), for when you want the built-in report instead of the tidy
accessors and ggplot2 charts in this package.

## Usage

``` r
model_report(
  model,
  path = "meridian_summary.html",
  start_date = NULL,
  end_date = NULL
)
```

## Arguments

- model:

  A fitted `meridian_model`.

- path:

  Output HTML file path.

- start_date, end_date:

  Optional date strings (e.g. `"2022-01-03"`) that limit the reporting
  window.

## Value

`path`, invisibly.
