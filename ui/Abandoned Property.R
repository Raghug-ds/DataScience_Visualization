tabPanel(h1("Abandoned Property"),
  h2(
    "Business Status and Location of Vacant Lots"
  ),
  sidebarLayout(sidebarPanel(
    selectInput(
      inputId = "Zip_Code",
      label = "Choose Zip Code",
      choices = lots$Zip_Code,
      
    )
  ),
  # Show a plot of the generated distribution
  mainPanel(leafletOutput("vmap")))
  
)