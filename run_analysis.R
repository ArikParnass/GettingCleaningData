#COURSE PROJECT WEARABLE COMPUTING

#Read in folder and unzip
tf <-tempfile()
td <- tempdir()
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,tf,mode="wb",method="curl")
file.names <- unzip(tf,exdir="Downloads")

#Download each table from the folder
SubjectTest <- read.table("Downloads/UCI HAR Dataset/test/subject_test.txt")
XTest <- read.table("Downloads/UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("Downloads/UCI HAR Dataset/test/Y_test.txt")
SubjectTrain <- read.table("Downloads/UCI HAR Dataset/train/subject_train.txt")
XTrain <- read.table("Downloads/UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("Downloads/UCI HAR Dataset/train/Y_train.txt")
featuresList <- read.table("Downloads/UCI HAR Dataset/features.txt")

#Merge Test and Train files individually
XTest2 <- cbind(XTest,SubjectTest)
XTest2 <- cbind(XTest2,YTest)
XTrain2 <- cbind(XTrain,SubjectTrain)
XTrain2 <- cbind(XTrain2,YTrain)

#Merge the Test and Train files together
XBoth <- rbind(XTest2,XTrain2)

#Set column names to vector of features.txt
names(XBoth2) <- featuresList[,2]
names(XBoth2)[562:563] <- c("Subject", "Activity")

#Subset only those columns that include "mean" or "std" or "Subject" or "Activity"
XBoth3 <- XBoth2[,grep("*mean*|*std*|Subject|Activity",names(XBoth2),ignore.case=TRUE)]

#Change activity numbers to discriptive strings
XBoth3$Activity[XBoth3$Activity==1] <- "walking"
XBoth3$Activity[XBoth3$Activity==2] <- "walkingUp"
XBoth3$Activity[XBoth3$Activity==3] <- "walkingDown"
XBoth3$Activity[XBoth3$Activity==4] <- "sitting"
XBoth3$Activity[XBoth3$Activity==5] <- "standing"
XBoth3$Activity[XBoth3$Activity==6] <- "laying"

#Change variable names
XBoth4 <- XBoth3
names(XBoth4) <- gsub("-",".",names(XBoth4))
names(XBoth4) <- gsub("\\(","",names(XBoth4))
names(XBoth4) <- gsub("\\)","",names(XBoth4))
names(XBoth4) <- gsub(",",".",names(XBoth4))
names(XBoth4) <- gsub("^t","time",names(XBoth4))
names(XBoth4) <- gsub("^f","fastfourier", names(XBoth4))

#Create independent data set with means of each variable for each subject and activity
meanTable <- ddply(XBoth4, .(Subject,Activity), numcolwise(mean))

#Write the table
write.table(meanTable, "Desktop/meanTable.txt", sep="\t",row.name=FALSE)
