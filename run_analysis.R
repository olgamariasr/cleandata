##run_analysis.R
##setwd('C:\\Users\\compaq\\Desktop\\dc\\UCI HAR Dataset')
install.packages("reshape")
install.packages("plyr")
library(reshape)
library(plyr)


## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
# convert variable names to lowercase

## X headings
headings=read.table("./features.txt")$V2
X_train = read.table("./train/X_train.txt")
X_test = read.table("./test/X_test.txt")
colnames(X_train) = headings
colnames(X_test) = headings

## Y names
activity_names = tolower(levels(read.table("./activity_labels.txt")$V2))
y_train = read.table("./train/y_train.txt")
y_train <- rename(y_train, c(V1="activity"))
y_test  = read.table("./test/y_test.txt")
y_test <- rename(y_test, c(V1="activity"))
y_train$activity = factor(  y_train$activity,   labels = activity_names)
y_test$activity = factor(  y_test$activity,   labels = activity_names)

## subject heading
subject_train = read.table("./train/subject_train.txt")
subject_test = read.table("./test/subject_test.txt")

subject_train <- rename(subject_train, c(V1="subject_Id"))
subject_test <- rename(subject_test, c(V1="subject_Id"))

## Merges the training and the test sets to create one data set.
train_data = cbind(X_train, subject_train, y_train)
test_data = cbind(X_test, subject_test, y_test)
combined_data = rbind(train_data, test_data)


## Extracts only the measurements on the mean and standard deviation for each measurement. 
namesSelected <- function(origNames, pattern ){
  return (grep(pattern, origNames, value=TRUE))
}
namesS= namesSelected(names(combined_data),"mean|std|subject_Id|activity")
tidyData = combined_data[,namesS]

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
data_set = ddply(tidyData, .(activity, subject_Id), numcolwise(mean))
# upload your data set as a txt file created with write.table() using row.name=FALSE 
write.table(data_set, file="data_set.txt", append=F,row.name=FALSE)


