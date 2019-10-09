library(shiny)
library(leaflet)
library(scales)

shinyUI(
  ########## Navbar Heading ##########
  navbarPage("NYC Trees", id = "NYCTREE",
             
  ########## 1st Panel ##########           
    tabPanel("Distribution", value = "Panel1",

  ########## Map output 
           div(class = "outer",
               tags$style(".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
               leafletOutput(outputId = "map", width = "100%",height = "100%")),
  ########## Condition Section
           absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                         draggable = FALSE, top = 60, left = "auto", right = 0, bottom = "auto",
                         width = 160, height = 120,
                         radioButtons("RY", label = "Recording Year",
                                      choices = list("1995" , "2005", "2015"),
                                      selected = "1995")),
  ##########  Recording Year Section
           absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                         draggable = TRUE, top = 60, left = 0, right = 40, bottom = "auto",
                         width = 300, height= "auto",
                         
                         h3("Conditions"),
                         
                         selectInput("healthp", label = h4("Health Problem"),
                                     choices = list("Good", "Fair","Poor", "Dead"),
                                     selected = "GOOD"),

                         sliderInput("diameter", label = h4("Diameter"), min = 0, max = 50, value = c(0,50)
                         )
                         
                         
           )
   ),
  
   
  ########## 2rd Panel ##########
  tabPanel("Health Condition", value = "Panel2",
           sidebarLayout(
             ######### Panel
            sidebarPanel(
              
                        h3("Controls"),
              
                        radioButtons("RY3",inline = TRUE, label = "Recording Year",
                                      choices = list("1995" , "2005", "2015"),
                                      selected = "1995"),
                         
                         textInput("zipcode", "Zip Code: \n (10001 - 10475)", "10025"),
                         
                         sliderInput("diameter3", label = h3("Diameter"), min = 0, max = 50, value = c(0,50))
           ),
            ####### plot output
           mainPanel(
             plotOutput(outputId = "plot2",height = "700")
           )
         )
   ),
  ########## 3rd Panel ##########
  tabPanel("Detailed Information", value = "Panel2",
           sidebarLayout(
             ######## Panel
             sidebarPanel(
               
               h3("Controls"),
               
               radioButtons("RY2",inline = TRUE, label = "Recording Year",
                            choices = list("1995" , "2005", "2015"),
                            selected = "1995"),
               
               textInput("zipcode", "Zip Code: (10001 - 10475)", "10025")
             ),
             ####### Plottting
             mainPanel(
               plotOutput(outputId = "plot1",height = "700")
             )
           )
         )
  )
)

