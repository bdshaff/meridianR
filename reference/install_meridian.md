# Install Meridian and its Python dependencies

Creates (or reuses) a persistent Python virtual environment and installs
the `google-meridian` package together with the backend of your choice.
Once installed, meridianR will use this environment automatically in
future sessions.

## Usage

``` r
install_meridian(
  envname = "r-meridian",
  ...,
  backend = c("tensorflow", "jax"),
  gpu = FALSE,
  python_version = ">=3.10",
  new_env = identical(envname, "r-meridian")
)
```

## Arguments

- envname:

  Name of (or path to) the virtual environment to install into. Defaults
  to `"r-meridian"`.

- ...:

  Additional arguments passed to
  [`reticulate::py_install()`](https://rstudio.github.io/reticulate/reference/py_install.html).

- backend:

  Compute backend to provision: `"tensorflow"` (default) or the
  experimental `"jax"` backend. The JAX backend pulls in the
  `google-meridian[jax]` extra and is recorded as the default backend
  for future sessions (see
  [`use_backend()`](https://bdshaff.github.io/meridianR/reference/use_backend.md)).

- gpu:

  Logical; if `TRUE`, install the CUDA GPU build
  (`google-meridian[and-cuda]`). Ignored on platforms without CUDA
  support.

- python_version:

  Python version constraint used when creating a new environment.
  Meridian requires Python \>= 3.10.

- new_env:

  If `TRUE`, any existing environment of the same name is removed before
  installing. Defaults to `TRUE` only for the default `"r-meridian"`
  environment.

## Value

The environment name, invisibly.

## Details

If you skip this step, meridianR still works:
[`reticulate::py_require()`](https://rstudio.github.io/reticulate/reference/py_require.html)
(set up on load) will provision an ephemeral environment containing
Meridian the first time Python is used. `install_meridian()` is
recommended when you want a reusable environment, GPU support, or the
experimental JAX backend.

## Examples

``` r
if (FALSE) { # \dontrun{
# Default CPU / TensorFlow install
install_meridian()

# GPU build
install_meridian(gpu = TRUE)

# Experimental JAX backend
install_meridian(backend = "jax")
} # }
```
