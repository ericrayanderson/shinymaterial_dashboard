material_page(
  title = "",
  nav_bar_color = "blue",
  # Place side-nav in the beginning of the UI
  material_side_nav(
    fixed = TRUE, 
    image_source = "img/material.png",
    # Place side-nav tabs within side-nav
    material_side_nav_tabs(
      side_nav_tabs = c(
        "Housing Prices" = "housing_prices",
        "Source Data" = "view_data",
        "Code" = "code"
      ),
      icons = c("insert_chart", "explore", "code")
    )
  ),
  # Define side-nav tab content
  material_side_nav_tab_content(
    side_nav_tab_id = "housing_prices",
    tags$br(),
    
    material_row(
      material_column(
        width = 6,
        material_dropdown(
          input_id = "Area_State",
          label = "Location", 
          choices = sort(unique(HPI_AT_metro$Area_State)),
          color = "blue"
        )
      ),
      material_column(
        width = 3,
        material_slider(
          input_id = "from_year",
          label = "From Year",
          min_value = 1995,
          max_value = 2016,
          initial_value = 1995,
          color = "blue"
        )
      ),
      material_column(
        width = 3,
        material_slider(
          input_id = "to_year",
          label = "To Year",
          min_value = 1996,
          max_value = 2017,
          initial_value = 2017,
          color = "blue"
        )
      )
    ),
    material_row(
      material_column(
        width = 12,
        material_card(
          title = "Visualize",
          plotOutput("housing_plot"),
          uiOutput("housing_plot_error")
        )
      )
    )
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "view_data",
    tags$br(),
    material_row(
      material_column(
        width = 10,
        material_card(
          title = "Source",
          tags$a(href = "https://www.fhfa.gov/DataTools/Downloads",
                 target = "_blank",
                 "Federal Housing Finance Agency (FHFA)")
        )
      )
    )
  )
)