#---------------------------------------------------------------------------#
# Nom : europe_temperature.r                                                #
# Description : Spiral diagram from NY times replication project            #
# Auteur : Pietro Violo                                                     #
#---------------------------------------------------------------------------#

rm(list=ls(all=TRUE))
options(scipen=999)

# Library
library(tidyverse)
library(ggtext)
library(here)
library(lubridate)
library(viridis)
library(gganimate)

# Central England temperature from the met office
df <- read.table("https://www.metoffice.gov.uk/hadobs/hadcet/data/meantemp_monthly_totals.txt", skip = 4, header = T)

df <- df %>% select(- Annual) %>% 
  pivot_longer(Jan:Dec, values_to = "average_temp", names_to = "Month") %>% 
  filter(Year >= 1950)

df <- df %>% 
  filter(average_temp > -99.9) %>% mutate(Month = factor(Month, levels = c("Jan", "Feb", "Mar", 
                                                                           "Apr", "May", "Jun",
                                                                           "Jul", "Aug", "Sep",
                                                                           "Oct", "Nov", "Dec"))) 

# Close the gap

bridges <- df[df$Month == 'Jan',]
bridges$Year <- bridges$Year - 1    # adjust index to align with previous group
bridges$Month <- NA  

df <- rbind(df, bridges) %>% 
  arrange(Year, Month) %>% 
  mutate(frame_n = 1:943)

gg_df <- df %>% ggplot(aes(x = Month, y = average_temp, color = Year, group = Year)) +
  geom_line(size = 1.5) +
  scale_color_viridis(option = "magma") +
  theme_dark() +
  coord_polar() + 
  scale_x_discrete(expand = c(0,0), breaks = month.abb)


df_anim <- gg_df +
  labs(title = 'Year: {Year}', x = 'Month', y = 'Average temperature')+
  transition_reveal(frame_n) +
  shadow_mark(past = TRUE)


