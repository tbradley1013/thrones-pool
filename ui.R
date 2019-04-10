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
      )
    )
  )
)