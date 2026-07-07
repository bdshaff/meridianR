# Simulated weekly marketing-mix data

A simulated geo-level panel used to demonstrate meridianR: weekly
conversions and marketing activity across four regions over two years.
Conversions are generated from a dominant, structured baseline (level,
trend, and annual seasonality) plus media effects with geometric adstock
and Hill saturation and a price control, so a fitted model recovers a
good fit and a realistic media contribution (~10-15%). It is **not**
real data.

## Usage

``` r
sales
```

## Format

A data frame with 416 rows (4 regions x 104 weeks) and 9 columns:

- region:

  Geo identifier: "North", "South", "East", or "West".

- week:

  Week start date (a `Date`).

- conversions:

  Weekly KPI (conversions).

- population:

  Region population, constant over time.

- tv_spend:

  TV media spend.

- tv_impressions:

  TV impressions (media execution metric).

- search_spend:

  Search media spend.

- search_clicks:

  Search clicks (media execution metric).

- price_index:

  Price index control variable.

## Source

Simulated; see `data-raw/sales.R`.
