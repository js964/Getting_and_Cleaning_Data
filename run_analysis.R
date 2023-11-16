#training data----------------------
subject_train <- read.csv("./train/subject_train.txt", col.names = "Subject")
y_train <- read.csv("./train/y_train.txt", col.names = "Labels") 
#trainMerged <- cbind(subject_train, y_train, X_train)
#inertial signals
  #body acceleration
body_acc_x_train <- read.csv("./train/Inertial Signals/body_acc_x_train.txt", col.names = "Acceleration_Signal_X_Axis")
body_acc_y_train <- read.csv("./train/Inertial Signals/body_acc_y_train.txt", col.names = "Acceleration_Signal_Y_Axis")
body_acc_z_train <- read.csv("./train/Inertial Signals/body_acc_z_train.txt", col.names = "Acceleration_Signal_Z_Axis")
  #body gyro (angular velocity)
body_gyro_x_train <- read.csv("./train/Inertial Signals/body_gyro_x_train.txt", col.names = "Angular_Velocity_X_Axis")
body_gyro_y_train <- read.csv("./train/Inertial Signals/body_gyro_y_train.txt", col.names = "Angular_Velocity_Y_Axis")
body_gyro_z_train <- read.csv("./train/Inertial Signals/body_gyro_z_train.txt", col.names = "Angular_Velocity_Z_Axis")
  #total acceleration
total_acc_x_train <- read.csv("./train/Inertial Signals/total_acc_x_train.txt", col.names = "Total_Acceleration_X_Axis")
total_acc_y_train <- read.csv("./train/Inertial Signals/total_acc_y_train.txt", col.names = "Total_Acceleration_Y_Axis")
total_acc_z_train <- read.csv("./train/Inertial Signals/total_acc_z_train.txt", col.names = "Total_Acceleration_Z_Axis")
#merge the columns together
trainMerged <- cbind(subject_train, y_train, body_acc_x_train, body_acc_y_train, body_acc_z_train, body_gyro_x_train, body_gyro_y_train, body_gyro_z_train, total_acc_x_train, total_acc_y_train, total_acc_z_train)

#test data---------------------------------------------
subject_test <- read.csv("./test/subject_test.txt", col.names = "Subject")
y_test <- read.csv("./test/y_test.txt", col.names = "Labels") 
#inertial signals
#body acceleration
body_acc_x_test <- read.csv("./test/Inertial Signals/body_acc_x_test.txt", col.names = "Acceleration_Signal_X_Axis")
body_acc_y_test <- read.csv("./test/Inertial Signals/body_acc_y_test.txt", col.names = "Acceleration_Signal_Y_Axis")
body_acc_z_test <- read.csv("./test/Inertial Signals/body_acc_z_test.txt", col.names = "Acceleration_Signal_Z_Axis")
#body gyro (angular velocity)
body_gyro_x_test <- read.csv("./test/Inertial Signals/body_gyro_x_test.txt", col.names = "Angular_Velocity_X_Axis")
body_gyro_y_test <- read.csv("./test/Inertial Signals/body_gyro_y_test.txt", col.names = "Angular_Velocity_Y_Axis")
body_gyro_z_test <- read.csv("./test/Inertial Signals/body_gyro_z_test.txt", col.names = "Angular_Velocity_Z_Axis")
#total acceleration
total_acc_x_test <- read.csv("./test/Inertial Signals/total_acc_x_test.txt", col.names = "Total_Acceleration_X_Axis")
total_acc_y_test <- read.csv("./test/Inertial Signals/total_acc_y_test.txt", col.names = "Total_Acceleration_Y_Axis")
total_acc_z_test <- read.csv("./test/Inertial Signals/total_acc_z_test.txt", col.names = "Total_Acceleration_Z_Axis")
#merge the columns together
testMerged <- cbind(subject_test, y_test, body_acc_x_test, body_acc_y_test, body_acc_z_test, body_gyro_x_test, body_gyro_y_test, body_gyro_z_test, total_acc_x_test, total_acc_y_test, total_acc_z_test)

#bind test and train dataframes-----------------------
mergedDF <- rbind(trainMerged, testMerged)
mergedDF$Labels[mergedDF$Labels == 1] <- "WALKING"
mergedDF$Labels[mergedDF$Labels == 2] <- "WALKING_UPSTAIRS"
mergedDF$Labels[mergedDF$Labels == 3] <- "WALKING_DOWNSTAIRS"
mergedDF$Labels[mergedDF$Labels == 4] <- "SITTING"
mergedDF$Labels[mergedDF$Labels == 5] <- "STANDING"
mergedDF$Labels[mergedDF$Labels == 6] <- "LAYING"

#find means and standard deviations (SD) -----------------------
rowCount <- nrow(mergedDF)
mean_SD_DF <- data.frame(mergedDF$Subject, mergedDF$Labels)
for (i in 3:ncol(mergedDF)) {
  col <- mergedDF[i]
  tempMeansList <- NULL
  tempSDList <- NULL
  for (j in 1:rowCount) {
    currentCol <- col[j,]
    convertToNum <- as.numeric(unlist(strsplit(as.character(currentCol)," +")))
    findMean <- mean(convertToNum,na.rm = TRUE)
    tempMeansList <- rbind(tempMeansList, findMean)
    findSD <- sd(convertToNum, na.rm = TRUE)
    tempSDList <- rbind(tempSDList, findMean)
  }
  mean_SD_DF <- cbind(mean_SD_DF, tempMeansList, tempSDList)
}

#rename columns-------------------------------------------------------
colnames(mean_SD_DF) <- c("Subject", "Activity", "Mean_Body_Acceleration_X_Axis", "SD_Body_Acceleration_X_Axis", "Mean_Body_Acceleration_Y_Axis", "SD_Body_Acceleration_Y_Axis", "Mean_Body_Acceleration_Z_Axis", "SD_Body_Acceleration_Z_Axis", "Mean_Angular_Velocity_X_Axis", "SD_Angular_Velocity_X_Axis", "Mean_Angular_Velocity_Y_Axis", "SD_Angular_Velocity_Y_Axis", "Mean_Angular_Velocity_Z_Axis", "SD_Angular_Velocity_Z_Axis", "Mean_Total_Acceleration_X_Axis", "SD_Total_Acceleration_X_Axis", "Mean_Total_Acceleration_Y_Axis", "SD_Total_Acceleration_Y_Axis", "Mean_Total_Acceleration_Z_Axis", "SD_Total_Acceleration_Z_Axis")
write.table(mean_SD_DF, "tidy_Data.txt", sep="\t", row.names = TRUE) #save to textfile

#create a second dataset with the average of each variable for each activity and subject
#subject
by_subject <- mean_SD_DF |>  group_by(Subject)
subjectDF <- by_subject |>  summarise(across(Mean_Body_Acceleration_X_Axis:SD_Total_Acceleration_Z_Axis, ~ mean(.x, na.rm = TRUE)))
#activity
by_activity <- mean_SD_DF |>  group_by(Activity)
activityDF <- by_activity |>  summarise(across(Mean_Body_Acceleration_X_Axis:SD_Total_Acceleration_Z_Axis, ~ mean(.x, na.rm = TRUE)))
#merge into one table
colnames(subjectDF)[1] <- "Group"
colnames(activityDF)[1] <- "Group"
secondDF <- rbind(subjectDF, activityDF)
