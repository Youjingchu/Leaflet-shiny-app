library(shiny)
library(leaflet)
library(rgdal)
library(readr)
library(dplyr)
library(geojsonio)

T.map <- readOGR(dsn="OFiles", layer="County_MOI_1041215")
acdnt <- read_csv("OFiles/English_data_for_graphing.csv")

shinyServer(function(input, output) { 
  output$distPlot1 <- renderLeaflet({
    county_seq <- T.map@data
    data <- acdnt %>% select(1,3)
    county_seq$C_Name <- iconv(county_seq$C_Name,"UTF-8")
    county_seq <- county_seq %>% merge(data, by.x = c("C_Name"), by.y = c("C_Name")) %>% arrange(OBJECTID)
    T.map@data["index"] <- county_seq[,ncol(county_seq)]
    state_popup <- paste0("<strong>", county_seq$C_Name, "</strong>", "<br><strong>Dead_Ratio: </strong>", T.map$index)
    qpal <- colorQuantile("Blues", T.map$index,n =10)
    m <- leaflet(T.map) %>%  addProviderTiles("Stamen.TonerLite") %>% setView(lng=120.602, lat=23.680, zoom = 8)
    m <- m %>% addPolygons(stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, color = ~qpal(index), weight = 3, popup = state_popup)
    m %>% addLegend("bottomright", pal = qpal, values = ~index, title = "acdnt_dead_ratio", opacity = 0.5)
  })
})
