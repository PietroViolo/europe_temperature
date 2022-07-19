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

# Central England temperature from the met office
df <- read.table("https://www.metoffice.gov.uk/hadobs/hadcet/data/meantemp_monthly_totals.txt", skip = 4, header = T)

