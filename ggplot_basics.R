library(tidyverse)

#Scatterplot showing the relation between Engine Size and Fuel
#Consumption, using the native dataset mpg

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))


#Same graphic but now with colors to distinguish classes of vehicles

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))


#Facets can divide your data into subplots, using a categorical variable

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

#You can also use a combination of two variables using facet_grid

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

#Using different Geometrical objects

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

#For some Geoms you can use the group parameter to separate values

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

#color also works

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv))

#You can create plots with two geoms, passing the parameters globally
#inside ggplot

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

#In this situation, the parameters you pass inside the geom will be
#considered local and will override the global parameters if necessary

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == 'subcompact'), se = FALSE)


#Charts have stats associated with them, and they can be used like
#variables.

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

#Changing the color of bar charts

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

#You can also set the fill argument as a variable to make stacked charts

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

#There is also the position argument, which changes how the data is displayed

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")


#Coordinates can be changed with the coord argument

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = FALSE,
    width = 1) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)+
  coord_polar()
