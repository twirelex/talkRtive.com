#### Question5

library(astsa)

birth_data <- astsa::birth

# Make dataset a time series data and plot 

birth_ts <- ts(birth_data)

plot(birth_ts)

# There is no obvious trend in the data looking at the plot but there appears to be seasonality. 

birth_ts_diff <- diff(birth_ts) # apply differencing on the data to get rid of seasonality

plot(birth_ts_diff) # Now we have a seasonality free data

# we can confirm that the data is no longer seasonal by looking at its mean

mean(birth_ts_diff) # near zero mean

# Now let's look at acf and pacf plots to determine the type of model to fit 

acf2(birth_ts_diff)

# based on the plots we have (1,1,0)(1,1,1)12

model <- sarima(birth_ts, 1,1,0,1,1,1,12)

model


##### print and plot your predictions for the next six time preriod  

sarima.for(birth_ts,6, 1,1,0,1,1,1,12)



