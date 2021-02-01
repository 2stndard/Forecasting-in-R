# Exercise
# Box-Cox transformations for time series
# Here, you will use a Box-Cox transformation to stabilize the variance of the pre-loaded a10 series, which contains monthly anti-diabetic drug sales in Australia from 1991-2008.
# 
# In this exercise, you will need to experiment to see the effect of the lambda () argument on the transformation. Notice that small changes in  make little difference to the resulting series. You want to find a value of  that makes the seasonal fluctuations of roughly the same size across the series.
# 
# Recall from the video that the recommended range for lambda values is .
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Plot the a10 series and observe the increasing variance as the level of the series increases.
# Try transforming the series using BoxCox() in the format of the sample code. Experiment with four values of lambda: 0.0, 0.1, 0.2, and 0.3. Can you determine which lambda value approximately stabilizes the variance?
#   Now compare your chosen value of lambda with the one returned by BoxCox.lambda().


# Plot the series
autoplot(a10)

# Try four values of lambda in Box-Cox transformations
a10 %>% BoxCox(lambda = 0.0) %>% autoplot()
a10 %>% BoxCox(lambda = 0.1) %>% autoplot()
a10 %>% BoxCox(lambda = 0.2) %>% autoplot()
a10 %>% BoxCox(lambda = 0.3) %>% autoplot()

# Compare with BoxCox.lambda()
BoxCox.lambda(a10)



# Exercise
# Non-seasonal differencing for stationarity
# Differencing is a way of making a time series stationary; this means that you remove any systematic patterns such as trend and seasonality from the data. A white noise series is considered a special case of a stationary time series.
# 
# With non-seasonal data, you use lag-1 differences to model changes between observations rather than the observations directly. You have done this before by using the diff() function.
# 
# In this exercise, you will use the pre-loaded wmurders data, which contains the annual female murder rate in the US from 1950-2004.
# 
# Instructions
# 100 XP
# Plot the wmurders data and observe how it has changed over time.
# Now, plot the annual changes in the murder rate using the function mentioned above and observe that these are much more stable.
# Finally, plot the ACF of the changes in murder rate using a function that you learned in the first chapter.


# Plot the US female murder rate
autoplot(wmurders)

# Plot the differenced murder rate
autoplot(diff(wmurders))

# Plot the ACF of the differenced murder rate
ggAcf(diff(wmurders))



# Exercise
# Seasonal differencing for stationarity
# With seasonal data, differences are often taken between observations in the same season of consecutive years, rather than in consecutive periods. For example, with quarterly data, one would take the difference between Q1 in one year and Q1 in the previous year. This is called seasonal differencing.
# 
# Sometimes you need to apply both seasonal differences and lag-1 differences to the same series, thus, calculating the differences in the differences.
# 
# In this exercise, you will use differencing and transformations simultaneously to make a time series look stationary. The data set here is h02, which contains 17 years of monthly corticosteroid drug sales in Australia. It has been loaded into your workspace.
# 
# Instructions
# 100 XP
# Plot the data to observe the trend and seasonality.
# Take the log() of the h02 data and then apply seasonal differencing by using an appropriate lag value in diff(). Assign this to difflogh02.
# Plot the resulting logged and differenced data.
# Because difflogh02 still looks non-stationary, take another lag-1 difference by applying diff() to itself and save this to ddifflogh02. Plot the resulting series.
# Plot the ACF of the final ddifflogh02 series using the appropriate function.


# Plot the data
autoplot(h02)

# Take logs and seasonal differences of h02
difflogh02 <- diff(log(h02), lag = 12)

# Plot difflogh02
autoplot(difflogh02)

# Take another difference and plot
ddifflogh02 <- diff(difflogh02, lag = 1)
autoplot(ddifflogh02)

# Plot ACF of ddifflogh02
ggAcf(ddifflogh02)



# Exercise
# Automatic ARIMA models for non-seasonal time series
# In the video, you learned that the auto.arima() function will select an appropriate autoregressive integrated moving average (ARIMA) model given a time series, just like the ets() function does for ETS models. The summary() function can provide some additional insights:
#   
#   > # p = 2, d = 1, p = 2
#   > summary(fit)
# 
# Series: usnetelec
# ARIMA(2,1,2) with drift
# ...
# In this exercise, you will automatically choose an ARIMA model for the pre-loaded austa series, which contains the annual number of international visitors to Australia from 1980-2015. You will then check the residuals (recall that a p-value greater than 0.05 indicates that the data resembles white noise) and produce some forecasts. Other than the modelling function, this is identicial to what you did with ETS forecasting.
# 
# Instructions
# 100 XP
# Fit an automatic ARIMA model to the austa series using the newly introduced function. Save this to fit.
# Use the appropriate function to check that the residuals of the resulting model look like white noise. Assign TRUE (if the residuals look like white noise) or FALSE (if they don't) to residualsok.
# Apply summary() to the model to see the fitted coefficients.
# Based on the results using summary(), what is the AICc value to two decimal places? How many differences were used? Assign these to AICc and d, respectively.
# Finally, using the pipe operator, plot forecasts of the next 10 periods from the chosen model.



