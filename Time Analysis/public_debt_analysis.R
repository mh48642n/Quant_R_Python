
cor(data[, -c(1, 21:24)], use = "complete.obs")

which(!complete.cases(data))

#E_ is data object; 
E_ <- lm(Euro ~ NASDAQ + data$`S&P_1500` + unrate + core_cpi + log(total_debt) + log(public_held_debt), data = data)
summary(E_)

Y_ <- lm(Yuan ~ NASDAQ + data$`S&P_1500` + unrate + core_cpi + log(total_debt) + log(public_held_debt), data)
summary(Y_)

Yn_ <- lm(Yen ~ NASDAQ + data$`S&P_1500` + unrate + core_cpi + log(total_debt) + log(public_held_debt), data)
summary(Y_)

rm(list = ls())