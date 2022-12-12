tabPanel(h1("Neighborhood"),
         h2("Neighborhood Development Areas"),
         sidebarLayout(
           sidebarPanel(
             radioButtons(
               inputId = "parameter",
               label = "Select Facility Type",
               choices = c("Facilites",
                           "Parks",
                           "Schools",
                           "Abandoned Properties"),
               selected = "Facilites"
             )# end check box
           ),
           mainPanel(leafletOutput("map"),
                     DT::dataTableOutput(outputId = "table"))
 )
)