#pulls data into program
library(readxl)
data <- read_excel(file.choose())
attach(data)
str(data)

#Make a data frame out of the dates, three yield rates, and change in public debt, cpi and unrate
cleaned <- data[, -c(2:6, 9:10, 12, 14:16, 18:19, 25:26)]
str(cleaned)

#make the percentage change in the yieldsr and debt, we have to eliminate the N/A values in the 
#dataframe to make it easier for arima to work
library(dplyr)
library(tidyr)
cleaned <- cleaned %>% fill(yields_3mth, yields_2yr, yields_10yr, total_debt, .direction = "downup") %>% 
  mutate(
    pct_3mth = ((lead(yields_3mth) / yields_3mth) - 1) *100, 
    pct_2yr = ((lead(yields_2yr) / yields_2yr) - 1) *100 ,
    pct_10yr = ((lead(yields_10yr) / yields_10yr) - 1) *100 ,
    pct_td = ((lead(total_debt) /total_debt) - 1) *100 
     )%>% 
  mutate(dates = as.Date(dates, format = "%Y-%m-%d"))
#work another way to keep dates after 05/23 so find yields for 10yr, 2yr and 3mth after 5/23
df <- df[complete.cases(df[, c(11:14)]), ]
#make use of the dataframe called clean from here on out
#make a plot between the change in public debt and the yields
library(ggplot2)
library(ggfortify)
library(xts)
library(forecast)

df <- xts(cleaned[, -c(1, 8:11)], order.by = data$dates)
df <- df %>% as.numeric(df)

autoplot(df[, c(7:10)], facets = TRUE) + xlab("Dates") +
  ylab(" ") + ggtitle("Daily changes in yields and public debt")
autoplot(df[, c(1:3, 6)], facets = TRUE) + xlab("Dates") + 
  ylab(" ") + ggtitle("Daily changes in yields and public debt")

fit <- auto.arima(df$pct_10yr, xreg = df$pct_td)
plot(checkresiduals(fit))


cor(data[, -c(1, 21:24, 27:30)], use = "complete.obs")
str(data)
which(!complete.cases(data))

#E_ is data object; 
E_ <- lm(Euro ~ NASDAQ + data$`S&P_1500` + unrate + core_cpi + log(total_debt) + log(public_held_debt), data = data)
summary(E_)

Y_ <- lm(Yuan ~ NASDAQ + data$`S&P_1500` + unrate + core_cpi + log(total_debt) + log(public_held_debt), data)
summary(Y_)

Yn_ <- lm(Yen ~ NASDAQ + data$`S&P_1500` + unrate + core_cpi + log(total_debt) + log(public_held_debt), data)
summary(Y_)



y3mth_ <- lm(yields_3mth ~ unrate + core_cpi + log(total_debt) + log(public_held_debt), data)
summary(y3mth_)

y2yr_ <- lm(yields_2yr ~ unrate + core_cpi + log(total_debt) + log(public_held_debt), data)
summary(y2yr_)

y10yr_ <- lm(yields_10yr ~ unrate + core_cpi + log(total_debt) + log(public_held_debt), data)
summary(y10yr_)

rm(list = ls())
