
Dear User,

This repo includes three files that are relevant to the production of the tidy data that was uploaded to the Getting Data course assignment page on Coursera.  The goal in this exercise was to create a tidy dataset using the UCI Human Activity Recognition data. I relied on the general consensus about "tidy data" in the course [tidy data thread](https://class.coursera.org/getdata-014/forum/thread?thread_id=31) to shape the data.

You will find in this repo:

1. **run/_analysis.R:** The R script you can run to create the tidy data.  The notes in the code are intended to help the user understand what each step of the code does.
2. **codebook.md:** A detailed description of the data, 
3. This **readme.md** file! Gives detailed information and instructions on software used, necessary steps to take **before** running the script such as the working directory and folder to unzip the file.  It includes detailed descriptions of the steps taken in the script. It aims at reproducibility of the code.


##**Instructions**

This codebook explains the modifications *run\_analysis.R* script (_The script_ throughout this codebook) makes to the UCI Human Activity Recognition dataset and the tidy data produced by this script.

_The script requires that you have created **_a directory named RWD on your Desktop, set it as your R working directory, and unzipped the .zip file above into a file named "UCIHARDataset" in this directory._**  The script was created in **RStudio Version 0.98.1103**, on a **MacOSX 10.9.5**. The script sources "dplyr" and "plyr" libraries, users should make sure they have these packages and their dependencies installed before running the script._

##**Explanation for the steps in the script:**
The script follows the steps below.  Explanations are also available as note in the code itself.
**_Please familiarize yourself with the data by reading the original codebooks and the codebook in this repository before you begin!_**

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
11. I write this new tidy dataset to a txt file, this will  be saved into the working directory \(RWD folder on the Desktop\).






