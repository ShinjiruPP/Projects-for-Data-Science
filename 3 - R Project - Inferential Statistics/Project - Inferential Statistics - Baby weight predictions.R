# Progetto di Statistica Inferenziale

# Task 1 - Import dataset
data <- read.csv("neonati.csv")
attach(data)

# Task 2 - Description of variables
head(data)
n <- nrow(data)

# Task 3 - Descriptive analysis of dataset
# Variable: Anni.madre
summary(Anni.madre)

mean_Anni.madre = mean(Anni.madre)
sd_Anni.madre = sd(Anni.madre)

nd_Anni.madre = rnorm(Anni.madre, mean_Anni.madre, sd_Anni.madre)

x11()
hist(nd_Anni.madre, 
     freq = FALSE, 
     ylim = c(0, 0.1), 
     col = "lightblue", 
     xlab = "Value", 
     ylab = "Density", 
     main = "Histogram with Density of Probability - Anni.madre")
dens <- density(nd_Anni.madre)
lines(dens$x, dens$y, col = "red", lwd = 2)

moments::skewness(Anni.madre)
moments::kurtosis(Anni.madre) - 3

# Variable: N.gravidanze
summary(N.gravidanze)

mean_N.gravidanze = mean(N.gravidanze)
sd_N.gravidanze = sd(N.gravidanze)

nd_N.gravidanze = rnorm(N.gravidanze, mean_N.gravidanze, sd_N.gravidanze)

x11()
hist(nd_N.gravidanze, 
     freq = FALSE, 
     ylim = c(0, 0.35), 
     col = "lightblue", 
     xlab = "Value", 
     ylab = "Density", 
     main = "Histogram with Density of Probability - N.gravidanze")
dens <- density(nd_N.gravidanze)
lines(dens$x, dens$y, col = "red", lwd = 2)

moments::skewness(N.gravidanze)
moments::kurtosis(N.gravidanze) - 3

# Variable: Gestazione
summary(Gestazione)

mean_Gestazione = mean(Gestazione)
sd_Gestazione = sd(Gestazione)

nd_Gestazione = rnorm(Gestazione, mean_Gestazione, sd_Gestazione)

x11()
hist(nd_Gestazione, 
     freq = FALSE, 
     ylim = c(0, 0.25), 
     col = "lightblue", 
     xlab = "Value", 
     ylab = "Density", 
     main = "Histogram with Density of Probability - Gestazione")
dens <- density(nd_Gestazione)
lines(dens$x, dens$y, col = "red", lwd = 2)

moments::skewness(Gestazione)
moments::kurtosis(Gestazione) - 3

# Variable: Peso
summary(Peso)

mean_Peso = mean(Peso)
sd_Peso = sd(Peso)

nd_Peso = rnorm(Peso, mean_Peso, sd_Peso)

x11()
hist(nd_Peso, 
     freq = FALSE, 
     ylim = c(0, 0.00080), 
     col = "lightblue", 
     xlab = "Value", 
     ylab = "Density", 
     main = "Histogram with Density of Probability - Peso")
dens <- density(nd_Peso)
lines(dens$x, dens$y, col = "red", lwd = 2)

moments::skewness(Peso)
moments::kurtosis(Peso) - 3

# Variable: Lunghezza
summary(Lunghezza)

mean_Lunghezza = mean(Lunghezza)
sd_Lunghezza = sd(Lunghezza)

nd_Lunghezza = rnorm(Lunghezza, mean_Lunghezza, sd_Lunghezza)

x11()
hist(nd_Lunghezza, 
     freq = FALSE, 
     ylim = c(0, 0.015), 
     col = "lightblue", 
     xlab = "Value", 
     ylab = "Density", 
     main = "Histogram with Density of Probability - Lunghezza")
dens <- density(nd_Lunghezza)
lines(dens$x, dens$y, col = "red", lwd = 2)

moments::skewness(Lunghezza)
moments::kurtosis(Lunghezza) - 3

# Variable: Cranio
summary(Cranio)

mean_Cranio = mean(Cranio)
sd_Cranio = sd(Cranio)

nd_Cranio = rnorm(Cranio, mean_Cranio, sd_Cranio)

