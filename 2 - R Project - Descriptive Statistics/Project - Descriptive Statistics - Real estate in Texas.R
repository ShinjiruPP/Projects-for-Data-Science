# Project - Descriptive Statistics
library(ggplot2)
source("Progetto Statistica Descrittiva - Funzioni.R")

# Task 1
# Describe the dataset and import it
data_texas <- read.csv("realestate_texas.csv")

# Task 2
# Explore the dataset and describe the variable types
head(data_texas, 5)

# Task 3
# Compute measures of central tendency, variability, and shape for the variables
attach(data_texas)
dim <- dim(data_texas)[1]

# Frequencies distributions for the variable city
frequenza_assoluta_city <- table(data_texas$city)
frequenza_relativa_city <- table(data_texas$city)/dim
frequenza_cumulata_city <- cumsum(frequenza_assoluta_city)
frequenza_cumulata_relativa_city <- frequenza_cumulata_city/dim

frequenza_assoluta_city
frequenza_relativa_city
frequenza_cumulata_city
frequenza_cumulata_relativa_city

frequenze_data_frame_city <- as.data.frame(cbind(frequenza_assoluta_city, 
                                                 frequenza_relativa_city, 
                                                 frequenza_cumulata_city, 
                                                 frequenza_cumulata_relativa_city))

# Plot of frequencies distributions for the variable city
x11()
barplot(frequenze_data_frame_city$frequenza_assoluta_city,
        main = "Distribuzione di frequenza delle città",
        xlab = "Città",
        ylab = "Frequenze assolute",
        ylim = c(0, 70),
        col = "lightblue",
        border = "black",
        names.arg = rownames(frequenze_data_frame_city))

# Frequencies distributions for the variable year
frequenza_assoluta_year <- table(data_texas$year)
frequenza_relativa_year <- table(data_texas$year)/dim
frequenza_cumulata_year <- cumsum(frequenza_assoluta_year)
frequenza_cumulata_relativa_year <- frequenza_cumulata_year/dim

frequenza_assoluta_year
frequenza_relativa_year
frequenza_cumulata_year
frequenza_cumulata_relativa_year

frequenze_data_frame_year <- as.data.frame(cbind(frequenza_assoluta_year, 
                                                 frequenza_relativa_year, 
                                                 frequenza_cumulata_year, 
                                                 frequenza_cumulata_relativa_year))

# Plot of frequencies distributions for the variable yaer
x11()
barplot(frequenze_data_frame_year$frequenza_assoluta_year,
        main = "Distribuzione di frequenza degli anni",
        xlab = "Anno",
        ylab = "Frequenze assolute",
        ylim = c(0, 60),
        col = "lightblue",
        border = "black",
        names.arg = rownames(frequenze_data_frame_year))

# Frequencies distributions for the variable month
frequenza_assoluta_month <- table(data_texas$month)
frequenza_relativa_month <- table(data_texas$month)/dim
frequenza_cumulata_month <- cumsum(frequenza_assoluta_month)
frequenza_cumulata_relativa_month <- frequenza_cumulata_month/dim

frequenza_assoluta_month
frequenza_relativa_month
frequenza_cumulata_month
frequenza_cumulata_relativa_month

frequenze_data_frame_month <- as.data.frame(cbind(frequenza_assoluta_month, 
                                                 frequenza_relativa_month, 
                                                 frequenza_cumulata_month, 
                                                 frequenza_cumulata_relativa_month))

# Plot of frequencies distributions for the variable city
x11()
barplot(frequenze_data_frame_month$frequenza_assoluta_month,
        main = "Distribuzione di frequenza dei mesi",
        xlab = "Mese",
        ylab = "Frequenze assolute",
        ylim = c(0, 30),
        col = "lightblue",
        border = "black",
        names.arg = rownames(frequenze_data_frame_month))


# Calculation of position indices for the variable: sales
min_sales = min(sales)
max_sales = max(sales)
mean_sales = mean(sales)
quantile_sales = quantile(sales)
median_sales = median(sales)

min_sales
max_sales
mean_sales
quantile_sales
median_sales

summary(sales)

