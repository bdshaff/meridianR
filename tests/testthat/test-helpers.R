test_that("compact drops NULL elements", {
  expect_equal(compact(list(a = 1, b = NULL, c = 2)), list(a = 1, c = 2))
  expect_equal(compact(list()), list())
})

test_that("as_py_int coerces to integer and preserves NULL", {
  expect_null(as_py_int(NULL))
  expect_identical(as_py_int(8), 8L)
  expect_identical(as_py_int(c(2, 3)), c(2L, 3L))
})

test_that("named_cols is NULL-safe and tags columns", {
  expect_length(named_cols("controls", NULL), 0)
  x <- named_cols("media", c("a", "b"))
  expect_equal(unname(x), c("a", "b"))
  expect_equal(names(x), c("media", "media"))
})

test_that("meridian_pip_spec builds the right extras", {
  expect_equal(meridian_pip_spec("tensorflow", FALSE), "google-meridian")
  expect_equal(meridian_pip_spec("jax", FALSE), "google-meridian[jax]")
  expect_equal(meridian_pip_spec("tensorflow", TRUE), "google-meridian[and-cuda]")
  expect_equal(meridian_pip_spec("jax", TRUE), "google-meridian[and-cuda,jax]")
})
