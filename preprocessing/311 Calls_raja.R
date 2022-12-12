
call.rawdata = read.csv("data/311_Phone_Call_Log_Mod.csv"
)


min_date <- min(as.Date(call.rawdata$Call_Date))
max_date <- max(as.Date(call.rawdata$Call_Date))

call.summary.data <- drop_na(call.rawdata) %>% 
  dplyr::select(Department, Call_Date, duration_Seconds) %>% 
  group_by(Department) %>% 
  summarise(avg_duration = mean(duration_Seconds), no_of_calls=n()) %>% 
  arrange(desc(no_of_calls)) %>%
  mutate(Department = factor(Department, levels = unique(Department))) %>%
  head(4)

call.reason.data <- drop_na(call.rawdata) %>% 
  group_by(Called_About) %>%
  select(Called_About)

dept_dropdown <- c("all", c(gsub(' ','',paste('KEY',call.summary.data$Department))))
dept_names <- c("All", c(gsub('','',call.summary.data$Department)))
dept_dropdown <- setNames(dept_dropdown, dept_names)
dept_df <- data.frame(dep_key=dept_dropdown,dept_name=dept_names)

reason_df <-
  data.frame(reason_key = unique(c("all", c(gsub(
    ' ', '', paste('KEY', call.reason.data$Called_About)
  )))),
  reason_name = unique(c("All", c(
    gsub('', '', call.reason.data$Called_About)
  ))))

get_called_about <- function(arg_dept_type){
  t_selected_dept <- get_selected_dept(arg_dept_type)
  called_abt_df <- call.rawdata %>%
    filter(Department== t_selected_dept) %>%
    group_by(Called_About) %>%
    summarise(no_of_calls = n()) %>%
    arrange(desc(no_of_calls)) %>%
    mutate(Called_About = factor(Called_About, levels = unique(Called_About))) %>%
    head(5)
  
  ca_dropdown <- c("all")
  ca_names <- c("All")
  if(t_selected_dept != "All"){
    ca_dropdown <- c("all", c(gsub(' ','',paste('KEY',called_abt_df$Called_About))))
    ca_names <- c("All", c(gsub('','',called_abt_df$Called_About)))
  }
  ca_df <- data.frame(ca_key=ca_dropdown, ca_name=ca_names)
  ca_dropdown <- setNames(ca_dropdown, ca_names)
  
  return(ca_dropdown)
  
}

get_department_plot <- function(arg_dates_range, arg_dept_type){
  t_selected_dept <- get_selected_dept(arg_dept_type)
  if (arg_dept_type == "all"){
    t_data <- call.rawdata %>%
      filter(Call_Date >= arg_dates_range[1], Call_Date <= arg_dates_range[2]) %>%
      group_by(Called_About) %>% 
      summarise(no_of_calls=n()) %>% 
      arrange(desc(no_of_calls)) %>%
      mutate(Called_About = factor(Called_About, levels = unique(Called_About))) %>%
      head(5) 
  }
  else {
    t_data <- call.rawdata %>%
      filter(Department== t_selected_dept) %>%
      filter(Call_Date >= arg_dates_range[1], Call_Date <= arg_dates_range[2]) %>%
      group_by(Called_About) %>% 
      summarise(no_of_calls=n()) %>% 
      arrange(desc(no_of_calls)) %>%
      mutate(Called_About = factor(Called_About, levels = unique(Called_About))) %>%
      head(5) 
  }
  title_called_abt <- paste("Most called reason: ", t_data$Called_About[1])
  dplot <-  
    ggplot(data=t_data, aes(x=Called_About, y=no_of_calls, fill=no_of_calls)) +
    geom_col() +
    xlab("Called_About") + 
    ylab("# of calls") +
    labs(fill='# of calls') +
    ggtitle(title_called_abt) +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))    
  return(dplot)
}

get_timeseries_plot <- function(arg_dates_range, arg_dept_type, arg_called_reason) {
  
  # Finding department selected
  t_selected_dept <- get_selected_dept(arg_dept_type)
  t_selected_reason <- get_selected_reason(arg_called_reason)
  most_called_abt <- paste("Trend Chart for ", t_selected_reason)
  
  # Retrieving timeseries data for the department selected
  if (arg_dept_type == "all") {
    ts_data <- drop_na(call.rawdata) %>%
      dplyr::select(Department, Call_Date) %>%
      mutate(Call_Date = as.Date(Call_Date)) %>%
      group_by(Call_Date) %>%
      summarise(count = n())
  }
  else
  {
    if (arg_called_reason == "all"){
      ts_data <- drop_na(call.rawdata) %>%
        dplyr::select(Department, Call_Date) %>%
        mutate(Call_Date = as.Date(Call_Date)) %>%
        filter(Department == t_selected_dept) %>%
        group_by(Call_Date) %>%
        summarise(count = n())
    }
    else {
      ts_data <- drop_na(call.rawdata) %>%
        dplyr::select(Department, Called_About, Call_Date) %>%
        mutate(Call_Date = as.Date(Call_Date)) %>%
        filter(Department == t_selected_dept, Called_About == t_selected_reason) %>%
        group_by(Call_Date) %>%
        summarise(count = n())
    }
  }
  
  # Creating the plot based on timeline
  ts_plot <- ggplot(ts_data, aes(x = Call_Date, y = count)) +
    geom_line(color = "steelblue") +
    geom_point() +
    xlab("") +
    ylab("# of calls") +
    ggtitle(most_called_abt) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
    scale_x_date(breaks = "1 month", 
                 date_labels = "%m-%Y", 
                 limit=c(arg_dates_range[1],arg_dates_range[2]))  
  
  return(ts_plot)
}

get_selected_dept <- function(arg_dept_type) {
  return(dept_df$dept_name[which(dept_df$dep_key == arg_dept_type)])
}

get_selected_reason <- function(arg_reason) {
  return(reason_df$reason_name[which(reason_df$reason_key == arg_reason)])
}
