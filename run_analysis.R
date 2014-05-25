##step 1:Merging the training and the test sets to create one data set.

  ## setting the working directory
  setwd("C:/Users/Pratibha/Documents/Coursera/Data science/03.Getting and cleaning data")
  getwd()


  ## unzipping the zip file present in the working directory
  unzip("getdata-projectfiles-UCI HAR Dataset.zip")
 

  ## Load the features file
  features <- read.table(file="./UCI HAR Dataset/features.txt", sep = " ")

  head(features)

  ##load the activity file
  activity <- read.table("./UCI HAR Dataset/activity_labels.txt", sep = " ")

  head(activity)

  ## read the train files
  xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="", header = F )
  ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt", sep="", header = F )
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="", header = F)

  
  ## read the test files
  xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="", header = F )
  ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt", sep="", header = F )
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="", header = F)


  ## combine all test data
  test_data <- cbind(subject_test,ytest,xtest)

  ## combine all train data
  train_data <- cbind(subject_train,ytrain,xtrain)

  ##merge train and test data
  data <- rbind(train_data,test_data)

  ##getting the column names from features file and adding subject and activity names to it
  colNames <- c("subject","activity",as.vector(features[,2]))

  ## setting the column names of data as the values derived above
  colnames(data) <- colNames  
  
  
  

## step 2 : Extracts only the measurements on the mean and standard deviation for 
  ##each measurement. 
  mean_std_colnames <- grep("mean\\(\\)|std\\(\\)", colNames, perl=TRUE, value=TRUE)
  
  ## extracting the data related to the columns required
  new_data <- data[,c("subject","activity",mean_std_colnames)]
  
  
  
##step 3: Giving descriptive activity names to name the activities in the data set  
  ## recoding the activity numbers with the corresponding names in the activity file
  data$activity <- activity[,2][match(data$activity,activity[,1])]


  
  
##step 4: Appropriately labels the data set with descriptive activity names. 
  
  ##getting current column names into a variable
  column_data <- colnames(new_data)
  
  ##pair of patterns and replacements are stored in a list
  pattern_replacement_pairs = list(c('-', '_'), c('\\(\\)', ''),c('^t','time_'),
                                   c('^f', 'frequency_'), c('Acc', 'acceleration_'),
                                   c('Mag', 'magnitude_'),c('Gravity', 'gravity_'),
                                   c('Body', 'body_'),c('Gyro', 'gyroscope_'),
                                   c('Jerk', 'jerk_') )

  
  ## function which takes a vector and perform pattern replacement for multiple values 
  ##References:Stackoverflow
  ## http://stackoverflow.com/questions/15253954/replace-multiple-arguments-with-gsub
  pattern_replace <- function( pattern_replacement_pairs,data){
        sub <- function(pattern_replacement, x){
            do.call('gsub', list(x = x, pattern = pattern_replacement[1], 
                                 replacement = pattern_replacement[2]))
        }
        Reduce(sub, pattern_replacement_pairs, init = data, right = T) 
  }

  colnames(new_data) <- pattern_replace(pattern_replacement_pairs,column_data)
  ## removing the additional characters further
  colnames(new_data) <- gsub("_+","_",colnames(new_data))
  colnames(new_data) <- gsub("_body_body_","_body_",colnames(new_data))
  ##saving the new column names to colList 
  colnames(new_data) -> colList
  
  

## Step5: Creating a second, independent tidy data set with the average of each variable 
##for each activity and each subject.
  ##loading required libraries
  library(plyr)

  library(reshape2)

  ##melting data based on subject and activity and storing rest all features into variable
  melt_data <- melt(new_data, id.vars= c("subject","activity") ,
                    measure.vars=colList[!colList %in% c("subject","activity")])
  ## summarizing data based on mean of features present in variables column
  tidy_data <- ddply(melt_data, .(subject,activity,variable), summarize, mean=mean(value))
  head(tidy_data)

  write.table(tidy_data, "./UCI HAR dataset/tidy_data.txt", sep = "\t", 
              row.names = F, col.names = T, quote = F)



