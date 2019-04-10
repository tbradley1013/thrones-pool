
shinyServer(
  function(input, output, session){
    session$onSessionEnded(stopApp)
    
    output$leaderboard <- renderDataTable({
      datatable(leaderboard)
    })
    
    
    output$comp_char <- renderDataTable({
      
      player_comp_char %>% 
        rename(character = question) %>% 
        datatable()
      
    })
    
    output$comp_prop <- renderDataTable({
      player_comp_prop %>% 
        datatable()
    })
  }
)