# Calculation of variability indices for the variable: sales
range_sales = max_sales - min_sales
IQR_sales = IQR(sales)
sigma2_sales = variance(sales)
sigma_sales = sqrt(sigma2_sales)
cv_sales = coefficient_variation(sales)

# Calculation of shape indices for the variable: sales
nd_sales <- rnorm(sales, mean_sales, sigma_sales)

x11()
plot(density(nd_sales))
abline(v = mean_sales, col="red")

m3_sales <- fisher_index(sales)
m4_sales <- kurtosis_index(sales)

# Calculation of position indices for the variable: volume
min_volume = min(volume)
max_volume = max(volume)
mean_volume = mean(volume)
quantile_volume = quantile(volume)
median_volume = median(volume)

min_volume
max_volume
mean_volume
quantile_volume
median_volume

summary(volume)

# Calculation of variability indices for the variable: volume
range_volume = max_volume - min_volume
IQR_volume = IQR(volume)
sigma2_volume = variance(volume)
sigma_volume = sqrt(sigma2_volume)
cv_volume = coefficient_variation(volume)

# Calculation of shape indices for the variable: volume
nd_volume <- rnorm(volume, mean_volume, sigma_volume)

x11()
plot(density(nd_volume))

m3_volume <- fisher_index(volume)
m4_volume <- kurtosis_index(volume)

# Calculation of position indices for the variable: median_price
min_median_price = min(median_price)
max_median_price = max(median_price)
mean_median_price = mean(median_price)
quantile_median_price = quantile(median_price)
median_median_price = median(median_price)

min_median_price
max_median_price
mean_median_price
quantile_median_price
median_median_price

summary(median_price)

# Calculation of variability indices for the variable: median_price
range_median_price = max_median_price - min_median_price
IQR_median_price = IQR(median_price)
sigma2_median_price = variance(median_price)
sigma_median_price = sqrt(sigma2_median_price)
cv_median_price = coefficient_variation(median_price)


# Calculation of shape indices for the variable: median_price
nd_median_price <- rnorm(median_price, mean_median_price, sigma_median_price)

x11()
plot(density(nd_median_price))

m3_median_price <- fisher_index(median_price)
m4_median_price <- kurtosis_index(median_price)

# Calculation of position indices for the variable: listings
min_listings = min(listings)
max_listings = max(listings)
mean_listings = mean(listings)
quantile_listings = quantile(listings)
median_listings = median(listings)

min_listings
max_listings
mean_listings
quantile_listings
median_listings

summary(listings)

# Calculation of variability indices for the variable: listings
range_listings = max_listings - min_listings
IQR_listings = IQR(listings)
sigma2_listings = variance(listings)
sigma_listings = sqrt(sigma2_listings)
cv_listings = coefficient_variation(listings)
sigma2_listings
cv_listings
sigma_listings

# Calculation of shape indices for the variable: listings
nd_listings <- rnorm(listings, mean_listings, sigma_listings)

x11()
plot(density(nd_listings))

m3_listings <- fisher_index(listings)
m4_listings <- kurtosis_index(listings)

# Calculation of position indices for the variable: months_inventory
min_months_inventory = min(months_inventory)
max_months_inventory = max(months_inventory)
mean_months_inventory = mean(months_inventory)
quantile_months_inventory = quantile(months_inventory)
median_months_inventory = median(months_inventory)

min_months_inventory
max_months_inventory
mean_months_inventory
quantile_months_inventory
median_months_inventory

summary(months_inventory)

# Calculation of variability indices for the variable: months_inventory
range_months_inventory = max_months_inventory - min_months_inventory
IQR_months_inventory = IQR(months_inventory)
sigma2_months_inventory = variance(months_inventory)
sigma_months_inventory = sqrt(sigma2_months_inventory)
cv_months_inventory = coefficient_variation(months_inventory)

# Calculation of shape indices for the variable: months_inventory
nd_months_inventory <- rnorm(months_inventory, mean_months_inventory, sigma_months_inventory)

x11()
plot(density(nd_months_inventory))

m3_months_inventory <- fisher_index(months_inventory)
m4_months_inventory <- kurtosis_index(months_inventory)

