# Exercise
# Creating time series objects in R
# A time series can be thought of as a vector or matrix of numbers along with some information about what times those numbers were recorded. This information is stored in a ts object in R. In most exercises, you will use time series that are part of existing packages. However, if you want to work with your own data, you need to know how to create a ts object in R.
# 
# Let's look at an example usnim_2002 below, containing net interest margins for US banks for the year 2002 (source: FFIEC).
# 
# > usnim_2002
#                usnim
# 1   2002-01-01  4.08
# 2   2002-04-01  4.10
# 3   2002-07-01  4.06
# 4   2002-10-01  4.04
# 
# > # ts(data, start, frequency, ...)
# > usnim_ts = ts(usnim_2002[, 2], start = c(2002, 1), frequency = 4)
# The function ts() takes in three arguments:
# 
# data is set to everything in usnim_2002 except for the date column; it isn't needed since the ts object will store time information separately.
# start is set to the form c(year, period) to indicate the time of the first observation. Here, January corresponds with period 1; likewise, a start date in April would refer to 2, July to 3, and October to 4. Thus, period corresponds to the quarter of the year.
# frequency is set to 4 because the data are quarterly.
# In this exercise, you will read in some time series data from an xlsx file using read_excel(), a function from the readxl package, and store the data as a ts object. Both the xlsx file and package have been loaded into your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use the read_excel() function to read the data from "exercise1.xlsx" into mydata.
# Apply head() to mydata in the R console to inspect the first few lines of the data. Take a look at the dates - there are four observations in 1981, indicating quarterly data with a frequency of four rows per year. The first observation or start date is Mar-81, the first of four rows for year 1981, indicating that March corresponds with the first period.
# Create a ts object called myts using ts(). Set data, start and frequency based on what you observed.

library(readxl)
# Read the data from Excel into R
mydata <- read_excel("exercise1.xlsx")

# Look at the first few lines of mydata
head(mydata)

# Create a ts object called myts
myts <- ts(mydata[2:4], start = c(1981, 1), frequency = 4)
