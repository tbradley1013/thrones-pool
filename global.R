#===============================================================================
# Global script for the Game of Thrones Death Pool tracker app
# 
# Tyler Bradley 
# 2019-04-10
#===============================================================================

suppressWarnings({
  suppressPackageStartupMessages({
    library(shiny)
    library(shinythemes)
    library(shinyjs)
    library(tidyverse)
    library(readxl)
  })
})