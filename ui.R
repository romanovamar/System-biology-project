library(shiny)
library(corrplot)
library(ggplot2)
library(markdown)
library(htmltools)
library(shinyjqui)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Correlation on custom data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput('inputId',''),
      textInput("datafile_sep", "Field Seperator", value = ","),
      selectInput("corUse", "NA Action",
                  c("everything", "complete.obs", "na.or.complete", "pairwise.complete.obs")),
      selectInput("plotMethod", "Plot Method",
                  choices = eval(formals(corrplot)$method), "circle"),
      actionButton(inputId = 'Apply',
                   label = 'Apply')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel( 
        tabPanel("Data",
                 dataTableOutput("dataTable")),
        
        tabPanel("Correlation",
                 fluidRow(
                 column(12, 
                        actionButton("Select_variables", "Select all"),
                        actionButton("Delete_variables", "Delete all"),
                        actionButton("Scatterplot", "Scatterplot"),
                        selectInput("Variables",'',choices=NULL,selected=NULL,multiple =T,selectize = T)
                        )),
                 fluidRow(
                 column(12, 
                        jqui_resizable(plotOutput("corrPlot", width = '500px', height = '500px'),
                                       uiOutput("warning"))),
                 

                 column(11,
                        jqui_resizable(plotOutput("scatter", width = '500px', height = '500px')))
                 
                 )
                 
                 
             )
      )
    )
  )
))
