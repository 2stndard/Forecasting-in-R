# Exercise
# Forecasting sales allowing for advertising expenditure
# Welcome to the last chapter of the course!
#   
#   The auto.arima() function will fit a dynamic regression model with ARIMA errors. The only change to how you used it previously is that you will now use the xreg argument containing a matrix of regression variables. Here are some code snippets from the video:
#   
#   > fit <- auto.arima(uschange[, "Consumption"],
#                       xreg = uschange[, "Income"])
# 
# > # rep(x, times)
#   > fcast <- forecast(fit, xreg = rep(0.8, 8))
# You can see that the data is set to the Consumption column of uschange, and the regression variable is the Income column. Furthermore, the rep() function in this case would replicate the value 0.8 exactly eight times for the matrix argument xreg.
# 
# In this exercise, you will model sales data regressed against advertising expenditure, with an ARMA error to account for any serial correlation in the regression errors. The data are available in your workspace as advert and comprise 24 months of sales and advertising expenditure for an automotive parts company. The plot shows sales vs advertising expenditure.
# 
# Think through everything you have learned so far in this course, inspect the advert data in your console, and read each instruction carefully to tackle this challenging exercise.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Plot the data in advert. The variables are on different scales, so use facets = TRUE.
# Fit a regression with ARIMA errors to advert by setting the first argument of auto.arima() to the "sales" column, second argument xreg to the "advert" column, and third argument stationary to TRUE.
# Check that the fitted model is a regression with AR(1) errors. What is the increase in sales for every unit increase in advertising? This coefficient is the third element in the coefficients() output.
# Forecast from the fitted model specifying the next 6 months of advertising expenditure as 10 units per month as fc. To repeat 10 six times, use the rep() function inside xreg like in the example code above.
# Plot the forecasts fc and fill in the provided code to add an x label "Month" and y label "Sales".


# Time plot of both variables
autoplot(advert, facets = T)

# Fit ARIMA model
fit <- auto.arima(advert[, 'sales'], xreg = advert[, 'advert'], stationary = T)

# Check model. Increase in sales for each unit increase in advertising
salesincrease <- coefficients(fit)[3]

# Forecast fit as fc
fc <- forecast(fit, xreg = rep(10, 6))

# Plot fc with x and y labels
autoplot(fc) + xlab('Month') + ylab('Sales')



# Exercise
# Forecasting electricity demand
# You can also model daily electricity demand as a function of temperature. As you may have seen on your electric bill, more electricity is used on hot days due to air conditioning and on cold days due to heating.
# 
# In this exercise, you will fit a quadratic regression model with an ARMA error. One year of daily data are stored as elec including total daily demand, an indicator variable for workdays (a workday is represented with 1, and a non-workday is represented with 0), and daily maximum temperatures. Because there is weekly seasonality, the frequency has been set to 7.
# 
# Let's take a look at the first three rows:
# 
# > elec[1:3, ]
#        Demand Temperature Workday
# [1,] 168.2798        20.2       0
# [2,] 183.0822        21.9       1
# [3,] 184.5135        25.1       1
# elec has been pre-loaded into your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Produce time plots of only the daily demand and maximum temperatures with facetting.
# Index elec accordingly to set up the matrix of regressors to include MaxTemp for the maximum temperatures, MaxTempSq which represents the squared value of the maximum temperature, and Workday, in that order. Clearly, the second argument of cbind() will require a simple mathematical operator.
# Fit a dynamic regression model of the demand column with ARIMA errors and call this fit.
# If the next day is a working day (indicator is 1) with maximum temperature forecast to be 20°C, what is the forecast demand? Fill out the appropriate values in cbind() for the xreg argument in forecast().


# Time plots of demand and temperatures
autoplot(elecdaily[, c('Demand', 'Temperature')], facets = T)

# Matrix of regressors
xreg <- cbind(MaxTemp = elecdaily[, "Temperature"], 
              MaxTempSq = (elecdaily[, 'Temperature'])^2, 
              Workday = elecdaily[, "WorkDay"])

# Fit model
fit <- auto.arima(elecdaily[, "Demand"], xreg = xreg)

# Forecast fit one day ahead
forecast(fit, xreg = cbind(20, sqrt(20), 1))



# Exercise
# Forecasting weekly data
# With weekly data, it is difficult to handle seasonality using ETS or ARIMA models as the seasonal length is too large (approximately 52). Instead, you can use harmonic regression which uses sines and cosines to model the seasonality.
# 
# The fourier() function makes it easy to generate the required harmonics. The higher the order (), the more "wiggly" the seasonal pattern is allowed to be. With , it is a simple sine curve. You can select the value of  by minimizing the AICc value. As you saw in the video, fourier() takes in a required time series, required number of Fourier terms to generate, and optional number of rows it needs to forecast:
#   
#   > # fourier(x, K, h = NULL)
#   
#   > fit <- auto.arima(cafe, xreg = fourier(cafe, K = 6),
#                       seasonal = FALSE, lambda = 0)
# > fit %>%
#   forecast(xreg = fourier(cafe, K = 6, h = 24)) %>%
#   autoplot() + ylim(1.6, 5.1)
# The pre-loaded gasoline data comprises weekly data on US finished motor gasoline products. In this exercise, you will fit a harmonic regression to this data set and forecast the next 3 years.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Set up an xreg matrix called harmonics using the fourier() method on gasoline with order K = 13  which has been chosen to minimize the AICc.
# Fit a dynamic regression model to fit. Set xreg equal to harmonics and seasonal to FALSE because seasonality is handled by the regressors.
# Set up a new xreg matrix called newharmonics in a similar fashion, and then compute forecasts for the next three years as fc.
# Finally, plot the forecasts fc.


