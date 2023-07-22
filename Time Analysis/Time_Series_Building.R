#Sets working directory
setwd("C:\\Users\\marvi\\OneDrive\\Documents\\R")

#Finds data, attaches the data, and determines datatypes of data
library(readxl)
rates <- read_excel(file.choose())
yield <- read_excel(file.choose())
attach(rates)
str(rates)

#Here we are merging the two dataframes together to create one dataframe
#Also we are making this a excel file to make it more accesible for next time
library(writexl)
data <- merge(rates, yield, by = "dates")
write_xlsx(data, "C:\\Users\\marvi\\Onedrive\\Documents\\Dataset_yr&d.xlsx")

#Turns datatype of column date from POSIXct to
library(dplyr)
library(scales)
data <- data %>% 
  mutate(dates = as.Date(dates, format = "%Y-%m-%d"))

library(ggplot2)
library(plotly)
library(ggthemes)
library(extrafont)
#allYourFigureAreBelongToUs ggthemes for tha themes
fonts()
#Plots the euro rates to dates with a normal ggplot
#swap out rate for column name for Euro, Yuan or Yen and it should work
euro_rates <- ggplot(data, mapping = aes(date, euro)) + 
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
                 color = "black")
axesfont <- list(family = "Georgia",
                 size = 16,
                 color = "black")
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
           xaxis = list(rangeslider = list(visible = T)),
           yaxis = list(fixedrange = FALSE)
           )%>%
    style(hoverlabel = label)
fig  
#Saves the plot as a html file
library(htmlwidgets)
saveWidget(fig, "euro_rates_graph.html")

#Now we'll make an interactive graph with four rates at once

#Develops the buttons
#This right here WORKSSSS
B_Euro <- list(
      label = "Euro",
      method = "update",
      args = list(list(visible = c(TRUE, FALSE, FALSE, TRUE)))
      )
B_Yuan <- list(
      label = "Yuan",
      method = "update",
      args = list(list(visible = c(FALSE, TRUE, FALSE, TRUE)))
    )
B_Yen  <- list(
      label = "Yen",
      method = "update",
      args = list(list(visible = c(FALSE, FALSE, TRUE, TRUE)))
      )
B_All <- list(
    label = "All",
    method = "update",
    args = list(list(visible = c(TRUE, TRUE, TRUE, TRUE)))
    )
#Making other axes to make graph readable

#Plot with three lines: Euro, Yuan, and Yen  
viz1 <- plot_ly(data, x = ~dates,y = ~Euro, name = 'Euro', type = "scatter", mode = "lines", 
                line = list(color = 'rgb(255, 128, 0)'))%>% 
                add_trace(y = ~Yuan, name = 'Yuan', mode = "lines", 
                          type = "scatter", line = list(color = 'rgb(0, 128, 255)'))%>%
                add_trace(y = ~Yen, name = 'Yen', mode = "lines", 
                          type = "scatter", line = list(color = 'rgb(255, 51, 51)'))
#Buttons kind of work!!!
#Rangeslider is operating hella well!!!
#Hovermode = "x unified" helps to make the data readable for all three lines
#good up to this point, fix merge problem and that's it
viz2 <- viz1 %>% layout(plot_bgcolor = 'white',
                        paper_bgcolor = 'lightgray',  
                 updatemenus = list(
                        list(type = 'buttons',
                        direction = "up",
                        xanchor = 'right',
                        yanchor = 'top',
                        x = 1.25, y = 1, 
                        showactive = FALSE,
                        buttons = list(B_Euro, B_Yuan, B_Yen, B_All))
                        ),
                  xaxis = list(title = "Dates", 
                               rangeslider = list(visible = T)),
                  yaxis = list(title = "Spot Exchange Rates"),
                  hovermode = "x unified",
                  legend = list(orientation = "v", x = 100, y = 0.90,
                                title=list(text='<b> Legend </b>'))
                 )
viz2
#Adding a 2 plots with 4 lines so adding the yields to the 3 currency rates
yield_2y <- viz2 %>%  add_trace(data, x = ~dates, y = ~data$, yaxis2 = "y2",
                                name = "2yr Yields", mode = "lines",
                                line = list(color = 'rgb(2, 251, 115)'))
yield_2y <- yield_2y %>% layout(title = list(text ="Exchange Rates and 2yr Yields",
                                             font = titlefont),
                                yaxis2 = list(overlaying = "y",
                                              side = "right",
                                              title = "2yr Yields"
                                              )
                                )
library(htmlwidgets)
saveWidget(viz2, "Yields_Rates_&Dates.html")


rm(list = ls())