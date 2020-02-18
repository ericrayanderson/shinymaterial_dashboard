library(shiny)
library(shinymaterial)
library(tidyverse)
library(stringr)

HPI_AT_metro <-
  read_csv(
    "https://www.fhfa.gov/DataTools/Downloads/Documents/HPI/HPI_AT_metro.csv",
    col_names = FALSE
  ) %>%
  rename_(
    .dots = 
      setNames(colnames(.),
               c("Metropolitan_Statistical_Area_Name",	
                 "Core_Based_Statistical_Area", 
                 "Year",	
                 "Quarter", 
                 "Index",
                 "Index_Standard_Error"))
  ) %>%
  filter(Year > 1994) %>%
  transmute(
    Metropolitan_Statistical_Area_Name = Metropolitan_Statistical_Area_Name,
    Core_Based_Statistical_Area = as.character(Core_Based_Statistical_Area),
    Housing_Price_Index = as.numeric(ifelse(Index == '-', NA, Index)),
    Quarter = Quarter,
    Year = Year,
    Year_Quarter_num = Year + (Quarter / 4)
  ) %>%
  filter(complete.cases(.)) %>%
  mutate(
    Metropolitan_Statistical_Area_Name = 
      str_replace(Metropolitan_Statistical_Area_Name, '(MSAD)', '')
  ) %>%
  separate(
    Metropolitan_Statistical_Area_Name,
    c('Area', 'State'),
    ', '
  ) %>%
  mutate(State = str_sub(State, 1, 2)) %>% 
  unite(Area_State, State, Area, sep = ", ", remove = FALSE)

git_refs <- function(){
  shiny::tagList(
    tags$a(target = "_blank",
           href = "https://github.com/ericrayanderson/shinymaterial_dashboard/blob/master/ui.R#L1",
           HTML('<h3>ui.R<i class="material-icons">open_in_new</i></h3>')),
    "Includes shinymaterial functions: ",
    tags$ul(style = "font-family:monospace; display:block",
            tags$li("material_side_nav()",
                    "material_side_nav_tabs()",
                    "material_side_nav_tab_content()")
    ),
    tags$a(target = "_blank",
           href = "https://github.com/ericrayanderson/shinymaterial_dashboard/blob/master/server.R#L1",
           HTML('<h3>server.R<i class="material-icons">open_in_new</i></h3>')),
    "Includes shinymaterial functions: ",
    tags$ul(style = "font-family:monospace; display:block",
            tags$li("material_spinner_show()",
                    "material_spinner_hide()")
    ),
    br(),
    br(),
    tags$a(
      target = "_blank",
      href = "https://ericrayanderson.github.io/shinymaterial/",
      "shinymaterial website"
    ) 
  )
}
