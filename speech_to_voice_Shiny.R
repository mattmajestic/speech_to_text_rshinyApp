library(shiny)
library(googleLanguageR)
library(tuneR)
library(stringr)
library(shinydashboard)


setwd("C:/Users/Matt/Documents/Sound recordings")
gl_auth("majesticCluster-2c47c76c005a.json")


ui <- dashboardPage(
  dashboardHeader(title = "Audio to Text"),
  dashboardSidebar(),
  dashboardBody(
    fileInput("audio_file",label = "Upload .wav"),
    textOutput("audio_text")))

server <- function(input,output,session){
  
  observeEvent(input$audio_file,{
    output$audio_text <- renderText({
      inFile <- input$audio_file
      audio_name <- inFile$name
      audio_size <- inFile$size
      wav_file <- readWave(audio_name)
      wav_file_mono <- mono(wav_file, which = c("left", "right", "both"))
      play(wav_file_mono)
      writeWave(wav_file_mono, paste0("C:/Users/Matt/Documents/Sound recordings/",audio_name), extensible = F)
      wav_text <<- gl_speech(paste0("C:/Users/Matt/Documents/Sound recordings/",audio_name),sampleRateHertz=48000)
      wav_text$transcript$transcript
    })
  })
  
  output$audio_text <- renderText("Nothing Yet")
}

shinyApp(ui,server)