# Task 4
# Check the variable with major variation
x11()
boxplot(sales)

x11()
boxplot(volume)

x11()
boxplot(median_price)

x11()
boxplot(listings)

x11()
boxplot(months_inventory)

# Comparison of standard deviation
sigma_listings
sigma_median_price
sigma_months_inventory
sigma_sales
sigma_volume

# Comparison of coefficient of variation
cv_listings
cv_median_price
cv_months_inventory
cv_sales
cv_volume

# Comparison of Fisher index
m3_listings
m3_median_price
m3_months_inventory
m3_sales
m3_volume

# Comparison of Kurtosis index
m4_listings
m4_median_price
m4_months_inventory
m4_sales
m4_volume

# Task 5
# Check the summary of sales distribution in order to define the class
summary(sales)

# Create a new column for the classes and count the variabile for each class
data_texas$sales_class <- cut(data_texas$sales, 
                              breaks = c(0, 100, 200, 300, 400, 500))

# Calculate the absolute, relative and cumulative frequency for sales class
frequenza_assoluta_sales_class <- table(data_texas$sales_class)
frequenza_relativa_sales_class <- table(data_texas$sales_class)/length(sales)
frequenza_cumulata_sales_class <- cumsum(frequenza_assoluta_sales_class)
frequenza_cumulata_relativa_sales_class <- frequenza_cumulata_sales_class/length(sales)

frequenza_assoluta_sales_class
frequenza_relativa_sales_class
frequenza_cumulata_sales_class
frequenza_cumulata_relativa_sales_class

dataframe_sales_class <- as.data.frame(cbind(frequenza_assoluta_sales_class,
                                            frequenza_relativa_sales_class,
                                            frequenza_cumulata_sales_class,
                                            frequenza_cumulata_relativa_sales_class))

# Plot the absolute frequencies of sales variable
x11()
ggplot() +
  geom_bar(aes(x = data_texas$sales_class),
           stat = "count",
           col = "lightblue",
           fill = "blue") + 
  labs(title = "Distribuzioni assolute delle classi sales",
       x = "Classi sales",
       y = "Frequenze assolute") +
  scale_y_continuous(breaks = seq(0, 150, 50)) +
  theme_classic()

sales_class_array <- seq(0, 500, 100)
sales_class_array <- paste0(sales_class_array, " - ", sales_class_array + 100)
sales_class_array[1] <- "0 - 100"
sales_class_array <- sales_class_array[-6]

# Plot the relative frequencies of sales variable
x11()
ggplot(data = dataframe_sales_class) +
  geom_bar(aes(x = sales_class_array, 
               y = dataframe_sales_class$frequenza_relativa_sales_class),
               stat = "identity", 
               col = "lightblue", 
               fill = "blue") + 
  labs(title = "Distribuzioni relative delle classi sales",
       x = "Classi sales",
       y = "Frequenze relative") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_classic()

# Calculate gini index for sales variable
gini_index_sales <- gini_index(sales)
gini_index_sales


# Task 6
# Check the absolute frequency of city variable
table(city)
gini_index_city <- gini_index(city)
gini_index_city

# Task 7
# Plot the variable city and its relative frequency in order to calculate
# the probability
x11()
ggplot() + 
  geom_histogram(aes(x = city,
                     y = stat(count/sum(count))),
                 stat = "count",
                 col = "black",
                 fill = "lightblue") + 
  scale_y_continuous(breaks = seq(0, 1, 0.25)) +
  labs(title = "Probabilità della variabile City",
       x = "City",
       y = "Probabilità")

x11()
ggplot() + 
  geom_histogram(aes(x = month,
                     y = stat(count/sum(count))),
                 stat = "count",
                 col = "black",
                 fill = "lightblue") + 
  scale_x_continuous(breaks = seq(0, 12, 1)) +
  scale_y_continuous(breaks = seq(0, 0.5, 0.01)) +
  labs(title = "Probabilità della variabile Month",
       x = "Mese",
       y = "Probabilità")

prob_month_year <- table(data_texas$month, data_texas$year)/dim

