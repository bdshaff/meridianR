# Save and load a Meridian model

`save_model()` serializes a Meridian model – including its inference
data – to a file, and `load_model()` restores it. Thin bindings to
Meridian's `save_mmm()` and `load_mmm()`.

## Usage

``` r
save_model(model, path)

load_model(path)
```

## Arguments

- model:

  A `meridian_model`.

- path:

  File path to write to or read from.

## Value

`save_model()` returns `path` invisibly; `load_model()` returns a
`meridian_model`.

## Examples

``` r
if (FALSE) { # \dontrun{
save_model(mmm, "mmm.pkl")
mmm2 <- load_model("mmm.pkl")
} # }
```
