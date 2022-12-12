tabPanel(h1("311 Calls"),
         h2("Services and Call Data"),
         column(
           6,
           sliderInput(
             "dates_range",
             "Dates:",
             min = min_date,
             max = max_date,
             value = c(min_date, max_date),
             timeFormat = "%Y-%m-%d"
           )
         ),
         column(
           3,
           selectInput("dept_type",
                       "Department",
                       dept_dropdown,
                       selectize = FALSE)
         ),
         column(
           3,
           selectInput("called_reason",
                       "Called About",
                       dept_dropdown,
                       selectize = FALSE)
         ),

fluidRow(column(12,
                uiOutput("plot_srvc"))))



