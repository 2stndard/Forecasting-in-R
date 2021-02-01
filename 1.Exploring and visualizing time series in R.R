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



# Exercise
# Time series plots
# The first step in any data analysis task is to plot the data. Graphs enable you to visualize many features of the data, including patterns, unusual observations, changes over time, and relationships between variables. Just as the type of data determines which forecasting method to use, it also determines which graphs are appropriate.
# 
# You can use the autoplot() function to produce a time plot of the data with or without facets, or panels that display different subsets of data:
#   
#   > autoplot(usnim_2002, facets = FALSE)
# The above method is one of the many taught in this course that accepts boolean arguments. Both T and TRUE mean "true", and F and FALSE mean "false", however, T and F can be overwritten in your code. Therefore, you should only rely on TRUE and FALSE to set your indicators for the remainder of the course.
# 
# You will use two more functions in this exercise, which.max() and frequency().
# which.max() can be used to identify the smallest index of the maximum value
# 
# > x <- c(4, 5, 5)
# > which.max(x)
# [1] 2
# To find the number of observations per unit time, use frequency(). Recall the usnim_2002 data from the previous exercise:
#   
#   > frequency(usnim_2002)
# [1] 4
# Because this course involves the use of the forecast and ggplot2 packages, they have been loaded into your workspace for you, as well as myts from the previous exercise and the following three series (available in the package forecast):
#   
#   gold containing gold prices in US dollars
# woolyrnq containing information on the production of woollen yarn in Australia
# gas containing Australian gas production
# Instructions
# 100 XP
# Plot the data you stored as myts using autoplot() with facetting.
# Plot the same data without facetting by setting the appropriate argument to FALSE. What happens?
#   Plot the gold, woolyrnq, and gas time series in separate plots.
# Use which.max() to spot the outlier in the gold series. Which observation was it?
#   Apply the frequency() function to each commodity to get the number of observations per unit time. This would return 52 for weekly data, for example.

library(forecast)
# Plot the data with facetting
autoplot(myts, facets = T)

# Plot the data without facetting
autoplot(myts, facets = F)

# Plot the three series
autoplot(gold)
autoplot(woolyrnq)
autoplot(gas)

# Find the outlier in the gold series
goldoutlier <- which.max(gold)

# Look at the seasonal frequencies of the three series
frequency(gold)
frequency(woolyrnq)
frequency(gas)



# Seasonal plots
# Along with time plots, there are other useful ways of plotting data to emphasize seasonal patterns and show changes in these patterns over time.
# 
# A seasonal plot is similar to a time plot except that the data are plotted against the individual “seasons” in which the data were observed. You can create one using the ggseasonplot() function the same way you do with autoplot().
# An interesting variant of a season plot uses polar coordinates, where the time axis is circular rather than horizontal; to make one, simply add a polar argument and set it to TRUE.
# A subseries plot comprises mini time plots for each season. Here, the mean for each season is shown as a blue horizontal line.
# One way of splitting a time series is by using the window() function, which extracts a subset from the object x observed between the times start and end.
# 
# > window(x, start = NULL, end = NULL)
# In this exercise, you will load the fpp2 package and use two of its datasets:
#   
#   a10 contains monthly sales volumes for anti-diabetic drugs in Australia. In the plots, can you see which month has the highest sales volume each year? What is unusual about the results in March and April 2008?
#   ausbeer which contains quarterly beer production for Australia. What is happening to the beer production in Quarter 4?
#   These examples will help you to visualize these plots and understand how they can be useful.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use library() to load the fpp2 package.
# Use autoplot() and ggseasonplot() to produce plots of the a10 data.
# Use the ggseasonplot() function and its polar argument to produce a polar coordinate plot for the a10 data.
# Use the window() function to consider only the ausbeer data starting from 1992.
# Finally, use autoplot() and ggsubseriesplot() to produce plots of the beer series.


# Load the fpp2 package
library(fpp2)

