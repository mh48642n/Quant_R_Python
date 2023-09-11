#Sets working directory
setwd("C:\\Users\\marvi\\OneDrive\\Documents")

answer = readline("Upload data(Say): Upload ")

if(answer == "Upload") {
  library(readxl)
  data <- read_excel(file.choose())
  attach(data)
}

library(dplyr)
library(scales)
data <- data %>% mutate(dates = as.Date(dates, format = "%Y-%m-%d"))
str(data)

#libraries needed to graph
#plotly for interactive 

library(ggplot2)
library(plotly)
library(ggthemes)
library(extrafont)

#fonts for the title and tooltip label
titlefont <-list(family = "Georgia",
                 size = 20,
                 color = "black")
axesfont <- list(family = "Georgia",
                 size = 14,
                 color = "black")
label <- list(text = template,
              bgcolor = "tan",
              bordercolor = "transparent",
              font = list(family = "Georgia",
                          size = 11,
                          color = "white"))

#2 yr yields are plotted here
two_year <- plot_ly(data, x = ~dates, y = ~Euro, mode = "lines", type = "scatter",name = "Euro", 
               line = list(color = "rgb(251,107,1)"))%>%
  add_trace(x = ~dates, y = ~spread_2yr, mode = "lines", type = "scatter", yaxis = "y2", 
            name = "2-yr yields", line = list(color = 'rgb(251,194,2)'))%>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))%>%
  style(hoverinfo = "skip", traces = c(1, 2))
  

#3 mth yields are plotted here
three_mo <- plot_ly(data, x = ~dates,y = ~Euro, mode = "lines", type = "scatter", name = "Euro", 
               line = list(color = 'rgb(251,107,1)'))%>%
  add_trace(x = ~dates, y = ~spread_3mth, mode = "lines", type = "scatter", yaxis = "y2", 
            name = "3-mth yields", line = list(color = 'rgb(251,194,2)')) %>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))%>%
  style(hoverinfo = "skip", traces = c(1, 2))        

yield_Treasury <- plot_ly(data, x = ~dates, y = ~yields_3mth, mode = "lines", type = "scatter", name = "3 mth yields", 
                  line = list(color = 'rgb(230, 126, 34)'))%>%
    add_trace(y = ~yields_2yr, mode = "lines", type = "scatter", name = "2 year yields", line = list(color = 'rgb(175, 96, 26)'))%>%
    add_trace(y = ~yields_5yr, mode = "lines", type = "scatter", name = "5 year yields", line = list(color = 'rgb(211, 84, 0)'))%>%
    add_trace(y = ~yields_7yr, mode = "lines", type = "scatter", name = "7 year yields",line = list(color = 'rgb(231, 76, 60)'))%>%
    add_trace(y = ~yields_10yr, mode = "lines", type = "scatter", name = "10 year yields",line = list(color = 'rgb(148, 49, 38)'))%>%
    add_trace(y = ~yields_30yr, mode = "lines", type = "scatter",name = "30 year yields" ,line = list(color = 'rgb(192, 57, 43)'))
#Added the other currencies
currencies_2yr <- function(value, choice){
     value <- formatting(value, choice)
     
     value <- value %>% add_trace(y = ~Yuan, name = 'Yuan', mode = "lines", 
                  type = "scatter", line = list(color = 'rgb(233,108,27)'))%>%
                  add_trace(y = ~Yen, name = 'Yen', mode = "lines", 
                  type = "scatter", line = list(color = 'rgb(255, 51, 51)'),
                  hoverinfo = 'text',
                  text = paste("Date: ", dates, 
                                "\nFor every dollar of US currency: ",
                                "\n    Euro: ", Euro,
                                "\n    Yuan: ", Yuan,
                                "\n    Yen: ", Yen,
                                "\n    Spread: ", spread_2yr,
                                "\nDuring the term of President ", 
                                current_President, "\nthe debt was at ", 
                                total_debt, "\nActions taken for the debt: ", 
                                action_taken, "\nPublic Law: ", public_law))%>%
                  layout(title = list(text = "Exchange Rates vs Spreads", font = titlefont))%>%
                  style(hoverinfo = "skip", traces = 3)         
                  
      return(value)
}
currencies_3mth <- function(value, choice){
  value <- formatting(value, choice)
  
  value <- value %>% add_trace(y = ~Yuan, name = 'Yuan', mode = "lines", 
                               type = "scatter", line = list(color = 'rgb(233,108,27)'))%>%
    add_trace(y = ~Yen, name = 'Yen', mode = "lines", 
              type = "scatter", line = list(color = 'rgb(255, 51, 51)'),
              hoverinfo = 'text',
              text = paste("Date: ", dates, 
                           "\nFor every dollar of US currency: ",
                           "\n    Euro: ", Euro,
                           "\n    Yuan: ", Yuan,
                           "\n    Yen: ", Yen,
                           "\n    Spread: ", spread_3mth,
                           "\nDuring the term of President ", 
                           current_President, "\nthe debt was at ", 
                           total_debt, "\nActions taken for the debt: ", 
                           action_taken, "\nPublic Law: ", public_law))%>%
    layout(title = list(text = "Exchange Rates vs Spreads", font = titlefont))%>%
    style(hoverinfo = "skip", traces = 3)         
  
  return(value)
}

#formatting graphs 
formatting <- function(value,choice){
  if(choice != "Yields"){
      title_text = "Exchange Rates over Time vs Spread"
      y_text = "Spot Exchange Rates(EUR, CNY, JPY)"
        }
  else{
    title_text = "Yields over Time"
    y_text = "All Yields"
  }
  #Rangeslider is operating !!!
  #Hovermode = "x unified" helps to make the data readable for all three lines
  value <- value %>%layout(plot_bgcolor = 'white',
                    paper_bgcolor = 'lightgray',  
                    xaxis = list(title = list(text = "Dates",
                                 font = axesfont), rangeslider = list(visible = T)),
                    yaxis = list(title = list(text = y_text,
                                 font = axesfont), showgrid = F),
                    hovermode = "x unified",
                    legend = list(orientation = "v", x = 100, y = 0.90,
                                  title=list(text='<b> Legend </b>', font = axesfont))
             )
  return(value)
}
#make either a case when or switch for yield chart and currency chart
  
#make sure to clear variables from r if reloading more than once
#or you'll have multiple yuan and yen titles in the legend
#Other than that both graphs are functional!!!
ty = readline("Enter a title: ")
two_year <- currencies(two_year) 
three_mo <- currencies(three_mo)

choice = readline("Yields or Exchange Rates(2-Year Spreads or 3-Month Spreads): ")
result = switch(
  choice,
  "2-Year Spreads" = print(currencies_2yr(two_year, choice)),
  "3-Month Spreads" = print(currencies_3mth(three_mo, choice)), 
  "Yields" = print(formatting(yield_Treasury, choice))
                )


#Wrap in loop and put readline in function call
save_graphs <- function(graph_){
      library(htmlwidgets)
      saveWidget(graph_, readline("Name of the file(end with .html): "))
}

rm(list = ls())
