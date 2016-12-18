library(leaflet)

shinyUI(fluidPage(
  titlePanel("User distributed map"),
  fluidRow(
    
  ),
  mainPanel(leafletOutput("distPlot1", width = "150%", height = "540px"))
))
