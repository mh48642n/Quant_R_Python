#Sets working directory
setwd("C:\\Users\\marvi\\OneDrive\\Documents\\R")

#Finds data, attaches the data, and determines datatypes of data
library(readxl)
data <- read_excel(file.choose())
attach(data)
str(data)
ranges_ <- c("1999", "2001", "2003", "2005", "2007", "2009", "2011", "2013", "2015", "2017",
  "2019", "2021" ,"2023")


library(ggplot2)
library(plotly)
#plots the euro rates
euro_rates <- ggplot(data, mapping = aes(date, rate)) + 
   geom_line(size = 0.5, color = "green") +
   theme_gray() + labs(x = "Years", y = "Rates") +
   theme(axis.title.x = element_text(size = "9")) +
   theme(axis.title.y = element_text(size = "11"))
   theme(axis.text = element_text(size = 10)) +
   scale_x_date(breaks = as.Date(ranges_))
euro_rates
  
#Makes the graph interactive so you can trace mouse over plot line
#set scatter mode next time to see what happens
fig <- ggplotly(euro_rates) %>% add_trace(x = ~date, y = ~rate)%>% 
      layout(showlegend = F)
fig

rm(list = ls())