library(ggplot2)
library(grid)
library(rworldmap)
library(magick)
library(tidyverse)


europa   <- read.delim("raw/europe.csv", sep = ',', header = F)
members  <- read.delim("raw/members.csv", sep = ',', header = T)
ecnp_lab <- image_read("raw/resilience-network.png") %>% rasterGrob()



map_figure <- map_data("world") %>% 
  
  filter(region %in% europa$V1) %>% 

  mutate(represented = 
           case_when(region %in% members$Country ~ TRUE, 
                     .default = FALSE)
         ) %>% 

ggplot() +
  aes(x = long, y = lat) +
  
  #Fill in countries
  geom_polygon(aes(group = group, fill = represented), color = "#17513f", show.legend = FALSE) +
  
  #Mark specific places
  geom_point(data = members, aes(x = long, y = lat), 
             fill = "#17513f", colour = "#0c2a21",
             stroke = 1, size = 2.5, shape = 21)+
  
  #Control the colours of countries
  scale_fill_manual(values = c("TRUE" = "#43b590", "FALSE" = "#bae6d7")) +
  
  #Add ECNP resilience logo
  annotation_custom(ecnp_lab,-27.5, -5.5,25, 70) +
  theme_bw() +
  
  #Make nice borders
  coord_cartesian(xlim = c(-25, 45), ylim = c(35, 70))  +
  xlab(NULL) + ylab(NULL) +
  #Get rid of axis ticks
  theme(axis.text = element_blank(), axis.ticks = element_blank())


