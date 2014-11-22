Getting And Cleaning Data
=========================

Herein is a demonstration of how R scripting can be used to prepare raw data for analysis. Put another way, the raw data is processed into tidy data. This demonstration uses raw data collected from smart phone devices worn by 30 volunteers in a research experiment. For more details on the raw data and the generated tidy data set see the [Codebook.md](/Codebook.md) file contained in this repository.

# Data Set Files

Before explaining the logic the structure of how the raw data files are presented must be understood. The experiment was run in two steps, *train* and *test* where separate subsets of data where created for each step.

```
UCIHAR Dataset/
  activity_labels.txt  # Provides the labels for the activities.  
  feautures.txt        # List, in order, all the columns presented in the subject text file.     
  test/
    y_test.txt         # list the activity code for each row in x_test.txt   
    subject_test.txt   # list the subject id for each row in x_text.txt    
    X_test.txt         # sensor data aligning with columns in features.txt
  train/
    y_train.txt        # list the activity code for each row in x_train.txt   
    subject_train.txt  # list the subject id for each row in x_train.txt   
    X_train.txt        # sensor data
  
```

# Script

The [run_analysis.R](run_analysis.R) contains the R code for this demonstration. The following outlines the operation of the script.

  1. Check if the raw data is on the local disk, if not down load it. 
  2. Initialize the selected columns by calling initColumnSelections(). This function statically defines the requisite columns for mean and standard deviation. 
  3. Read in the activity label data. e.g. SLEEPING, WALKING, etc.
  4. Call loadData() to load the train data. 
  5. Call loadData() to build the test data. 
  6. Merge train and test data sets.
  7. Create average, mean, of each variable for each activity and each subject. (Order by activity then by subject.)
  8. Write results to file *summary.txt*

Because the sub folder/directory for *test* and *train* have the same structure the *loadData()* function is codes the common functionality and is the called twice. The following are the steps taken by *loadData()*: 

1. Create the filePath
2. Load the feature vector data. 
3. Perform a projection, Codd parlance, operation to select the required fields from the featurs vector.
4. Apply the standardizedVariableName to the new projected data frame from the previous step.
5. Append subject column
6. Append activity column - this is represented as numeric data but we convert to factors based on the activity labels.

The majority of the script is coded using the base R libraries. The plyr library is used in step 7 and does a lot of the heavy lifting with great ease.

# Environment 

The following are the environment details for the project:

* R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet", platform: x86_64-w64-mingw32.
* Plyr Library Version - 1.8.1
* R Studio Version 0.98.1049 – © 2009-2013 RStudio, Inc.
* Microsoft Windows 8.1
