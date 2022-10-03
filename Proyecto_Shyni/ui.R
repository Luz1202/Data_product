
library(shiny)
library(DT)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Laboratorio_1"),
  
  # Sidebar with a slider input for number of bins
  shiny::tabsetPanel(
    tabPanel("Interacciones",
             h1("Diagrama de dispersión"),
             plotOutput("plot_click_options",
                        click = "clk",
                        dblclick = "dclk",
                        hover = 'mhover',
                        brush = 'mbrush' ),
             fluidRow(h1('Datos seleccionados'),
               column(12,DT::dataTableOutput("tabla_2")))
               )
    )
))
