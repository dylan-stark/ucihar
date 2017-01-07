library(devtools)
library(readr)
library(dplyr)
library(stringr)

ucihar_url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"

clean_names <- function(df) {
  names(df) <- names(df) %>%
    str_replace(",", "_") %>%
    str_replace("^f", "freq") %>%
    str_replace("^t", "time") %>%
    str_replace("[(][)]-?", "") %>%
    str_replace_all("-", "_") %>%
    str_replace_all("([^_])([A-Z])", "\\1_\\2") %>%
    str_to_lower()
}

# Downloads and extracts files into `data-raw/ucihar`
get_ucihar_data <- function() {
  temp <- tempfile(fileext = ".zip")
  raw_zip <- download.file(ucihar_url, temp)

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
}

gen_ucihar_features <- function() {
  read_delim("data-raw/ucihar/features.txt", delim = " ",
             col_names = c("id", "feature"))
}

gen_ucihar_activity <- function() {
  activity <- read_table("data-raw/ucihar/activity_labels.txt",
                         col_names = c("id", "activity"))
}

gen_ucihar_training <- function() {
  features <- ucihar_features()
  activity <- ucihar_activity()

  X <- read_table("data-raw/ucihar/X_train.txt", col_names = features$feature,
                  col_types = cols(.default = col_double()))
  y <- read_table("data-raw/ucihar/y_train.txt", col_names = c("activity_id"))
  subject <- read_table("data-raw/ucihar/subject_train.txt",
                        col_names = c("subject_id"))

  training <- cbind(X, y, subject) %>%
    inner_join(activity, by = c("activity_id" = "id"))

  names(training) <- clean_names(training)

  training
}

gen_ucihar_testing <- function() {
  features <- ucihar_features()
  activity <- ucihar_activity()

  X <- read_table("data-raw/ucihar/X_test.txt", col_names = features$feature,
                  col_types = cols(.default = col_double()))
  y <- read_table("data-raw/ucihar/y_test.txt", col_names = c("activity_id"))
  subject <- read_table("data-raw/ucihar/subject_test.txt",
                        col_names = c("subject_id"))

  # TODO: deduplicate feature names
  testing <- cbind(X, y, subject) %>%
    inner_join(activity, by = c("activity_id" = "id"))

  names(testing) <- clean_names(testing)

  testing
}

gen_ucihar_simple <- function() {
  train <- gen_ucihar_training()
  test <- gen_ucihar_testing()

  ucihar <- rbind(test, train) %>%
    select(subject_id, activity, contains("mean_"), contains("std_")) %>%
    mutate(activity = str_to_lower(activity))

  ucihar
}

gen_ucihar_avgs <- function(data) {
  data %>%
    group_by(subject_id, activity) %>%
    summarise_all(mean)
}

################################################################################

get_ucihar_data()

ucihar_training <- gen_ucihar_training()
use_data(ucihar_training, overwrite = TRUE)

ucihar_testing <- gen_ucihar_testing()
use_data(ucihar_testing, overwrite = TRUE)

ucihar_simple <- gen_ucihar_simple()
use_data(ucihar_simple, overwrite = TRUE)

ucihar_avgs <- gen_ucihar_avgs(ucihar)
use_data(ucihar_avgs, overwrite = TRUE)
