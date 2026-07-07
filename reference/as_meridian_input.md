# Assemble Meridian input data from a data frame

`as_meridian_input()` is the primary, one-call way to turn a long-format
R data frame into a Meridian `InputData` object. It drives Meridian's
`DataFrameInputDataBuilder` (see
[`input_data_builder()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md))
under the hood, adding only the components you supply.

## Usage

``` r
as_meridian_input(
  data,
  kpi,
  time = "time",
  geo = "geo",
  population = "population",
  media_spend = NULL,
  media = NULL,
  media_channels = NULL,
  controls = NULL,
  revenue_per_kpi = NULL,
  reach = NULL,
  frequency = NULL,
  rf_spend = NULL,
  rf_channels = NULL,
  organic_media = NULL,
  non_media_treatments = NULL,
  kpi_type = c("non_revenue", "revenue"),
  national = FALSE
)
```

## Arguments

- data:

  A long-format data frame.

- kpi:

  Name of the KPI column.

- time:

  Name of the time column (dates are coerced to ISO-8601 strings).

- geo:

  Name of the geo column. Ignored (and synthesized) when
  `national = TRUE`.

- population:

  Name of the per-geo population column. Synthesized as a constant when
  `national = TRUE` and absent.

- media_spend:

  Character vector of media spend columns.

- media:

  Character vector of media execution columns (e.g. impressions),
  aligned with `media_spend`. Defaults to `media_spend`.

- media_channels:

  Character vector of channel labels. Defaults to `media_spend`.

- controls:

  Character vector of control-variable columns.

- revenue_per_kpi:

  Name of the revenue-per-KPI column, if any.

- reach, frequency, rf_spend:

  Character vectors of reach, average-frequency, and spend columns for
  reach-and-frequency channels.

- rf_channels:

  Channel labels for R&F channels. Defaults to `reach`.

- organic_media:

  Character vector of organic-media columns.

- non_media_treatments:

  Character vector of non-media treatment columns.

- kpi_type:

  `"non_revenue"` (default) or `"revenue"`.

- national:

  If `TRUE`, treat the data as national (single geo): a geo column and
  constant population are synthesized when absent.

## Value

A `meridian_input_data` object wrapping a Meridian `InputData`.

## Details

The data must be in long format: one row per geo-by-time (or per time
for a national model), with columns for the KPI, population, media
spend, and any controls. Media, reach/frequency, organic media, and
non-media treatments are optional.

If you supply `media_spend` but not `media`, spend is also used as the
media execution metric (a spend-based model). Channel labels default to
the spend column names; pass `media_channels` for nicer labels.

## See also

[`input_data_builder()`](https://bdshaff.github.io/meridianR/reference/input_data_builder.md)
for the step-by-step builder, and
[`meridian_model()`](https://bdshaff.github.io/meridianR/reference/meridian_model.md)
to fit a model on the result.

## Examples

``` r
if (FALSE) { # \dontrun{
input <- as_meridian_input(
  sales,
  kpi         = "conversions",
  time        = "week",
  geo         = "region",
  population  = "population",
  media_spend = c("tv_spend", "search_spend"),
  media       = c("tv_impressions", "search_clicks"),
  media_channels = c("TV", "Search"),
  controls    = "price_index"
)
input
} # }
```