# Set up harmonic regressors of order 13
harmonics <- fourier(gasoline, K = 13)

# Fit regression model with ARIMA errors
fit <- auto.arima(gasoline, xreg = harmonics, seasonal = FALSE)

# Forecasts next 3 years
newharmonics <- fourier(gasoline, K = 13, h = 156)
fc <- forecast(fit, xreg = newharmonics)

# Plot forecasts fc
autoplot(fc)



# Exercise
# Harmonic regression for multiple seasonality
# Harmonic regressions are also useful when time series have multiple seasonal patterns. For example, taylor contains half-hourly electricity demand in England and Wales over a few months in the year 2000. The seasonal periods are 48 (daily seasonality) and 7 x 48 = 336 (weekly seasonality). There is not enough data to consider annual seasonality.
# 
# auto.arima() would take a long time to fit a long time series such as this one, so instead you will fit a standard regression model with Fourier terms using the tslm() function. This is very similar to lm() but is designed to handle time series. With multiple seasonality, you need to specify the order  for each of the seasonal periods.
# 
# # The formula argument is a symbolic description
# # of the model to be fitted
# 
# > args(tslm)
# function (formula, ...)
#   tslm() is a newly introduced function, so you should be able to follow the pre-written code for the most part. The taylor data are loaded into your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Fit a harmonic regression called fit to taylor using order 10 for each type of seasonality.
# Forecast 20 working days ahead as fc. Remember that the data are half-hourly in order to set the correct value for h.
# Create a time plot of the forecasts.
# Check the residuals of your fitted model. As you can see, auto.arima() would have done a better job.


# Fit a harmonic regression using order 10 for each type of seasonality
fit <- tslm(taylor ~ fourier(taylor, K = c(10, 10)))

# Forecast 20 working days ahead
fc <- forecast(fit, newdata = data.frame(fourier(taylor, K = c(10,10), h = 20*48)))

# Plot the forecasts
autoplot(fc)

# Check the residuals of fit
checkresiduals(fit)




# Exercise
# Forecasting call bookings
# Another time series with multiple seasonal periods is calls, which contains 20 consecutive days of 5-minute call volume data for a large North American bank. There are 169 5-minute periods in a working day, and so the weekly seasonal frequency is 5 x 169 = 845. The weekly seasonality is relatively weak, so here you will just model daily seasonality. calls is pre-loaded into your workspace.
# 
# The residuals in this case still fail the white noise tests, but their autocorrelations are tiny, even though they are significant. This is because the series is so long. It is often unrealistic to have residuals that pass the tests for such long series. The effect of the remaining correlations on the forecasts will be negligible.
# 
# Instructions
# 100 XP
# Plot the calls data to see the strong daily seasonality and weak weekly seasonality.
# Set up the xreg matrix using order 10 for daily seasonality and 0 for weekly seasonality. Note that if you incorrectly specify your vector, your session may expire!
#   Fit a dynamic regression model called fit using auto.arima() with seasonal = FALSE and stationary = TRUE.
# Check the residuals of the fitted model.
# Create the forecasts for 10 working days ahead as fc, and then plot it. The exercise description should help you determine the proper value of h.


# Plot the calls data
autoplot(calls)

# Set up the xreg matrix
xreg <- fourier(calls, K = c(10,0))

# Fit a dynamic regression model
fit <- auto.arima(calls, xreg = xreg, seasonal = F, stationary = T)

# Check the residuals
checkresiduals(fit)

# Plot forecasts for 10 working days ahead
fc <- forecast(fit, xreg =  fourier(calls, c(10, 0), h = 10*169))
autoplot(fc)



# Exercise
# TBATS models for electricity demand
# As you saw in the video, a TBATS model is a special kind of time series model. It can be very slow to estimate, especially with multiple seasonal time series, so in this exercise you will try it on a simpler series to save time. Let's break down elements of a TBATS model in TBATS(1, {0,0}, -, {<51.18,14>}), one of the graph titles from the video:
# 
# Component	Meaning
# 1	Box-Cox transformation parameter
# {0,0}	ARMA error
# -	Damping parameter
# {\<51.18,14>}	Seasonal period, Fourier terms
# 
# 
# The gas data contains Australian monthly gas production. A plot of the data shows the variance has changed a lot over time, so it needs a transformation. The seasonality has also changed shape over time, and there is a strong trend. This makes it an ideal series to test the tbats() function which is designed to handle these features.
# 
# gas is available to use in your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Plot gas using the standard plotting function.
# Fit a TBATS model using the newly introduced method to the gas data as fit.
# Forecast the series for the next 5 years as fc.
# Plot the forecasts of fc. Inspect the graph title by reviewing the table above.
# Save the Box-Cox parameter to 3 decimal places and order of Fourier terms to lambda and K, respectively.


# Plot the gas data
autoplot(gas)

# Fit a TBATS model to the gas data
fit <- tbats(gas)

# Forecast the series for the next 5 years
fc <- forecast(fit, h = 5*12)

# Plot the forecasts
autoplot(fc)

# Record the Box-Cox parameter and the order of the Fourier terms
lambda <- 0.082
K <- 5


