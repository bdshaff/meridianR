# Plot a fitted Meridian model

[`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
builds a ggplot for a fitted model, and
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) draws it. The
`type` argument selects which chart, dispatching to the `plot_*()`
family (e.g.
[`plot_model_fit()`](https://bdshaff.github.io/meridianR/reference/plot_model_fit.md),
[`plot_roi()`](https://bdshaff.github.io/meridianR/reference/plot_roi.md),
[`plot_response_curves()`](https://bdshaff.github.io/meridianR/reference/plot_response_curves.md)).

## Usage

``` r
# S3 method for class 'meridian_model'
autoplot(object, type = plot_types, ...)

# S3 method for class 'meridian_model'
plot(x, type = plot_types, ...)
```

## Arguments

- object, x:

  A fitted `meridian_model`.

- type:

  One of `"fit"`, `"roi"`, `"contribution"`, `"response"`, `"hill"`,
  `"adstock"`, or `"rhat"`.

- ...:

  Passed to the underlying `plot_*()` function.

## Value

[`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
returns a ggplot object;
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) draws it and
returns it invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
autoplot(mmm, type = "roi")
plot(mmm, type = "response")
} # }
```
