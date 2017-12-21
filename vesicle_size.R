#Read in the vesicle sizes
Vesicle_size <- read.table(file="D:/Documents/Science/Cell_Model/vesicle_size.csv", header=T, sep=",")

#Aggregate the data by what image the vesicles were taken from- get the means to look for differences between images
aggregate(Long.length~Image,data = Vesicle_size,mean)

#Create a histogram and density plot showing the population of vesicle slices
hist(Vesicle_size$Long.length, n = 20)
lines(density(Vesicle_size$Long.length))

#In order to account for both vesicle size heterogeneity and the random slices, we use the 75th
#quartile to represent the population diameter size.
quantile(Vesicle_size$Long.length, c(0.25,0.75))

#The size of vesicles we use will be 130nm.


calth <- c(.4,.2,.3,.3,.55,.3,.4,.3,.4,.3,.35,.4,.35)
hist(calth, n = 5)
lines(density(calth))
quantile(calth, c(0.25,0.75))
mean(calth)


#height of the things
height <- data.frame(c(12.1363,11.2028,11.2028,10.2692,10.2692,11.2028,11.2028,12.1363,10.2692,13.0699,13.0699))
boxplot(height, ylim=c(0,15))
require(ggplot2)
