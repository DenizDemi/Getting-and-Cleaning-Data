# Getting-and-Cleaning-Data

This is the README file for the Getting and Cleaning Data Course assignment. Submitted files for this assignment are:

* run_analysis.R, which is the R script that reads in the raw data and generates tidy data set with the averages

* averages.txt, which is the file generated from run_analysis.R

* CodeBook.md, which contains the description of the variables

* this README file

Following is a description of the script "run_analysis.R":

0. reads in subject_train.txt, y_train.txt X_train.txt and subject_test.txt, y_test.txt, X_test.txt files

            subtrain <- read.table("train/subject_train.txt",header = FALSE, sep = "\n" )
            ytrain <- read.table("train/y_train.txt", header = FALSE, sep = "\n")
            # Each feature vector is a row on the text file.
            xtrain = readLines("train/X_train.txt", encoding="utf-8", skipNul = TRUE)
            # similar steps for the test data files

1. matches the subjects, activities and measurements and combines train and test data to create a wide form tidy data set (each variable is in one column, each observation is in a different row)

            mergedtrain <- cbind(subtrain, ytrain, xtrainspdf)
            mergedtest <- cbind(subtest, ytest, xtestspdf)
            merged <- rbind(mergedtrain, mergedtest)

2. extracts measurements on mean and standart deviation by selecting columns that contain "mean" and "std" in their names

            meanorstd <- select(merged, c(subject, activity, contains(c("mean", "std"))))

3. replaces activity labels with descriptive names which are found in activity_labels.txt

            activities <- read.table("activity_labels.txt", header = FALSE)
            meanorstd <- mutate(meanorstd, activity = activities[[2]][activity])

4. labels the measurements with the descriptive labels found in features.txt, in addition first column is labeled "subject", second "activity"

            # read in features.txt for labels
            features <- read.table("features.txt", header = FALSE)
            # set up column names
            colnames(xtrainspdf) <- features$V2
            colnames(xtestspdf) <- features$V2
            colnames(subtrain) <- "subject"
            colnames(ytrain) <- "activity"


5. resulting data frame is grouped by subject and activity and the average for each variable for each subject and activity is generated. The data is again in wide format, as per tidy data principle each variable is averaged in its own column, each subject - activity - measurement means is in a separete row. 

            averages <- group_by(meanorstd, subject, activity)
            averages <- summarize(averages, across(1:86, mean))


Please refer to the file run_analysis.R for further details on the source code. 

To read in the data frame from averages.txt you may use the following code:

            averages <-read.table("averages.txt", header = TRUE)
