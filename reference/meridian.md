# Direct handle to the Meridian Python module

`meridian` is a module proxy that exposes the underlying
[Meridian](https://developers.google.com/meridian) Python package
directly, e.g. `meridian$model$model$Meridian` or
`meridian$data$load$CsvDataLoader`. It is the low-level escape hatch
beneath the R wrappers: anything reachable from Python is reachable
here.

## Usage

``` r
meridian
```

## Format

An object of class `python.builtin.module` (inherits from
`python.builtin.object`) of length 0.

## Value

A Python module proxy (an object of class `python.builtin.module`).

## Details

The module is imported lazily. The first time you touch `meridian$...`,
reticulate initializes Python (provisioning an environment via
[`install_meridian()`](https://bdshaff.github.io/meridianR/reference/install_meridian.md)
or
[`reticulate::py_require()`](https://rstudio.github.io/reticulate/reference/py_require.html)
if needed).

## Examples

``` r
if (FALSE) { # \dontrun{
meridian$`__version__`
} # }
```
