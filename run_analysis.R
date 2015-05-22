# Please refer to the codebook for detailed instructions and steps you need to complete before 
# runnig the code.
# read the test files
a <- read.csv("~/Desktop/RWD/UCIHARDataset/test/subject_test.txt", sep="", header = FALSE)
b <- read.csv("~/Desktop/RWD/UCIHARDataset/test/y_test.txt", sep="", header = FALSE)
c <- read.csv("~/Desktop/RWD/UCIHARDataset/test/X_test.txt", sep="", header = FALSE)

# read the train files
d <- read.csv("~/Desktop/RWD/UCIHARDataset/train/subject_train.txt", sep="", header = FALSE)
e <- read.csv("~/Desktop/RWD/UCIHARDataset/train/y_train.txt", sep="", header = FALSE)
f <- read.csv("~/Desktop/RWD/UCIHARDataset/train/X_train.txt", sep="", header = FALSE)

#read the features file, extract the second column that includes the features and save it into 
# a factor called colnames.  Will use this factor as variable names for 561 variables in 
#X_test and X_train

features <- read.csv("~/Desktop/RWD/UCIHARDataset/features.txt", sep="", header = FALSE)
colnames <- features$V2
newcoln <- make.names(colnames, unique = TRUE, allow_ = TRUE) 
colnames <- as.factor(newcoln)

#assign column names to the single column data frames (subjects and activities in both test and train)
colnames(a) <- "subject"
colnames(b) <- "activity"
colnames(d) <- "subject"
colnames(e) <- "activity"

# assign the features in "colnames" vector as column names for X_test and X_train

colnames(c) <- colnames
colnames(f) <- colnames

# bind (columns) subject, activity and X data frames to get data with 563 columns, for both test and train
test <- cbind(a, b, c)
train <- cbind(d, e, f)

# bind (rows) test and train data to get a data frame with 10299 rows. 
# Note that this data frame already has assigned column names
# use dplayr to order data according to subject and activity type.
# Note that activity is coded in numbers (1, 2, 3..) at this point
ttall <- rbind(test, train)
library(dplyr)
# sort data by subject and then activity
ttall <- arrange(ttall, subject, activity)

# rename activity coding so users can see activity names (Walking, WalkUp,..) 
#instead of numbers (1, 2,..)
library(plyr)
ttall$activity <- as.factor(revalue(as.character(ttall$activity), c("1"="Walking", "2"="WalkUp", "3"="WalkDwn", "4"="Sitting", "5"="Standing", "6"="Laying")))

detach(package:plyr)

# selecting mean and std of measurements among the 561 measurement columns. Then, combining them 
# into a reduced data file.

ttallm <- select(ttall, contains("mean"))
ttalls <- select(ttall, contains("std"))
ttallas <- select(ttall, 1:2)
ttallag <- cbind(ttallas, ttallm, ttalls)

# From the reduced data file above, create a second,independent tidy dataset 
# with the average of each variable for each activity and each subject.

#produce a 180x88 file including column names, sorted by subject and activity(alphabetically). 
#then write this data frame into a csv file
newsumdata <- ttallag %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(newsumdata, file="tidydata.txt", row.names = FALSE)



