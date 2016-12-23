library(shiny)
library(leaflet)
library(rgdal)
library(readr)
library(dplyr)
library(geojsonio)
library(plotly)
library(DT)

# data downloaded
T.map <- readOGR(dsn="OFiles", layer="County_MOI_1041215")

# Cut out unnecessary columns
GPSdata <- T.map@data %>% select(3)
GPSdata$C_Name <- iconv(GPSdata$C_Name,"UTF-8")

# Get the credit car data 
Cdata <- read_csv("OFiles/credit card_data.csv")


shinyServer(function(input, output) { 
  
  getDataSet<-reactive({
    
    # Get a subset of the income data which is contingent on the input variables
    data_year <- Cdata[Cdata$year== input$dataYear,]
    
    # Adjust the seq of C_Name
    data_year <- data_year[match(GPSdata$C_Name, data_year$C_Name),]
    
    # round the number
    data_year$number <- round(data_year$number,2)
    data_year$consumption <- round(data_year$consumption,2)
    
    # return the data
    data_year
  })
  
  output$TaiwanMap<-renderLeaflet({
    
    leaflet() %>% addProviderTiles("Stamen.TonerLite") %>%
      
      # Centre the map in the middle of our co-ordinates
      setView(lng=120.602, lat=23.680, zoom = 7)   
    
  })
  
  observe({
    
    # Get a subset of the income data which is contingent on the input variables     
    # dataSet<- Cdata[Cdata$year== "2014",]
    
    dataSet <- getDataSet()
    
    T.map@data["consumption"] <- dataSet$consumption
    
    # colour palette mapped to data
    qpal <- colorQuantile("Blues",T.map$consumption, n = 12)
    
    
    # set text for the clickable popup labels
    state_popup <- paste0("<strong>County: </strong>", 
                          dataSet$C_Name, 
                          "<br><strong>",
                          "credit card consumption:",
                          "</strong>", 
                          formatC(dataSet$consumption, big.mark=',')
    )
    
    # If the data changes, the polygons are cleared and redrawn, however, the map (above) is not redrawn
    leafletProxy("TaiwanMap", data = T.map) %>%
      clearShapes() %>% 
      addPolygons(stroke = FALSE, fillOpacity = 0.8, smoothFactor = 0.5, color = ~qpal(consumption), weight = 3, popup = state_popup)
    
  })
  
  # table of results, rendered using data table
  output$dataTable <- renderDataTable(datatable({
    dataSet<-getDataSet()
    dataSet<-dataSet[,c(1,3,4)] # Just get name and value columns
    names(dataSet)<-c("County","avg. number_by month","avg. Money_by month")
    dataSet
    },
  options = list(lengthMenu = c(5, 10, 22),pageLength = nrow(5)))
  )
  
  output$barchart <- renderPlotly({
    dataSet<-getDataSet()
    plot_ly(dataSet,x = ~C_Name) %>%
      add_trace(x = ~C_Name, y = ~consumption, type = 'bar', name = 'money'
      ) %>%
      add_markers(y = ~number, yaxis = "y2",name = 'number',marker = list(size = 10)
      ) %>%
      layout(title = 'Situation of Credit Card in Taiwan',
             xaxis = list(title = ""),
             yaxis = list(side = 'left', title = 'money', showgrid = FALSE, zeroline = FALSE),
             yaxis2 = list(side = 'right', overlaying = "y", title = 'number', showgrid = FALSE, zeroline = FALSE))
    
  })
  
   output$yearSelect<-renderUI({
    yearRange<-sort(unique(Cdata$year), decreasing=F)
    selectInput("dataYear", "Year", choices=yearRange, selected=yearRange[1])
  })
})
