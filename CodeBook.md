CodeBook.md
========================================================

###Data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

####For each record it is provided:
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

####The dataset includes the following files:
* 'README.txt'
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.

####The following files are available for the train and test data. Their descriptions are equivalent. 
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

###Variables
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

###Transformations

####Data sets preparations
The data set has been stored in the `UCI HAR Dataset/` directory.
`read.table` is used to load the data to R environment for the data, the activities and the subject of both test and training datasets.
```
t_data <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
t_data_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
t_data_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
```
and
```
tr_data <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
tr_data_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
tr_data_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
```

#### Merge test and training sets into one data set, including the activities

The `Activity` and `Subject` columns are appended to the test and train data frames, and then are both merged in the `merge` data frame.

```
test_labels <- cbind(t_data, t_data_labels)
test_final <- cbind(test_labels, t_data_subject)
train_labels <- cbind(tr_data, tr_data_labels)
train_final <- cbind(train_labels, tr_data_subject)
merge <- rbind(test_final, train_final)
```

#### Extract only the measurements on the mean and standard deviation for each measurement

`mean()` and `sd()` are used against `merge` via `sapply()` to extract the requested measurements.

```
mean <- sapply(merge, mean, na.rm = TRUE)
standart_dev <- sapply(merge, sd, na.rm = TRUE)
```

#### Descriptive activity names to name the activities in the data set

The class labels linked with their activity names are loaded from the `activity_labels.txt` file. The numbers of the `t_data_labels` and `tr_data_labels` data frames are replaced by those names:

```
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, colClasses = "character")
t_data_labels$V1 <- factor(t_data_labels$V1, levels=activity$V1, labels=activity$V2)
tr_data_labels$V1 <- factor(tr_data_labels$V1, levels=activity$V1, labels=activity$V2)
```

#### Appropriately labels the data set with descriptive activity names

Each data frame of the data set is labeled - using the `features.txt` - with the information about the variables used on the feature vector. The `Activity` and `Subject` columns are also named properly before merging them to the test and train dataset.

```
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, colClasses = "character")
colnames(t_data) <- features$V2
colnames(tr_data) <- features$V2
colnames(t_data_labels) <- c("Activity")
colnames(tr_data_labels) <- c("Activity")
colnames(t_data_subject) <- c("Subject")
colnames(tr_data_subject) <- c("Subject")
```

#### Creates a tidy data set with the average of each variable for each activity and each subject.

Finaly the result, a `table_m` data table is created with the average of each measurement per activity/subject combination. The new dataset is saved in `tidy.csv` file.

```
table_m <- data.table(merge)
tidy_data <- table_m[,lapply(.SD,mean), by="Activity,Subject"]
write.table(tidy_data, file = "tidy.csv", sep = ",", row.names = FALSE)
```