# Fit an automatic ARIMA model to the austa series
fit <- auto.arima(austa)

# Check that the residuals look like white noise
checkresiduals(fit)
residualsok <- TRUE

# Summarize the model
summary(fit)

# Find the AICc value and the number of differences used
AICc <- -14.46
d <- 1

# Plot forecasts of fit
fit %>% forecast(h = 10) %>% autoplot()



# Exercise
# Forecasting with ARIMA models
# The automatic method in the previous exercise chose an ARIMA(0,1,1) with drift model for the austa data, that is,  You will now experiment with various other ARIMA models for the data to see what difference it makes to the forecasts.
# 
# The Arima() function can be used to select a specific ARIMA model. Its first argument, order, is set to a vector that specifies the values of ,  and . The second argument, include.constant, is a booolean that determines if the constant , or drift, should be included. Below is an example of a pipe function that would plot forecasts of usnetelec from an ARIMA(2,1,2) model with drift:
#   
#   > usnetelec %>%
#   Arima(order = c(2,1,2), include.constant = TRUE) %>%
#   forecast() %>%
#   autoplot()
# In the examples here, watch for how the different models affect the forecasts and the prediction intervals. The austa data is ready for you to use in your workspace.
# 
# Instructions
# 100 XP
# Plot forecasts from an ARIMA(0,1,1) model with no drift.
# Plot forecasts from an ARIMA(2,1,3) model with drift.
# Plot forecasts from an ARIMA(0,0,1) model with a constant.
# Plot forecasts from an ARIMA(0,2,1) model with no constant.


# Plot forecasts from an ARIMA(0,1,1) model with no drift
austa %>% Arima(order = c(0, 1, 1), include.constant = F) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(2,1,3) model with drift
austa %>% Arima(order = c(2, 1, 3), include.constant = T) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(0,0,1) model with a constant
austa %>% Arima(order = c(0, 0, 1), include.constant = T) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(0,2,1) model with no constant
austa %>% Arima(order = c(0, 2, 1), include.constant = F) %>% forecast() %>% autoplot()



# Exercise
# Comparing auto.arima() and ets() on non-seasonal data
# The AICc statistic is useful for selecting between models in the same class. For example, you can use it to select an ETS model or to select an ARIMA model. However, you cannot use it to compare ETS and ARIMA models because they are in different model classes.
# 
# Instead, you can use time series cross-validation to compare an ARIMA model and an ETS model on the austa data. Because tsCV() requires functions that return forecast objects, you will set up some simple functions that fit the models and return the forecasts. The arguments of tsCV() are a time series, forecast function, and forecast horizon h. Examine this code snippet from the second chapter:
#   
#   e <- matrix(NA_real_, nrow = 1000, ncol = 8)
# for (h in 1:8)
#   e[, h] <- tsCV(goog, naive, h = h)
# ...
# Furthermore, recall that pipe operators in R take the value of whatever is on the left and pass it as an argument to whatever is on the right, step by step, from left to right. Here's an example based on code you saw in an earlier chapter:
# 
# # Plot 20-year forecasts of the lynx series modeled by ets()
# lynx %>% ets() %>% forecast(h = 20) %>% autoplot()
# In this exercise, you will compare the MSE of two forecast functions applied to austa, and plot forecasts of the function that computes the best forecasts. Once again, austa has been loaded into your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Fill in the farima() function to forecast the results of auto.arima(). Follow the structure of the pre-written code in fets() that does the same for ets().
# Compute cross-validated errors for ETS models on austa using tsCV() with one-step errors, and save this to e1.
# Compute cross-validated errors for ARIMA models on austa using tsCV() with one-step errors, and save this to e2.
# Compute the cross-validated MSE for each model class and remove missing values. Refer to the previous chapter if you cannot remember how to calculate MSE.
# Produce and plot 10-year forecasts of future values of austa using the best model class.


# Set up forecast functions for ETS and ARIMA models
fets <- function(x, h) {
  forecast(ets(x), h = h)
}
farima <- function(x, h) {
  forecast(auto.arima(x), h = h)
}

# Compute CV errors for ETS on austa as e1
e1 <- tsCV(austa, fets, h = 1)

# Compute CV errors for ARIMA on austa as e2
e2 <- tsCV(austa, farima, h = 1)

# Find MSE of each model class
mean(e1^2, na.rm = T)
mean(e2^2, na.rm = T)

# Plot 10-year forecasts using the best model class
austa %>% farima(h = 10) %>% autoplot()


