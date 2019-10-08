library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(rgdal)
library(data.table)
library(choroplethr)
library(choroplethrZip)

mydata <- fread("../data/combineddata.csv",
                stringsAsFactors = FALSE)
mydata$health <- recode(mydata$health,"GOOD"="Good","POOR"="Poor", "FAIR"="Fair","DEAD"="Dead")


data("zip.regions")
valid_region <- zip.regions$region

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  dfInput <- reactive({
    mydata %>%  
      filter(year == input$RY) %>%
      filter(tree_dbh > input$diameter[1]) %>%
      filter(tree_dbh < input$diameter[2]) %>%
      group_by(postcode) %>% 
      count(health) %>%
      ungroup() %>% 
      filter(health == input$healthp) %>%
      mutate(region = as.character(postcode), value = n) %>% 
      filter(region %in% valid_region) %>% 
      select(region, value)
  })
  
  
  
  output$map <- renderLeaflet({
    df_1 <- dfInput()
    NYCzip <- readOGR("../data/ZIP_CODE_040114.shp", verbose = FALSE)
    selectZip <- subset(NYCzip, NYCzip$ZIPCODE %in% df_1$region)
    subdat <- spTransform(selectZip, CRS("+init=epsg:4326"))
    subdat_data <- subdat@data[,c("ZIPCODE","POPULATION")]
    subdat.rownames <- rownames(subdat_data)
    subdat_data$ZIPCODE <- as.character(subdat_data$ZIPCODE)
    subdat_data <- subdat_data %>% left_join(df_1, by=c("ZIPCODE" = "region"))
    rownames(subdat_data) <- subdat.rownames
    subdat <- SpatialPolygonsDataFrame(subdat, data=subdat_data)
    
    pal1 <- colorNumeric(palette = "Reds", domain = subdat$value)
    
    popup1 = paste0('</strong>ZIP:<strong>', subdat$ZIPCODE, '<br></strong>Count:<strong>', subdat$value)
    
  #  labels <- sprintf(
  #    "Zip Code: <strong>%s</strong><br/> Count: <strong>%g<sup></sup></strong>",
  #    as.character(subdat$ZIPCODE), subdat$value
  #  ) %>% lapply(htmltools::HTML)
    
    leaflet(subdat) %>% 
      #addProviderTiles("CartoDB.Positron") %>%
      addProviderTiles("Esri.WorldGrayCanvas",
                       options = tileOptions(minZoom=9.2, maxZoom=13)) %>%
      setView(-73.95, 40.705, zoom = 9.5) %>%
      addPolygons(fillColor = ~pal1(subdat$value),
                  fillOpacity = 0.7,
                  color = "darkgrey",
                  weight = 1.5, 
                  #label = labels,
                  highlightOptions = highlightOptions(color="black", opacity = 0.5,
                                                      weight = 2, fillOpacity = 0.9,
                                                      bringToFront = TRUE, sendToBack = TRUE),
                  #labelOptions = labelOptions(
                  #  style = list("font-weight" = "normal", padding = "3px 8px"),
                  #  textsize = "12px",
                  #  direction = "auto"),
                  popup = popup1,
                  
                  group= "2015") %>%
      addLegend(position = "bottomright",
                pal = pal1,
                values = ~value,
                opacity = 0.6,
                title = "Value"
      )
    
    
  })
  
  observeEvent(input$map1_shape_click, {
    click <- input$map1_shape_click
    posi <- reactive({input$map1_shape_click})
  }
  )
    
    observeEvent(input$details,{
      if (input$details){
        updateTabsetPanel(session, "NYCTREE", selected = "Panel2")
      }
      
    })
  
    ######### Panel 2 plotting #########
    
    dfPlot <- reactive({
      mydata %>% 
        filter(year == input$RY2) %>% 
        filter(postcode ==strtoi(input$zipcode))
    })
    

    
    output$plot1 <- renderPlot({
      
      df_2 <- dfPlot()
      data <- df_2
      
      numberoftrees <- data.frame(table(data$spc_common))
      numberoftrees <- numberoftrees[order(-numberoftrees$Freq),]
      specieswant <- numberoftrees$Var1[1:12]
      interactivedata <-  mydata[mydata$spc_common %in% specieswant,]
      
      
      plot1<- ggplot(interactivedata, aes(x=reorder(spc_common,spc_common,function(x)length(x)))) + 
        geom_bar(aes(y=(..count..), fill = health)) + 
        scale_fill_brewer("Health Status")+
        labs(title="TOP 12 Species Count ", x="Species", y = "Count") +
        theme_light()+
        theme(plot.title = element_text(size=30, face="bold", hjust = 0.5),
              axis.text=element_text(size=16),
              axis.title=element_text(size=20)) + 
        coord_flip()+ 
        scale_y_continuous(name="Count", labels = scales::comma)
      
      plot2<- ggplot(interactivedata, aes(x=tree_dbh)) + 
        geom_density(data = data, aes(fill="Overall"), alpha = 0.5) + 
        geom_density(aes(fill="Selected"), alpha = 0.5) +
        labs(title="Tree Diameter Density Curve", x="Breast Height Diameter/inch", y = "Density")+
        theme_light()+
        theme(plot.title = element_text(size = 30, face = "bold", hjust = 0.5),
              axis.text=element_text(size=16),
              axis.title=element_text(size=20)) + 
        xlim(0,50)+
        scale_fill_manual(breaks=c("Overall",'Selected'),values=c('lightgrey','lightblue'), name = "Range")
      
      require(gridExtra)
      
      grid.arrange(plot1, plot2, ncol=1)
    })
    
    ########## Panel 3 plotting #########
    
    dfPlot2 <- reactive({
      mydata %>% 
        filter(year == input$RY3) %>%
        filter(postcode ==strtoi(input$zipcode)) %>%
        filter(tree_dbh > input$diameter3[1]) %>%
        filter(tree_dbh < input$diameter3[2])
    })
    
    output$plot2 <- renderPlot({
      
      df_3 <- dfPlot2()
      
      blank_theme <- theme_minimal()+
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          panel.border = element_blank(),
          panel.grid=element_blank(),
          axis.ticks = element_blank(),
          plot.title=element_text(size=30, face="bold",hjust=0.5)
        )
      
      ggplot(df_3, aes(x=factor(1), fill=health))+
        geom_bar(width = 1)+ 
        scale_fill_brewer("Health Status")+
        coord_polar("y")+ 
        labs(title = "Health Pie Chart")+
        blank_theme+  
        theme(axis.text.x=element_blank())
      
      
    })
    
    
    
})