x11()
hist(nd_Cranio, 
     freq = FALSE, 
     ylim = c(0, 0.025), 
     col = "lightblue", 
     xlab = "Value", 
     ylab = "Density", 
     main = "Histogram with Density of Probability - Cranio")
dens <- density(nd_Cranio)
lines(dens$x, dens$y, col = "red", lwd = 2)

moments::skewness(Cranio)
moments::kurtosis(Cranio) - 3

# Variable: Fumatrici
frequenza_assoluta_Fumatrici <- table(Fumatrici)
frequenza_relativa_Fumatrici <- table(Fumatrici)/dim
frequenza_cumulata_Fumatrici <- cumsum(frequenza_assoluta_Fumatrici)
frequenza_cumulata_relativa_Fumatrici <- frequenza_cumulata_Fumatrici/dim

frequenze_data_frame_Fumatrici <- as.data.frame(cbind(frequenza_assoluta_Fumatrici, 
                                                 frequenza_relativa_Fumatrici, 
                                                 frequenza_cumulata_Fumatrici, 
                                                 frequenza_cumulata_relativa_Fumatrici))

x11()
barplot(frequenze_data_frame_Fumatrici$frequenza_assoluta_Fumatrici,
        main = "Distribuzione di frequenza delle madri fumatrici",
        xlab = "Madre fumatrice",
        ylab = "Frequenze assolute",
        ylim = c(0, 2550),
        col = "lightblue",
        border = "black",
        names.arg = rownames(frequenze_data_frame_Fumatrici))

# Variable: Ospedale
frequenza_assoluta_Ospedale <- table(Ospedale)
frequenza_relativa_Ospedale <- table(Ospedale)/dim
frequenza_cumulata_Ospedale <- cumsum(frequenza_assoluta_Ospedale)
frequenza_cumulata_relativa_Ospedale <- frequenza_cumulata_Ospedale/dim

frequenze_data_frame_Ospedale <- as.data.frame(cbind(frequenza_assoluta_Ospedale, 
                                                     frequenza_relativa_Ospedale, 
                                                     frequenza_cumulata_Ospedale, 
                                                     frequenza_cumulata_relativa_Ospedale))

x11()
barplot(frequenze_data_frame_Ospedale$frequenza_assoluta_Ospedale,
        main = "Distribuzione di frequenza degli ospedali",
        xlab = "Ospedale",
        ylab = "Frequenze assolute",
        ylim = c(0, 2550),
        col = "lightblue",
        border = "black",
        names.arg = rownames(frequenze_data_frame_Ospedale))

# Variable: Sesso
frequenza_assoluta_Sesso <- table(Sesso)
frequenza_relativa_Sesso <- table(Sesso)/dim
frequenza_cumulata_Sesso <- cumsum(frequenza_assoluta_Sesso)
frequenza_cumulata_relativa_Sesso <- frequenza_cumulata_Sesso/dim

frequenze_data_frame_Sesso <- as.data.frame(cbind(frequenza_assoluta_Sesso, 
                                                  frequenza_relativa_Sesso, 
                                                  frequenza_cumulata_Sesso, 
                                                  frequenza_cumulata_relativa_Sesso))

x11()
barplot(frequenze_data_frame_Sesso$frequenza_assoluta_Sesso,
        main = "Distribuzione di frequenza dei sessi dei neonati",
        xlab = "Sesso",
        ylab = "Frequenze assolute",
        ylim = c(0, 2550),
        col = "lightblue",
        border = "black",
        names.arg = rownames(frequenze_data_frame_Sesso))

gini.index <- function(x) {
  ni <- table(x)
  fi <- ni/length(x)
  fi2 <- fi^2
  J <- length(table(x))
  
  gini <- 1 - sum(fi2)
  gini_normalizzato <- gini/((J-1)/J)
  
  return(gini_normalizzato)
}
gini.index(Sesso)
gini.index(Ospedale)

# Task 4 - test the hypothesis that the mean weight and length of this sample 
# of newborns are significantly equal to those of the population
t.test(Peso,
       mu = 3300,
       conf.level = 0.95,
       alternative = "two.sided")

t.test(Lunghezza,
       mu = 500,
       conf.level = 0.95,
       alternative = "two.sided")

# Task 5 - Test t for independent samples
t.test(Lunghezza ~ Sesso, data = data)
t.test(Peso ~ Sesso, data = data)
t.test(Cranio ~ Sesso, data = data)



