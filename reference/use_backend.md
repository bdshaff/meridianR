# Select the Meridian compute backend

Meridian can run on a TensorFlow (default) or an experimental JAX
backend. The backend is read from the `MERIDIAN_BACKEND` environment
variable when the Meridian Python module is first imported, so for a
reliable switch call `use_backend()` *before* any other meridianR
function in a session. If Meridian is already loaded, `use_backend()`
additionally attempts a runtime switch, which may not take full effect
until the session is restarted.

## Usage

``` r
use_backend(backend = c("tensorflow", "jax"))
```

## Arguments

- backend:

  `"tensorflow"` or `"jax"`.

## Value

The selected backend, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_backend("jax")
} # }
```
