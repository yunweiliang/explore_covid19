library(tidyr)
library(dplyr)
library(lubridate)
library(ggplot2)

covid19_confirmed_raw <- read.csv('time_series_19-covid-Confirmed.csv', stringsAsFactors = FALSE)
covid19_deaths_raw <- read.csv('time_series_19-covid-Deaths.csv', stringsAsFactors = FALSE)
covid19_recovered_raw <- read.csv('time_series_19-covid-Recovered.csv', stringsAsFactors = FALSE)

covid19_confirmed <- gather(covid19_confirmed_raw, 
                     key = 'Date', 
                     value = 'Confirmed',
                     -(Province.State:Long))
covid19_deaths <- gather(covid19_deaths_raw,
                         key = 'Date',
                         value = 'Deaths',
                         -(Province.State:Long))
covid19_recovered <- gather(covid19_recovered_raw,
                            key = 'Date',
                            value = 'Recovered',
                            -(Province.State:Long))

covid19_collective <- left_join(covid19_confirmed, 
                                covid19_deaths,
                                by = c('Province.State', 
                                       'Country.Region',
                                       'Lat',
                                       'Long',
                                       'Date')) %>% 
  left_join(covid19_recovered,
            by = c('Province.State', 
                   'Country.Region',
                   'Lat',
                   'Long',
                   'Date')) %>% 
  mutate(Date = as.Date(Date, 'X%m.%d.%Y')) 
 # left_join(map_data('world'), by = c('Country.Region' = 'region'))


year(covid19_collective$Date) <- 2020

world_map <- map_data('world')

map_by_date <- function(date){
  # expects a Date object
  
  covid19_on_date <- covid19_collective[covid19_collective$Date == date,]
  result_map <- ggplot() +
    geom_polygon(data = world_map,
                 mapping = aes(x = long, 
                               y = lat, 
                               group = group)) + 
    geom_point(data=covid19_on_date, 
               mapping = aes(x = Long, y = Lat,
                             size = Confirmed,
                             color = 'red')) +
    coord_quickmap()
  
  return (result_map)
}

first_day <- map_by_date(as.Date('2020-01-22'))
