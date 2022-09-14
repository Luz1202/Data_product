
library(shiny)
library(DT)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Laboratorio_1"),
  
  # Sidebar with a slider input for number of bins
  shiny::tabsetPanel(
    tabPanel("Interacciones",
             h2("Diagrama de dispersión"),
             plotOutput("plot_click_options",
                        click = "clk",
                        dblclick = "dclk",
                        hover = 'mhover',
                        brush = 'mbrush' ),
             h2('Clicked y Brushed'),
             fluidRow(
               column(6,h3('Clicked'),
                      DT::dataTableOutput("tabla_2")),
               column(6,h3('Brushed'),
                      DT::dataTableOutput("tabla_3"))
               )
             ),
    
    tabPanel("Tabla",
             h2('Estado inicial'),
             fluidRow(
               column(12,DT::dataTableOutput("tabla_1"))
               )
  )
)))
