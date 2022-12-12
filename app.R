#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(leaflet)
library(tidyverse)
library(sf)
library(leaflet.extras)
library(shinydashboard)
library(hrbrthemes)
library(cowplot)

source("preprocessing/streelights_ana.R")
source("preprocessing/districts_schools_babu.R")
source("preprocessing/parks_facilites_raghu.R")
source("preprocessing/abandoned property_jesus.R")
source("preprocessing/311 Calls_raja.R")


# Define UI for application that draws a histogram
ui <- fluidPage(
  title = "Data Visualization | Final Project | WEST2",
  tagList(
    navbarPage(
      theme = shinytheme("flatly"),
      includeCSS("www/finalproject.css"),
      tabPanel("About",
               div(
                 img(src = "southbend_city.jpeg", width = "100%") 
               ),
               uiOutput("About")
      ),# end First tab panel
      tabPanel("City of SouthBend",
               tabsetPanel(
                 source(file.path("ui", "neighborhood.R"),  local = TRUE)$value,
                 source(file.path("ui", "streetlights.R"),  local = TRUE)$value,
                 source(file.path("ui", "Abandoned Property.R"),  local = TRUE)$value,
                 source(file.path("ui", "311 Call Log.R"),  local = TRUE)$value
               )# end tabset panel
      ),# end second tab panel
    )#end navbarPage
  )#end taglist
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
  
  output$About <- renderUI(includeHTML("www/About.html"))
  source(file.path("server", "streetlights.R"),  local = TRUE)$value
  source(file.path("server", "neighborhood.R"),  local = TRUE)$value
  source(file.path("server", "Abandoned Property.R"),  local = TRUE)$value
  source(file.path("server", "311 Call Log.R"),  local = TRUE)$value

}

# Run the application
shinyApp(ui = ui, server = server)
