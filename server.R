
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
    
    
    output$character_outcome_fig <- renderPlotly({
      submissions %>% 
        filter(question_type == "character") %>% 
        count(question, answer) %>% 
        spread(key = answer, value = n) %>% 
        mutate_at(vars(Dies, Lives), list(~ifelse(is.na(.), 0, .))) %>% 
        mutate(character = factor(question) %>% fct_reorder(Dies)) %>% 
        arrange(desc(character)) %>% 
        plot_ly(x = ~character, y = ~Dies, type = "bar", name = "Dies") %>% 
        add_trace(y = ~Lives, name = "Lives") %>% 
        layout(
          yaxis = list(title = 'Count'), 
          barmode = 'stack',
          xaxis = list(
            title = "",
            dtick = 1
          ),
          title = "Survival Expectancy by Character"
        ) 
    })
    
    output$positivity <- renderPlotly({
      submissions %>% 
        filter(question_type == "character") %>% 
        count(submitter, answer) %>% 
        spread(key = answer, value = n) %>% 
        mutate_at(vars(Dies, Lives), list(~ifelse(is.na(.), 0, .))) %>% 
        mutate(submitter = factor(submitter) %>% fct_reorder(Dies)) %>% 
        plot_ly(x = ~submitter, y = ~Dies, type = "bar", name = "Dies") %>% 
        add_trace(y = ~Lives, name = "Lives") %>% 
        layout(
          yaxis = list(title = 'Count'), 
          barmode = 'stack',
          xaxis = list(
            title = "",
            dtick = 1
          ),
          title = "Player Optimism"
        ) 
    })
    
    
  }
)