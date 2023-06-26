#Sets working directory
setwd("C:\\Users\\marvi\\OneDrive\\Documents\\R")

#Finds data, attaches the data, and determines datatypes of data
library(readxl)
data <- read_excel(file.choose())
attach(data)
str(data)

#Turns datatype of column date from POSIXct to
library(dplyr)
data <- data %>% 
  mutate(date = as.Date(date, format = "%Y-%m-%d"))

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
   geom_line(linewidth = 0.35, color = "orange") + 
   theme_economist_white() + labs(y = "US Dollars to One Euro\n") +
   theme(axis.title.y = element_text(family = "Georgia",
                                     face = "bold",
                                     colour = "lightblue",
                                     size = 10),
         axis.title.x = element_blank(),
         axis.text.x = element_text(size = 7.5, 
                                    angle = 45, 
                                    vjust = 0.65,
                                    family = "Arial"),
         axis.text.y = element_text(size = 7.5, 
                                    family = "Arial",
                                    hjust = 0)) +
   scale_x_date(breaks = "1 year", labels = date_format("%m/%Y"), 
                limits = as.Date(c('1999-01-04', '2023-05-25')), 
                expand = c(0, 0))
euro_rates
  
#fonts for the title and tooltip label
titlefont <-list(family = "Georgia",
                 size = 20,
                 color = "lightblue")
label <- list(bgcolor = "orange",
              bordercolor = "transparent",
              font = list(family = "Georgia",
                          size = 11,
                          color = "white"))

#Makes the graph interactive so you can trace mouse over plot line
#Added a range slider to find accurate dates
fig <- ggplotly(euro_rates, type = 'scatter', mode = 'line') %>% 
    add_trace(x = ~date, 
              y = ~rate
              )%>% 
    layout(title = list(text = 'Exchange Rates: US Dollars to Euro\n', 
                        font =titlefont,
                        x = 0.0446,
                        y = 10.5),
           xaxis = list(rangeslider = list(visible = T),
           yaxis = list(fixedrange = FALSE)
           ))%>%
    style(hoverlabel = label)
fig  
 
#Saves the plot as a html file
library(htmlwidgets)
saveWidget(fig, "euro_rates_graph.html")


rm(list = ls())