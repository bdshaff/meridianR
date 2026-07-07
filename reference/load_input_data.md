# Realize input data from a loader

Calls a loader's `.load()` method and wraps the result.

## Usage

``` r
load_input_data(loader)
```

## Arguments

- loader:

  A `meridian_data_loader` from
  [`csv_loader()`](https://bdshaff.github.io/meridianR/reference/csv_loader.md)
  or
  [`data_frame_loader()`](https://bdshaff.github.io/meridianR/reference/csv_loader.md).

## Value

A `meridian_input_data` object.
