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
df <- read.table("https://www.metoffice.gov.uk/hadobs/hadcet/data/meantemp_daily_totals.txt", header = T)

df <- df %>% mutate(Date =as.Date(Date, format = c("%Y-%m-%d"))) %>%
             mutate(Month = month(Date),
                    Day = day(Date),
                    Year = year(Date)) %>% 
  filter(Year >= 1870)

# # Calculate difference from a 30 year average
# # First, calculate a 30 year average
# 
# average30 <- c()
# 
# for(month in month.abb){
#   for(n in 1:122){
#     
#     average30 <- rbind(average30, cbind(mean(unlist((df %>% filter(Month == month))[n:(30+n),3]), na.rm = TRUE), month, paste(1900 + n)))
#   
#     }
# }

# average30_df <- as.data.frame(average30) %>% 
#   mutate(V1 = as.double(V1),
#          V3 = as.integer(V3))
# 
# colnames(average30_df) <- c("average30", "Month", "Year")
# 
# 
# df <- left_join(df, average30_df) %>% 
#   mutate(anomalies = average_temp - average30) %>% 
#   filter(Year >= 1900)
# 


# Close the gap

bridges <- df[df$Month == 'Jan',]
bridges$Year <- bridges$Year - 1    # adjust index to align with previous group
bridges$Month <- NA  

df <- rbind(df, bridges) %>% mutate(Month = factor(Month, levels = c("Jan", "Feb", "Mar", 
                                                                     "Apr", "May", "Jun",
                                                                     "Jul", "Aug", "Sep",
                                                                     "Oct", "Nov", "Dec"))) 

gg_df <- df %>% ggplot(aes(x = Month, y = anomalies, color = Year, group = Year)) +
  geom_path(size = 1.5) +
  scale_color_viridis(option = "magma") +
  theme_dark() +
  coord_polar() + 
  scale_x_discrete(expand = c(0,0), breaks = month.abb)


df_anim <- gg_df +
  labs(title = 'Frame: {frame_time}', x = 'Month', y = 'Temperature anomalies')+
  transition_time(Year) +
  shadow_mark(past = TRUE)

  

