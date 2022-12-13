############# Neighborhood ##############


dataset <- eventReactive(input$parameter, {
  i <- input$parameter
  if (i == "Facilities"){
    facilites.legend<-facilities.spatial$Type
    colorType <- colorFactor(palette = 'Set1', domain =facilities.spatial$Type)(facilities.spatial$Type)
    return(list(facilities.spatial, facilities_table,colorType,facilites.legend))
  }
   
  if (i == "Parks"){
    ParkColorType <- colorFactor(palette = 'Set1', domain =parks.spatial$Park_Type)(parks.spatial$Park_Type)
    parks.legend<-parks.spatial$Park_Type
    return(list(parks.spatial, parks_table,ParkColorType,parks.legend))
  }
   
  if (i == "Schools"){
    schools.legend<-schools.spatial$SchoolType
    SchoolColorType <- colorFactor(palette = 'Set1', domain =schools.spatial$SchoolType)(schools.spatial$SchoolType)
    return(list(schools.spatial, schools_table,SchoolColorType,schools.legend))
  }
    
  if (i == "Abandoned Properties"){
    abandoned.legend<-abandoned.spatial$Outcome_St
    StatusColorType <- colorFactor(palette = 'Set1', domain =abandoned.spatial$Outcome_St)(abandoned.spatial$Outcome_St)
    return(list(abandoned.spatial, abandoned_table,StatusColorType,abandoned.legend))
  }
   
})


data <- eventReactive(input$parameter, {
  District <- districts.spatial$District
  districtColor <- colorFactor("plasma", District)(District)
  return(list(districts.spatial, districtColor))
  
})


output$map <- renderLeaflet({
  myMap <- leaflet() %>%
    #addTiles()%>%
    addProviderTiles(providers$OpenStreetMap.HOT, group = "OpenStreetMap") %>%
    addPolygons(
      data = data()[[1]],
      popup = ~popup,
      color = "#444444",
      weight = 1,
      smoothFactor = 0.5,
      opacity = 1.0,
      fillOpacity = 0.5,
      fillColor = ~ data()[[2]],
      highlightOptions = highlightOptions(
        color = "white",
        weight = 2,
        bringToFront = TRUE
      ),
      group = "Districts"
    )
 
  myMap <-
    myMap %>% addCircleMarkers(
      data = dataset()[[1]][data()[[1]], ],
      popup = ~popup,
      stroke = FALSE,
      #color = "navy",
      color = ~ dataset()[[3]], 
      fillOpacity = .6,
      radius = 6,
      group = "Facilities"
    )

  myMap %>% 
    addLayersControl(
      overlayGroups= c("Districts", "Facilities"),
      options = layersControlOptions(collapsed = FALSE),
      position = "bottomright") %>%
     setView(-86.25, 41.68, zoom = 11.4)
})
output$table <- DT::renderDataTable({
  DT::datatable(
    dataset()[[2]],
    extensions = 'Buttons',
    options = list(
      dom = 'Bfrtip',
      buttons =
        list(
          'copy',
          'print',
          list(
            extend = 'collection',
            buttons = c('csv', 'excel', 'pdf'),
            text = 'Download'
          )
        )
      
    )
  )
})
############# Neighborhood ##############

