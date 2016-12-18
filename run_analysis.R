# 1.Merges the training and the test sets to create one data set.  

# read features   
features <- read.table("UCI HAR Dataset/features.txt")    

# X data set  xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")   
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")   
xds <- rbind(xtrain, xtest)    

# Subject data set  
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")   
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt")   
sds <- rbind(subtrain, subtest)  

# Y data set  
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")   
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")   
yds <- rbind(ytrain, ytest)    

names(sds)<-c("subject")  
names(yds)<- c("activity")  
names(xds)<- features$V2    
syds <- cbind(sds, yds) # cbind subject and activity  
finalds <- cbind(xds, syds) # cbind features  

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.    
meanstd <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]  
featuresnames <- c(as.character(meanstd), "subject", "activity" )  
finalds <- subset(finalds,select=featuresnames)  

# 3.Uses descriptive activity names to name the activities in the data set  
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")  
finalds$activity<-factor(finalds$activity,labels=activityLabels[,2])  

# 4.Appropriately labels the data set with descriptive variable names.   
names(finalds)<-gsub("^t", "time", names(finalds))  
names(finalds)<-gsub("^f", "frequency", names(finalds))  
names(finalds) <- gsub("-mean","-Mean",names(finalds))  
names(finalds) <- gsub("-std","-StandardDeviation",names(finalds))  


# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
tidyds <-aggregate(. ~subject + activity, finalds, mean)  
tidyds <- tidyds[order(tidyds$subject,tidyds$activity),]  
write.table(tidyds, file = "UCI HAR Dataset/tidydataset.txt",row.name=FALSE)
