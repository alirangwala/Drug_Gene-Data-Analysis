library(shiny)
library(rentrez)
library(ggplot2)
library(boot)
ui<- bootstrapPage(
  div(style="display:inline-block",textInput("text1", label = h3("Gene"), value = "Replace text with Gene...")),
  div(style="display:inline-block",textInput("text2", label = h4("Drug Name"), value = "Replace text with Drug...")),
div(style="display:inline-block",sliderInput("slider", label = "Years", min = 2000, 
                                             max = 2016, value = c(2011, 2016))),
  plotOutput(outputId = 'scatter')       

)


server<-function(input,output){
output$scatter<-renderPlot({
  
    search_year <- function(year, term){
      query <- paste(term, "AND (", year, "[PDAT])")
      entrez_search(db="pubmed", term=query, retmax=0)$count
    }
    
    search<-paste(input$text1, "AND", input$text2,sep=" ")
    year <- input$slider[1]:input$slider[2]
    papers <- sapply(year, search_year, term=search, USE.NAMES=FALSE)
    
  plot(year, papers, type='b',
         main=paste("Count of Papers with",input$text1,"AND",input$text2, sep=" "))
    })

  
}


shinyApp(ui=ui, server=server)