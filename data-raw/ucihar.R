library(devtools)
library(readr)
library(dplyr)
library(stringr)

get_ucihar_data <- function() {
  url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"

  # Download full data set
  temp <- tempfile(fileext = ".zip")
  raw_zip <- download.file(url, temp)

  # Extract necessary files
  files <- c(
    "UCI HAR Dataset/features.txt",
    "UCI HAR Dataset/activity_labels.txt",
    "UCI HAR Dataset/test/X_test.txt",
    "UCI HAR Dataset/test/y_test.txt",
    "UCI HAR Dataset/test/subject_test.txt",
    "UCI HAR Dataset/train/X_train.txt",
    "UCI HAR Dataset/train/y_train.txt",
    "UCI HAR Dataset/train/subject_train.txt"
  )
  unzip(temp, exdir = "data-raw/ucihar", junkpaths = TRUE, files = files)

  features <- read_delim("data-raw/ucihar/features.txt", delim = " ",
                         col_names = c("id", "feature"))

  # TODO: deduplicate feature names
  test <- read_table("data-raw/ucihar/X_test.txt", col_names = features$feature,
                     col_types = cols(.default = col_double())) %>%
    cbind(read_table("data-raw/ucihar/y_test.txt", col_names = c("activity_id"))) %>%
    cbind(read_table("data-raw/ucihar/subject_test.txt", col_names = c("subject_id")))

  train <- read_table("data-raw/ucihar/X_train.txt", col_names = features$feature,
                      col_types = cols(.default = col_double())) %>%
    cbind(read_table("data-raw/ucihar/y_train.txt", col_names = c("activity_id"))) %>%
    cbind(read_table("data-raw/ucihar/subject_train.txt", col_names = c("subject_id")))

  activity_labels <- read_table("data-raw/ucihar/activity_labels.txt", col_names = c("id", "activity"))

  ucihar <- rbind(test, train) %>%
    inner_join(activity_labels, by = c("activity_id" = "id")) %>%
    select(subject_id, activity, contains("mean()"), contains("std()")) %>%
    mutate(activity = str_to_lower(activity))

  names(ucihar) <- names(ucihar) %>%
    str_replace("^f", "freq") %>%
    str_replace("^t", "time") %>%
    str_replace("[(][)]-?", "") %>%
    str_replace_all("-", "_") %>%
    str_replace_all("([A-Z])", "_\\1") %>%
    str_to_lower()

  ucihar
}

get_ucihar_avgs <- function(data) {
  ucihar_avgs <- data %>%
    group_by(subject_id, activity) %>%
    summarise_all(mean)

  ucihar_avgs
}

ucihar <- get_ucihar_data()
use_data(ucihar, overwrite = TRUE)

ucihar_avgs <- get_ucihar_avgs(ucihar)
use_data(ucihar_avgs, overwrite = TRUE)
