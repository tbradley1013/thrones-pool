
shinyServer(
  function(input, output, session){
    session$onSessionEnded(stopApp)
    
    output$leaderboard <- renderDataTable({
      datatable(leaderboard)
    })
    
    
    output$comp_char <- renderDataTable({
      
      df <- player_comp_char
      
      if (!is.null(input$people_filter)) {
        if (!"All" %in% input$people_filter){
          my_cols <- map(input$people_filter, quo)
          
          df <- df %>% 
            select(question, master, !!!my_cols)
        }
        
      }
        
      
      df %>% 
        rename(character = question) %>% 
        datatable(
          rownames = FALSE,
          options = list(
           pageLength = 40,
           scrollX = TRUE,
           fixedColumns = list(
             leftColumns = 2
           )
          )
        )
      
    })
    
    output$comp_prop <- renderDataTable({
      df <- player_comp_prop
      
      if (!is.null(input$people_filter)) {
        if (!"All" %in% input$people_filter){
          my_cols <- map(input$people_filter, quo)
          
          df <- df %>% 
            select(question, master, !!!my_cols)
        }
        
      }
      
      
      df %>% 
        datatable(rownames = FALSE)
    })
    
    
    output$player_stats <- renderDataTable({
      player_stats %>% 
        rename_all(list(~str_to_title(str_replace(str_replace_all(., "_", " "), "num", "#")))) %>% 
        datatable(rownames = FALSE)
    })
  }
)