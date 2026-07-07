# Is the Meridian Python package available?

Checks whether the `meridian` Python module can be imported in the
active reticulate configuration. The first call may initialize Python
(and, if no environment is configured, trigger
[`reticulate::py_require()`](https://rstudio.github.io/reticulate/reference/py_require.html)
provisioning).

## Usage

``` r
meridian_available()
```

## Value

`TRUE` or `FALSE`.
