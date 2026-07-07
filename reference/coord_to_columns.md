# Map data columns to Meridian coordinates

Thin binding to Meridian's `CoordToColumns`, which tells a data loader
which columns hold each Meridian coordinate. Scalar fields take a single
column name; the media/control fields take character vectors.

## Usage

``` r
coord_to_columns(
  time = "time",
  geo = "geo",
  kpi = "kpi",
  population = "population",
  revenue_per_kpi = NULL,
  controls = NULL,
  media = NULL,
  media_spend = NULL,
  reach = NULL,
  frequency = NULL,
  rf_spend = NULL,
  non_media_treatments = NULL,
  organic_media = NULL,
  organic_reach = NULL,
  organic_frequency = NULL
)
```

## Arguments

- time, geo, kpi, population, revenue_per_kpi:

  Single column names.

- controls, media, media_spend, reach, frequency, rf_spend,
  non_media_treatments, organic_media, organic_reach, organic_frequency:

  Character vectors of column names (or `NULL`).

## Value

A `meridian_coord_to_columns` object.

## See also

[`csv_loader()`](https://bdshaff.github.io/meridianR/reference/csv_loader.md),
[`data_frame_loader()`](https://bdshaff.github.io/meridianR/reference/csv_loader.md)
