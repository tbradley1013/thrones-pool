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
    library(DT)
    library(plotly)
  })
})


submissions <- read_rds("data/submissions.rds")
master <- read_rds("data/master.rds")


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
  summarize(
    total_points = sum(points)
  ) %>% 
  arrange(desc(total_points))


player_stats <- answers %>% 
  group_by(submitter) %>% 
  summarize(
    total_points = sum(points),
    num_character_correct = sum(question_type == "character" & answer == master),
    num_character_wrong = sum(question_type == "character" & answer != master),
    character_points = num_character_correct - num_character_wrong,
    num_props_correct = sum(question_type == "prop" & !is.na(master) & answer == master),
    num_props_wrong = sum(question_type == "prop" & !is.na(master) & answer != master),
    prop_points = sum((question_type == "prop" & !is.na(master) & answer == master)*points)
  ) %>% 
  mutate_if(is.numeric, round, 0) %>% 
  arrange(desc(total_points))



player_comp_char <- answers %>% 
  filter(question_type == "character") %>% 
  select(-c(points, question_type)) %>% 
  spread(key = submitter, value = answer)

player_comp_prop <- answers %>% 
  filter(question_type == "prop") %>% 
  select(-c(points, question_type)) %>% 
  spread(key = submitter, value = answer)


  
prop_counts <- submissions %>% 
  filter(question_type == "prop") %>% 
  count(question, answer)


prop_graphs <- function(filt, title){
  prop_counts %>% 
    filter(str_detect(question, filt)) %>% 
    mutate(answer = factor(answer) %>% fct_reorder(n)) %>% 
    plot_ly(x = ~answer, y = ~n, type = "bar", marker = list(color = "#8a0303")) %>% 
    layout(
      title = title,
      yaxis = list(
        title = "Count"
      ),
      xaxis = list(
        title = "",
        dtick = 1,
        autorange = "reversed"
      )
    )
}
