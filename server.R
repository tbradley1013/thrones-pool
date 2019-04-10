
shinyServer(
  function(input, output, session){
    session$onSessionEnded(stopApp)
    
    output$leaderboard <- renderDataTable({
      datatable(leaderboard)
    })
  }
)