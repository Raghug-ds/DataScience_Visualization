  tabPanel(h1("Streetlights"),
    h2("Crime Prevention: Street Lighting"),
    mainPanel(
      #Summary statistics
      infoBoxOutput("SBcrime"),
      infoBoxOutput("Incrime"),
      infoBoxOutput("Natcrime"),
      
      #this will create a space for us to display our map
      leafletOutput(outputId = "mymap"),
    )
  )