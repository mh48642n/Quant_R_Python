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
library(zoo)
total_debt_ <- fortify.zoo(na.locf(zoo(total_debt), na.rm = FALSE))
total_debt_ <- total_debt_[, 2]
actions <- subset(data, action_taken == 'Raised Debt Ceiling' | action_taken == 'Suspend Debt Ceiling', 
                  select = c('dates', 'total_debt'))
actions <- as.data.frame(actions)
actions["action_dates"] <- actions$dates
actions["debt_ceiling_now"] <- actions$total_debt

data <- data %>% mutate(dates = as.Date(dates, format = "%Y-%m-%d"))%>% 
  mutate(debt_no_nas = total_debt_)#instead make a column called total debt with no nas 
data <- merge(x = data, y = actions, by = "dates", all.x=TRUE)

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
label <- list(bgcolor = "tan",
              bordercolor = "transparent",
              font = list(family = "Georgia",
                          size = 11,
                          color = "white"))

#Market against the currencies
sp <- plot_ly(data, x = ~dates, y = ~Euro, mode = "lines", type = "scatter",name = "Euro", 
               line = list(color = "rgb(251,107,1)"))%>%
  add_trace(x = ~dates, y = ~data$`S&P_1500`, mode = "lines", type = "scatter", yaxis = "y2", 
            name = "2-yr yields", line = list(color = 'rgb(251,194,2)'))%>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))%>%
  style(hoverinfo = "skip", traces = c(1, 2))
  
ns <- plot_ly(data, x = ~dates,y = ~Euro, mode = "lines", type = "scatter", name = "Euro", 
               line = list(color = 'rgb(251,107,1)'))%>%
  add_trace(x = ~dates, y = ~NASDAQ, mode = "lines", type = "scatter", yaxis = "y2", 
            name = "3-mth yields", line = list(color = 'rgb(251,194,2)')) %>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))%>%
  style(hoverinfo = "skip", traces = c(1, 2))        

#Debt against the markets
debt_sp1500 <- plot_ly(data, x = ~dates, y = ~`data$`S&P_1500`, mode = "lines", type = "scatter", 
                       name = "S&P 1500", line = list(color = 'rgb(230, 126, 34)'))%>%
  add_trace(x = ~action_dates, y = ~debt_ceiling_now, type = "bar", yaxis = "y2", 
            name = "Debt Ceiling", marker = list(color = 'rgb(15,160,8)'))%>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))

debt_nasdaq <- plot_ly(data, x = ~dates, y = ~NASDAQ, mode = "lines", type = "scatter", 
                       name = "NASDAQ", line = list(color = 'rgb(230, 126, 34)'))%>%
  add_trace(x = ~data$action_dates, y = ~data$debt_ceiling_now, type = "bar", yaxis = "y2", 
            name = "Debt ceiling", marker = list(color = 'rgb(15,160,8)'))%>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F))

#Debt against yields
debt_yields <- plot_ly(data, x = ~dates, y = ~yields_10yr, mode = "lines", type = "scatter", 
                       name = "Ten Year", line = list(color = 'rgb(230, 126, 34)'))%>%
  add_trace(x = ~action_dates, y = ~debt_ceiling_now, type = "bar", yaxis = "y2" ,name = "Total Debt", marker = list(color = 'rgb(15,160,8)')) %>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F)) %>%
  add_trace(y = ~yields_2yr, mode = "lines", type = "scatter", name = "2 year", line = list(color = 'rgb(255, 195, 0)'))%>%
  add_trace(y = ~yields_3mth, mode = "lines", type = "scatter", name = "3 mth",line = list(color = 'rgb(246, 6, 6)'))

#Yields against markets
market_yields <- plot_ly(data, x = ~dates, y = ~yields_10yr, mode = "lines" ,type = "scatter", name = "10 year", line = list(color = 'rgb(251,194,2)')) %>%
  add_trace(x = ~dates, y = ~`S&P_1500`, mode = "lines", type = "scatter", yaxis = "y2", 
            name = "S&P 1500", line = list(color = 'rgb(230, 126, 34)'))%>%
  layout(yaxis2 = list(overlaying = "y", side = "right", showgrid = F)) %>%
  add_trace(y = ~yields_2yr, mode = "lines", type = "scatter", name = "2 year", line = list(color = 'rgb(175, 96, 26)'))%>%
  add_trace(y = ~yields_3mth, mode = "lines", type = "scatter", name = "3 mth",line = list(color = 'rgb(148, 49, 38)'))

#Added the other currencies
currencies_ns <- function(value, choice){
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
currencies_sp <- function(value, choice){
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
formatting <- function(value, choice){
  if(choice == 1){
      title_text = "Yields and Indicies"
      y_text = "Yields"
        }
  else if(choice == 2){
    title_text = "Debt and Yields"
    y_text = "Yields"
  }
  else if(choice == 3 || choice == 4){
    title_text = "Debt and Markets"
    if(choice == 3){
      y_text = "S&P 1500"
      }
    else{
      y_text = "NASDAQ"    
    }
  }
  else if(choice == 5 || choices == 6){
    title_text = "Markets and Currencies"
    if(choice == 5){
      y_text = "S&P 1500"
    }
    else{
      y_text = "NASDAQ"
    }
  }
  #Rangeslider is operating !!!
  #Hovermode = "x unified" helps to make the data readable for all three lines
  value <- value %>%layout(plot_bgcolor = 'white',
                    paper_bgcolor = 'lightgray', 
                    title = list(text = title_text, font = titlefont),
                    xaxis = list(title = list(text = "Dates",
                                 font = axesfont), rangeslider = list(visible = T)),
                    yaxis = list(title = list(text = y_text ,font = axesfont), showgrid = F),
                    hovermode = "x unified",
                    legend = list(orientation = "v", x = 1.15, y = 0.90,
                                  title=list(text='<b> Legend </b>', font = axesfont))
             )
  return(value)
}
#adding yields over days that debt ceiling raised

  
#make sure to clear variables from r if reloading more than once
#or you'll have multiple yuan and yen titles in the legend
#Other than that both graphs are functional!!!
print("What do you want to look at:
      \n\t1. Yields & Indicies(S&P 1500)
      \n\t2. Debt & Yields
      \n\t3. Currency & Indices(S&P 1500)
      \n\t4. Currency & Indices(NASDAQ)
      \n\t5. Debt & Indices(S&P 1500)
      \n\t6. Debt & Indices(NASDAQ)\n\t")
choice = strtoi(readline("Choice(Number): "))
result = switch(
  choice,
  1 == print(formatting(market_yields, choice)),
  2 == print(formatting(debt_yields, choice)), 
  3 == print(currencies_sp(sp, choice)),
  4 == print(currencies_ns(ns, choice)),
  5 == print(formatting(debt_sp1500, choice)),
  6 == print(formatting(debt_nasdaq, choice))
)

#Make one for each graph instead
#Wrap in loop and put readline in function call
save_graphs <- function(graph_){
      library(htmlwidgets)
      saveWidget(graph_, readline("Name of the file(end with .html): "))
}

rm(list = ls())
