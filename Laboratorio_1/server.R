
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

shinyServer(function(input, output) {
  
  #Creamos una variable global
  global <<- data.frame(NULL)
  nhover <<- data.frame(NULL)
  nbrush <<- data.frame(NULL)
  
  
#FUNCIÓN 1, PARA CAPTURA DE CLICKS
  nuevos_clks <- reactive({

    if(!is.null(input$clk$x)){
      nclk <- nearPoints(mtcars,input$clk,xvar = 'wt',yvar='mpg', maxpoints = 1)
      nclk[,c("n","id")] <- c(NULL,paste(as.integer(input$clk$x),
                                  as.integer(input$clk$y),
                                  sep = "-"))
      
      global <<- rbind(global,nclk)
      global$n <<- c(1:length(global$id))
      } 
    
    if(!is.null(input$dclk$x)){
      ndbclk <- nearPoints(mtcars,input$dclk,xvar = 'wt',yvar='mpg',maxpoints = 1,threshold = 15)
      ndbclk[,c("n","id")] <- c(NULL,paste(as.integer(input$dclk$x),
                                         as.integer(input$dclk$y),
                                         sep = "-"))
    opt <- global %>%
      dplyr::filter(id == ndbclk$id[1])

    if(!is.null(opt)){
      if(ndbclk$id[1] != "NA"){
      global <<- global[-opt$n[1],]
      global$n <<- c(1:length(global$id))}
    }
    }
})
  
  
##FUNCIÓN 2: PARA HOVER
  hover_n <- reactive({ 
    if(!is.null(input$mhover$x)){
      nhover <<- nearPoints(mtcars,input$mhover,xvar = 'wt',yvar='mpg',threshold = 15,maxpoints = 1)
    }
  })
    
  brush_n <- reactive({ 
    if(!is.null(input$mbrush$xmin)){
      nbrush <<- brushedPoints(mtcars,input$mbrush,xvar='wt',yvar='mpg')}
    })
  
  output$click_data_test <- renderPrint({
    print(brush_n())
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
      points(nhover$wt,nhover$mpg,col="gray", pch = 19)
    }
    
    if(!is.null(nbrush)){
      brush_n()
      points(nbrush$wt,nbrush$mpg,col="blue", pch = 19)
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
      NULL
    }
  })
  
  output$tabla_3 <- DT::renderDataTable({
    brush_n()
    if(nrow(nbrush)!=0){
      nbrush %>% DT::datatable(filter = 'top',
                               options = list(
                                 pageLength = 5,
                                 scrollX=TRUE))
    } else {
      NULL
    }
  })
})