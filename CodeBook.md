The original data set is available at the UCI Machine Learning
Repository as the [Human Activity Recognition Using Smartphones Data
Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
([data
folder](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/)).
Full details are available in the `README.txt` in the download archive
or on the web at [UCI HAR
Dataset.names](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names)
file. This package contains two [tidy](http://tidyverse.org) data sets:

1.  `ucihar` -- mean and standard deviation measurements (10299 obs. of
    68 variables)
2.  `ucihar_avgs` -- summarized (mean) values for each measurement in
    `ucihar` by subject and activity (180 obs. of 68 variables)

Study Design
------------

The source data is across multiple files. The following are the steps
taken to create the `ucihar` data set:

-   Create feature names vector from `features.txt`
-   Create test set by reading in `test/X_test.txt`, using feature names
    as column names, adding activity IDs from `test/y_test.txt`, and
    adding subject IDs from `test/subject_test.txt`.
-   Create training set following same process for test set (above)
-   Create activity labels vector from `activity_labels.txt`
-   Create full featrue set by combining test and training data sets
-   Replace activity IDs with activity labels
-   Remove all variables not measuring mean and standard deviation

The following are the steps taken to clean field and activity labels:

-   Convert field names to use lowercase with separating `_` instead of
    camelCase, recode `f` and `t` to `freq` and `time`, remove
    non-alphanumeric characteris `(`, `)`, and `-` (e.g., from
    `tBodyAcc-mean()-X` to `time_body_acc_mean_x`)
-   Convert activity names to lowercase (e.g., from `WALKING_UPSTAIRS`
    to `walking_upstairs`)

The following are the steps taken to create the `ucihar_avgs` data set:

-   Group `ucihar` data by `subject_id` and `activity`
-   Summarise all fields using `mean()`

Implementations for both data sets are in `get_ucihar()` and
`get_ucihar_avgs()` in [`data-raw/ucihar.R`](data-raw/ucihar.R).

Code book for the `ucihar` data set
-----------------------------------

The following maps variables from the [source details
document](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names)
to the new variable names:

`subject_id`  
"An identifier of the subject who carried out the experiment."

`activity`  
Type of activity being performed (standing, sitting, laying, walking,
walking\_downstairs, walking\_upstairs)

`time_body_acc_mean_{x,y,z}`, `time_body_acc_std_{x,y,z}`  
Mean and std. dev. of body acceleration
