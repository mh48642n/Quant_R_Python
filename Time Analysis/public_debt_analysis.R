#pulls data into program
library(readxl)
data <- read_excel(file.choose())
attach(data)
str(data)

#running correlation matrix to see what makes each of these
cor(data[, c(7,8,11, 14, 17, 20)], use = "complete.obs")
data <- as.data.frame(data)
str(data)
which(!complete.cases(data))

library(olsrr)
library(lmtest)
library(sandwich)
library(car)

y3mth_ <- lm(yields_3mth ~ unrate + core_cpi + log(total_debt), data)
summary(y3mth_)
ols_test_breusch_pagan(y3mth_)
y3mth_rb <- coeftest(y3mth_, vcov = vcovHC(y10yr_, "HC1"))
vif(y3mth_)

y2yr_ <- lm(yields_2yr ~ unrate + core_cpi + log(total_debt), data)
summary(y2yr_)
ols_test_breusch_pagan(y2yr_)
y2yr_rb<- coeftest(y2yr_, vcov = vcovHC(y10yr_, "HC1"))
vif(y2yr_)

y10yr_ <- lm(yields_10yr ~ unrate + core_cpi + log(total_debt), data)
summary(y10yr_)
ols_test_breusch_pagan(y10yr_)
vif(y10yr_)


#Make a data frame out of the dates, three yield rates, and change in public debt, cpi and unrate
cleaned <- data[, -c(2:6, 9:10, 12, 14:16, 18:19, 25:26)]
str(cleaned)

#make the percentage change in the yieldsr and debt, we have to eliminate the N/A values in the 
#dataframe to make it easier for arima to work
library(dplyr)
library(tidyr)

data <- data %>%    
  mutate(
    pct_3mth = ((lead(yields_3mth) / yields_3mth) - 1) *100, 
    pct_2yr = ((lead(yields_2yr) / yields_2yr) - 1) *100 ,
    pct_10yr = ((lead(yields_10yr) / yields_10yr) - 1) *100 ,
    pct_td = ((lead(total_debt) /total_debt) - 1) *100 
     )%>% 
  mutate(dates = as.Date(dates, format = "%Y-%m-%d"))
#make use of the dataframe called clean from here on out
#make a plot between the change in public debt and the yields
library(ggplot2)
library(ggfortify)
library(xts)
library(forecast)

df <- xts(data[, c( 7, 8, 11, 14, 17, 20, 27:30)], order.by = data$dates)
df <- df %>% as.numeric(df)
df[is.na(df)| df == "Inf"] = NA

autoplot(df[, c(7:10)], facets = TRUE) + xlab("Dates") +
  ylab(" ") + ggtitle("Daily percent changes in yields and public debt")
autoplot(df[, c(1:3, 6)], facets = TRUE) + xlab("Dates") + 
  ylab(" ") + ggtitle("Daily changes in yields and public debt")

fit <- auto.arima(df$pct_10yr, xreg = df$pct_td)
fit1 <- auto.arima(diff(df$pct_2yr), xreg = df$pct_td)
fit2 <- auto.arima(df$pct_3mth,xreg = df$pct_td)

plot(checkresiduals(fit))
plot(checkresiduals(fit1))
plot(checkresiduals(fit2))


#formatting the regressions and tables
library(stargazer)

y2yr_se <- y2yr_rb[, 2]
y3mth_se <- y3mth_rb[, 2]

sum_stats <- summary(interest)

df_corr <- as.data.frame(cor(data[, c(7,8,11,14,17,20)]))

stargazer(df_corr, type = "html", coavariate.labels = c("3-mth Yields", "2-yr Yields", "10-yr Yields ", "Core CPI", "Unemployment Rate", "Total Debt"),
          title = "Correlation Matrix", out = "corr_mat.html")
stargazer(data[, c(14,17,25,26)], type = "html", covariate.labels = c("3-mth Yields", "2-yr Yields", "10-yr Yields ", "Core CPI", "Unemployment Rate", "Total Debt"), 
          title = "Descriptive Statistics", out = "sum_diff_stats.html", flip = TRUE)
stargazer(y10yr_, y2yr_, y2yr_, y3mth_, y3mth_, type = "html",se = list(NULL, NULL, y2yr_se, NULL, y3mth_se) , title = "Regressions of Yields on Debt",
          dep.var.labels = c("10-year Yields", "2-year Yields","3-month Yields"),
          covariate.labels = c("Unemployment Rate", "Core CPI", "Total Debt(% change)"),
          digits = 2, out = "ytd.docx")
stargazer(xf, title = "Auto.arima results" , type = "html",
          dep.var.caption = "10 yr")
#Here we determine the ARs and MAs for the arima regressions

#acf plots and updated arima regression models: 10yr
par(mfrow = c(1, 2))
acf_10 <- Acf(df$pct_10yr, lag.max = 12, type = "correlation", plot = TRUE, calc.ci = TRUE)#stops after 4
pacf_10 <- Acf(df$pct_10yr, lag.max = 12, type = "partial", plot = TRUE, calc.ci = TRUE)#stops after 4 

x1 <- Arima(df$pct_10yr, xreg = df$pct_td, order = c(2, 0, 0))
xf <- Arima(df$pct_10yr, xreg = df$pct_td, order = c(1, 0, 1))

f_cast <- forecast(x1, xreg = df$pct_td, 50) 
autoplot(f_cast) + ylab("Change in Yields") 

#acf plots and updated arima regression models: 2yr
acf_02 <- Acf(df$pct_2yr, lag.max = 12, type = "correlation", plot = TRUE, calc.ci = TRUE)#dies at 1
pacf_02 <- Acf(df$pct_2yr, lag.max = 12, type = "partial", plot = TRUE, calc.ci = TRUE)#stops after 1 

y1 <- Arima(df$pct_2yr, xreg = df$pct_td, order = c(5, 0, 0))
yf <- Arima(df$pct_2yr, xreg = df$pct_td, order = c(2, 0, 0))

f_cast0 <- forecast(yf, xreg = df$pct_td, 50)
autoplot(f_cast0) + ylab


#acf plots and updated arima regression models: 3mth
acf_03 <- Acf(df$pct_3mth, lag.max = 12, type = "correlation", plot = TRUE, calc.ci = TRUE)#dies at 1
pacf_03 <- Acf(df$pct_3mth, lag.max = 12, type = "partial", plot = TRUE, calc.ci = TRUE)#stops after 1 

z1 <- Arima(df$pct_3mth, xreg = df$pct_td, order = c(1, 0, 0))
zf <- Arima(df$pct_3mth, xreg = df$pct_td, order = c(2, 0, 0))

par(mfrow = c(1, 1))

help(stargazer)

rm(list = ls())