# Exercise
# Automatic ARIMA models for seasonal time series
# As you learned in the video, the auto.arima() function also works with seasonal data. Note that setting lambda = 0 in the auto.arima() function - applying a log transformation - means that the model will be fitted to the transformed data, and that the forecasts will be back-transformed onto the original scale.
# 
# After applying summary() to this kind of fitted model, you may see something like the output below which corresponds with :
#   
#   ARIMA(0,1,4)(0,1,1)[12]
# In this exercise, you will use these functions to model and forecast the pre-loaded h02 data, which contains monthly sales of cortecosteroid drugs in Australia.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Using the standard plotting function, plot the logged h02 data to check that it has stable variance.
# Fit a seasonal ARIMA model to the h02 series with lambda = 0. Save this to fit.
# Summarize the fitted model using the appropriate method.
# What levels of differencing were used in the model? Assign the amount of lag-1 differencing to d and seasonal differencing to D.
# Plot forecasts for the next 2 years by using the fitted model. Set h accordingly.


# Check that the logged h02 data have stable variance
h02 %>% log() %>% autoplot()

# Fit a seasonal ARIMA model to h02 with lambda = 0
fit <- auto.arima(h02, lambda = 0)

# Summarize the fitted model
summary(fit)

# Record the amount of lag-1 differencing and seasonal differencing used
d <- 1
D <- 1

# Plot 2-year forecasts
fit %>% forecast(h = 24) %>% autoplot()



# Exercise
# Exploring auto.arima() options
# The auto.arima() function needs to estimate a lot of different models, and various short-cuts are used to try to make the function as fast as possible. This can cause a model to be returned which does not actually have the smallest AICc value. To make auto.arima() work harder to find a good model, add the optional argument stepwise = FALSE to look at a much larger collection of models.
# 
# Here, you will try finding an ARIMA model for the pre-loaded euretail data, which contains quarterly retail trade in the Euro area from 1996-2011. Inspect it in the console before beginning this exercise.
# 
# Instructions
# 100 XP
# Use the default options in auto.arima() to find an ARIMA model for euretail and save this to fit1.
# Use auto.arima() without a stepwise search to find an ARIMA model for euretail and save this to fit2.
# Run summary() for both fit1 and fit2 in your console, and use this to determine the better model. To 2 decimal places, what is its AICc value? Assign the number to AICc.
# Finally, using the better model based on AICc, plot its 2-year forecasts. Set h accordingly.


# Find an ARIMA model for euretail
fit1 <- auto.arima(euretail)
summary(fit1)
# Don't use a stepwise search
fit2 <- auto.arima(euretail, stepwise = FALSE)
summary(fit2)
# AICc of better model
AICc <- 68.39

# Compute 2-year forecasts from better model
fit2 %>% forecast(h = 8) %>% autoplot()




# Exercise
# Comparing auto.arima() and ets() on seasonal data
# What happens when you want to create training and test sets for data that is more frequent than yearly? If needed, you can use a vector in form c(year, period) for the start and/or end keywords in the window() function. You must also ensure that you're using the appropriate values of h in forecasting functions. Recall that h should be equal to the length of the data that makes up your test set.
# 
# For example, if your data spans 15 years, your training set consists of the first 10 years, and you intend to forecast the last 5 years of data, you would use h = 12 * 5 not h = 5 because your test set would include 60 monthly observations. If instead your training set consists of the first 9.5 years and you want forecast the last 5.5 years, you would use h = 66 to account for the extra 6 months.
# 
# In the final exercise for this chapter, you will compare seasonal ARIMA and ETS models applied to the quarterly cement production data qcement. Because the series is very long, you can afford to use a training and test set rather than time series cross-validation. This is much faster.
# 
# The qcement data is available to use in your workspace.
# 
# Instructions
# 100 XP
# Create a training set called train consisting of 20 years of qcement data beginning in the year 1988 and ending at the last quarter of 2007; you must use a vector for end. The remaining data is your test set.
# Fit ARIMA and ETS models to the training data and save these to fit1 and fit2, respectively.
# Just as you have done with previous exercises, check that both models have white noise residuals.
# Produce forecasts for the remaining data from both models as fc1 and fc2, respectively. Set h to the number of total quarters in your test set. Be careful- the last observation in qcement is not the final quarter of the year!
# Using the accuracy() function, find the better model based on the RMSE value, and save it as bettermodel.


# Use 20 years of the qcement data beginning in 1988
train <- window(qcement, start = c(1988, 1), end = c(2007, 4))

# Fit an ARIMA and an ETS model to the training data
fit1 <- auto.arima(train)
fit2 <- ets(train)

# Check that both models have white noise residuals
checkresiduals(fit1)
checkresiduals(fit2)

# Produce forecasts for each model
fc1 <- forecast(fit1, h = 25)
fc2 <- forecast(fit2, h = 25)

# Use accuracy() to find better model based on RMSE
accuracy(fc1, qcement)
accuracy(fc2, qcement)
bettermodel <- fit2




