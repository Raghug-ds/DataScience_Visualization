############# Abandoned Property  ##############
pal <- colorFactor(palette = 'Set1',
                   #levels = unique(licenses2$License__1),
                   domain = licenses2$License__1)
pal2 <- colorFactor(palette = c("darkviolet", "darkblue"),
                    #levels = unique(licenses2$License__1),
                    domain = lots$Structures)
output$vmap <- renderLeaflet({
  input$Zip_Codes
  leaflet()  %>%
    setView(lng = -86.25,
            lat = 41.7,
            zoom = 11.4) %>%
    addProviderTiles(providers$OpenStreetMap) %>%
    addCircles(
      data = licenses2,
      group = 'Zip_Code',
      popup = paste(
        licenses2$Business_N,
        '<br>',
        licenses2$Street_Add,
        licenses2$City,
        licenses2$Zip_Code,
        '<br>',
        "Type:",
        licenses2$Classifi_1
      ),
      color = ~ pal(License__1),
      stroke = 0,
      fillOpacity = 1,
      radius = 10
    ) %>%
    addPolygons(
      data = lots,
      group = 'Zip_Code',
      popup = paste(
        "Building Status:",
        lots$Outcome_St,
        '<br>',
        lots$Address_Nu,
        lots$Street_Nam,
        lots$Zip_Code,
        '<br>',
        "Lot Class:",
        lots$Structures
      ),
      color = ~ pal2(Structures),
      stroke = 0,
      fillOpacity = 1
    ) %>%
    addLegend(
      "bottomright",
      pal = pal,
      values = licenses2$License__1,
      title = 'License Status'
    ) %>%
    addLegend(
      "topright",
      pal = pal2,
      values = lots$Structures,
      title = 'Lot Classification'
    )
})
observeEvent(input$Zip_Code, {
  leafletProxy("vmap") %>%
    setView(lng = -86.25,
            lat = 41.7,
            zoom = 11) %>%
    clearGroup("Zip_Code") %>%
    addPolygons(
      data = lots[lots$Zip_Code == input$Zip_Code,],
      group = "Zip_Code",
      popup = paste(
        "Building Status:",
        lots$Outcome_St,
        '<br>',
        lots$Address_Nu,
        lots$Street_Nam,
        lots$Zip_Code,
        '<br>',
        "Lot Class:",
        lots$Structures
      ),
      color = ~ pal2(Structures),
      stroke = 0,
      fillOpacity = 1
    ) %>%
    addCircles(
      data = licenses2[licenses2$Zip_Code == input$Zip_Code,],
      group = "Zip_Code",
      popup = paste(
        licenses2$Business_N,
        '<br>',
        licenses2$Street_Add,
        licenses2$City,
        licenses2$Zip_Code,
        '<br>',
        "Type:",
        licenses2$Classifi_1
      ),
      color = ~ pal(License__1),
      stroke = 0,
      fillOpacity = 1,
      radius = 10
    )
})
############# Abandoned Property ##############