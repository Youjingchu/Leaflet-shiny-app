library(shinydashboard)
library(leaflet)
library(plotly)

header<-dashboardHeader(title="Situation of Credit Card in Taiwan",titleWidth = 500)

body<-dashboardBody(
  fluidRow(
    column(width = 6,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("TaiwanMap", height=400)
           ),
           box(width=NULL,
               dataTableOutput("dataTable")
           )
    ),
    column(width=6,
           box(width=NULL, 
               uiOutput("yearSelect")
           ),
           box(width=NULL,
               plotlyOutput("barchart")
           )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
