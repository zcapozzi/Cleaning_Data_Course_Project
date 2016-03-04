
#setwd("C:\\Users\\zcapozzi002\\Documents\\GitHub\\Cleaning_Data_Course_Project")
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="project_data.zip")
#unzip("project_data.zip")

# 0. Loading data
features <- read.delim("UCI HAR Dataset\\features.txt", sep="\n", header=FALSE)
features_info <- read.delim("UCI HAR Dataset\\features_info.txt", sep="\n", header = TRUE, skip = 2)
activity_labels <- read.delim("UCI HAR Dataset\\activity_labels.txt", sep="\n", header = FALSE)


x_train <- read.table("UCI HAR Dataset\\train\\X_train.txt") # actual data
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt") # person studied
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt") # the activity they were doing


x_test <- read.table("UCI HAR Dataset\\test\\X_test.txt") # actual data
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt") # person studied
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt") # the activity they were doing



# 1. Merges the training and the test sets to create one data set.

x_test_and_train <- rbind(x_test, x_train)
y_test_and_train <- rbind(y_test, y_train)
subject_test_and_train <- rbind(subject_test, subject_train)

x_test_and_train_w_sub_act = cbind(x_test_and_train, subject_test_and_train)
x_test_and_train_w_sub_act = cbind(x_test_and_train_w_sub_act, y_test_and_train)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features$mean_or_std = grepl("mean()|std()", features[,])
features$ID = c(1:nrow(features))
key_features = subset(features, features$mean_or_std == TRUE, select=c('ID'))
head(key_features)
key_list = as.vector(key_features$ID)
just_means_and_stds_x <- subset(x_test_and_train, select=key_list)

# 3. Uses descriptive activity names to name the activities in the data set

activities = as.data.frame(c(1:6))
names(activities) = c("ID")
activities$activity_name = ""
activities[1, 'activity_name'] = "WALKING"
activities[2, 'activity_name'] = "WALKING_UPSTAIRS"
activities[3, 'activity_name'] = "WALKING_DOWNSTAIRS"
activities[4, 'activity_name'] = "SITTING"
activities[5, 'activity_name'] = "STANDING"
activities[6, 'activity_name'] = "LAYING"

y_test_and_train_w_activities = merge(y_test_and_train, activities, by.x='V1', by.y='ID')

# 4. Appropriately labels the data set with descriptive variable names.

var_names = as.vector(features$V1)
names(x_test_and_train_w_sub_act) = c(var_names, 'Subject_ID', 'Activity_ID')

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

agg <- aggregate(x_test_and_train_w_sub_act, by=list(x_test_and_train_w_sub_act$Subject_ID, x_test_and_train_w_sub_act$Activity_ID), FUN=mean)
names(agg)[1] = "Grouped_Subject"
names(agg)[2] = "Grouped_Activity_ID"

merged <- merge(activities, agg, by.x='ID', by.y='Grouped_Activity_ID')
cols = c(2:564)
final = subset(merged, select=cols)

write.table(final, "final.txt", row.names=FALSE)