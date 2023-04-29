#Function for Statistic Project

#Variance calculation
variance <- function(x) {
  n <- length(x)
  mu <- mean(x)
  return(sum((x - mu)^2)/n)
}

#Coefficient of variation
coefficient_variation <- function(x) {
  return (sd(x)/mean(x)*100)
}

#Gini coefficient
gini_index <- function(x) {
  ni <- table(x)
  fi <- ni/length(x)
  fi2 <- fi^2
  J <- length(table(x))
  
  gini <- 1 - sum(fi2)
  gini_normalized <- gini/((J-1)/J)
  
  return(gini_normalized)
}

#Fisher index
fisher_index <- function(x) {
  mu <- mean(x)
  sigma <- sd(x)
  n <- length(x)
  m3 <- sum((x - mu)^3) / n
  return(m3/sigma^3)
}

#Kurtosis index
kurtosis_index <- function(x) {
  mu <- mean(x)
  n <- length(x)
  sigma <- sd(x)
  m4 <- sum((x - mu)^4)/n
  return((m4/sigma^4) - 3)
}
