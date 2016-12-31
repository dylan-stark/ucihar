# ucihar

This package contains data hosted at the UCI Machine Learning Repository (source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

This package contains two [tidy](http://tidyverse.org) data sets:

1. `ucihar` -- mean and standard deviation measurements (10299 obs. of 68 variables)
2. `ucihar_avgs` -- summarized (mean) values for each measurement in `ucihar` by subject and activity (180 obs. of 68 variables)

See the [Code Book](CodeBook.md) for details full details -- all processing and merging of raw data is done in [`data-raw/ucihar.R`](data-raw/ucihar.R).

Installation:

```
devtools::install_github("dylan-stark/ucihar")
```

