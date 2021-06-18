library(dplyr)
library(nycflights13)
library(tidyverse)

flights

#Filter shows a subset of the data based on your restrictions
filter(data = flights, month == 1, day == 1)

filter(flights, month == 11 | month == 12)

#Find all flights that:

#Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)

#Flew to Houston (IAH or HOU)
filter(flights, dest == 'IAH' | dest == 'HOU')
filter(flights, dest %in% c('IAH', 'HOU'))

#Were operated by United, American, or Delta
filter(flights, carrier %in% c('UA', 'AA', 'DL'))

#Departed in summer (July, August, and September)
filter(flights, month %in% c(7, 8, 9))

#Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay > 120 & dep_delay <= 0)

#Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60 & arr_delay <=30)

#Departed between midnight and 6am (inclusive)
filter(flights, between(dep_time, 0000, 0600)) 

#How many flights have a missing dep_time?
filter(flights, dep_time == NA)



#arrange() works similarly to filter() except that instead
#of selecting rows, it changes their order.

arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))

arrange(flights, desc(is.na(dep_delay)))



#select() is used to filter variables you are interested in
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

#rename is pretty obvious
rename(flights, tail_num = tailnum)

#mutate add new columns that are functions of other colunms
#first We create a new smaller dataset

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
                      )

#Then we can add new calculated columns to it, using mutate

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
       )

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
       )

#Transmute keeps only the new variables

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
          )

#Exercises
#Changing dep_time to a format that's more useful

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100,
          minutes_since_midnight = hour * 60 + minute
          )

#comparing air_time, with arr_time - dep_time

transmute(flights,
          air_time,
          difference = arr_time - dep_time)

#comparing dep_time, sched_dep_time and dep_delay

transmute(flights,
          dep_time,
          sched_dep_time,
          dep_delay)

#Summarise is used to collapse a data frame into a single row, 
#containing a statistical expression. When combined with group by
#we can make statistical aggregations of variables, like this:

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

#The na.rm argument is used to remove NA values

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


#The 'pipe' operator (%>%) is very useful to perform multiple
#transformations with data in the same expression. A good way
#to think about the pipe is to read it as "Then"

#This code attributes the data frame to a variable, THEN it groups
#by destination, THEN it summarises some measures and THEN it applies
#filter to remove unwanted data.

delays <- flights %>% 
        group_by(dest) %>% 
        summarise(
                count = n(),
                dist = mean(distance, na.rm = TRUE),
                delay = mean(arr_delay, na.rm = TRUE)
                ) %>% 
        filter(count > 20, dest != "HNL")

ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
        geom_point(aes(size = count), alpha = 1/3) +
        geom_smooth(se = FALSE)

#Changing to a dataset that contains information about baseball

library(Lahman)

batting <- as_tibble(Lahman::Batting)

#Group by PlayerID and measure the batting average(sum of hits divided
#by attempts) and the number of attempts
batters <- batting %>% 
        group_by(playerID) %>% 
        summarise(
                ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
                ab = sum(AB, na.rm = TRUE)
                )

#Filters for players with more than 100 attempts and plots

batters %>% 
        filter(ab > 100) %>% 
        ggplot(mapping = aes(x = ab, y = ba)) +
        geom_point() + 
        geom_smooth(se = FALSE)
       