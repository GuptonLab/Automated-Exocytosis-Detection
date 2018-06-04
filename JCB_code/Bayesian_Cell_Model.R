require(dplyr)
require(rstanarm)
require(ggplot2)
require(brms)
#Read in the surface area file
fourtyeight_hours <- read.table(file="D:/Documents/Science/Cell_Model/48_hours_3_finalmix.csv", header=T, sep=",")

#Aggregate the data by what image the vesicles were taken from- get the means to look for differences between images
aggregate(Surface.Area~Time,data = fourtyeight_hours,mean)

#Lets build a linear regression model

#convert the time parameter into a factor
fourtyeight_hours$Time <- as.factor(fourtyeight_hours$Time)

#build the model
lol <- lm(Surface.Area ~ Time, data = fourtyeight_hours)
plot(fourtyeight_hours$Time, fourtyeight_hours$Surface.Area)

#summary of the model
summary(lol)

#the data looks non-normal, let's check the residuals
plot(residuals(lol))
hist(fourtyeight_hours$Surface.Area)
#the residuals are not evenly distributed, but show a trend. 
#log-transforming the Surface Area, then rebuilding the model:
#fourtyeight_hours$Surface.Area <- log(fourtyeight_hours$Surface.Area)

#new model
lol <- lm(Surface.Area ~ Time, data = fourtyeight_hours)
summary(lol)
plot(residuals(lol))
#The residuals look much better.

#######################################
#Bayesian (heirarchical) Linear Regression
#######################################
#Define the model(s)
stan_model <- stan_glm(
  Surface.Area ~ Time,
  data = fourtyeight_hours,
  prior = normal(location = 1000, scale = 4),
  prior_intercept = normal(1000,10),
  chains = 4,
  iter= 100000
)

fit1 <- brm(formula = Surface.Area ~ Time,
            data = fourtyeight_hours, family = gaussian(),
            prior = set_prior("normal(1000,10)", class = "b"),
            warmup = 10000, iter = 100000, chains = 4,
            control = list(adapt_delta = 0.95))

fit2 <- brm(formula = Surface.Area ~ Time,
            data = fourtyeight_hours, family = skew_normal(),
            prior = set_prior("normal(1000,10)", class = "b"),
            warmup = 10000, iter = 100000, chains = 4,
            control = list(adapt_delta = 0.95))

fit3 <- brm(formula = Surface.Area ~ Time,
            data = fourtyeight_hours, family = student(),
            prior = set_prior("normal(1000,10)", class = "b"),
            warmup = 10000, iter = 100000, chains = 4,
            control = list(adapt_delta = 0.95))

fit4 <- brm(formula = Surface.Area ~ Time,
            data = fourtyeight_hours, family = weibull(),
            prior = set_prior("normal(1000,10)", class = "b"),
            warmup = 10000, iter = 100000, chains = 4,
            control = list(adapt_delta = 0.95))
fit5 <- brm(formula = Surface.Area ~ Time,
            data = fourtyeight_hours, family = Gamma("identity"),
            prior = set_prior("normal(1000,10)", class = "b"),
            warmup = 10000, iter = 100000, chains = 4,
            control = list(adapt_delta = 0.95))

w1 <- WAIC(fit1)
w2 <- WAIC(fit2)
w3 <- WAIC(fit3)
w4 <- WAIC(fit4)
w5 <- WAIC(fit5)
compare_ic(w1,w2,w3,w4,w5)
pp_check(fit1, nsamples=50, xlim = c(-10,300))
pp_check(fit2, nsamples=50, xlim = c(-10,300))
pp_check(fit3, nsamples=50, xlim = c(-10,300))
pp_check(fit4, nsamples=50, xlim = c(-10,300))
pp_check(fit5, nsamples=50)

plot(fit3, ask = FALSE)
plot(fit4, ask = FALSE)
plot(fit5, ask = FALSE)
plot(marginal_effects(fit1), points = TRUE, ask = FALSE)
plot(stan_model)
plot(marginal_effects(fit1, probs = c(0.05, 0.95)))
stanplot(fit1, type = "intervals", ci_level = 0.95)
summary(fit1, wait = TRUE)
summary(fit2, wait = TRUE)
summary(fit3, wait = TRUE)
summary(fit4, wait = TRUE)
summary(fit5, wait = TRUE)
launch_shinystan(stan_model)
summary(stan_model)

#Explore the model itself
stan_model
plot(stan_model)
pp_check(stan_model)
pp_check(fit3, nsamples=50, xlim = c(-10,300))
#Create a plot of ~400 credible regression lines
samples <- fit5 %>% as.data.frame %>% tbl_df
df_model <- fit5 %>% as_data_frame()

df_model2 <- df_model %>%
  mutate(F_Intercept = `(Intercept)`, F_Slope = Time2,
         M_Intercept = Time2,
         M_Slope = Time3-Time2) %>%
  select(F_Intercept:M_Slope)
df_model2

fits <- sample_n(df_model, 2000)
medians <- df_model %>% summarise_each(funs = funs(median))

#This creates the actual ggplot
p2 <- ggplot(fourtyeight_hours) +aes(x = Time, y = Surface.Area) +scale_y_continuous(limits=c(0,3500))+geom_abline(aes(color = "F", intercept = b_Intercept, slope = b_Time2), data = fits, alpha = .075)+geom_point()
p2  


geom_abline(aes(color = "M", intercept = M_Intercept,
                  slope = M_Slope), data = fits, alpha = .075) +
  geom_abline(aes(color = "F", intercept = F_Intercept,
                  slope = F_Slope), data = medians, size = 1.25) +
  geom_abline(aes(color = "M", intercept = M_Intercept,
                  slope = M_Slope), data = medians, size = 1.25) +
  geom_point()
p4 <- ggplot(fourtyeight_hours) +
  aes(x = Time, y = Surface.Area) + geom_abline(df_model2)
#display the plot
p2
posterior_interval(stan_model)
#?nnls
#1check the posterior distribution
pp_check(stan_model)

#Launches the viewer to allow the exploration of the model
launch_shinystan(stan_model)
marginal_effects(fit5)

