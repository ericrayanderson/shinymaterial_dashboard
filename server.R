server <- function(input, output, session) {
  
  
  output$housing_plot_error <- renderUI({
    if(input$from_year >= input$to_year){
        tags$span(
          style = "color:red; font-weight:bold",
          paste0('"From Year" (', input$from_year, ') must be before "To Year" (', input$to_year, ')')
        )
    } else {
      NULL
    }
  })
  
  output$housing_plot <- renderPlot({
    
    if(input$from_year >= input$to_year){
      return(NULL)
    }
    
    material_spinner_show(session, "housing_plot")
    
     Sys.sleep(2.5) # sleep to show spinner example 
    
    plot_data <- 
      HPI_AT_metro %>% 
      filter(
        Area_State == input$Area_State,
        Year >= input$from_year,
        Year <= input$to_year
      ) %>% 
      mutate(
        Housing_Price_Index_Plot =
          round(
            ((Housing_Price_Index / Housing_Price_Index[Year_Quarter_num == min(Year_Quarter_num)]) * 100) - 100
            ,0
          )
      )
    
    plot_out <- ggplot(plot_data, aes(x = Year_Quarter_num,
                          y = Housing_Price_Index_Plot)) +
      geom_line(size = 3, color = "#0000ff") +
      geom_label(data = plot_data[plot_data$Year_Quarter_num == max(plot_data$Year_Quarter_num), ],
                 aes(label = paste0(Housing_Price_Index_Plot, "%")),
                 color = "#0000ff", size = 5) + 
     geom_hline(yintercept = 0, linetype = 2) +
      scale_x_continuous(
        breaks = sort(unique(plot_data$Year))
      ) +
      xlab("Year") + 
      ylab("Price Change (%)") +
      theme(text = element_text(size = 20),
            legend.position = "none",
            axis.text.x=element_text(angle=60, hjust=1))
    
    material_spinner_hide(session, "housing_plot")
    
    plot_out
  })
}