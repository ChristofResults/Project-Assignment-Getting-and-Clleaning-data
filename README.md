# Readme Getting & Cleaning Data project assignment

The project assignment was to take data from Human Activity Recognition Using Smartphones Dataset, Version 1.0 and process this data for analysis purposes

The following steps to reproduce the results:

1.  create a new RStudio project
2.  download the data set: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
3.  extract the zip in your RStudio project's working directory. This should result in a folder with the name "UCI HAR Dataset"
4.  create a directory "Data" in your project's working directory to store the output from the script
5.  copy "run_analysis.R" to project working directory
6.  run script "run_analysis.R"
7.  the output of this script is stored in the directory "Data" as "tidy_data_full.csv" and "tidy_data_mean_bymeasurement.csv",
8.  "result.txt" contains the result as requested by the assignment (using write.table)

Session Info:

-   R version 4.2.2 (2022-10-31)

-   Platform: aarch64-apple-darwin20 (64-bit)

-   Running under: macOS Ventura 13.2.1

-   Matrix products: default LAPACK: /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/lib/libRlapack.dylib

-   locale: [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

-   attached base packages: [1] stats graphics grDevices utils datasets methods base

-   other attached packages: [1] reshape2_1.4.4 dplyr_1.1.0
