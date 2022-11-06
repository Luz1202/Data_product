
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

shinyServer(function(input, output) {
  
  #Creamos una variable global
  global <<- mtcars[0,]
  nhover <<- data.frame(NULL)

#FUNCIÓN 1, PARA CAPTURA DE CLICKS
  nuevos_clks <- reactive({

    if(!is.null(input$clk$x)){
      nclk <- nearPoints(mtcars,input$clk,xvar = 'wt',yvar='mpg',
                         threshold = 15, maxpoints = 1)

      if(nrow(global)>0){
        pr1 <- global %>%
        dplyr::filter(row.names(global) == row.names(nclk))

      if(nrow(pr1) > 0){
        global <<- global
      } else {
        global <<- rows_insert(global,nclk,by=c('mpg','wt'))
      }} else {
        global <<- rbind(global,nclk)
      }
      } 
    
    if(!is.null(input$dclk$x)){
      ndbclk <- nearPoints(mtcars,input$dclk,xvar = 'wt',yvar='mpg',
                           maxpoints = 1,threshold = 15)

      if(nrow(global)>0){
      opt <- global %>%
        dplyr::filter(row.names(global) == row.names(ndbclk)[1])
      
      if(nrow(opt)>0){
        global <<- rows_delete(global,ndbclk,by=c('mpg','wt'))
        }
      }
      }
    
      if(!is.null(input$mbrush$xmin)){
        nbrush <- brushedPoints(mtcars,input$mbrush,xvar='wt',yvar='mpg')
        
        if(nrow(global)>0){
          for(i in row.names(nbrush)){
              pr2 <- global %>%
                dplyr::filter(row.names(global) == i)
              
              if(nrow(pr2) > 0){
                nbrush <- rows_delete(nbrush,pr2,by=c('mpg','wt'))
              } else {next}
          }
          global <<- rows_insert(global,nbrush,by=c('mpg','wt'))
          
        } else {global <<- rows_insert(global,nbrush,by=c('mpg','wt'))}
      }
  })
  
  
##FUNCIÓN 2: PARA HOVER
  hover_n <- reactive({ 
    if(!is.null(input$mhover$x)){
      nhover <<- nearPoints(mtcars,input$mhover,xvar = 'wt',yvar='mpg',
                            threshold = 15,maxpoints = 1)
    }
  })
  
  
  
  # Creamos una función para el gráfico
  colorear <- reactive({
    plot(mtcars$wt,mtcars$mpg, xlab = "wt", ylab="millas por galon")
    
    if(!is.null(global)){
      nuevos_clks()
      points(global$wt,global$mpg,col="green", pch = 19)
    }
    
    if(!is.null(nhover)){
      hover_n()
      points(nhover$wt,nhover$mpg,col="black", pch = 19)
    }
    
  })
  
  
  #Llamamos la función del gráfico
  output$plot_click_options <- renderPlot({
    colorear()
  })
  
  
  
  output$tabla_1 <- DT::renderDataTable({
    mtcars %>% DT::datatable(filter = 'top',
                            options = list(
                              pageLength = 5,
                              scrollX=TRUE))
  })

  output$tabla_2 <- DT::renderDataTable({
    nuevos_clks()
    if(nrow(global)!=0){
      global %>% DT::datatable(filter = 'top',
                               options = list(
                                 pageLength = 5,
                                 scrollX=TRUE))
    } else {
      mtcars[0,]
    }
  })
  
})