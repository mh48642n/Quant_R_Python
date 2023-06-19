#Sets working directory
setwd("C:\\Users\\marvi\\OneDrive\\Documents\\R")

#Finds data, attaches the data, and determines datatypes of data
library(readxl)
data <- read_excel(file.choose())
attach(data)
str(data)

library(ggplot2)
library(plotly)
library(scales)

#Plots the euro rates to dates with a normal ggplot
euro_rates <- ggplot(data, mapping = aes(date, rate)) + 
   geom_line(size = 0.5, color = "green")+ 
   theme_gray() + labs(x = "Years", y = "Rates") +
   theme(axis.title.x = element_text(size = "9")) +
   theme(axis.title.y = element_text(size = "11")) +
   theme(axis.text = element_text(size = 10))
euro_rates
  
#Makes the graph interactive so you can trace mouse over plot line
#Added a range slider to find accurate dates
fig <- ggplotly(euro_rates) %>% add_trace(x = ~date, y = ~rate)%>% 
    layout(showlegend = F, xaxis = list(rangeslider = list(visible = T)))
      
fig

rm(list = ls())