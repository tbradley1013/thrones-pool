#===============================================================================
# 
# 
# Tyler Bradley 
# 2019-04-10
#===============================================================================


shinyUI(
  tagList(
    useShinyjs(),
    navbarPageWithInputs(
      title = "Game of Thrones Death Pool",
      theme = shinytheme("cosmo"),
      
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
          "Answer Summaries"
        ),
        div(
          h2("Answer Summaries"),
          plotlyOutput("character_outcome_fig"),
          plotlyOutput("wins_got"),
          plotlyOutput("dies_first"),
          plotlyOutput("dies_last"),
          plotlyOutput("kills_night_king"),
          plotlyOutput("kills_cercei"),
          plotlyOutput("undead_ned"),
          plotlyOutput("cleganebowl"),
          plotlyOutput("stark_children"),
          plotlyOutput("arya_kills")
        )
      ),
      tabPanel(
        div(
          "Player Stats"
        ),
        div(
          h2("Player Stats"),
          dataTableOutput("player_stats"),
          plotlyOutput("positivity")
        )
      ),
      inputs = div(
        p(
          "Last Updated: S8E1", 
          style = "color:white;font-size:10px;"
        ),
        style = "position:relative;float:right;"
      )
    )
  )
)