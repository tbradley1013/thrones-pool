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
          dataTableOutput("leaderboard")
        )
      ),
      tabPanel(
        div(
          "Compare Choices"
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
      )
    )
  )
)