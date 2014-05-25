==================================================================
##Producing a tidy data file from Smartphones Dataset

==================================================================
Author: Pratiba Behara

###Data
==================================================================
The dataset is downloaded to the 'R' working directory from the following link
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Project goals
======================================
Goal of the project is to achieve a tidy data set from the above data according to the steps given below.

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

### Final Data set description
=========================================
The final tidy data has the following features. 

*subject:  Contains the participant of the experiment
*activity: Contains the activity of the participant
*variable: Contains the different dimensions the participant is measured for
*mean:     COntains the average mean measured across a subject,activity and a particular dimension

