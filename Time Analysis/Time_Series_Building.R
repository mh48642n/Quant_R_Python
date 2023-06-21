#Sets working directory
setwd("C:\\Users\\marvi\\OneDrive\\Documents\\R")

#Finds data, attaches the data, and determines datatypes of data
library(readxl)
data <- read_excel(file.choose())
attach(data)
str(data)

#Turns datatype of column date from POSIXct to
data <- data %>% 
  mutate(date = as.Date(date, format = "%Y-%m-%d"))

library(dplyr)
library(ggplot2)
library(plotly)
library(scales)
library(ggthemes)
library(extrafont)
#allYourFigureAreBelongToUs ggthemes for tha themes

font_import()
fonts()

#Plots the euro rates to dates with a normal ggplot
euro_rates <- ggplot(data, mapping = aes(date, rate)) + 
   geom_line(linewidth = 0.05, color = "orange") + 
   theme_economist() +
   theme(axis.title.x = element_blank(),
         axis.text.x = element_text(size = 9.5, angle = 45, vjust = 0.7),
         axis.title.y = element_text(size = 12,hjust = 0.5, vjust = 0),
         axis.text.y = element_text(size = 9.5, vjust = 0.7),
         plot.title = element_text(face = "bold", color = "white", size = 15),
         plot.subtitle = element_text(size = 10, color = "black", hjust = 0), 
         axis.title = element_text()) +
   scale_x_date(breaks = "1 year", labels = date_format("%m/%Y")) 
euro_rates
  
#Makes the graph interactive so you can trace mouse over plot line
#Added a range slider to find accurate dates
#fix this font changes so shift font stuff to plotly function, subtitle and caption are gone as well
fig <- ggplotly(euro_rates) %>% 
    add_trace(x = ~date, 
              y = ~rate 
              )%>% 
    layout(showlegend = F, 
           xaxis = list(rangeslider = list(visible = T),
           title = list(color = "white",
                        text = "Exchange Rates: US Dollars to Euro",
                        family = "Goudy Old Style"
                        ))
           )   
fig

library(htmlwidgets)
saveWidget(fig, "Euro_rates.html")


rm(list = ls())