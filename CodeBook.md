# Getting and Cleaning Data Assignment Codebook
## Input Data
- `subject_train` : contains the subject who performed the activity. 
- `y_train` : contains the numerical label for each activity. 1 = WALKING, 2 = WALKING_UPSTAIRS, 3 = WALKING_DOWNSTAIRS, 4 = SITTING, 5 = STANDING, 6 = LAYING
- `body_acc_x_train` : contains the body acceleration signal (= total accelaration - gravity), same applies for y axis and z axis (.y_train/.z_train)
- `body_gyro_x_train` : contains the angular velocity measured by the gyroscope (units = radians/second), same applies for y axis and z axis (.y_train/.z_train)
- `total_acc_x_train` : contains the acceleration data taken from the accelerometer x-axis (units = 'g'), same applies for y axis and z axis (.y_train/.z_train)\
*Note: same applies to test data*

## Dataframes
- `trainMerged` : contains the merged train data
- `testMerged` : contains the merged test data
- `mergedDF` : train and test data merged together in one dataframe
- `mean_SD_DF` : dataframe containing the subject ID, activity, mean body acceleration and the standard deviation for the body acceleration (for x, y, z axis), mean and standard deviations for the angular velpcity (for x, y, z axis) and mean and standard deviation for the total acceleration (for x, y, z axis)
- `secondDF` : contains `Group` column, which contains the subject IDs and activities, and the columns which have been summarised depending on the group.

## Code Overview
1. Data was unzipped and downloaded into the working directory prior to tidying
2. Subject IDs, label numbers and intertial signals of the training data were read into `trainMerged` dataframe
3. Subject IDs, label numbers and intertial signals of the test data were read into `testMerged` dataframe
4. Train and test dataframes were merged into `mergedDF` dataframe
5. Label numbers were changed to their corresponding labels (see y_train)
6. Means and standard deviations for each column were found and added to `mean_SD_DF` dataframe, column names were changed to be more descriptive
7. A second dataset called `secondDF` was creaed to hold the averages of each variables according to activity and subject
