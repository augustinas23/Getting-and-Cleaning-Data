
y_train <- read.table("y_train.txt")
x_train <- read.table("X_train.txt")
subject_train <- read.table("subject_train.txt")
y_test <- read.table("y_test.txt")
x_test <- read.table("X_test.txt")
subject_test <- read.table("subject_test.txt")


dim(y_train)
dim(x_train)
dim(subject_train)


dim(x_test)
dim(y_test)
dim(subject_test)


full_train <- cbind(subject_train, y_train, x_train)
full_test <- cbind(subject_test, y_test, x_test)


data <- rbind(full_test, full_train)


col_names <- read.table("features.txt")


col_mean_std <- grep("mean\\(|std\\(", col_names$V2)


col_mean_std <- col_mean_std + 2
first_rows<- 1:2
nes_col<- c(first_rows,col_mean_std)


final_data <- data[,as.vector(nes_col)]


activity <- read.table("activity_labels.txt")


get_activity_name <- activity$V2
names(get_activity_name) <- activity$V1


data_activity <- as.character(unname(get_activity_name[data[,2]]))

 
final_data <- final_data [,-c(2)]
  
library(tibble)


final_data <- add_column(final_data, data_activity, .after=1)


col_mean_std <- grep("mean\\(|std\\(", col_names$V2, value=TRUE)


full_col_names <- c(c("subject", "activity"), col_mean_std)


names(final_data) <- full_col_names


tidy_data<- final_data %>% group_by (subject, activity) %>% summarize_all(mean)


write.table(tidy_data, file="tidy_data.txt", sep="\t", row.names=FALSE, col.names=TRUE)
