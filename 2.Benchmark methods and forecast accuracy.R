# Exercise
# Naive forecasting methods
# As you learned in the video, a forecast is the mean or median of simulated futures of a time series.
# 
# The very simplest forecasting method is to use the most recent observation; this is called a naive forecast and can be implemented in a namesake function. This is the best that can be done for many time series including most stock price data, and even if it is not a good forecasting method, it provides a useful benchmark for other forecasting methods.
# 
# For seasonal data, a related idea is to use the corresponding season from the last year of data. For example, if you want to forecast the sales volume for next March, you would use the sales volume from the previous March. This is implemented in the snaive() function, meaning, seasonal naive.
# 
# For both forecasting methods, you can set the second argument h, which specifies the number of values you want to forecast; as shown in the code below, they have different default values. The resulting output is an object of class forecast. This is the core class of objects in the forecast package, and there are many functions for dealing with them including summary() and autoplot().
# 
# naive(y, h = 10)
# snaive(y, h = 2 * frequency(x))
# You will try these two functions on the goog series and ausbeer series, respectively. These are available to use in your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use naive() to forecast the next 20 values of the goog series, and save this to fcgoog.
# Plot and summarize the forecasts using autoplot() and summary().
# Use snaive() to forecast the next 16 values of the ausbeer series, and save this to fcbeer.
# Plot and summarize the forecasts for fcbeer the same way you did for fcgoog.


# Use naive() to forecast the goog series
fcgoog <- naive(goog, h = 20)

# Plot and summarize the forecasts
autoplot(fcgoog)
summary(fcgoog)

# Use snaive() to forecast the ausbeer series
fcbeer <- snaive(ausbeer, h = 16)

# Plot and summarize the forecasts
autoplot(fcbeer)
summary(fcbeer)


# Exercise
# Checking time series residuals
# When applying a forecasting method, it is important to always check that the residuals are well-behaved (i.e., no outliers or patterns) and resemble white noise. The prediction intervals are computed assuming that the residuals are also normally distributed. You can use the checkresiduals() function to verify these characteristics; it will give the results of a Ljung-Box test.
# 
# You haven't used the pipe function (%>%) so far, but this is a good opportunity to introduce it. When there are many nested functions, pipe functions make the code much easier to read. To be consistent, always follow a function with parentheses to differentiate it from other objects, even if it has no arguments. An example is below:
# 
# > function(foo)       # These two
# > foo %>% function()  # are the same!
# 
# > foo %>% function    # Inconsistent
# In this exercise, you will test the above functions on the forecasts equivalent to what you produced in the previous exercise (fcgoog obtained after applying naive() to goog, and fcbeer obtained after applying snaive() to ausbeer).
# 
# Instructions
# 100 XP
# Using the above pipe function, run checkresiduals() on a forecast equivalent to fcgoog.
# Based on this Ljung-Box test results, do the residuals resemble white noise? Assign googwn to either TRUE or FALSE.
# Using a similar pipe function, run checkresiduals() on a forecast equivalent to fcbeer.
# Based on this Ljung-Box test results, do the residuals resemble white noise? Assign beerwn to either TRUE or FALSE.


# Check the residuals from the naive forecasts applied to the goog series
goog %>% naive() %>% checkresiduals()

# Do they look like white noise (TRUE or FALSE)
googwn <- T

# Check the residuals from the seasonal naive forecasts applied to the ausbeer series
ausbeer %>% snaive() %>% checkresiduals()

# Do they look like white noise (TRUE or FALSE)
beerwn <- F



# Exercise
# Evaluating forecast accuracy of non-seasonal methods
# In data science, a training set is a data set that is used to discover possible relationships. A test set is a data set that is used to verify the strength of these potential relationships. When you separate a data set into these parts, you generally allocate more of the data for training, and less for testing.
# 
# One function that can be used to create training and test sets is subset.ts(), which returns a subset of a time series where the optional start and end arguments are specified using index values.
# 
# > # x is a numerical vector or time series
#   > # To subset observations from 101 to 500
#   > train <- subset(x, start = 101, end = 500, ...)
# 
# > # To subset the first 500 observations
#   > train <- subset(x, end = 500, ...)
# As you saw in the video, another function, accuracy(), computes various forecast accuracy statistics given the forecasts and the corresponding actual observations. It is smart enough to find the relevant observations if you give it more than the ones you are forecasting.
# 
# > # f is an object of class "forecast"
#   > # x is a numerical vector or time series
#   > accuracy(f, x, ...)
# The accuracy measures provided include root mean squared error (RMSE) which is the square root of the mean squared error (MSE). Minimizing RMSE, which corresponds with increasing accuracy, is the same as minimizing MSE.
# 
# The pre-loaded time series gold comprises daily gold prices for 1108 days. Here, you'll use the first 1000 days as a training set, and compute forecasts for the remaining 108 days. These will be compared to the actual values for these days using the simple forcasting functions naive(), which you used earlier in this chapter, and meanf(), which gives forecasts equal to the mean of all observations. You'll have to specify the keyword h (which specifies the number of values you want to forecast) for both.
# 
# Instructions
# 100 XP
# Use subset() to create a training set for gold comprising the first 1000 observations. This will be called train.
# Compute forecasts of the test set, containing the remaining data, using naive() and assign this to naive_fc. Set h accordingly.
# Now, compute forecasts of the same test set using meanf() and assign this to mean_fc. Set h accordingly.
# Compare the forecast accuracy statistics of the two methods using the accuracy() function.
# Based on the above results, store the forecasts with the higher accuracy as bestforecasts.


