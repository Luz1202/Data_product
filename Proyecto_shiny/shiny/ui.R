library(shiny)
library(shinythemes)
library(markdown)
library(lubridate)
library(shinyWidgets)

shinyUI(fluidPage(theme = shinytheme("sandstone"),
                  
                  navbarPage("Juegos Olimpicos",
                             tabPanel("Eventos", icon = icon("fa-light fa-calendar-star"),
                                      sidebarLayout(
                                        sidebarPanel(
                                          h2('Eventos Olimpicos'),
                                          h4('Complete los 3 filtros para ver su informacion'),
                                          br(),
                                          sliderInput('ChooseYear', 'Seleccione Rango de Años:',
                                                      value = c(min(athlete_events$Year), max(athlete_events$Year)),sep = "", 
                                                      min = min(athlete_events$Year), max = max(athlete_events$Year),
                                                      step = 2),
                                          br(),
                                          pickerInput('selectHost', 'Seleccione Ciudad Host:',
                                                      choices = unique(sort(athlete_events$City)),
                                                      options = list(`actions-box` = TRUE),
                                                      multiple = T),
                                          br(),
                                          checkboxGroupInput('chkboxSeason', 'Seleccione Temporada:',
                                                             choices = unique(athlete_events$Season),
                                                             selected = NULL, inline = TRUE),
                                          br(),
                                          actionButton("clean","Limpiar")
                                        ),
                                        mainPanel(
                                          dataTableOutput("tablaEventos")
                                        )
                                      )
                             ),
                             tabPanel("Equipos",icon = icon("fa-thin fa-users-viewfinder"),
                             ),
                             tabPanel("Atletas", icon = icon("fa-thin fa-ranking-star"),
                                      sidebarLayout(
                                        sidebarPanel(width = 3,
                                                     h2('Atletas participantes'),
                                                     br(),
                                                     checkboxGroupInput('season','Season',choices = unique(athlete_events$Season), 
                                                                        selected = unique(athlete_events$Season)),
                                                     numericInput('year','Year',value = 2000, step = 2, min = min(athlete_events$Year), 
                                                                  max = max(athlete_events$Year)),
                                                     selectInput('sport', 'Sport', choices = unique(athlete_events$Sport),selected = NULL)
                                        ),
                                        mainPanel(
                                          tabsetPanel(
                                            tabPanel(
                                              "Informacion General",
                                              h2("Informacion Atletas"),
                                              fluidRow(
                                                column(12, dataTableOutput('tablaAtletas'))
                                              )
                                            ),
                                            tabPanel(
                                              "Edad y Sexo",
                                              fluidRow(
                                                column(6, 
                                                       h4("Grafica Sexo"),
                                                       plotOutput('plotSexo')),
                                                column(6,
                                                       h4("Grafica Edades"),
                                                       plotOutput('plotEdades'))
                                              )
                                            )
                                          )
                                        )
                                      )
                             ),
                             tabPanel("Logros", icon = icon("fa-duotone fa-medal"),
                             )
                  )
)
)