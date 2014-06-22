#set working directory
setwd("~/Documents/getdatacoursera/")

#check if working directory is set correctly
getwd()
list.files()

#data.table package is needed
library(data.table)

#1. Merges the training and the test sets to create one data set.
#A "test"
#creating variables for 'test' dir (testset data)
t_data <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
t_data_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
t_data_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
#merging "test"
test_labels <- cbind(t_data, t_data_labels)
test_final <- cbind(test_labels, t_data_subject)
#B "train"
#creating variables for 'train' dir (training data)
tr_data <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
tr_data_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
tr_data_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
#merging "train"
train_labels <- cbind(tr_data, tr_data_labels)
train_final <- cbind(train_labels, tr_data_subject)
#merge A & B
merge <- rbind(test_final, train_final)

#2. Extracts only the measurements on the mean and standard deviation
#   for each measurement.
mean <- sapply(merge, mean, na.rm = TRUE)
standart_dev <- sapply(merge, sd, na.rm = TRUE)

#3. Uses descriptive activity names to name the activities in the data set
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, colClasses = "character")
t_data_labels$V1 <- factor(t_data_labels$V1, levels=activity$V1, labels=activity$V2)
tr_data_labels$V1 <- factor(tr_data_labels$V1, levels=activity$V1, labels=activity$V2)

#4. Appropriately labels the data set with descriptive variable names.
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, colClasses = "character")
colnames(t_data) <- features$V2
colnames(tr_data) <- features$V2
colnames(t_data_labels) <- c("Activity")
colnames(tr_data_labels) <- c("Activity")
colnames(t_data_subject) <- c("Subject")
colnames(tr_data_subject) <- c("Subject")

#after labeling we need to repeat merge from step 1.
test_labels <- cbind(t_data, t_data_labels)
test_final <- cbind(test_labels, t_data_subject)
train_labels <- cbind(tr_data, tr_data_labels)
train_final <- cbind(train_labels, tr_data_subject)
merge <- rbind(test_final, train_final)

#5 Creates a second, independent tidy data set with the average of each variable for
#  each activity and each subject.
table_m <- data.table(merge)
tidy_data <- table_m[,lapply(.SD,mean), by="Activity,Subject"]
write.table(tidy_data, file = "tidy.csv", sep = ",", row.names = FALSE)