x11()
boxplot(data_texas$month ~ data_texas$year,
  main = "Distribuzione dei mesi",
  xlab = "Anno", ylab = "Mesi", 
  col = "lightblue", border = "blue",
  notch = TRUE)

x11()
barplot(as.matrix(prob_month_year), 
        beside = TRUE, 
        col = rainbow(12), 
        main = "Distribuzione dei mesi per ogni anno",
        xlab = "Anno", 
        ylab = "Frequenza dei mesi",
        ylim = c(0, 0.06))


prob_month_year[12, "2012"]

# Task 8
# Calculate and add a new column that contains the mean of price
data_texas$mean_price <- (data_texas$volume * 1000000) / data_texas$sales

# Task 9
# Calculate effectiveness of sales
data_texas$effectiveness_sales <- 
  (data_texas$sales / (data_texas$listings + data_texas$sales))

x11()
ggplot() +
  geom_bar(aes(x = city,
               y = data_texas$effectiveness_sales),
           stat = "identity",
           fill = "pink") +
  labs(title = "Efficacia di vendite per City",
       x = "City",
       y = "Efficacia")

x11()
ggplot() +
  geom_bar(aes(x = year,
               y = data_texas$effectiveness_sales),
           stat = "identity",
           fill = "blue") +
  labs(title = "Efficacia di vendite per Year",
       x = "Anno",
       y = "Efficacia")

x11()
ggplot() +
  geom_bar(aes(x = as.factor(year),
               y = data_texas$effectiveness_sales,
               fill = city),
           stat = "identity") +
  labs(title = "Efficacia di vendite per città e anno",
       x = "Anno",
       y = "Efficacia")

library(dplyr)
data_agg <- data_texas %>%
  group_by(city, year, month) %>%
  summarise(total_eff_sales = sum(effectiveness_sales))

x11()
ggplot(data_agg) +
  geom_bar(aes(x = as.factor(month),
               y = total_eff_sales,
               fill = as.factor(year)),
           stat = "identity") +
  facet_wrap(~city, ncol = 2, scales = "free_y") +
  scale_fill_discrete(name = "Anni") +
  labs(title = "Efficacia di vendite per città e anno",
       x = "Anno",
       y = "Efficacia")


install.packages("plotly")
library(plotly)

x11()
plot_ly(data_texas, 
        x = ~city, 
        y = ~year, 
        z = ~month,
        size = ~effectiveness_sales,
        type = "scatter3d",
        colors = "blue",
        marker = list(opacity = 0.8, symbol = 16)) %>% 
  layout(scene = list(xaxis = list(title = "City"),
                      yaxis = list(title = "Year",
                                   tickmode = "linear",
                                   tick0 = 2012,
                                   dtick = 1),
                      zaxis = list(title = "Month",
                                   tickmode = "linear",
                                   tick0 = 1,
                                   dtick = 1)))

# Task 10
# Create the summary for some of data set variables
library(dplyr)
summarise_city = 
  data_texas %>%
    group_by(city) %>%
    summarise(sd_sales=sd(sales), sd_volume=sd(volume), 
              sd_listings=sd(listings), 
              mean_sales=mean(sales), mean_volume=mean(volume), 
              mean_listings=mean(listings))

summarise_month = 
  data_texas %>%
  group_by(month) %>%
  summarise(sd_sales=sd(sales), sd_volume=sd(volume), 
            sd_listings=sd(listings), 
            mean_sales=mean(sales), mean_volume=mean(volume), 
            mean_listings=mean(listings))

summarise_year = 
  data_texas %>%
  group_by(year) %>%
  summarise(sd_sales=sd(sales), sd_volume=sd(volume), 
            sd_listings=sd(listings), 
            mean_sales=mean(sales), mean_volume=mean(volume), 
            mean_listings=mean(listings))

summarise_city_month = 
  data_texas %>%
  group_by(city, month) %>%
  summarise(sd_sales=sd(sales), sd_volume=sd(volume), 
            sd_listings=sd(listings), 
            mean_sales=mean(sales), mean_volume=mean(volume), 
            mean_listings=mean(listings))           

