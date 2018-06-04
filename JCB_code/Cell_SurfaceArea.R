require(reshape2)
require("BEST")
#Read in the CAAX measured surface area and the VAMP2 measured SA
CAAX_SA <- read.table(file="D:/Documents/Science/Cell_Model/CAAX_surface_area_mixed.csv", header=T, sep=",")
fourtyeight_hours <- read.table(file="D:/Documents/Science/Cell_Model/48_hours_3_finalmix.csv", header=T, sep=",")

#turn the timepoints into a factor
fourtyeight_hours$Time <- factor(fourtyeight_hours$Time)
CAAX_SA$Surface.Area <- 2.5*CAAX_SA$Surface.Area

#subset the original 24 hour SA
orig_24 <- subset(fourtyeight_hours, Time == "1")
orig_48 <- subset(fourtyeight_hours, Time == "1")
boxplot(orig_24$Surface.Area,CAAX_SA$Surface.Area)



BESTout <- BESTmcmc(orig_24$Surface.Area,orig_48$Surface.Area)
BESTout1 <-BESTmcmc(orig_24$Surface.Area,CAAX_SA$Surface.Area)
BESTout <- BESTmcmc(CAAX_SA$Surface.Area, priors = NULL)


summary(BESTout)
plot(BESTout)
plot(BESTout,"sd")
plotPostPred(BESTout)


plotAll(BESTout, credMass=0.8, ROPEm=c(-0.1,0.1),
        ROPEeff=c(-0.2,0.2), compValm=0.5)
plotAll(BESTout, credMass=0.8, ROPEm=c(-0.1,0.1),
        ROPEeff=c(-0.2,0.2), compValm=0.5, showCurve=TRUE)
summary(BESTout, credMass=0.8, ROPEm=c(-0.1,0.1), ROPEsd=c(-0.15,0.15),
        ROPEeff=c(-0.2,0.2))
pairs(BESTout)
head(BESTout$mu1)
muDiff <- BESTout$mu1 - BESTout$mu2
mean(muDiff > 1.5)
mean(BESTout$sigma1 - BESTout$sigma2)
hist(BESTout$nu)

powerRet <- BESTpower(BESTout, N1=length(orig_24$Surface.Area), N2=length(CAAX_SA$Surface.Area),
                      ROPEm=c(-0.1,0.1), maxHDIWm=2.0, nRep=20)
powerRet

BestOut2 <- BESTmcmc(MyoMyo)
plot(BestOut2)


aa <- 1:5
bb <- 2:6
cc <- aa-bb
cc
