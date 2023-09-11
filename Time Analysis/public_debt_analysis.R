#Running correlations between different currencies and yield spreads
cor(data[, -c(1, 7, 8)], use = "complete.obs")

#Running correlations between currencies and the rise and fall of the indexes
cor(data[, -c(1)], use = "complete.obs")

#Running correlations between currencies and the yields of 3 different maturities
cor(data[, -c(1, 8:11)], use = "complete.obs")

#Running correlations between currencies, maturities and spreads
cor(data[, -c(1, 10:11)], use = "complete.obs")

#Running correlations between indexes and yields
cor(data[, -c(1, 5:9)], use = "complete.obs")

