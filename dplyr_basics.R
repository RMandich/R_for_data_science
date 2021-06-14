library(dplyr)
library(nycflights13)
library(tidyverse)

flights

#Filter shows a subset of the data based on your restrictions
filter(.data = flights, month == 1, day == 1)

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
