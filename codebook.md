## Codebook for run_analysis.R

This codebook explains the modifications *run\_analysis.R* script (_The script_ throughout this codebook) makes to the UCI Human Activity Recognition dataset and the tidy data produced by this script.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
The original data uses tracks the movements of 30 subjects with Samsung Galaxy S smartphones attached to their waists.  Detailed information about the dataset is avaliable at: [UCI archives](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphone)

The original data and codebooks are bundled in a zip file, which can be downloaded from [this cloudfront link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) **_Please refer to the original codebook files for descriptions of measurements and their units._**

_The script requires that you have created **_a directory named RWD on your Desktop, set it as your R working directory, and unzipped the .zip file above into a file named "UCIHARDataset" in this directory._**  The script was created in **RStudio Version 0.98.1103**, on a **MacOSX 10.9.5**. The script sources "dplyr" and "plyr" libraries, users should make sure they have these packages and their dependencies installed before running the script._

##**Description of the Dataset:**
The study that generated the dataset was carried out by Jorge L. Reyes\-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto \(Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes\-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware\-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living \(IWAAL 2012\). Vitoria\-Gasteiz, Spain. Dec 2012\).  

The original codebook describes the data generation process as:
> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone \(Samsung Galaxy S II\) on the waist. Using its embedded accelerometer and gyroscope, we captured 3\-axial linear acceleration and 3\-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

> The sensor signals \(accelerometer and gyroscope\) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap \(128 readings/window\). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low\-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See \'features\_info.txt\' for more details. 

**The files run\_analysis.R utilizes and their descriptions are below:**

- *subject\_test.txt*: A data file of dimensions 2947x1. This data includes the identifiers for the test subjects across the 2947 rows \(Answering: Which test subject are these measurements for?\). The script reads this data into R as "a".
- *y\_test.txt*: A data file of dimensions 2947x1. This data includes the activity codes for each test subject, for each instance measurements were taken. There are 6 activities recorded, and these are listed in activity\_labels.txt.  The script reads this date into R as "b".
- *X\_test.txt*: A data file of dimensions 2947x561. This data includes measurements for test subjects over 561 features. The script reads this data into R as "c".
- *subject\_train.txt*: A data file of dimensions 7352x1. This data includes the identifiers for the train subjects across the 7352 rows \(Answers: Which train subject are these measurements for?\). The script reads this data into R as "d".
- *y\_train.txt*: A data file of dimensions 7352x1. This data includes the activity codes for each train subject, for each instance measurements were taken. There are 6 activities recorded, and these are listed in activity\_labels.txt.  The script reads this date into R as "e".
- *X\_train.txt*: A data file of dimensions 7352x561. This data includes measurements for test subjects over 561 features. The script reads this data into R as "f".
- *features.txt* A data file of dimensions 561x2. This data includes the names of the 561 measurements that were taken for the test and train subjects. Detailed information about this file are available in the "features\_info.txt" in the zip file. The script reads the file into R as "features" and uses it to label the columns in X\_test\(a\) and Y\_test\(d\). 
 
*activity\_labels.txt* is a small data file that shows the activities the numbers in y\_test and y\_train datasets corresponds to.  The script uses this information to label the activity variable.

##**Explanation for the steps in the script:**
The script follows the steps below.  Explanations are also available as note in the code itself.

1. It reads in the test files.
2. It reads in the train files.
3. It reads in the features file and extracts the column that includes feature names. We will use this column to name the columns in X\_train/test files.  Note that the feature names include many characters such as parantheses; they cannot exist in a column name.  Thus I force the feature names to be acceptable "names" and then this column is saved as a factor. See the examples below:

    * tBodyAcc\-mean\(\)\-X \-\>  tBodyAcc.mean...X  
    * tBodyAcc\-mean\(\)\-Y \-\> tBodyAcc.mean...Y  
    * tBodyAcc\-mean\(\)\-Z \-\>  tBodyAcc.mean...Z  
    * tBodyAcc\-std\(\)\-X \-\>   tBodyAcc.std...X  
    * tBodyAcc\-std\(\)\-Y \-\>  tBodyAcc.std...Y  
    * tBodyAcc\-std\(\)\-Z \-\>  tBodyAcc.std...Z  

4. I assign column names \(subject and activity\) for subject\_test/train and x/y\_train files.
5. I bind the columns for subject, activity and X data frames. I end up with 563 columns for both train and test data.
6. I bind the rows for the 563 columns in test and train data, resulting in a 10299 x 563 data frame. This data.frame retains the column names assigned above.
7. Using dplyr, I order this data frame according to subject and activity type.  This is the master data we will be working from.  Note that activity is coded in numbers, not activity names at this point.
8. Using plyr, I rename activity codes from numbers \(1,2,..,6\) to activity names \(Walking, Sitting, \) as in activity_labels.txt. Note that I detach the plyr package after this step, because it may interfere with the dplyr functions I will use below.
9. I use dplyr select functions to create three files: one contains the variables that has "mean" in it, the second including "std" and the third includes activity/subject columns.  Then I bind these **88** columns together. This is our **reduced data file**. Note that I have included columns for meanFreq\(\), angle\(\) columns; they are already summaries of the other measurements, however they are also measurements that provide useful information.
10. I use the **reduced data** created above to generate another, independent tidy dataset which lists the average of each variable for each activity and each subject.  This is a 180 x 88  file, includes column names and is sorted by subject and \(alphabetically\) activity. (Note: 30 subjects x 6 activities makes 180 rows.)  **_It is tidy because each variable is in one column and each subject-activity pair (different observations) are in different rows._**
11. I write this new tidy dataset to a txt file, this will  be saved into the working directory /(RWD folder on the Desktop/).



