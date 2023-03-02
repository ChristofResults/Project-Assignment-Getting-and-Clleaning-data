## R script for project assignment of course 3 - Getting and Cleaning Data
## date: 2023-03-02
## author: Christof
## version: 2.0
## status: final
## change history: 
## 1.0 calculated mean across measurements, wrong interpretation of assignment
## 2.0 select columns with mean() or std() in the name

## purpose of this script: prepare data for analysis
## requirements: 
##    result must be 2 data sets that adheres to tidy data principles
##    output 2nd data set to txt file

## packages
library(dplyr) # for functions such as mutate(), select()
library(reshape2) # for functions such as melt()

## settings
work_dir <- getwd() # setworking directory
source_dir <- paste(work_dir, "/UCI HAR Dataset/", sep = "") # create dir for raw source data
output_dir <- paste(work_dir, "/Data/", sep = "") # create dir for raw source data

## collect activities and features
      # create activities data set for descriptive activity names: reads data and renames columns
      activities_file <- paste(source_dir, "activity_labels.txt", sep = "")
      activities_data <- read.table(activities_file)
      # renaming of columns to descriptive names
      activities_data <- rename(activities_data, activity_id = V1, activity_name = V2)
      activities_data$activity_name <- as.factor(activities_data$activity_name)

      # create features data for descriptive measurements names
      features_data <- read.table(paste(source_dir,"features.txt", sep =""))
      features_data <- rename(features_data, feature_id = V1, feature_name = V2)
      #create unique names using both collumns for features because the provided list contains duplicate names
      features_list <- mutate(features_data, uniquenames = paste(feature_id, feature_name, sep=""))

# create training data set from X_train.txt, y_train.txt (as labels), subject_train.txt (for subject ids)
      # create filepaths to source data
      training_file_x <- paste(source_dir, "train/X_train.txt", sep = "")
      training_file_labels <- paste(source_dir, "train/y_train.txt", sep = "")
      training_file_subjectids <- paste(source_dir, "train/subject_train.txt", sep = "")
      # create lists of factors to add to the observation data in X_train.txt
      training_data_activityids <- read.csv(training_file_labels, header = FALSE, col.names = "activity_id")
      training_data_subjectids <- read.csv(training_file_subjectids, header = FALSE, col.names = "subject_id")
      # create data frame with the obervations and add the factor data
      training_data_table <- read.table(training_file_x)
      # add column names based on features name
      colnames(training_data_table) <- features_list[,3]
      # combine the subject, activity and measurement data
      training_data_table <- cbind(training_data_subjectids, training_data_activityids, training_data_table)

# create test data set from X_test.txt, y_test.txt (as labels), subject_test.txt (for subject ids)
      # create filepaths to source data
      test_file_x <- paste(source_dir, "test/X_test.txt", sep = "")
      test_file_labels <- paste(source_dir, "test/y_test.txt", sep = "")
      test_file_subjectids <- paste(source_dir, "test/subject_test.txt", sep = "")
      # create lists of factors to add to the observation data in X_test.txt
      test_data_activityids <- read.csv(test_file_labels, header = FALSE, col.names = "activity_id")
      test_data_subjectids <- read.csv(test_file_subjectids, header = FALSE, col.names = "subject_id")
      # create data frame with the obervations and add the factor data
      test_data_table <- read.table(test_file_x)
      # add column names based on features name
      colnames(test_data_table) <- features_list[,3]
      # combine the subject, activity and measurement data
      test_data_table <- cbind(test_data_subjectids, test_data_activityids, test_data_table)

## Create merged data set with calculated variables
# Merge the training and the test sets to create one data set.
      merged_data <- rbind(training_data_table, test_data_table) # rbind because both test & train data have the same columns
# add activity names  based on activity_id
      merged_data$activity_id <- factor(merged_data$activity_id, levels = activities_data$activity_id, labels = activities_data$activity_name)
      merged_data$subject_id <- as.factor(merged_data$subject_id)

# Extracts per activity-subject combination the measurements on the mean and standard deviation for each measurement. 
# using the text "mean()" "std() and ensure that other columns are retained

      # construct search string for columns needed
      search_string <- c("activity_id", "subject_id", "mean()", "std()")

      # Extracts per activity-subject combination the measurements that contain "mean()" "std() in the name
      tidy_data_full <- merged_data %>% 
            select(contains(search_string)) %>%
            # create tidy data
            melt(id = c("activity_id","subject_id"), variable.name = "measurement")
            # store as tibble for easier review
            tidy_data_full <- tibble::as_tibble(tidy_data_full)
            print("data set 1 has name: tidy_data_full")

      # Create data set from the melted data set created in previous step
      # resulting in rows that contain per activity-subject-variable combination the mean value
      tidy_data_mean_bymeasurement <- tidy_data_full %>%
            group_by(activity_id, subject_id, measurement) %>%
            summarise(mean = mean(value))
            print("data set 2 has name: tidy_data_mean_bymeasurement")

## write the data sets to files
print("Write the 2 data sets as csv to the 'Data' subdirectory from the working directory")
write.csv(tidy_data_full, paste(output_dir,"tidy_data_full.csv", sep=""))
write.csv(tidy_data_mean_bymeasurement, paste(output_dir, "tidy_data_mean_bymeasurement.csv", sep = ""))

print("Write the requested result file to the 'Data' subdirectory from the working directory")
write.table(tidy_data_mean_bymeasurement, paste(output_dir,"result.txt", sep=""), row.name=FALSE)