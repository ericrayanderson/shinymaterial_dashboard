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
