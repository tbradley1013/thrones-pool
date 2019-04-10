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


read_submission <- function(file){
  char_locs <- c("B4:D24", "E4:G24")
  
  name <- read_excel(file, range = "C2", col_names = FALSE)
  name <- name$X__1
  
  character_df <- map_dfr(char_locs, ~{
    df <- read_excel(file, range = .x)
    
    df <- df %>% 
      janitor::clean_names()
    
    return(df)
  })
  
  character_df <- character_df %>% 
    mutate(
      answer = case_when(
        lives & dies ~ "lives",
        lives ~ "lives",
        dies ~ "dies",
        TRUE ~ "lives"
      ),
      question_type = "character"
    ) %>% 
    select(question = character, question_type, answer)
  
  
  props_df <- read_excel(file, range = "B25:G31") %>% 
    janitor::clean_names() %>% 
    select(bonus_questions, answer = x_5) %>% 
    mutate(
      points = str_extract(bonus_questions, "\\([0-9]") %>% str_extract("[0-9]") %>% as.numeric(),
      question = str_extract(bonus_questions, "(^.*)?\\?"),
      question_type = "prop"
    ) %>% 
    select(question, question_type, answer, points)
  
  output <- character_df %>% 
    bind_rows(props_df) %>% 
    mutate(submitter = name) %>% 
    select(submitter, everything())
  
  return(output)
  
}


parse_submissions <- function(){
  submissions <- list.files("submissions", full.names = TRUE, recursive = TRUE)
  
  map_dfr(submissions, read_submission)
}


submissions <- parse_submissions()

master <- read_submission("answer-key.xlsx")


answers <- submissions %>% 
  left_join(
    master %>% 
      select(-c(submitter, points, question_type)) %>% 
      rename(master = answer),
    by = "question"
  ) %>% 
  mutate(
    points = case_when(
      question_type == "character" & answer == master ~ 1,
      question_type == "character" & answer != master ~ -1,
      is.na(master) ~ 0,
      answer == master ~ points,
      answer != master ~ 0
    )
  )



leaderboard <- answers %>% 
  group_by(submitter) %>% 
  summarize(all_points = sum(points))