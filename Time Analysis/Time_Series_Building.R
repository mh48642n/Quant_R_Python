#Sets working directory
setwd("C:\\Users\\marvi\\OneDrive\\Documents")

answer = readline("Choose how to upload data(Get or Merge): ")

if(answer = "Get"){
  data <- make_table()
  attach(data)
}else{
  library(readxl)
  data <- read_excel(file.choose())
  attach(data)
}


#Pulls exchange_rates and yields from PC
#Merges them on dates
#It modifies the date datatype and creates a excel sheet and saves on pc
make_table <- function(){
  library(readxl)
  rates <- read_excel(file.choose())
  yield <- read_excel(file.choose())

  library(dplyr)
  library(scales)
  data <- merge(rates, yield, by = "dates") %>% 
    mutate(dates = as.Date(dates, format = "%Y-%m-%d"))
  
  str(data)
  
  library(writexl)
  write_xlsx(data, "C:\\Users\\marvi\\Onedrive\\Documents\\Dataset_yr&d.xlsx")
  
  return(data)
}

library(dplyr)

#libraries needed to graph
#plotly for interactive 
library(ggplot2)
library(plotly)
library(ggthemes)
library(extrafont)

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
    add_trace(x = ~date, y = ~rate)%>% 
    layout(title = list(text = 'Exchange Rates: US Dollars to Euro\n', 
                        font =titlefont, x = 0.0446, y = 10.5),
           xaxis = list(rangeslider = list(visible = T)),
           yaxis = list(fixedrange = FALSE)
           )%>%
    style(hoverlabel = label)
fig  
#Saves the plot as a html file
library(htmlwidgets)
saveWidget(fig, "euro_rates_graph.html")

#Now we'll make an interactive graph with three rates at once
viz0 <- plot_ly(data, x = ~dates,y = ~Euro, name = 'Euro', type = "scatter", mode = "lines", 
                line = list(color = 'rgb(255, 128, 0)'))%>% 
  add_trace(y = ~Yuan, name = 'Yuan', mode = "lines", 
            type = "scatter", line = list(color = 'rgb(0, 128, 255)'))%>%
  add_trace(y = ~Yen, name = 'Yen', mode = "lines", 
            type = "scatter", line = list(color = 'rgb(255, 51, 51)'))

#2 yr yields are plotted here
two_year <- plot_ly(data, x = ~dates, y = ~Euro, mode = "lines", type = "scatter",name = "Euro", 
               line = list(color = "rgb(251,107,1)"))%>%
  add_trace(x = ~dates, y = ~yields_2yr, mode = "lines", type = "scatter", yaxis = "y2", 
            name = "2-yr yields", line = list(color = 'rgb(251,194,2)'))%>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))

#3 mth yields are plotted here
three_mo <- plot_ly(data, x = ~dates,y = ~Euro, mode = "lines", type = "scatter", name = "Euro", 
               line = list(color = 'rgb(251,107,1)'))%>%
  add_trace(x = ~dates, y = ~yields_3mth, mode = "lines", type = "scatter", yaxis = "y2", 
            name = "3-mth yields", line = list(color = 'rgb(251,194,2)')) %>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))        


#Added the other currencies
currencies<- function(x, name_graph){
      x <- x %>% add_trace(y = ~Yuan, name = 'Yuan', mode = "lines", 
                  type = "scatter", line = list(color = 'rgb(233,108,27)'))%>%
                 add_trace(y = ~Yen, name = 'Yen', mode = "lines", 
                  type = "scatter", line = list(color = 'rgb(255, 51, 51)'))
      x <- formatting(x)
      return(x)
}
#formatting graphs 
formatting <- function(d, title_){
  #Buttons work!!!
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
  #Rangeslider is operating !!!
  #Hovermode = "x unified" helps to make the data readable for all three lines
  d <- d %>% layout(plot_bgcolor = 'white',
                    paper_bgcolor = 'lightgray',  
                    updatemenus = list(
                      list(type = 'buttons',
                           direction = "up",
                           xanchor = 'right',
                           yanchor = 'top',
                           x = 1.25, y = 1, 
                           showactive = T,
                           buttons = list(B_Euro, B_Yuan, B_Yen, B_All))
                    ),
                    title = list(text = title_,
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
  return(d)
}

#make sure to clear variables from r if reloading more than once
#or you'll have multiple yuan and yen titles in the legend
#Other than that both graphs are functional!!!
two_year <- currencies(two_year, readline("Title for the graph: ")) 
three_mo <- currencies(three_mo, readline("Title for the graph: "))

#Wrap in loop and put readline in function call
save_graphs <- function(p){
      library(htmlwidgets)
      
      saveWidget(p, readline("Name of the file(end with .html): "))
}



rm(list = ls())