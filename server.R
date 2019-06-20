library(corrplot)
library(ggplot2)
library(markdown)
library(htmltools)
library(shinyjqui)
library(shiny)
library(ggpubr)

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  observeEvent(input$Apply, {
  dataset <- reactive({
    inFile <- input$inputId
    read.delim(inFile$datapath, 
               sep = gsub("\\t", "\t", 
                          input$datafile_sep, 
                          fixed = TRUE))
                      }
                     )
   
  numericColumns <- reactive({
    df <- dataset()
    names(df)[sapply(df, is.numeric)]
  })
  
  observeEvent(input$Delete_variables, {
  observe({
  updateSelectInput(session, 'Variables', choices = numericColumns(), selected=NULL)
    })
  })
  
  observeEvent(input$Select_variables, {
    updateSelectInput(session, "Variables", choices = numericColumns(), selected=numericColumns())
  })
  observe({
    updateSelectInput(session, 'Variables', choices = numericColumns(), selected=NULL)
  })
  observe({
    updateSelectInput(session, "Variables", selected = isolate(input$Vairables))
  })
  
  observeEvent(input$Scatterplot,{
  output$scatter <- renderPlot({
    variables <- input$Variables
    if (length(input$Variables) == 2){
      data <-  dataset()[,variables]
    ggplot(dataset()[,variables],aes(x=data[,1], y=data[,2])) +
      geom_point() +
      stat_cor(method = "spearman",label.x = 5) +
      geom_smooth(method='lm')
    }
    })
  })

  
  output$corrPlot <- renderPlot({
    variables <- input$Variables
    if(is.null(variables)) {
      NULL
    } else {
      corrplot(cor(dataset()[,variables], 
                   use = input$corUse, 
                   method = 'spearman'),
                   method=input$plotMethod,
               p.mat=cor.mtest(dataset()[,variables])$p)
    }
  })
  output$dataTable <- renderDataTable(dataset())
  })
})
  
