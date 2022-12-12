############# 311 Service calls ##############
source("preprocessing/311 Calls_raja.R")
 
# A mandatory method for reactive shiny apps
toListen <- reactive({
  list(input$dept_type, input$dates_range, input$called_reason)
})

# A which defines the reactive widgets to listen to
observeEvent(toListen(), {
})    

observeEvent(input$dept_type, {
  reason_choices <- get_called_about(input$dept_type)
  updateSelectInput(session, "called_reason",
                    choices = reason_choices)
})

# A mandatory method which reacts to the input change
get_plot <- eventReactive(toListen(), {
  dates_range <- as.Date(input$dates_range, format = "%Y-%m-%d")
  plot_grid(get_department_plot(dates_range, input$dept_type),
            get_timeseries_plot(dates_range, input$dept_type, input$called_reason),
            nrow=1, ncol=2)
})

output$plot_srvc <- renderUI({
  plotOutput("plot", height=500, width=1000)
})

output$plot <- renderPlot({
  get_plot()
})
############# 311 Service calls ##############