# Project 2: NYC Trees 
+ Shiny App Development Version 2.0
+ Term: Fall 2019
+ Team sec1-grp1


### [Project Description](doc/project2_desc.md)

The app can be accessed through this link: https://kaiyanzheng.shinyapps.io/Proj2-sec1-grp1/

There are three panels in the app. Each panel can perform a very straightforward function. Users can interact with the app by choosing the filter condition.
![panel1](output/panel1.png)
![panel2](output/panel2.png)
![panel3](output/panel3.png)

+ **Group Menbers**: 
  + Ponkshe, Tushar tvp2110@columbia.edu
  + Qiu, Feng fq2150@columbia.edu
  + Wu, Bingquan bw2585@columbia.edu
  + Zhang, Shijie sz2781@columbia.edu
  + Zheng, Kaiyan kz2324@columbia.edu

+ **Dataset**: Due to the limitation of the maximum size of uploading files by Github, the dataset used in the project cannot be uploaded in the `data` file. However, the [integrated datset](data/combineddata.csv) is contained. The original datasets can be found on [NYC Open Data](https://opendata.cityofnewyork.us/). Linked bewlow:
  + [1995 Street Tree Census](https://data.cityofnewyork.us/Environment/1995-Street-Tree-Census/7gmq-dbas)
  + [2005 Street Tree Census](https://data.cityofnewyork.us/Environment/2005-Street-Tree-Census/ye4j-rp7z)
  + [2015 Street Tree Census](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/pi5s-9p35) 

+ **Project summary**: This shinyapp provides a directive visualizaiton of trees distribution in New York City, as well as the basic health condition of trees and diameter of breast height in different districts. According to the dataset used in the project, most trees in New York City are planted in the Statent Island while Manhattan is the area with the least trees planted if trees in Central Park are not accounted. In each district of New York City, trees are mostly in "Good" condition with approximately 5 inch diameter at breast height.

+ **Contribution statement**: 
  + **Ponkshe, Tushar**: Created the basic frame of the app, presented the final app
  + **Qiu, Feng**: Improved the detailed output and layout of the shinyapp and the Github page, added the control panels
  + **Wu, Bingquan**:  Provided the idea of the tree dataset and its source, plotted the tree ggplot map (Panel 2 & 3)
  + **Zhang, Shijie**: Created the map pattern and integrates the data to form the leafletout map (Panel 1)
  + **Zheng, Kaiyan**: Deployed the app to the cloud with Shinyapps.io, improved the details in output and Github page
  
Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
|-- app/
|-- lib/
|-- data/
|-- doc/
|-- output/
```

Please see each subfolder for a README file.

