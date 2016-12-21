library(shinydashboard)
library(leaflet)
library(plotly)
library(DT)

header<-dashboardHeader(title="Situation of Credit Card in Taiwan",titleWidth = 500)

body<-dashboardBody(
   fluidRow(
    column(width = 6,
           box(width=NULL, 
               uiOutput("yearSelect")
           ),
           box(width=NULL,
               plotlyOutput("barchart", height=315)
           )
    ),
    column(width=6,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("TaiwanMap", height=435)
           )
    )
  ),
           box(width=NULL,
               dataTableOutput("dataTable")
           )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
