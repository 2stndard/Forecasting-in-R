# Exercise
# Simple exponential smoothing
# The ses() function produces forecasts obtained using simple exponential smoothing (SES). The parameters are estimated using least squares estimation. All you need to specify is the time series and the forecast horizon; the default forecast time is h = 10 years.
# 
# > args(ses)
# function (y, h = 10, ...)
#   
#   > fc <- ses(oildata, h = 5)
# > summary(fc)
# You will also use summary() and fitted(), along with autolayer() for the first time, which is like autoplot() but it adds a "layer" to a plot rather than creating a new plot.
# 
# Here, you will apply these functions to marathon, the annual winning times in the Boston marathon from 1897-2016. The data are available in your workspace.
# 
# Instructions
# 100 XP
# Use the ses() function to forecast the next 10 years of winning times.
# Use the summary() function to see the model parameters and other information.
# Use the autoplot() function to plot the forecasts.
# Add the one-step forecasts for the training data, or fitted values, to the plot using fitted() and autolayer().


# Use ses() to forecast the next 10 years of winning times
fc <- ses(marathon, h = 10)

# Use summary() to see the model parameters
summary(fc)

# Use autoplot() to plot the forecasts
autoplot(fc)

# Add the one-step forecasts for the training data to the plot
autoplot(fc) + autolayer(fitted(fc))



# Exercise
# SES vs naive
# In this exercise, you will apply your knowledge of training and test sets, the subset() function, and the accuracy() function, all of which you learned in Chapter 2, to compare SES and naive forecasts for the marathon data.
# 
# You did something very similar to compare the naive and mean forecasts in an earlier exercise "Evaluating forecast accuracy of non-seasonal methods".
# 
# Let's review the process:
# 
# First, import and load your data. Determine how much of your data you want to allocate to training, and how much to testing; the sets should not overlap.
# Subset the data to create a training set, which you will use as an argument in your forecasting function(s). Optionally, you can also create a test set to use later.
# Compute forecasts of the training set using whichever forecasting function(s) you choose, and set h equal to the number of values you want to forecast, which is also the length of the test set.
# To view the results, use the accuracy() function with the forecast as the first argument and original data (or test set) as the second.
# Pick a measure in the output, such as RMSE or MAE, to evaluate the forecast(s); a smaller error indicates higher accuracy.
# The marathon data is loaded into your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Using subset(), create a training set for marathon comprising all but the last 20 years of the data which you will reserve for testing.
# Compute the SES and naive forecasts of this training set and save them to fcses and fcnaive, respectively.
# Calculate forecast accuracy measures of the two sets of forecasts using the accuracy() function in your console.
# Assign the best forecasts (either fcses or fcnaive) based on RMSE to fcbest.



# Create a training set using subset()
train <- subset(marathon, end = length(marathon) - 20)

# Compute SES and naive forecasts, save to fcses and fcnaive
fcses <- ses(train, h = 20)
fcnaive <- naive(train, h = 20)

# Calculate forecast accuracy measures
accuracy(fcses, marathon)
accuracy(fcnaive, marathon)

# Save the best forecasts as fcbest
fcbest <- fcnaive



# Exercise
# Holt's trend methods
# Holt's local trend method is implemented in the holt() function:
#   
#   > holt(y, h = 10, ...)
# Here, you will apply it to the austa series, which contains annual counts of international visitors to Australia from 1980-2015 (in millions). The data has been pre-loaded into your workspace.
# 
# Instructions
# 100 XP
# Produce 10 year forecasts of austa using Holt's method. Set h accordingly.
# Use the summary() function to view the model parameters and other information.
# Plot your forecasts using the standard time plotting function.
# Use checkresiduals() to see if the residuals resemble white noise.



# Produce 10 year forecasts of austa using holt()
fcholt <- holt(austa, h = 10)

# Look at fitted model using summary()
summary(fcholt)

# Plot the forecasts
autoplot(fcholt)

# Check that the residuals look like white noise
checkresiduals(fcholt)



# Exercise
# Holt-Winters with monthly data
# In the video, you learned that the hw() function produces forecasts using the Holt-Winters method specific to whatever you set equal to the seasonal argument:
#   
#   fc1 <- hw(aust, seasonal = "additive")
# fc2 <- hw(aust, seasonal = "multiplicative")
# Here, you will apply hw() to a10, the monthly sales of anti-diabetic drugs in Australia from 1991 to 2008. The data are available in your workspace.
# 
# Instructions
# 100 XP
# Produce a time plot of the a10 data.
# Produce forecasts for the next 3 years using hw() with multiplicative seasonality and save this to fc.
# Do the residuals look like white noise? Check them using the appropriate function and set whitenoise to either TRUE or FALSE.
# Plot a time plot of the forecasts.


# Plot the data
autoplot(a10)

# Produce 3 year forecasts
fc <- hw(a10, seasonal = 'multiplicative', h = 36)

# Check if residuals look like white noise
checkresiduals(fc)
whitenoise <- FALSE

# Plot forecasts
autoplot(fc)



