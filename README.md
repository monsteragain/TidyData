Getting And Cleanng Data
========================

Herein is a demonstration of how R scripting can be used to prepare raw data for analysis. Put another way, the raw data is processed into tidy data. This demonstartion uses raw data collected from smart phone devices worn by 30 volunteers in a research experiment. More details on the raw data and the generated tidy data set see the [Codebook.md](/CodeBook.md) file contained in this repository.

# Data Set Files

Before explaining the logic the structure of how the files are presented must be understood. The experiment was run in two steps, *train* and *test* where separate subsets of data where created for each step.

```
UCIHAR Dataset/
  activity_labels.txt  // Provides the labels for the activities.  
  feautures.txt        // List, in order, all the columns presented in the subject text file.     
  test/
    y_test.txt // list the activity code for each row in x_test.txt   
    subject_test.txt // list the subject id for each row in x_text.txt    
    X_test.txt  // sensor data aligning with columns in features.txt
  train/
    y_train.txt // list the activity code for each row in x_train.txt   
    subject_train.txt // list the subject id for each row in x_train.txt   
    X_train.txt // sensor data
  
```

# Script

The run_analysis.R contains R code for this demonstration. The following outlines the operation of the script.

  1. Check if the raw data is on the local disk, if not down load it. 
  2. Initialize the selected columns by calling initColumnSelections(). This function statically defines the requesite columns for mean and standard deviation. 
  3. Read in the activity label data. e.g. SLEEPING, WALKING, etc.
  4. Call loadData() to load the train data. 
  5. Call loadData() to build the test data. 
  6. Merge train and test data sets.
  7. Create average, mean, of each variable for each activity and each subject. (Order by activity then subject.)
  8. Write results to file *summary.txt*

Because the sub structure for *test* and *train* have the same structure the *loadData()* function is coded and called twice. The following are the steps taken by *loadData()*: 

1. Create the filePath
2. Load the feature vector data. 
3. Perform a project, Codd parlance, operation to select the required fields from the featurs vector.
4. Apply the standardizedVariableName to the new projected data frame from the previous step.
5. Append subject column
6. Append activity column - this represented as numeric data but we convery to factors based on the activity labels.

The majority of the script is coded using the base R libraries. The plyr library is used to in 7 and and does a lot of the heavy lift with great ease.







