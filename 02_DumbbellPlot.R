###############################################################################
######## Stata Conference 2022
######## Visualizing survey data-analysis results: Marrying the best from Stata and R
######## Code written by: Nel Jason L. Haw
######## Last updated: July 25, 2022
######## Creating the dumbbell plot

# Set working directory
setwd("C:/Users/neljasonhaw/OneDrive - Johns Hopkins/Dissertation/81 Stata Conference")

###############################################################################
# Read .dta using haven
# install.packages("haven")     # install if doing this for the first time
library(haven)                  # For opening Stata dta files
data <- read_dta("dumbbell.dta")
data

###############################################################################
# Create dumbbell plot
# install.packages(c("tidyverse", "ggalt")) # install if doing this for the first time
library(tidyverse)              # Includes ggplot2
library(ggalt)                  # Dumbbell plot extension of ggplot2
# Helpful guide: https://towardsdatascience.com/create-dumbbell-plots-to-visualize-group-differences-in-r-3536b7d0a19a

# Start with the basic plot
dumbbell <- ggplot(data = data,
                   aes(y = as.factor(survey), x = nonpoor, xend = poor)) +
            geom_dumbbell()
dumbbell

# Increase the size of the dumbbell plot and change colors
dumbbell <- dumbbell +
  geom_dumbbell(size = 2, color = "gray50",
                size_x = 6, 
                colour_x = "#024873", 
                size_xend = 6,
                colour_xend = "#920045")
dumbbell

# Add the rest of the modifications
dumbbell <- dumbbell +
  # Fit the axes
  scale_y_discrete(name = "", labels = paste0(data$survey, " (N = ", format(data$N, big.mark = ","), ")")) +
  scale_x_continuous(name = "", limits = c(0.4, 0.8), breaks = seq(0.4, 0.8, 0.2)) +
  # Add percentage labels
  geom_text(aes(x = nonpoor, y = as.factor(survey), label = format(nonpoor*100, digits = 3)),
          color = "#024873", size = 5, vjust = 2) +
  geom_text(aes(x = poor, y = as.factor(survey), label = format(poor*100, digits = 3)),
            color = "#920045", size = 5, vjust = 2) +
  # Add the dot legends
  geom_text(data = filter(data, as.factor(survey) == 2018),
          aes(x = nonpoor, y = 3, label = "NONPOOR"),
          color = "#024873", size = 5, vjust = -1.5, hjust = 0.75, fontface = "bold") + 
  geom_text(data = filter(data, as.factor(survey) == 2018),
            aes(x = poor, y = 3, label = "POOR"),
            color = "#920045", size = 5, vjust = -1.5, hjust = 0, fontface = "bold") +
  # Add the theme
  theme(plot.title = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 16, color = "black"),
        axis.title.x = element_text(face = "bold", size = 16, color = "black"),
        axis.title.y = element_blank(),
        axis.ticks = element_blank())
dumbbell