# Exercise
# Holt-Winters method with daily data
# The Holt-Winters method can also be used for daily type of data, where the seasonal pattern is of length 7, and the appropriate unit of time for h is in days.
# 
# Here, you will compare an additive Holt-Winters method and a seasonal naive() method for the hyndsight data, which contains the daily pageviews on the Hyndsight blog for one year starting April 30, 2014. The data are available in your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Using subset.ts(), set up a training set where the last 4 weeks of the available data in hyndsight have been omitted.
# Produce forecasts for these last 4 weeks using hw() and additive seasonality applied to the training data. Assign this to fchw.
# Produce seasonal naive forecasts for the same period. Use the appropriate function, introduced in a previous chapter, and assign this to fcsn.
# Which is the better of the two forecasts based on RMSE? Use the accuracy() function to determine this.
# Produce time plots of these forecasts.



# Create training data with subset()
train <- subset(hyndsight, end = length(hyndsight)-28)

# Holt-Winters additive forecasts as fchw
fchw <- hw(train, seasonal = 'additive', h = 28)

# Seasonal naive forecasts as fcsn
fcsn <- snaive(train, h = 28)

# Find better forecasts with accuracy()
accuracy(fchw, hyndsight)
accuracy(fcsn, hyndsight)

# Plot the better forecasts
autoplot(fchw)



# Exercise
# Automatic forecasting with exponential smoothing
# The namesake function for finding errors, trend, and seasonality (ETS) provides a completely automatic way of producing forecasts for a wide range of time series.
# 
# You will now test it on two series, austa and hyndsight, that you have previously looked at in this chapter. Both have been pre-loaded into your workspace.
# 
# Instructions
# 100 XP
# Using ets(), fit an ETS model to austa and save this to fitaus.
# Using the appropriate function, check the residuals from this model.
# Plot forecasts from this model by using forecast() and autoplot() together.
# Repeat these three steps for the hyndsight data and save this model to fiths.
# Which model(s) fails the Ljung-Box test? Assign fitausfail and fithsfail to either TRUE (if the test fails) or FALSE (if the test passes).



# Fit ETS model to austa in fitaus
fitaus <- ets(austa)

# Check residuals
checkresiduals(fitaus)

# Plot forecasts
autoplot(forecast(fitaus))

# Repeat for hyndsight data in fiths
fiths <- ets(hyndsight)
checkresiduals(fiths)
autoplot(forecast(fiths))

# Which model(s) fails test? (TRUE or FALSE)
fitausfail <- FALSE
fithsfail <- TRUE




# Exercise
# ETS vs seasonal naive
# Here, you will compare ETS forecasts against seasonal naive forecasting for 20 years of cement, which contains quarterly cement production using time series cross-validation for 4 steps ahead. Because this takes a while to run, a shortened version of the cement series will be available in your workspace.
# 
# The second argument for tsCV() must return a forecast object, so you need a function to fit a model and return forecasts. Recall:
#   
#   > args(tsCV)
# function (y, forecastfunction, h = 1, ...)
#   In this exercise you will use an existing forecasting function as well as one that has been created for you. Remember, sometimes simple methods work better than more sophisticated methods!
#   
#   Instructions
# 100 XP
# Instructions
# 100 XP
# A function to return ETS forecasts, fets(), has been written for you.
# Apply tsCV() for both ETS and seasonal naive methods to the cement data for a forecast horizon of 4. Use the newly created fets and the existing snaive functions as your forecast function argument for e1 and e2, respectively.
# Compute the MSE of the resulting 4-step errors and remove missing values. The expressions for calculating MSE have been provided for you, but the second optional arguments have not (you've used them before).
# Save the best MSE as bestmse. You can simply copy the entire line of code that generates the best MSE from the previous instruction.

cement <- c(1.468,1.755,1.962,1.833,1.626,1.703,1.733,1.545,1.526,1.593,1.706,1.699,1.511,1.785,1.826,1.83,1.719,1.861,1.956,2.067,1.737,1.944,2.005,2.027,1.835,2.07,1.898,1.652,1.554,1.717,1.679,1.836,1.729,1.992,2.03,1.978,1.831,1.892,2.227,2.09,1.963,2.18,2.307,2.157,1.98,2.481,2.34,2.265,2.027,2.278,2.427,2.451,2.14,2.362,2.536,2.562,2.183,2.558,2.612,2.373,1.963,2.16,2.325,2.273,1.904,2.401,2.494,2.296,2.055,2.273,2.499,2.39,2.067,2.223,2.451,2.503,2.049,2.528,2.637,2.565,2.229)

cement <- ts(cement, start = c(1994, 1), frequency = 4)  

# Function to return ETS forecasts
fets <- function(y, h) {
  forecast(ets(y), h = h)
}

# Apply tsCV() for both methods
e1 <- tsCV(cement, fets, h = 4)
e2 <- tsCV(cement, snaive, h = 4)

# Compute MSE of resulting errors (watch out for missing values)
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)

# Copy the best forecast MSE
bestmse <- 0.03046892



# Exercise
# When does ETS fail?
#   Computing the ETS does not work well for all series.
# 
# Here, you will observe why it does not work well for the annual Canadian lynx population available in your workspace as lynx.
# 
# Instructions
# 100 XP
# Plot the lynx series using the standard plotting function and note the cyclic behaviour.
# Use ets() to model the lynx series, and assign this to fit.
# Use summary() to look at the selected model and parameters.
# Plot forecasts for the next 20 years using the pipe operator. Note that you only need to specify h for one particular function.


# Plot the lynx series
autoplot(lynx)

# Use ets() to model the lynx series
fit <- ets(lynx)

# Use summary() to look at model and parameters
summary(fit)

# Plot 20-year forecasts of the lynx series
fit %>% forecast(h = 20) %>% autoplot()
