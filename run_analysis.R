run_analysis <- function () {
  # Merges the training and the test sets to create one data set.
  # Extracts only the measurements on the mean and standard deviation for each measurement. 
  # Uses descriptive activity names to name the activities in the data set
  # Appropriately labels the data set with descriptive variable names. 
  # From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  # github respository of 1) code, 2) codebook CodeBook.md, 3) readme.md file 4) tidy data set (output of run_analysis.R)
  
  # install.packages("data.table") 
  # require("data.table")

  activityLabels <- read.table("./activity_labels.txt",header=F) # 1-6
  featureLabels <- read.table("./features.txt", header=F, colClasses = NA, stringsAsFactors=!default.stringsAsFactors()) # 1-561
  subjectTestFile <- "./test/subject_test.txt"
  subjectTrainFile <- "./train/subject_train.txt"
  activityTestFile <- "./test/y_test.txt"
  activityTrainFile <- "./train/y_train.txt"
  testFiles <- c("./test/X_test.txt", "./test/Inertial Signals/body_acc_x_test.txt", "./test/Inertial Signals/body_acc_y_test.txt", "./test/Inertial Signals/body_acc_z_test.txt", "./test/Inertial Signals/body_gyro_x_test.txt", "./test/Inertial Signals/body_gyro_y_test.txt", "./test/Inertial Signals/body_gyro_z_test.txt", "./test/Inertial Signals/total_acc_x_test.txt", "./test/Inertial Signals/total_acc_y_test.txt", "./test/Inertial Signals/total_acc_z_test.txt")
  trainFiles <- c("./train/X_train.txt", "./train/Inertial Signals/body_acc_x_train.txt", "./train/Inertial Signals/body_acc_y_train.txt", "./train/Inertial Signals/body_acc_z_train.txt", "./train/Inertial Signals/body_gyro_x_train.txt", "./train/Inertial Signals/body_gyro_y_train.txt", "./train/Inertial Signals/body_gyro_z_train.txt", "./train/Inertial Signals/total_acc_x_train.txt", "./train/Inertial Signals/total_acc_y_train.txt", "./train/Inertial Signals/total_acc_z_train.txt")

  fullLabels <- c("subject","activity",featureLabels[,2],1:128) ## missing the 128 column names from files in InertialSignals
  #print(fullLabels)
  #print(class(featureLabels[,2]))
  
  # read in test/train data and merge
  subjectTest <- read.csv(subjectTestFile, header=F)
  subjectTrain <- read.csv(subjectTrainFile, header=F)
  activityTest <- read.csv(activityTestFile, header=F)
  activityTrain <- read.csv(activityTrainFile, header=F)
  
  # directory for merged files
  if (!file.exists("./merged")) {dir.create("./merged")}
  
  # merged subject/activities file rows, then bind columsn to finalDataSet
  subjects <- rbind(subjectTest, subjectTrain)
  activities <- rbind(activityTest, activityTrain)
  finalDataSet <- cbind(subjects,activities)
  
 
  # read data and merge to files
  i=1
  for (each in testFiles) { 
    print(paste("dataset ", i))
    data <- rbind(read.table(testFiles[i], header=FALSE), read.table(trainFiles[i], header=FALSE))
    finalDataSet <- cbind(finalDataSet,data)
    i=i+1
  }
  # write full data set with labels
  write.table(finalDataSet,"./tidy-merged.txt", quote=FALSE, col.names=fullLabels)
   
  # create dataset for mean from merged data
  avgDataSet <- cbind(paste(finalDataSet[,1],"-",finalDataSet[,2]),finalDataSet[,3:1715])
  print (paste("ncol avgDataSet ", ncol(avgDataSet))) #1714
  
  # calculate avg of each activity/subject combination
  tidyDataSet <- sapply(avgDataSet[,2:1714], mean)
  print(tidyDataSet[1:20,])
  
  # write metrics tidy dataset
  write.table(tidyDataSet,"./tidy-avg.txt", quote=FALSE) #col.names=fullLabels
}

# The goal is to prepare tidy data that can be used for later analysis. 
# You will be required to submit: 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing 
# the analysis, and 3) a code book called CodeBook.md, that describes the variables, the data, and any transformations or work that you 
# performed to clean up the data. You should also 4) include a README.md in the repo with your scripts. 
# This README.md explains how all of the scripts work and how they are connected.  

