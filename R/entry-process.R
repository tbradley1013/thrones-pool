#===============================================================================
# Script to process pool entries
# 
# Tyler Bradley 
# 2019-04-11
#===============================================================================


library(tidyverse)
library(readxl)


read_submission <- function(file){
  # browser()
  char_locs <- c("B4:C24", "D4:E24")
  
  name <- read_excel(file, range = "C2", col_names = FALSE)
  name <- name[[1,1]]
  
  character_df <- map_dfr(char_locs, ~{
    df <- read_excel(file, range = .x)
    
    df <- df %>% 
      janitor::clean_names()
    
    return(df)
  })
  
  character_df <- character_df %>% 
    mutate(
      question_type = "character"
    ) %>% 
    select(question = character, question_type, answer = lives_dies)
  
  
  props_df <- read_excel(file, range = "B25:E34") %>% 
    janitor::clean_names() %>% 
    select(bonus_questions, answer) %>% 
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
  submissions <- list.files("data-raw/submissions", full.names = TRUE, recursive = TRUE)
  
  map_dfr(submissions, read_submission)
}


submissions <- parse_submissions()

master <- read_submission("data-raw/answer-key.xlsx")


write_rds(submissions, "data/submissions.rds")
write_rds(master, "data/master.rds")