# Task 6 - Verify where the C-section is more used
library(ggplot2)

x11()
ggplot() +
  geom_bar(aes(x = Ospedale, fill = Tipo.parto),
           position = "dodge")

chisq.test(data$Tipo.parto, data$Ospedale)

# Task 7 - Relationship between variables

# Continuous variables

x11()
plot(Anni.madre, Peso, pch=20)
correlazione_Anni.madre_peso <- cor.test(Anni.madre, Peso, method="spearman", exact = F, correct = T)

x11()
plot(N.gravidanze, Peso, pch=20)
correlazione_N.gravidanze_peso <- cor.test(N.gravidanze, Peso, method="spearman", exact = F, correct = T)

x11()
plot(Gestazione, Peso, pch=20)
correlazione_Gestazione_peso <- cor.test(Gestazione, Peso, method="spearman", exact = F, correct = T)

x11()
plot(Lunghezza, Peso, pch=20)
correlazione_Lunghezza_peso <- cor(Lunghezza, Peso)

x11()
plot(Cranio, Peso, pch=20)
correlazione_Cranio_peso <- cor(Cranio, Peso)

# Qualitative variables
test_indipendenza_Sesso_peso <- chisq.test(Sesso, Peso)
test_indipendenza_Fumatrici_peso <- chisq.test(Fumatrici, Peso)


correlazione_Anni.madre_peso
correlazione_N.gravidanze_peso
correlazione_Gestazione_peso
correlazione_Lunghezza_peso
correlazione_Cranio_peso

test_indipendenza_Sesso_peso
test_indipendenza_Fumatrici_peso

# Task 8 - Model creation

# Check the normality of y
moments::skewness(Peso)
moments::kurtosis(Peso) - 3

shapiro.test(Peso)

# First model
mod1 <- lm(Peso ~ .,
           data = data)

summary(mod1)

# Task 9 - Find the best model
library(car)

stepwise.model_mix <- MASS::stepAIC(mod1, 
                              direction = "both",
                              k = log(n))

stepwise.model_back <- MASS::stepAIC(mod1, 
                                direction = "backward",
                                k = log(n))

stepwise.model_for <- MASS::stepAIC(mod1, 
                                     direction = "forward",
                                     k = log(n))

summary(stepwise.model_mix)
summary(stepwise.model_back)
summary(stepwise.model_for)

mod2 <- lm(Peso ~ N.gravidanze + Gestazione + Lunghezza + Cranio + 
             Tipo.parto  + Sesso,
           data = data)
summary(mod2)

mod3 <- lm(Peso ~ N.gravidanze + Gestazione + Lunghezza + Cranio + Sesso,
           data = data)
summary(mod3)

AIC(mod1, mod2, mod3, stepwise.model_mix, stepwise.model_back, stepwise.model_for)
BIC(mod1, mod2, mod3, stepwise.model_mix, stepwise.model_back, stepwise.model_for)

# Task 10 - Interaction between variables

# Analysis for variable: Lunghezza
# Model linear
model_linear_Lunghezza <- lm(Peso ~ Lunghezza, 
                             data = data)
residuals <- resid(model_linear_Lunghezza)

x11()
plot(data$Lunghezza, residuals, xlab = "Lunghezza", ylab = "Residui",
     main = "Grafico dei residui di Peso vs. Lunghezza")

# Model non-linear
model_nonlinear_Lunghezza <- lm(Peso ~ Lunghezza + I(Lunghezza^2), data = data)
summary(model_nonlinear_Lunghezza)

anova(model_linear_Lunghezza, model_nonlinear_Lunghezza)

# Analysis for variable: Cranio
# Model linear
model_linear_Cranio <- lm(Peso ~ Cranio, data = data)
residuals <- resid(model_linear_Cranio)
x11()
plot(data$Cranio, residuals, xlab = "Cranio", ylab = "Residui",
     main = "Grafico dei residui di Peso vs. Cranio")

# Model non-linear
model_nonlinear_Cranio <- lm(Peso ~ Cranio + I(Cranio^2), data = data)
summary(model_nonlinear_Cranio)

anova(model, model_nonlinear_Cranio)

mod4 <- lm(Peso ~ N.gravidanze + Gestazione + I(Lunghezza^2) + 
             Cranio + Tipo.parto + Sesso + Lunghezza:Cranio,
           data = data)
