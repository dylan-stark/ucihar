# ucihar

This package contains data hosted at the UCI Machine Learning Repository (source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

This package contains two [tidy](http://tidyverse.org) data sets:

1. `ucihar` -- mean and standard deviation measurements (10299 obs. of 68 variables)
2. `ucihar_avgs` -- summarized (mean) values for each measurement in `ucihar` by subject and activity (180 obs. of 68 variables)

See the [Code Book](CodeBook.md) for details full details -- all processing and merging of raw data is done in [`data-raw/run_analysis.R`](data-raw/run_analysis.R).

Installation:

```
devtools::install_github("dylan-stark/ucihar")
```

Citation:

Use `citation("ucihar")` to cite *this package*. Use the following article to cite the Human Activity Recognition Using Smartphones data set:

> Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

