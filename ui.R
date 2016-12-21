library(shinydashboard)
library(leaflet)
library(plotly)

header<-dashboardHeader(title="Situation of Credit Card in Taiwan",titleWidth = 500)

body<-dashboardBody(
  fluidRow(
    column(width = 6,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("TaiwanMap", height=370)
           ),
           box(width=NULL,
               plotlyOutput("barchart")
           )
    ),
    column(width=6,
           box(width=NULL, 
               uiOutput("yearSelect")
           ),
           box(width=NULL,
               dataTableOutput("dataTable")
           )
    )
  ),
  fluidRow(
    column(width=12,
           box(width=NULL,
               dataTableOutput("dataTable")
           )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
