#===============================================================================
# 
# 
# Tyler Bradley 
# 2019-04-10
#===============================================================================


shinyUI(
  tagList(
    useShinyjs(),
    navbarPage(
      title = "Game of Thrones Death Pool",
      theme = shinytheme("united"),
      
      # tab for the main results table
      tabPanel(
        div(
          "Leaderboard"
        ),
        div(
          h2("Leaderboard"),
          dataTableOutput("leaderboard")
        )
      ),
      tabPanel(
        div(
          "Compare Choices"
        ),
        div(
          selectInput(
            inputId = "people_filter",
            label = "Show People",
            choices = c("All", unique(answers$submitter)),
            selected = "All",
            multiple = TRUE
          )
        ),
        div(
          h2("Character Survival"),
          dataTableOutput("comp_char")
        ),
        br(),
        br(),
        div(
          h2("Bonus Questions"),
          dataTableOutput("comp_prop")
        )
      ),
      tabPanel(
        div(
          "Player Stats"
        ),
        div(
          h2("Player Stats"),
          dataTableOutput("player_stats")
        )
      )
    )
  )
)