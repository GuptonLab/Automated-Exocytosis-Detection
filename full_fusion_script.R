#Run this code for each file to generate the half life, peak change in fluorescence, and Major/minor
wt1_fin <- read.table(file="D:/Documents/F20_wt1_fin.csv", header=F, sep=",")
data_only <- wt1_fin[c(15:19)]
frame_obj <- wt1_fin[c(3:4)]
frame_obj = t(frame_obj)
frame_obj = t(frame_obj)
data_only = t(data_only)
data_only = t(data_only)
?density
centroid <- wt1_fin[c(1:2)]
centroid <- t(centroid)
centroid <- t(centroid)
x_time = seq(0.5,2.5, by = 0.5)

#Add a non-negative term 
data_only = data_only + 10

r_sq <- vector()
half_life <- vector()
max_int <- vector()
print(length(data_only[,1]))
for (i in 1:length(data_only[,1])){
  max_int[i] <- max(data_only[i,])
if(max(data_only[i,]) > 10.7){
  dat <- data_only[i,]
  exponential.model <- lm(dat~ log(x_time))
  coef <- summary(exponential.model)$coefficients
  half_life[i] <- -coef[2]
  r_sq[i] <- summary(exponential.model)$r.squared
  }else{
    half_life[i] = NA
  r_sq[i] = NA
}
}

hist(r_sq)
warnings()
tea = rbind(r_sq,half_life)
tea = t(tea)
tea = cbind(centroid,tea)
tea = cbind(frame_obj,tea)
max_int = max_int - 10
tea = cbind(max_int,tea)
full_fusion <- na.omit(tea)

#max intensity of all

hist(max_int)

#max intensity of just FF
hist(full_fusion[,1])
boxplot(full_fusion[,1])
40/282
#half-life
hist(full_fusion[,7])
boxplot(full_fusion[,7])
write.csv(full_fusion,file = "D:/Documents/F20_wt1_fullfusion.csv")