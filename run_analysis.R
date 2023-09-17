library(dplyr)

# reading in the subject and activity data files
subtrain <- read.table("train/subject_train.txt",header = FALSE, sep = "\n" )
ytrain <- read.table("train/y_train.txt", header = FALSE, sep = "\n")

# Each feature vector is a row on the text file X_train.txt
xtrain = readLines("train/X_train.txt", encoding="utf-8", skipNul = TRUE)

# getting rid of the extra empty spaces
xtrain <- gsub("  ", " ", xtrain)
xtrain <- sub(" ", "", xtrain)

# splitting the measurements by " " and transpose + convert to data frame
xtrainsp = strsplit(xtrain, " ")
xtrainspdf = as.data.frame(t(as.data.frame(xtrainsp)))
rownames(xtrainspdf) <- NULL

#reading in the test data files
subtest <- read.table("test/subject_test.txt",header = FALSE, sep = "\n")
ytest <- read.table("test/y_test.txt", header = FALSE, sep = "\n")
xtest = readLines("test/X_test.txt", encoding="utf-8", skipNul = TRUE)

xtest <- gsub("  ", " ", xtest)
xtest <- sub(" ", "", xtest)

xtestsp = strsplit(xtest, " ")
xtestspdf = as.data.frame(t(as.data.frame(xtestsp)))
rownames(xtestspdf) <- NULL

# read in features.txt for labels
features <- read.table("features.txt", header = FALSE)

# set up column names
colnames(xtrainspdf) <- features$V2
colnames(xtestspdf) <- features$V2
colnames(subtrain) <- "subject"
colnames(subtest) <- "subject"
colnames(ytrain) <- "activity"
colnames(ytest) <- "activity"

# merge all data
mergedtrain <- cbind(subtrain, ytrain, xtrainspdf)
mergedtest <- cbind(subtest, ytest, xtestspdf)

merged <- rbind(mergedtrain, mergedtest)

meanorstd <- select(merged, c(subject, activity, contains(c("mean", "std"))))

activities <- read.table("activity_labels.txt", header = FALSE)

meanorstd <- mutate(meanorstd, activity = activities[[2]][activity])
meanorstd <- mutate(meanorstd, across(3:88, as.numeric))

# creating a second data set with averages of each variable by subject and activity
averages <- group_by(meanorstd, subject, activity)
averages <- summarize(averages, across(1:86, mean))

write.table(averages, file = "averages.txt")
