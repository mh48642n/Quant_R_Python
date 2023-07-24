#Sets working directory
setwd("C:\\Users\\marvi\\OneDrive\\Documents")

#Finds data, attaches the data, and determines datatypes of data
library(readxl)
rates <- read_excel(file.choose())
yield <- read_excel(file.choose())
attach(rates)#and yields
str(rates)

#Here we are merging the two dataframes together to create one dataframe
#Also we are making this a excel file to make it more accesible for next time
library(writexl)
data <- merge(rates, yield, by = "dates")
write_xlsx(data, "C:\\Users\\marvi\\Onedrive\\Documents\\Dataset_yr&d.xlsx")
data <- read_excel(file.choose())

#Turns datatype of column date from POSIXct to custom
#write this to the excel sheet
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

#Now we'll make an interactive graph with three rates at once
viz1 <- plot_ly(data, x = ~dates,y = ~Euro, name = 'Euro', type = "scatter", mode = "lines", 
                line = list(color = 'rgb(255, 128, 0)'))%>% 
  add_trace(y = ~Yuan, name = 'Yuan', mode = "lines", 
            type = "scatter", line = list(color = 'rgb(0, 128, 255)'))%>%
  add_trace(y = ~Yen, name = 'Yen', mode = "lines", 
            type = "scatter", line = list(color = 'rgb(255, 51, 51)'))

#Now we'll add the 10 year Treasury minus 2 year treasury yield curve with buttons

#Develops the buttons
#This right here WORKSSSS
B_Euro <- list(
      label = "Euro",
      method = "update",
      args = list(list(visible = c(TRUE, TRUE, FALSE, FALSE)))
      )
B_Yuan <- list(
      label = "Yuan",
      method = "update",
      args = list(list(visible = c(FALSE, TRUE, TRUE, FALSE)))
    )
B_Yen  <- list(
      label = "Yen",
      method = "update",
      args = list(list(visible = c(FALSE, TRUE, FALSE, TRUE)))
      )
B_All <- list(
    label = "All",
    method = "update",
    args = list(list(visible = c(TRUE, TRUE, TRUE, TRUE)))
    )
#Making other axes to make graph readable
y2 <- list(
  side = "right",
  anchor = "free",
  position = 1,
  title = "2yr Yields")


#Second Y axis is established!!!!
viz <- plot_ly(data, x = ~dates, y = ~Euro, mode = "lines", type = "scatter",name = "Euro", line = list(color = "rgb(251,107,1)"))%>%
  add_trace(x = ~dates, y = ~data$`2-yr yields`, mode = "lines", type = "scatter", yaxis = "y2", 
            name = "2yr yields", line = list(color = 'rgb(251,194,2)'))%>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))

#Added the other currencies
viz <- viz %>% add_trace(y = ~Yuan, name = 'Yuan', mode = "lines", 
                  type = "scatter", line = list(color = 'rgb(233,108,27)'))%>%
               add_trace(y = ~Yen, name = 'Yen', mode = "lines", 
                  type = "scatter", line = list(color = 'rgb(255, 51, 51)'))

#Buttons work!!!
#Rangeslider is operating !!!
#Hovermode = "x unified" helps to make the data readable for all three lines
viz <- viz %>% layout(plot_bgcolor = 'white',
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
                     title = list(text ="Exchange Rates and 2yr Yields",
                                  font = titlefont),
                     xaxis = list(title = list(text = "Dates",
                                               font = axesfont),
                                  rangeslider = list(visible = T)),
                     yaxis = list(title = list(text = "Spot Exchange Rates",
                                          font = axesfont)
                                          ,showgrid = F),
                     hovermode = "x unified",
                     legend = list(orientation = "v", x = 100, y = 0.90,
                                   title=list(text='<b> Legend </b>',
                                              font = axesfont))
                )

library(htmlwidgets)
saveWidget(viz, "twoYr_yields_&_currencies.html")

#Now we'll build the graph with three currencies and 10 yr - 3 mth treasuries

rm(list = ls())