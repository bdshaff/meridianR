# Load Meridian input data from a CSV file or data frame

Faithful bindings to Meridian's `CsvDataLoader` and
`DataFrameDataLoader`. They return a loader object; call
[`load_input_data()`](https://bdshaff.github.io/meridianR/reference/load_input_data.md)
to produce the `meridian_input_data`.

## Usage

``` r
csv_loader(
  csv_path,
  coord_to_columns,
  kpi_type = c("non_revenue", "revenue"),
  media_to_channel = NULL,
  media_spend_to_channel = NULL,
  reach_to_channel = NULL,
  frequency_to_channel = NULL,
  rf_spend_to_channel = NULL,
  organic_reach_to_channel = NULL,
  organic_frequency_to_channel = NULL
)

data_frame_loader(
  data,
  coord_to_columns,
  kpi_type = c("non_revenue", "revenue"),
  media_to_channel = NULL,
  media_spend_to_channel = NULL,
  reach_to_channel = NULL,
  frequency_to_channel = NULL,
  rf_spend_to_channel = NULL,
  organic_reach_to_channel = NULL,
  organic_frequency_to_channel = NULL
)
```

## Arguments

- csv_path:

  Path to a CSV file (`csv_loader()`).

- coord_to_columns:

  A
  [`coord_to_columns()`](https://bdshaff.github.io/meridianR/reference/coord_to_columns.md)
  mapping.

- kpi_type:

  `"non_revenue"` (default) or `"revenue"`.

- media_to_channel, media_spend_to_channel, reach_to_channel,
  frequency_to_channel, rf_spend_to_channel, organic_reach_to_channel,
  organic_frequency_to_channel:

  Optional named lists mapping data columns to channel names.

- data:

  A data frame (`data_frame_loader()`).

## Value

A `meridian_data_loader` object.

## See also

[`load_input_data()`](https://bdshaff.github.io/meridianR/reference/load_input_data.md),
[`as_meridian_input()`](https://bdshaff.github.io/meridianR/reference/as_meridian_input.md)
