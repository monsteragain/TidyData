library(dplyr)

rawDataFolderName <- "UCI HAR Dataset"
columnSelections <- NULL

# This function, run, implements top level cordination for the solution. A single call to this 
# function gives the requisite results. The followng are the steps: 
#
#   1 - Check if the raw data is on the local disk, if not down load it. 
#   2 - Initialize the selected columns by calling initColumnSelections().
#   3 - Read in the activity label data. e.g. SLEEPING, WALKING, etc. 
#   4 - call loadData() to build the train data. 
#   5 - Call loadData() to build the test data. 
#   6 - Merge train and test data sets.
#   7 - Create average, mean, of each variable for each activity and each subject. 
#       (Order by activity then subject.)
#   8 - Write results to file "summary.txt"
#

run <- function() {

  # Step 1
  if (!file.exists(rawDataFolderName)) {
    zipFileName <- "datasets.zip"
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url,destfile = zipFileName, mode="wb")
    unzip(zipFileName)
  }
  
  # Step 2
  columnSelections <<-initColumnSelections()
  
  # Step 3
  activityLabels <- read.table(paste(rawDataFolderName,"//","activity_labels.txt", sep=""))   
  
  # Step 4
  dataSet <- loadData(activityLabels,"train")
  
  # Step 5 & Step 6 
  dataSet <- rbind(dataSet,loadData(activityLabels,"test")) 
  
  # Step 7 
  dst <- tbl_df(dataSet)
  byActivitySubject <- group_by(dst,activity,subject)
  summaryData <- summarise_each_(byActivitySubject, funs(mean),names(byActivitySubject)[1:86])
  
  # Step 8  
  write.table(summaryData, "summary.txt", row.names = F, quote = F)
  
  summaryData
}

#
# This function, loadData is a reuseable function to load the data for both train and test data 
# sets. The following are the steps taken: 
#
#   1 - create the filePath
#   2 - Load the feature vector data. 
#   3 - Perform a project, Codd parlance, operation to select the required fields from the featurs vector.
#   4 - Apply the standardizedVariableName to the new projected data frame from the previous step.
#   5 - Append subject column
#   6 - Append activity column - this represented as numeric data but we convery to factors based on the activity
#       labels.
#
loadData <- function(activityLabels,category) {
  
    if(!(category %in% c("train","test"))){
      stop("invalid category")
    }
  
    # Step 1  
    featuresFilePath <- buildPath(category,"X")
    
    # Step 2    
    rawFeatureVector <- read.table(featuresFilePath,
                                   sep="",
                                   colClasses="numeric",
                                   header=F)
   
    # Step 3
    projectFeatureVector <- rawFeatureVector[,(columnSelections[,1])]
    
    # Step 4 
    names(projectFeatureVector) <- columnSelections[,2]
        
    # Step 5
    subjectFilePath <-buildPath(category,"subject")
    subjects <- read.table(subjectFilePath)
    projectFeatureVector$subject<-subjects[,1]
    
    # Step 6 
    activitiesFilePath <-buildPath(category,"y")
    activites <- read.table(activitiesFilePath)
    tmp <- sapply(activites,FUN = function(a) {activityLabels[a,2]})
    projectFeatureVector$activity <- as.factor(tmp) ;rm(tmp)
    projectFeatureVector
        
}

buildPath <- function(category, fileType) {
  p <- paste(rawDataFolderName,"\\", category,"\\", fileType,"_",category,".txt", sep="")
  if (file.exists(p)) {
    msg <- paste("File: ", p , " exists.\n", sep="")
    cat(msg)    
  }
  p
}

initColumnSelections <- function() {
  originalCol <- c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,215,227,228,240,241,253,254,266,267,268,269,270,271,294,295,296,345,346,347,348,349,350,373,374,375,424,425,426,427,428,429,452,453,454,503,504,513,516,517,526,529,530,539,542,543,552,555,556,557,558,559,560,561)
  varName <- c("tBodyAccMeanX","tBodyAccMeanY","tBodyAccMeanZ","tBodyAccStdX","tbodyAccStdY","tBodyAccStdZ","tGravityAccMeanX","tGravityAccMeanY","tGravityAccMeanZ","tGravityAccStdX","tGravityAccStdY","tGravityAccStdZ","tBodyAccJerkMeanX","tBodyAccJerkMeanY","tBodyAccJerkMeanZ","tBodyAccJerkStdX","tBodyAccJerkStdY","tBodyAccJerkStdZ","tBodyGyroMeanX","tBodyGyroMeanY","tBodyGyroMeanZ","tBodyGyroStdX","tBodyGyroStdY","tBodyGyroStdZ","tBodyGyroJerkMeanX","tBodyGyroJerkMeanY","tBodyGyroJerkMeanZ","tBodyGyroJerkStdX","tBodyGyroJerkStdY","tBodyGyroJerkStdZ","tBodyAccMagMean","tBodyAccMagStd","tGravityAccMagMean","tGravityAccMagStd","tBodyAccJerkMagMean","tBodyAccJerkMagStd","tBodyGyroMagMean","tBodyGyroMagStd","tBodyGyroJerkMagMean","tBodyGyroJerkMagStd","fBodyAccMeanX","fBodyAccMeanY","fBodyAccMeanZ","fBodyAccStdX","fBodyAccStdY","fBodyAccStdZ","fBodyAccMeanFreqX","fBodyAccMeanFreqY","fBodyAccMeanFreqZ","fBodyAccJerkMeanX","fBodyAccJerkMeanY","fBodyAccJerkMeanZ","fBodyAccJerkStdX","fBodyAccJerkStdY","fBodyAccJerkStdZ","fBodyAccJerkMeanFreqX","fBodyAccJerkMeanFreqY","fBodyAccJerkMeanFreqZ","fBodyGyroMeanX","fBodyGyroMeanY","fBodyGyroMeanZ","fBodyGyroStdX","fBodyGyroStdY","fBodyGyroStdZ","fBodyGyroMeanFreqX","fBodyGyroMeanFreqY","fBodyGyroMeanFreqZ","fBodyAccMagMean","fBodyAccMagStd","fBodyAccMagMeanFreq","fBodyBodyAccJerkMagMean","fBodyBodyAccJerkMagStd","fBodyBodyAccJerkMagMeanFreq","fBodyBodyGyroMagMean","fBodyBodyGyroMagStd","fBodyBodyGyroMagMeanFreq","fBodyBodyGyroJerkMagMean","fBodyBodyGyroJerkMagStd","fBodyBodyGyroJerkMagMeanFreq","angletBodyAccMeanGravity","angletBodyAccJerkMeanGravityMean","angletBodyGyroMeanGravityMean","angletBodyGyroJerkMeanGravityMean","angleXgravityMean","angleYgravityMean","angleZgravityMean")  
  d <-data.frame(originalCol,varName)
}
