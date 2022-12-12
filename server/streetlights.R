############# Street Lighting ##############
# South Bend Crime Statistic
output$SBcrime <- renderValueBox({
  valueBox(5392,
           subtitle = "Crimes in South Bend / 100K People",
           color = "purple")
})

#Indiana Crime Statistic
output$Incrime <- renderValueBox({
  valueBox(paste0(152, '%'),
           subtitle = "Higher than Indiana Crime Rate",
           color = "red")
})

#National Crime Statistic
output$Natcrime <- renderValueBox({
  valueBox(paste0(130, '%'),
           subtitle = "Higher than National Crime Rate",
           color = "red")
})


#create the map
output$mymap <- renderLeaflet({
  stmap<-leaflet() %>%
    addTiles() %>%
    addCircles(
      data = stLight,
      lat = ~ Lat,
      lng = ~ Lon,
      weight = 1,
      radius = ~ 10,
      popup = ~ Lumens,
      color = ~ heat.colors(stLight$Lumens),
      group = "Without Districts"
    ) %>%
    #overlay district data
    addPolygons(
      data = districts.spatial,
      color = "blue",
      weight = 1,
      opacity = 0.5,
      highlightOptions = highlightOptions(
        color = "white",
        weight = 3,
        bringToFront = TRUE,
      ),
      group = "With Districts"
    ) 
  
  stmap %>% 
    addLayersControl(
      overlayGroups= c("With Districts", "Without Districts"),
      options = layersControlOptions(collapsed = FALSE),
      position = "bottomright") %>%
    setView(-86.25, 41.68, zoom = 11.4)
})

############# Street Lighting ##############