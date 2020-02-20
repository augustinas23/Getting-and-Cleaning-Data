# Getting-and-Cleaning-Data
Getting and Cleaning Data

# upload data into R
y_train <- read.table("y_train.txt")
x_train <- read.table("X_train.txt")
subject_train <- read.table("subject_train.txt")
y_test <- read.table("y_test.txt")
x_test <- read.table("X_test.txt")
subject_test <- read.table("subject_test.txt")

# explore data to know what to merge
dim(y_train)
dim(x_train)
dim(subject_train)

# explore data to know what to merge
dim(x_test)
dim(y_test)
dim(subject_test)

# merge data sets for full test and train categories
full_train <- cbind(subject_train, y_train, x_train)
full_test <- cbind(subject_test, y_test, x_test)

# merge test and train data sets
data <- rbind(full_test, full_train)

# upload variable names
col_names <- read.table("features.txt")

# extract only mean() and std() variables
col_mean_std <- grep("mean\\(|std\\(", col_names$V2)

# fit data to "data"
col_mean_std <- col_mean_std + 2
first_rows<- 1:2
nes_col<- c(first_rows,col_mean_std)

# extract only mean() and std() observations
final_data <- data[,as.vector(nes_col)]

# upload activity names data
activity <- read.table("activity_labels.txt")

# create look up table for activity name
get_activity_name <- activity$V2
names(get_activity_name) <- activity$V1

# extract activity columns from data set with activity name
data_activity <- as.character(unname(get_activity_name[data[,2]]))

# remove old activity column  
final_data <- final_data [,-c(2)]

library(tibble)

# add new activity columns to data
final_data <- add_column(final_data, data_activity, .after=1)

# extract variables names for "final data"
col_mean_std <- grep("mean\\(|std\\(", col_names$V2, value=TRUE)

# add column names for the first two columns
full_col_names <- c(c("subject", "activity"), col_mean_std)

# named final data
names(final_data) <- full_col_names

# make tidy data
tidy_data<- final_data %>% group_by (subject, activity) %>% summarize_all(mean)

# create tidy data txt file
write.table(tidy_data, file="tidy_data.txt", sep="\t", row.names=FALSE, col.names=TRUE)
