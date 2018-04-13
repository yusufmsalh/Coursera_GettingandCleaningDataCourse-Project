library(plyr)
myws <-"Yusuf M.Salh/Desktop/WS/UCI HAR Dataset"
setwd(myws)
# Step 1
# Merging  training and testing data sets to create a single data set
#--------------------------------------------------------------------

x_training <- read.table("train/X_train.txt")
y_training <- read.table("train/y_train.txt")
subject_training <- read.table("train/subject_train.txt")

x_testing <- read.table("test/X_test.txt")
y_testing <- read.table("test/y_test.txt")
subject_testing <- read.table("test/subject_test.txt")

# create 'x' data set
xdata <- rbind(x_training, x_testing)

# create 'y' data set
ydata <- rbind(y_training, y_testing)

# create 'subject' data set
subject_data <- rbind(subject_training, subject_testing)

# Step 2
# Extract only the measurements on  mean and standard deviation for each measurement :
#----------------------------------------------------------------------------

features <- read.table("features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
xdata <- xdata[, mean_and_std_features]

# correct the column names
names(xdata) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
#-----------------------------------------------------------------------

activities <- read.table("activity_labels.txt")

# update values with correct activity names
ydata[, 1] <- activities[ydata[, 1], 2]

# correct column name
names(ydata) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
#---------------------------------------------------------------

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(xdata, ydata, subject_data)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
#--------------------------------------------------------------

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
getwd()