summary(mod4)

mod5 <- lm(Peso ~ N.gravidanze + Gestazione + I(Lunghezza^2) + 
             Cranio + Tipo.parto + Sesso,
           data = data)
summary(mod5)

mod6 <- lm(Peso ~ N.gravidanze + Gestazione + I(Lunghezza^2) + 
             Cranio + Sesso,
           data = data)
summary(mod6)

AIC(mod1, mod2, mod3, mod4, mod5, mod6, 
    stepwise.model_mix, stepwise.model_back, stepwise.model_for)

BIC(mod1, mod2, mod3, mod4, mod5, mod6, 
    stepwise.model_mix, stepwise.model_back, stepwise.model_for)

# Best model including also non-linearity
mod_final <- lm(Peso ~ N.gravidanze + Gestazione + I(Lunghezza^2) + 
             Cranio + Sesso,
           data = data)
summary(mod_final)

car::vif(mod_final)

# Task 11 - Analysis of residuals

shapiro.test(residuals(mod_final))
x11()
plot(mod_final$fitted.values, mod_final$residuals,
     xlab = "Fitted values", 
     ylab = "Residuals", 
     main = "Residuals vs Fitted")


lmtest::bptest(mod_final)
x11()
qqnorm(mod_final$residuals, 
       main = "Normal Q-Q plot")
qqline(mod_final$residuals)


lmtest::dwtest(mod_final)
x11()
library(ggplot2)
ggplot(data.frame(fitted = mod_final$fitted.values, 
                  residuals = mod_final$residuals), 
       aes(fitted, sqrt(abs(residuals)))) +
  geom_point() +
  geom_smooth(se = FALSE) +
  labs(x = "Fitted values", 
       y = "Standardized residuals", 
       title = "Scale-Location plot")

plot(density(residuals(mod_final)))

x11()
lev <- hatvalues(mod_final)
plot(lev)

p <- sum(lev)
soglia <- 2 * p/n

abline(h = soglia, col = "red")
lev[lev > soglia]

x11()
plot(rstudent(mod_final))
abline(h = c(-2, 2), col = "red")
car::outlierTest(mod_final)

cook <- cooks.distance(mod_final)
plot(cook)
max(cook)

# Task 13 - Prediction
mean_cranio <- mean(Cranio)
mean_Lunghezza <- mean(Lunghezza)

observation <- data.frame(N.gravidanze = 3, 
                      Gestazione = 39, 
                      Lunghezza = mean_Lunghezza, 
                      Cranio = mean_cranio, 
                      Sesso = "F")

predictions <- predict(mod_final, observation)
print(predictions)

# Task 14 - Plot model
library("rgl")
library("ggplot2")
x11()
car::scatter3d(Peso ~ N.gravidanze + Gestazione)
car::scatter3d(Peso ~ Lunghezza + Cranio)
?scatter3d

x11()
ggplot(data = data) +
  geom_point(aes(x = Peso,
                 y = Gestazione,
                 col = Sesso),
             position = "jitter") + 
  geom_smooth(aes(x = Peso, # modello di regressione
                  y = Gestazione,
                  col = Sesso), 
              se = F,
              method = "lm") +
  geom_smooth(aes(x = Peso, # modello di regressione
                  y = Gestazione),
              col = "black", 
              se = F,
              method = "lm")

x11()
ggplot(data = data) +
  geom_point(aes(x = Peso,
                 y = Lunghezza,
                 col = Sesso),
             position = "jitter") + 
  geom_smooth(aes(x = Peso, # modello di regressione
                  y = Lunghezza,
                  col = Sesso), 
              se = F,
              method = "lm") +
  geom_smooth(aes(x = Peso, # modello di regressione
                  y = Lunghezza),
              col = "black", 
              se = F,
              method = "lm")

x11()
ggplot(data = data) +
  geom_point(aes(x = Peso,
                 y = Cranio,
                 col = Sesso),
             position = "jitter") + 
  geom_smooth(aes(x = Peso, # modello di regressione
                  y = Cranio,
                  col = Sesso), 
              se = F,
              method = "lm") +
  geom_smooth(aes(x = Peso, # modello di regressione
                  y = Cranio),
              col = "black", 
              se = F,
              method = "lm")