# Create plots of the a10 data
autoplot(a10)
ggseasonplot(a10)

# Produce a polar coordinate season plot for the a10 data
ggseasonplot(a10, polar = T)

# Restrict the ausbeer data to start in 1992
beer <- window(ausbeer, start = 1992)

# Make plots of the beer data
autoplot(beer)
ggsubseriesplot(beer)


# Exercise
# Autocorrelation of non-seasonal time series
# Another way to look at time series data is to plot each observation against another observation that occurred some time previously by using gglagplot(). For example, you could plot  against . This is called a lag plot because you are plotting the time series against lags of itself.
# 
# The correlations associated with the lag plots form what is called the autocorrelation function (ACF). The ggAcf() function produces ACF plots.
# 
# In this exercise, you will work with the pre-loaded oil data (available in the package fpp2), which contains the annual oil production in Saudi Arabia from 1965-2013 (measured in millions of tons).
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use the autoplot() function to plot the oil data.
# For the oil data, plot the relationship between  and ,  using one of the two functions introduced above. Look at how the relationships change as the lag increases.
# Likewise, plot the correlations associated with each of the lag plots using the other appropriate new function.


# Create an autoplot of the oil data
autoplot(oil)

# Create a lag plot of the oil data
gglagplot(oil)

# Create an ACF plot of the oil data
ggAcf(oil)



# Exercise
# Autocorrelation of seasonal and cyclic time series
# When data are either seasonal or cyclic, the ACF will peak around the seasonal lags or at the average cycle length.
# 
# You will investigate this phenomenon by plotting the annual sunspot series (which follows the solar cycle of approximately 10-11 years) in sunspot.year and the daily traffic to the Hyndsight blog (which follows a 7-day weekly pattern) in hyndsight. Both objects have been loaded into your workspace.
# 
# Instructions
# 100 XP
# Produce a time plot and ACF plot of sunspot.year.
# By observing the ACF plot, at which lag value (x) can you find the maximum autocorrelation (y)? Set this equal to maxlag_sunspot.
# Produce a time plot and ACF plot of hyndsight.
# By observing the ACF plot, at which lag value (x) can you find the maximum autocorrelation (y)? Set this equal to maxlag_hyndsight.


# Plot the annual sunspot numbers
autoplot(sunspot.year)
ggAcf(sunspot.year)

# Save the lag corresponding to maximum autocorrelation
maxlag_sunspot <- 1

# Plot the traffic on the Hyndsight blog
autoplot(hyndsight)
ggAcf(hyndsight)

# Save the lag corresponding to maximum autocorrelation
maxlag_hyndsight <- 7



# Exercise
# Stock prices and white noise
# As you learned in the video, white noise is a term that describes purely random data. You can conduct a Ljung-Box test using the function below to confirm the randomness of a series; a p-value greater than 0.05 suggests that the data are not significantly different from white noise.
# 
# > Box.test(pigs, lag = 24, fitdf = 0, type = "Ljung")
# There is a well-known result in economics called the "Efficient Market Hypothesis" that states that asset prices reflect all available information. A consequence of this is that the daily changes in stock prices should behave like white noise (ignoring dividends, interest rates and transaction costs). The consequence for forecasters is that the best forecast of the future price is the current price.
# 
# You can test this hypothesis by looking at the goog series, which contains the closing stock price for Google over 1000 trading days ending on February 13, 2017. This data has been loaded into your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# First plot the goog series using autoplot().
# Using the diff() function with autoplot(), plot the daily changes in Google stock prices.
# Use the ggAcf() function to check if these daily changes look like white noise.
# Fill in the pre-written code to do a Ljung-Box test on the daily changes using 10 lags.


# Plot the original series
autoplot(goog)

# Plot the differenced series
autoplot(diff(goog))

# ACF of the differenced series
ggAcf(diff(goog))

# Ljung-Box test of the differenced series
Box.test(diff(goog), lag = 10, type = "Ljung")


