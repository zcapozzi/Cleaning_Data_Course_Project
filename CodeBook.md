
The sections include:

# 0. Loading data

Because the data was already aggregated in the x_test data frame, I ignored the low-level acceleration data.  Otherwise, I used read.table to pull in the space-separated source data.

# 1. Merges the training and the test sets to create one data set.

This step was very simple, as I used cbind and rbind to connect the data sets together.  Rbind combines rows (for test/train).  Cbind combines columns, for including the subject and activity data.

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

To extract only the mean/std measurements, my first step was to figure out which features correspond to those metrics.  To do this, I used grepl (regex) to create a yes/no variable describing whether the feature name included mean or std.
Once I had this variable, I selected a subset of features corresponding to those values where the boolean was true.  I then converted this list of IDs to a list and used that in a second subset to select only those columns from my original data set that corresponded to the means or Std Devs.
The result of this transformation was stored in a data frame called just_means_and_stds_x.

# 3. Uses descriptive activity names to name the activities in the data set

This step involved creating an extra data frame, called activities, which contained the ID number used to identify activities, and the description provided in the documentation.  I also merged this activities table with the y_test_and_train data frame so that the original data frame would include activity description.

# 4. Appropriately labels the data set with descriptive variable names.

Similar to step 1, I created a list from the features data frame.  I then set the names attribute of my x_test_and_train_w_sub_act data frame to be equal to this list.  Very simple.

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

I used aggregate to get a list of 180 elements, 6 activities times 30 participants.  Aggregate allows me to calculate a single metric (in this case, average) according to whichever grouping variables I want.
To finish this step, I also modified the variable names and selected only the columns that I needed.  This produced the "final" data frame.