summarise_city_year = 
  data_texas %>%
  group_by(city, year) %>%
  summarise(sd_sales=sd(sales), sd_volume=sd(volume), 
            sd_listings=sd(listings), 
            mean_sales=mean(sales), mean_volume=mean(volume), 
            mean_listings=mean(listings))

summarise_month_year = 
  data_texas %>%
  group_by(month, year) %>%
  summarise(sd_sales=sd(sales), sd_volume=sd(volume), 
            sd_listings=sd(listings), 
            mean_sales=mean(sales), mean_volume=mean(volume), 
            mean_listings=mean(listings))

x11()
ggplot(summarise_month_year) +
  geom_bar(aes(x = year,
               y = mean_sales,
               fill = as.factor(month)),
           stat = "identity") +
  labs(title = "Media di vendite di immobili dall'anno 2010 a 2014",
       x = "Anni",
       y = "Media di vendite",
       fill = "Mesi") +
  scale_x_continuous(breaks = seq(2010, 2014, 1)) +
  scale_y_continuous(breaks = seq(0, 2800, 400))

x11()
ggplot(summarise_city, aes(x = city, y = mean_sales)) +
  geom_errorbar(aes(ymin = mean_sales - sd_sales, ymax = mean_sales + sd_sales),
                width = 0.2,                  
                colour = "blue",              
                size = 1.5) +                 
  geom_point(size = 3, fill = "red") +      
  labs(title = "Stabilità delle vendite per città",
       x = "Città",
       y = "Vendite")

x11()
ggplot(summarise_city_month) +
  geom_bar(aes(x = as.factor(month),
               y = mean_volume,
               fill = city),
           stat = "identity") +
  labs(title = "Media di milioni di dollari incassati per città durante i mesi",
       x = "Mesi",
       y = "Media di milioni di dollari incassati") +
  scale_y_continuous(breaks = seq(0, 220, 20))

# Task 11
# Comparison of median price between city

x11()
ggplot(data = data_texas) + 
  geom_boxplot(aes(x = city,
                   y = median_price),
               col = "black",
               fill = "lightblue") +
  labs(title = "Distribuzione del prezzo mediano",
       x = "Città",
       y = "Prezzo mediano")

x11()
ggplot(data = data_texas) + 
  geom_boxplot(aes(x = as.factor(year),
                   y = median_price,
                   fill = city)) +
  labs(title = "Distribuzione del prezzo mediano lungo anni e città",
       x = "Anno",
       y = "Prezzo mediano")

# Task 12
# Comparison of sales between city and year

x11()
ggplot(data = data_texas) + 
  geom_boxplot(aes(x = as.factor(year),
                   y = sales,
                   fill = city)) +
  labs(title = "Distribuzione delle vendite lungo anni e città",
       x = "Anno",
       y = "Vendite")

# Task 13
# Geom bar overlapped for sales during years and months

x11()
ggplot(data = data_texas) +
  geom_bar(aes(x = as.factor(year),
               y = sales,
               fill = as.factor(month)),
           stat = "identity",
           color = "black",
           size = 0.3) +
  labs(title = "Vendite di immobili per anni e mesi",
       x = "Anni",
       y = "Vendite",
       fill = "Mesi") +
  facet_wrap(~city, ncol = 2, scales = "free_y")

# Normalized bar plot for sales on years and months 
x11()
ggplot(data = data_texas) +
  geom_bar(aes(x = as.factor(year),
               y = sales / sum(sales),
               fill = as.factor(month)),
           stat = "identity",
           color = "black") +
  labs(title = "Vendite di immobili per anni e mesi",
       x = "Anni",
       y = "Proporzione delle vendite",
       fill = "Mesi") +
  facet_wrap(~city, ncol = 2, scales = "free_y")

# Task 14
# Line chart

data_tyler <- filter(data_texas, data_texas$city=="Tyler")
data_tyler
x11()
ggplot(data = data_texas) +
  geom_line(aes(x = as.factor(month),
               y = volume,
               group = city,
               color = city)) +
  facet_wrap(~as.factor(year), ncol = 2, scales = "free_y") +
  labs(title = "Milioni di dollari incassati per anni, mesi e città",
       x = "Mesi",
       y = "Milioni di dollari")




