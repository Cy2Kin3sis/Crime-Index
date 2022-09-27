library(shiny)
library(shinythemes)
library(DT)
library(ggplot2)
library(plotly)
library(corrplot)
library(ggcorrplot)

# dataset <- read.csv("crimerate.csv",header = TRUE)
# head(dataset, n=15)

dataset <- read.csv("crime.csv",header = TRUE)

# ignoring non-numerical data

#nonum <- dataset[!is.na(as.numeric(dataset$City)), ]
nonum <- dataset[, -1]
#nonum

#correlation
correlate <- round(cor(nonum), 1)

ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage("Crime Rate of the 20 Most Populous Cities in the Philippines",
                  tabPanel("Main Page",
                           HTML("<h2 align='center'>ABSTRACT</h2>"),
                           HTML("<p align='justify'>Crime is an action that constitutes an offense that 
                                is punishable by law. Crime includes acts such as breaking into someone’s home, 
                                stealing from someone, selling dangerous drugs, killing, and assaulting. Among all countries, 
                                Venezuela has the highest crime rate, followed by Papua New Guinea and South Africa.  
                                Philippines has a crime index of 42.46. On the other hand, population density measures the average 
                                number of persons per square unit.  Monaco has the highest population density of 26,523 people per 
                                square kilometer. This paper tackles the relationship between the crime index of a city and its 
                                population density, along with a few factors such as the city’s safety index when walking alone at 
                                daytime or nighttime. Let us also check if government efficiency and economic dynamism also affect these variables</p>"),
                           HTML("<h3>Definition of terms</h3>
                                <ul>
                                <li><b>Population</b> - number of inhabitants in a particular town or city</li>
                                <li><b>Population Density</b> - number of inhabitants per unit of area</li>
                                <li><b>Crime index</b> - a view of relative risk of specific crime types</li>
                                <li><b>Economic dynamism</b> - rate and direction of change in an economy</li>
                                </ul>
                                "),
                           HTML("<br><br>
                                  <p>Learning Evidence for CSDS312 - Applied Data Science</p>
                                  <br>
                                  <p><b>Submitted by:</b> Kent Cyril Bordios</p>")
                           ),
                  tabPanel("Dataset",
                           sidebarPanel(
                             HTML("<h3>Crime Data</h3>"),
                             HTML("<p align='justify'>This dataset was manually gathered from 
                                  <a href='https://www.numbeo.com/'>Numbeo</a> 
                                  for crime statistics, 
                                  <a href='https://psa.gov.ph/content/highlights-population-density-philippines-2020-census-population-and-housing-2020-cph#'>the PSA website</a>
                                  for population and population density, and 
                                  <a href='https://cmci.dti.gov.ph/rankings-data.php'>the DTI website</a> 
                                  for government efficiency and economic dynamism.</p>"),
                             HTML("<h3>Description</h3>"),
                             HTML("<ul>
                             <li><b>Population</b> - the city's/municipality's recorded population in 2020 (PSA)</li>
                             <li><b>PopDensity</b> - the city's/municipality's population density in 2020 (PSA)</li>
                             <li><b>Index</b> - the recorded crime index</li>
                             <li><b>SafeDay</b> - safety walking alone at daytime</li>
                             <li><b>SafeNight</b> - safety walking alone at nighttime</li>
                             <li><b>EconDyn</b> - economic dynamism</li>
                             <li><b>GovEff</b> - government efficiency</li>
                                  </ul>")
                           ), 
                           mainPanel(
                             dataTableOutput("datacrime"),
                             br(),
                           ) 
                           
                  ),
                  
                  tabPanel("Data Visualization",
                           navlistPanel("Characteristic",
                                        tabPanel("Population",
                                                 tabsetPanel(type = "tabs",
                                                             tabPanel("Graph", plotOutput("bar1"))
                                                 )
                                        ),
                                        tabPanel("Density",
                                                 tabsetPanel(type = "tabs",
                                                             tabPanel("Graph", plotOutput("bar2"))
                                                 )
                                        ),
                                        tabPanel("Crime Index",
                                                 tabsetPanel(type = "tabs",
                                                             tabPanel("Graph", plotOutput("bar3"))
                                                 )
                                        ),
                                        tabPanel("Safety Walking Alone",
                                                 tabsetPanel(type = "tabs",
                                                             tabPanel("Daytime", plotOutput("bar4")),
                                                             tabPanel("Nighttime", plotOutput("bar5"))
                                                 )
                                        ),
                                        tabPanel("Economic Dynamism",
                                                 tabsetPanel(type = "tabs",
                                                             tabPanel("Graph", plotOutput("bar6")))
                                        ),
                                        tabPanel("Government Efficiency",
                                                 tabsetPanel(type = "tabs",
                                                             tabPanel("Graph", plotOutput("bar7")))
                                        )
                           
                           )
                           ),
                  
                  tabPanel("Analysis and Interpretation",
                           navlistPanel("Plot Type",
                                        tabPanel("Scatterplots",
                                                 tabsetPanel(type = "pills",
                                                             tabPanel("Scat 1", plotOutput("scat1"),
                                                                      HTML("<p>The city's/municipality's population and crime index show a weak but significant positive correlation.</p>")),
                                                             tabPanel("Scat 2", plotOutput("scat2"),
                                                                      HTML("<p>Population density and crime index show a weak positive correlation.</p>")),
                                                             tabPanel("Scat 3", plotOutput("scat3"),
                                                                      HTML("<p>Safety indices at daytime and nighttime are strongly positively correlated.</p>")),
                                                             tabPanel("Scat 4", plotOutput("scat4"),
                                                                      HTML("<p>While it shows a bit positive correlation, crime index and government efficiency are almost not correlated.</p>")),
                                                             tabPanel("Scat 5", plotOutput("scat5"),
                                                                      HTML("<p>Government efficiency and economic dynamism are strongly correlated.</p>")),
                                                             tabPanel("Scat 6", plotOutput("scat6"),
                                                                      HTML("<p>Economic dynamism and crime index are almost not correlated.</p>"))
                                                             )
                                                 ),
                                        tabPanel("Boxplot",
                                                 tabsetPanel(type = "pills",
                                                             tabPanel("Box 1", plotOutput("box1")),
                                                             tabPanel("Box 2", plotOutput("box2")),
                                                             tabPanel("Box 3", plotOutput("box3")),
                                                             )
                                                 ),
                                        tabPanel("Correlogram",
                                                 tabsetPanel(type="pills",
                                                             tabPanel("All Variables", plotOutput("correloplot"),
                                                                      HTML("<p align='justify'>Two pairs of variables showed the highest <b>positive</b> correlation, namely
                                                                           the government efficiency & population and nighttime safety & daytime safety. Three pairs showed
                                                                           zero correlation, namely population density & economic dynamism, nighttime safety & government efficiency,
                                                                           and daytime safety & economic dynamism. This means these pairs have <b>no linear relationship</b> with each other.
                                                                           Daytime and nighttime safety variables each showed the strongest <b>negative</b> correlation with the crime index,
                                                                           as crime and safety are two opposing characteristics.</p>"))
                                                             )
                                          
                                                 )
                                        )
                           
                           )
                  
                  )
)

server <- function(input, output){
  
  # Dataset Output
  
  output$datacrime <- renderDataTable(dataset)
  
  # Population
  
  output$bar1 <- renderPlot({
    ggplot(dataset, aes(City, Population)) +
      geom_bar(stat="identity", position=position_dodge(), fill = "#2C3E50") +
      labs(x = "City/Municipality",
           y = "Population") +
      theme_minimal()
  })
  
  # Population Density
  output$bar2 <- renderPlot({
    ggplot(dataset, aes(City, PopDensity)) +
      geom_bar(stat = "identity", position = position_dodge(), fill = "#2C3E50") +
      labs(x = "City/Municipality",
           y = "Density") +
      theme_minimal()
  })
  
  # Crime Index
  output$bar3 <- renderPlot({
    ggplot(dataset, aes(City, Index)) +
      geom_bar(stat="identity", position=position_dodge(), fill = "#2C3E50") +
      labs(x = "City/Municipality",
           y = "Crime Index") +
      
      theme_minimal()
  })
  
  # Daytime
  
  output$bar4 <- renderPlot({
    ggplot(dataset, aes(City, SafeDay)) +
      geom_bar(stat="identity", position=position_dodge(), fill = "#2C3E50") +
      labs(x = "City/Municipality",
           y = "Safety Index at Daytime") +
      
      theme_minimal()
  })
  
  # Nighttime
  
  output$bar5 <- renderPlot({
    ggplot(dataset, aes(City, SafeNight)) +
      geom_bar(stat="identity", position=position_dodge(), fill = "#2C3E50") +
      labs(x = "City/Municipality",
           y = "Safety Index at Nighttime") +
      
      theme_minimal()
  })
  
  output$bar6 <- renderPlot({
    ggplot(dataset, aes(City, EconDyn)) +
      geom_bar(stat="identity", position=position_dodge(), fill = "#2C3E50") +
      labs(x = "City/Municipality",
           y = "Economic Dynamism") +
      
      theme_minimal()
  })
  
  output$bar7 <- renderPlot({
    ggplot(dataset, aes(City, GovEff)) +
      geom_bar(stat="identity", position=position_dodge(), fill = "#2C3E50") +
      labs(x = "City/Municipality",
           y = "Government Efficiency") +
      
      theme_minimal()
  })
  
  # Scatterplot
  
  # Population vs Crime Index
  
  output$scat1 <- renderPlot({
    ggplot(dataset,aes(Population, Index)) +
      geom_point(size = 2, color = "#2C3E50") +
      geom_smooth(method = "lm", formula = y~x, col = "#000000") +
      labs(x = "Population",
           y = "Crime Index") +
      theme_minimal()
  })
  
  # Density vs Crime Index
  
  output$scat2 <- renderPlot({
    ggplot(dataset,aes(PopDensity, Index)) +
      geom_point(size = 2, color = "#2C3E50") +
      geom_smooth(method = "lm", formula = y~x, col = "#000000") +
      labs(x = "Population Density",
           y = "Crime Index") +
      theme_minimal()
  })
  
  # SafeDay vs SafeNight
  
  output$scat3 <- renderPlot({
    ggplot(dataset,aes(SafeDay, SafeNight)) +
      geom_point(size = 2, color = "#2C3E50") +
      geom_smooth(method = "lm", formula = y~x, col = "#000000") +
      labs(x = "Safety at Daytime",
           y = "Safety at Nighttime") +
      theme_minimal()
  })
  
  # Crime Index vs Government Efficiency
  
  output$scat4 <- renderPlot({
    ggplot(dataset,aes(Index, GovEff)) +
      geom_point(size = 2, color = "#2C3E50") +
      geom_smooth(method = "lm", formula = y~x, col = "#000000") +
      labs(x = "Crime Index",
           y = "Government Efficiency") +
      theme_minimal()
  })
  
  # Government Efficiency vs Economic Dynamism
  
  output$scat5 <- renderPlot({
    ggplot(dataset,aes(GovEff, EconDyn)) +
      geom_point(size = 2, color = "#2C3E50") +
      geom_smooth(method = "lm", formula = y~x, col = "#000000") +
      labs(x = "Government Efficiency",
           y = "Economic Dynamism") +
      theme_minimal()
  })
  
  # Economic Dynamism vs Crime Index
  
  output$scat6 <- renderPlot({
    ggplot(dataset,aes(EconDyn, Index)) +
      geom_point(size = 2, color = "#2C3E50") +
      geom_smooth(method = "lm", formula = y~x, col = "#000000") +
      labs(x = "Economic Dynamism",
           y = "Crime Index") +
      theme_minimal()
  })
  
  # Boxplots
  
  # Population vs Crime Index
  
  output$box1 <- renderPlot({
    ggplot(dataset,aes(Population, Index)) +
      geom_boxplot(outlier.size=2,
                   size=.75,
                   fill = "#2C3E50") +
      labs(x = "Population",
           y = "Crime Index") +
      theme_minimal()
  })
  
  # Density vs Crime Index
  
  output$box2 <- renderPlot({
    ggplot(dataset,aes(PopDensity, Index)) +
      geom_boxplot(outlier.size=2,
                   size=.75,
                   fill = "#2C3E50") +
      labs(x = "Population Density",
           y = "Crime Index") +
      theme_minimal()
  })
  
  # Government Efficiency vs Crime Index
  
  output$box3 <- renderPlot({
    ggplot(dataset,aes(Index, GovEff)) +
      geom_boxplot(outlier.size=2,
                   size=.75,
                   fill = "#2C3E50") +
      labs(x = "Government Efficiency",
           y = "Crime Index") +
      theme_minimal()
  })

  # Correlogram
  
  output$correloplot <- renderPlot({
    ggcorrplot(correlate, hc.order = TRUE,
               type = "lower",
               lab = TRUE,
               lab_size = 3,
               method = "square",
               colors = c("#ff5050","white","#66ff66"),
               title = "Correlogram of variables",
               ggtheme = "theme_bw")
  })
    
} 

shinyApp(ui, server)