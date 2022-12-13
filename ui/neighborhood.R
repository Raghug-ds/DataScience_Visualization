tabPanel(h1("Neighborhood"),
         h2("Neighborhood Development Areas"),
         sidebarLayout(
           sidebarPanel(
             radioButtons(
               inputId = "parameter",
               label = "Select Facility Type",
               choices = c("Facilities",
                           "Parks",
                           "Schools",
                           "Abandoned Properties"),
               selected = "Facilities"
             )# end check box
           ),
           mainPanel(leafletOutput("map"),
                     DT::dataTableOutput(outputId = "table"))
 )
)