# Create the training data as train
train <- subset(gold, end = 1000)

# Compute naive forecasts and save to naive_fc
naive_fc <- naive(train, h = length(gold)-1000)

# Compute mean forecasts and save to mean_fc
mean_fc <- meanf(train, h = length(gold)-1000)

# Use accuracy() to compute RMSE statistics
accuracy(naive_fc, gold)
accuracy(mean_fc, gold)

# Assign one of the two forecasts as bestforecasts
bestforecasts <- naive_fc



# Exercise
# Evaluating forecast accuracy of seasonal methods
# As you learned in the first chapter, the window() function specifies the start and end of a time series using the relevant times rather than the index values. Either of those two arguments can be formatted as a vector like c(year, period) which you have also previously used as an argument for ts(). Again, period refers to quarter here.
# 
# Here, you will use the Melbourne quarterly visitor numbers (vn[, "Melbourne"]) to create three different training sets, omitting the last 1, 2 and 3 years, respectively. Inspect the pre-loaded vn data in your console before beginning the exercise; this will help you determine the correct value to use for the keyword h (which specifies the number of values you want to forecast) in your forecasting methods.
# 
# Then for each training set, compute the next year of data, and finally compare the mean absolute percentage error (MAPE) of the forecasts using accuracy(). Why do you think that the MAPE vary so much?
#   
#   Instructions
# 100 XP
# Use window() to create three training sets from vn[,"Melbourne"], omitting the last 1, 2 and 3 years; call these train1, train2, and train3, respectively. Set the end keyword accordingly.
# Compute one year of forecasts for each training set using the snaive() method. Call these fc1, fc2, and fc3, respectively.
# Following the structure of the sample code, compare the MAPE of the three sets of forecasts using the accuracy() function as your test set.

data(vn, package = 'fpp')

# Create three training series omitting the last 1, 2, and 3 years
train1 <- window(vn[, "Melbourne"], end = c(2010, 4))
train2 <- window(vn[, "Melbourne"], end = c(2009, 4))
train3 <- window(vn[, "Melbourne"], end = c(2008, 4))

# Produce forecasts using snaive()
fc1 <- snaive(train1, h = 4)
fc2 <- snaive(train2, h = 4)
fc3 <- snaive(train3, h = 4)

# Use accuracy() to compare the MAPE of each series
accuracy(fc1, vn[, "Melbourne"])["Test set", "MAPE"]
accuracy(fc2, vn[, "Melbourne"])["Test set", "MAPE"]
accuracy(fc3, vn[, "Melbourne"])["Test set", "MAPE"]



# Do I have a good forecasting model?
#   Answer the question
# 50XP
# Possible Answers
# 
# Good forecast methods should have normally distributed residuals.
# press
# 1
# 
# A model with small residuals will give good forecasts.
# press
# 2
# 
# If your model doesn’t forecast well, you should make it more complicated.
# press
# 3
# 
# Where possible, try to find a model that has low RMSE on a test set and has white noise residuals.  <- answer
# press
# 4


# Exercise
# Using tsCV() for time series cross-validation
# The tsCV() function computes time series cross-validation errors. It requires you to specify the time series, the forecast method, and the forecast horizon. Here is the example used in the video:
#   
#   > e = tsCV(oil, forecastfunction = naive, h = 1)
# Here, you will use tsCV() to compute and plot the MSE values for up to 8 steps ahead, along with the naive() method applied to the goog data. The exercise uses ggplot2 graphics which you may not be familiar with, but we have provided enough of the code so you can work out the rest.
# 
# Be sure to reference the slides on tsCV() in the lecture. The goog data has been loaded into your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Using the goog data and forecasting with the naive() function, compute the cross-validated errors for up to 8 steps ahead. Assign this to e.
# Compute the MSE values for each forecast horizon and remove missing values in e by specifying the second argument. The expression for calculating MSE has been provided.
# Plot the resulting MSE values (y) against the forecast horizon (x). Think through your knowledge of functions. If MSE = mse is provided in the list of function arguments, then mse should refer to an object that exists in your workspace outside the function, whereas MSE is the variable that you refers to this object within your function.


# Compute cross-validated errors for up to 8 steps ahead
e <- tsCV(goog, forecastfunction = naive, h = 8)

# Compute the MSE values and remove missing values
mse <- colMeans(e^2, na.rm = T)

# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()
