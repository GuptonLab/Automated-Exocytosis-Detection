#Determining how exocytosis happens through space and time.

#Step 1: Load the package stpp
library(stpp)
library(spatstat)
#Step 2: Load in the xyt data of wildtype cells.
#For the cell masks, turning it binary and unnaming is necessary for using it as a region of interest in subsequent analysis
#read in file
wt_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/WT/tracks/stream_pointsxyt.csv",header=T, sep=",")
wt_xytData_xyt <- wt_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_xytData_x = na.omit(as.numeric(wt_xytData_xyt[,1]))
wt_xytData_x = wt_xytData_x/62.8
wt_xytData_y = na.omit(as.numeric(wt_xytData_xyt[,2]))
wt_xytData_y = wt_xytData_y/62.8
wt_xytData_t = na.omit(as.numeric(wt_xytData_xyt[,3]))

#cell mask
wt_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/WT/tracks/stream_mask_file.csv",header=F, sep=",")
wt_xytData_mask <- (wt_xytData_mask > 0.5)
wt_xytData_mask<- unname(wt_xytData_mask, force = TRUE)


#2
wt2_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/WT/tracks/stream_2_pointsxyt.csv",header=T, sep=",")
wt2_xytData_xyt <- wt2_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt2_xytData_x = na.omit(as.numeric(wt2_xytData_xyt[,1]))
wt2_xytData_x = wt2_xytData_x/62.8
wt2_xytData_y = na.omit(as.numeric(wt2_xytData_xyt[,2]))
wt2_xytData_y = wt2_xytData_y/62.8
wt2_xytData_t = na.omit(as.numeric(wt2_xytData_xyt[,3]))

#cell mask
wt2_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/WT/tracks/stream_2_mask_file.csv",header=F, sep=",")
wt2_xytData_mask <- (wt2_xytData_mask > 0.5)
wt2_xytData_mask<- unname(wt2_xytData_mask, force = TRUE)


#3
wt3_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/WT/tracks/stream_3_pointsxyt.csv",header=T, sep=",")
wt3_xytData_xyt <- wt3_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt3_xytData_x = na.omit(as.numeric(wt3_xytData_xyt[,1]))
wt3_xytData_x = wt3_xytData_x/62.8
wt3_xytData_y = na.omit(as.numeric(wt3_xytData_xyt[,2]))
wt3_xytData_y = wt3_xytData_y/62.8
wt3_xytData_t = na.omit(as.numeric(wt3_xytData_xyt[,3]))

#cell mask
wt3_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/WT/tracks/stream_3_mask_file.csv",header=F, sep=",")
wt3_xytData_mask <- (wt3_xytData_mask > 0.5)
wt3_xytData_mask<- unname(wt3_xytData_mask, force = TRUE)



#4
wt4_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/WT/tracks/stream_4_pointsxyt.csv",header=T, sep=",")
wt4_xytData_xyt <- wt4_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt4_xytData_x = na.omit(as.numeric(wt4_xytData_xyt[,1]))
wt4_xytData_x = wt4_xytData_x/62.8
wt4_xytData_y = na.omit(as.numeric(wt4_xytData_xyt[,2]))
wt4_xytData_y = wt4_xytData_y/62.8
wt4_xytData_t = na.omit(as.numeric(wt4_xytData_xyt[,3]))

#cell mask
wt4_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/WT/tracks/stream_4_mask_file.csv",header=F, sep=",")
wt4_xytData_mask <- (wt4_xytData_mask > 0.5)
wt4_xytData_mask<- unname(wt4_xytData_mask, force = TRUE)


#second data set
wt5_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_pointsxyt.csv",header=T, sep=",")
wt5_xytData_xyt <- wt5_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt5_xytData_x = na.omit(as.numeric(wt5_xytData_xyt[,1]))
wt5_xytData_x = wt5_xytData_x/62.8
wt5_xytData_y = na.omit(as.numeric(wt5_xytData_xyt[,2]))
wt5_xytData_y = wt5_xytData_y/62.8
wt5_xytData_t = na.omit(as.numeric(wt5_xytData_xyt[,3]))

#cell mask
wt5_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_mask_file.csv",header=F, sep=",")
wt5_xytData_mask <- (wt5_xytData_mask > 0.5)
wt5_xytData_mask<- unname(wt5_xytData_mask, force = TRUE)




#
wt6_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_2_pointsxyt_div.csv",header=T, sep=",")
wt6_xytData_xyt <- wt6_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt6_xytData_x = na.omit(as.numeric(wt6_xytData_xyt[,1]))
wt6_xytData_x = wt6_xytData_x/62.8
wt6_xytData_y = na.omit(as.numeric(wt6_xytData_xyt[,2]))
wt6_xytData_y = wt6_xytData_y/62.8
wt6_xytData_t = na.omit(as.numeric(wt6_xytData_xyt[,3]))

#cell mask
wt6_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_2_mask_file.csv",header=F, sep=",")
wt6_xytData_mask <- (wt6_xytData_mask > 0.5)
wt6_xytData_mask<- unname(wt6_xytData_mask, force = TRUE)



#
wt7_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_3_pointsxyt.csv",header=T, sep=",")
wt7_xytData_xyt <- wt7_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt7_xytData_x = na.omit(as.numeric(wt7_xytData_xyt[,1]))
wt7_xytData_x = wt7_xytData_x/62.8
wt7_xytData_y = na.omit(as.numeric(wt7_xytData_xyt[,2]))
wt7_xytData_y = wt7_xytData_y/62.8
wt7_xytData_t = na.omit(as.numeric(wt7_xytData_xyt[,3]))

#cell mask
wt7_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_3_mask_file.csv",header=F, sep=",")
wt7_xytData_mask <- (wt7_xytData_mask > 0.5)
wt7_xytData_mask<- unname(wt7_xytData_mask, force = TRUE)



#
wt8_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_4_pointsxyt.csv",header=T, sep=",")
wt8_xytData_xyt <- wt8_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt8_xytData_x = na.omit(as.numeric(wt8_xytData_xyt[,1]))
wt8_xytData_x = wt8_xytData_x/62.8
wt8_xytData_y = na.omit(as.numeric(wt8_xytData_xyt[,2]))
wt8_xytData_y = wt8_xytData_y/62.8
wt8_xytData_t = na.omit(as.numeric(wt8_xytData_xyt[,3]))

#cell mask
wt8_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_4_mask_file.csv",header=F, sep=",")
wt8_xytData_mask <- (wt8_xytData_mask > 0.5)
wt8_xytData_mask<- unname(wt8_xytData_mask, force = TRUE)




#
wt9_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_6_pointsxyt.csv",header=T, sep=",")
wt9_xytData_xyt <- wt9_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt9_xytData_x = na.omit(as.numeric(wt9_xytData_xyt[,1]))
wt9_xytData_x = wt9_xytData_x/62.8
wt9_xytData_y = na.omit(as.numeric(wt9_xytData_xyt[,2]))
wt9_xytData_y = wt9_xytData_y/62.8
wt9_xytData_t = na.omit(as.numeric(wt9_xytData_xyt[,3]))

#cell mask
wt9_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/WT/trial/stream_6_mask_file.csv",header=F, sep=",")
wt9_xytData_mask <- (wt9_xytData_mask > 0.5)
wt9_xytData_mask<- unname(wt9_xytData_mask, force = TRUE)




#Aggregate all of the WT data into one table.
wt_all_xytData <- rbind(wt_xytData,wt2_xytData,wt3_xytData,wt4_xytData,wt5_xytData,wt6_xytData,wt7_xytData,wt8_xytData,wt9_xytData)

##Load in the netrin treated data.
wt_n_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/netrin/mtrack/stream_6_pointsxyt.csv",header=T, sep=",")
wt_n_xytData_xyt <- wt_n_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n_xytData_x = na.omit(as.numeric(wt_n_xytData_xyt[,1]))
wt_n_xytData_x = wt_n_xytData_x/62.8
wt_n_xytData_y = na.omit(as.numeric(wt_n_xytData_xyt[,2]))
wt_n_xytData_y = wt_n_xytData_y/62.8
wt_n_xytData_t = na.omit(as.numeric(wt_n_xytData_xyt[,3]))

#cell mask
wt_n_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/netrin/mtrack/stream_6_mask_file.csv",header=F, sep=",")
wt_n_xytData_mask <- (wt_n_xytData_mask > 0.5)
wt_n_xytData_mask<- unname(wt_n_xytData_mask, force = TRUE)



wt_n2_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/netrin/mtrack/stream_7_pointsxyt.csv",header=T, sep=",")
wt_n2_xytData_xyt <- wt_n2_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n2_xytData_x = na.omit(as.numeric(wt_n2_xytData_xyt[,1]))
wt_n2_xytData_x = wt_n2_xytData_x/62.8
wt_n2_xytData_y = na.omit(as.numeric(wt_n2_xytData_xyt[,2]))
wt_n2_xytData_y = wt_n2_xytData_y/62.8
wt_n2_xytData_t = na.omit(as.numeric(wt_n2_xytData_xyt[,3]))

#cell mask
wt_n2_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/netrin/mtrack/stream_7_mask_file.csv",header=F, sep=",")
wt_n2_xytData_mask <- (wt_n2_xytData_mask > 0.5)
wt_n2_xytData_mask<- unname(wt_n2_xytData_mask, force = TRUE)





#
wt_n3_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/netrin/mtrack/stream_8_pointsxyt.csv",header=T, sep=",")
wt_n3_xytData_xyt <- wt_n3_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n3_xytData_x = na.omit(as.numeric(wt_n3_xytData_xyt[,1]))
wt_n3_xytData_x = wt_n3_xytData_x/62.8
wt_n3_xytData_y = na.omit(as.numeric(wt_n3_xytData_xyt[,2]))
wt_n3_xytData_y = wt_n3_xytData_y/62.8
wt_n3_xytData_t = na.omit(as.numeric(wt_n3_xytData_xyt[,3]))

#cell mask
wt_n3_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_6_16_stream/netrin/mtrack/stream_8_mask_file.csv",header=F, sep=",")
wt_n3_xytData_mask <- (wt_n3_xytData_mask > 0.5)
wt_n3_xytData_mask<- unname(wt_n3_xytData_mask, force = TRUE)



#
wt_n4_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_pointsxyt.csv",header=T, sep=",")
wt_n4_xytData_xyt <- wt_n4_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n4_xytData_x = na.omit(as.numeric(wt_n4_xytData_xyt[,1]))
wt_n4_xytData_x = wt_n4_xytData_x/62.8
wt_n4_xytData_y = na.omit(as.numeric(wt_n4_xytData_xyt[,2]))
wt_n4_xytData_y = wt_n4_xytData_y/62.8
wt_n4_xytData_t = na.omit(as.numeric(wt_n4_xytData_xyt[,3]))

#cell mask
wt_n4_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_mask_file.csv",header=F, sep=",")
wt_n4_xytData_mask <- (wt_n4_xytData_mask > 0.5)
wt_n4_xytData_mask<- unname(wt_n4_xytData_mask, force = TRUE)



#
wt_n5_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_2_pointsxyt.csv",header=T, sep=",")
wt_n5_xytData_xyt <- wt_n5_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n5_xytData_x = na.omit(as.numeric(wt_n5_xytData_xyt[,1]))
wt_n5_xytData_x = wt_n5_xytData_x/62.8
wt_n5_xytData_y = na.omit(as.numeric(wt_n5_xytData_xyt[,2]))
wt_n5_xytData_y = wt_n5_xytData_y/62.8
wt_n5_xytData_t = na.omit(as.numeric(wt_n5_xytData_xyt[,3]))

#cell mask
wt_n5_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_2_mask_file.csv",header=F, sep=",")
wt_n5_xytData_mask <- (wt_n5_xytData_mask > 0.5)
wt_n5_xytData_mask<- unname(wt_n5_xytData_mask, force = TRUE)



#
wt_n6_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_3_pointsxyt.csv",header=T, sep=",")
wt_n6_xytData_xyt <- wt_n6_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n6_xytData_x = na.omit(as.numeric(wt_n6_xytData_xyt[,1]))
wt_n6_xytData_x = wt_n6_xytData_x/62.8
wt_n6_xytData_y = na.omit(as.numeric(wt_n6_xytData_xyt[,2]))
wt_n6_xytData_y = wt_n6_xytData_y/62.8
wt_n6_xytData_t = na.omit(as.numeric(wt_n6_xytData_xyt[,3]))

#cell mask
wt_n6_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_3_mask_file.csv",header=F, sep=",")
wt_n6_xytData_mask <- (wt_n6_xytData_mask > 0.5)
wt_n6_xytData_mask<- unname(wt_n6_xytData_mask, force = TRUE)


#
wt_n7_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_4_pointsxyt.csv",header=T, sep=",")
wt_n7_xytData_xyt <- wt_n7_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n7_xytData_x = na.omit(as.numeric(wt_n7_xytData_xyt[,1]))
wt_n7_xytData_x = wt_n7_xytData_x/62.8
wt_n7_xytData_y = na.omit(as.numeric(wt_n7_xytData_xyt[,2]))
wt_n7_xytData_y = wt_n7_xytData_y/62.8
wt_n7_xytData_t = na.omit(as.numeric(wt_n7_xytData_xyt[,3]))

#cell mask
wt_n7_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_4_mask_file.csv",header=F, sep=",")
wt_n7_xytData_mask <- (wt_n7_xytData_mask > 0.5)
wt_n7_xytData_mask<- unname(wt_n7_xytData_mask, force = TRUE)


#
wt_n8_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_5_pointsxyt.csv",header=T, sep=",")
wt_n8_xytData_xyt <- wt_n8_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n8_xytData_x = na.omit(as.numeric(wt_n8_xytData_xyt[,1]))
wt_n8_xytData_x = wt_n8_xytData_x/62.8
wt_n8_xytData_y = na.omit(as.numeric(wt_n8_xytData_xyt[,2]))
wt_n8_xytData_y = wt_n8_xytData_y/62.8
wt_n8_xytData_t = na.omit(as.numeric(wt_n8_xytData_xyt[,3]))

#cell mask
wt_n8_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_5_mask_file.csv",header=F, sep=",")
wt_n8_xytData_mask <- (wt_n8_xytData_mask > 0.5)
wt_n8_xytData_mask<- unname(wt_n8_xytData_mask, force = TRUE)



#
wt_n9_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_6_pointsxyt.csv",header=T, sep=",")
wt_n9_xytData_xyt <- wt_n9_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n9_xytData_x = na.omit(as.numeric(wt_n9_xytData_xyt[,1]))
wt_n9_xytData_x = wt_n9_xytData_x/62.8
wt_n9_xytData_y = na.omit(as.numeric(wt_n9_xytData_xyt[,2]))
wt_n9_xytData_y = wt_n9_xytData_y/62.8
wt_n9_xytData_t = na.omit(as.numeric(wt_n9_xytData_xyt[,3]))

#cell mask
wt_n9_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_6_mask_file.csv",header=F, sep=",")
wt_n9_xytData_mask <- (wt_n9_xytData_mask > 0.5)
wt_n9_xytData_mask<- unname(wt_n9_xytData_mask, force = TRUE)



#
wt_n10_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_7_pointsxyt.csv",header=T, sep=",")
wt_n10_xytData_xyt <- wt_n10_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n10_xytData_x = na.omit(as.numeric(wt_n10_xytData_xyt[,1]))
wt_n10_xytData_x = wt_n10_xytData_x/62.8
wt_n10_xytData_y = na.omit(as.numeric(wt_n10_xytData_xyt[,2]))
wt_n10_xytData_y = wt_n10_xytData_y/62.8
wt_n10_xytData_t = na.omit(as.numeric(wt_n10_xytData_xyt[,3]))

#cell mask
wt_n10_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_7_mask_file.csv",header=F, sep=",")
wt_n10_xytData_mask <- (wt_n10_xytData_mask > 0.5)
wt_n10_xytData_mask<- unname(wt_n10_xytData_mask, force = TRUE)

#Other and other
#
wt_n11_xytData <- read.table(file="D:/Documents/ANALYSE_THESE/5_14_16/T9/Stream_4_pointsxyt.csv",header=T, sep=",")
wt_n11_xytData_xyt <- wt_n11_xytData
#Extract the x,y, and t columns into their own variables. Convert the x/y into a more tractable region size
wt_n11_xytData_x = na.omit(as.numeric(wt_n11_xytData_xyt[,1]))
wt_n11_xytData_x = wt_n11_xytData_x/62.8
wt_n11_xytData_y = na.omit(as.numeric(wt_n11_xytData_xyt[,2]))
wt_n11_xytData_y = wt_n11_xytData_y/62.8
wt_n11_xytData_t = na.omit(as.numeric(wt_n11_xytData_xyt[,3]))

#cell mask
wt_n11_xytData_mask <- read.table(file="D:/Documents/ANALYSE_THESE/5_14_16/T9/Stream_4_mask_file.csv",header=F, sep=",")
wt_n11_xytData_mask <- (wt_n11_xytData_mask > 0.5)
wt_n11_xytData_mask<- unname(wt_n11_xytData_mask, force = TRUE)



pptemp11n<- ppp(wt_n11_xytData_x,wt_n11_xytData_y, c(0,16), c(0,16), mask = wt_n11_xytData_mask)
plot(density(pptemp11n,0.32), zlim = c(0,140))

#plotting density of some more wildtypes + netrin
plot(density(pptemp1n,0.32), zlim = c(0,15))



#aggregate all of the WT-netrin data into one table.
wt_n_all_xytData <- rbind(wt_n_xytData,wt_n2_xytData,wt_n3_xytData,wt_n4_xytData,wt_n5_xytData,wt_n6_xytData,wt_n7_xytData,wt_n8_xytData,wt_n9_xytData,wt_n10_xytData)




#Testing differences between WT and Netrin lines

#first histograms
hist(wt_all_xytData$t, breaks = 20)
hist(wt_n_all_xytData$t, breaks = 20)
#Next, perform a KS test to determine if there is a difference between WT and WT-Netrin curves (hint: There is)
ks.test(wt_all_xytData$t,wt_n_all_xytData$t)

#Creating hyperframe: We are going now combine the replicated point patter data.

#Take the above data, convert each into it's own PPP, then concatonate them into a list()

#convert all WT and netrin data into PPP:
pptemp1<- ppp(wt_xytData_x,wt_xytData_y, c(0,16), c(0,16), mask = wt_xytData_mask) #flagging for potentially inaccurate mask
pptemp2<- ppp(wt2_xytData_x,wt2_xytData_y, c(0,16), c(0,16), mask = wt2_xytData_mask)
pptemp3<- ppp(wt3_xytData_x,wt3_xytData_y, c(0,16), c(0,16), mask = wt3_xytData_mask)
pptemp4<- ppp(wt4_xytData_x,wt4_xytData_y, c(0,16), c(0,16), mask = wt4_xytData_mask)
pptemp5<- ppp(wt5_xytData_x,wt5_xytData_y, c(0,16), c(0,16), mask = wt5_xytData_mask)
pptemp6<- ppp(wt6_xytData_x,wt6_xytData_y, c(0,16), c(0,16), mask = wt6_xytData_mask) #flagged for potentially innacurate mask
pptemp7<- ppp(wt7_xytData_x,wt7_xytData_y, c(0,16), c(0,16), mask = wt7_xytData_mask)
pptemp8<- ppp(wt8_xytData_x,wt8_xytData_y, c(0,16), c(0,16), mask = wt8_xytData_mask)
pptemp9<- ppp(wt9_xytData_x,wt9_xytData_y, c(0,16), c(0,16), mask = wt9_xytData_mask)#flagged for potentially innacurate mask

#plotting density of some more wildtypes
plot(density(pptemp1,0.32), zlim = c(0,15))
plot(density(pptemp2,0.32), zlim = c(0,15))
plot(density(pptemp3,0.32), zlim = c(0,15))
plot(density(pptemp4,0.32), zlim = c(0,15))
plot(density(pptemp5,0.32), zlim = c(0,6))
plot(density(pptemp6,0.32), zlim = c(0,15))

tiff("plot3.tiff", width =4, height =4, units = 'in', res = 300)
plot(density(pptemp7,0.1, dimyx = 1500), zlim = c(0,20))
dev.off()
plot(density(pptemp8,0.32), zlim = c(0,15))
plot(density(pptemp9,0.32), zlim = c(0,15))

#pair distance
heatmap(pairdist(pptemp2))
heatmap(pairdist(pptemp3))
heatmap(pairdist(pptemp4))
heatmap(pairdist(pptemp5))
heatmap(pairdist(pptemp7))

heatmap(pairdist(pptemp2n))
heatmap(pairdist(pptemp1n))
heatmap(pairdist(pptemp4n))
heatmap(pairdist(pptemp5n))
heatmap(pairdist(pptemp7n))

pptemp1n<- ppp(wt_n_xytData_x,wt_n_xytData_y, c(0,16), c(0,16), mask = wt_n_xytData_mask)
pptemp2n<- ppp(wt_n2_xytData_x,wt_n2_xytData_y, c(0,16), c(0,16), mask = wt_n2_xytData_mask)
pptemp3n<- ppp(wt_n3_xytData_x,wt_n3_xytData_y, c(0,16), c(0,16), mask = wt_n3_xytData_mask)
pptemp4n<- ppp(wt_n4_xytData_x,wt_n4_xytData_y, c(0,16), c(0,16), mask = wt_n4_xytData_mask) #flag: Make sure mask is right
pptemp5n<- ppp(wt_n5_xytData_x,wt_n5_xytData_y, c(0,16), c(0,16), mask = wt_n5_xytData_mask)
pptemp6n<- ppp(wt_n6_xytData_x,wt_n6_xytData_y, c(0,16), c(0,16), mask = wt_n6_xytData_mask)
pptemp7n<- ppp(wt_n7_xytData_x,wt_n7_xytData_y, c(0,16), c(0,16), mask = wt_n7_xytData_mask)
pptemp8n<- ppp(wt_n8_xytData_x,wt_n8_xytData_y, c(0,16), c(0,16), mask = wt_n8_xytData_mask)
pptemp9n<- ppp(wt_n9_xytData_x,wt_n9_xytData_y, c(0,16), c(0,16), mask = wt_n9_xytData_mask)
pptemp10n<- ppp(wt_n10_xytData_x,wt_n10_xytData_y, c(0,16), c(0,16), mask = wt_n10_xytData_mask)

#plotting density of some more wildtypes + netrin
plot(density(pptemp1n,0.32), zlim = c(0,15))
plot(density(pptemp2n,0.32), zlim = c(0,15))
plot(density(pptemp3n,0.32), zlim = c(0,15))
plot(density(pptemp4n,0.32), zlim = c(0,15))
plot(density(pptemp5n,0.32), zlim = c(0,15))
plot(density(pptemp6n,0.32), zlim = c(0,15))
plot(density(pptemp7n,0.32), zlim = c(0,15))
plot(density(pptemp8n,0.32), zlim = c(0,15))
plot(density(pptemp9n,0.32), zlim = c(0,15))
plot(density(pptemp10n,0.32), zlim = c(0,15))


plot(ktemp3)
##K-functions of all the things
ktemp1 <- Lest(pptemp1, ratio=TRUE, correction="best")
ktemp2 <- Lest(pptemp2, ratio=TRUE, correction="best")
ktemp3 <- Lest(pptemp3, ratio=TRUE, correction="best")
ktemp4 <- Lest(pptemp4, ratio=TRUE, correction="best")
ktemp5 <- Lest(pptemp5, ratio=TRUE, correction="best")
ktemp6 <- Lest(pptemp6, ratio=TRUE, correction="best")
ktemp7 <- Lest(pptemp7, ratio=TRUE, correction="best")
ktemp8 <- Lest(pptemp8, ratio=TRUE, correction="best")
ktemp9 <- Lest(pptemp9, ratio=TRUE, correction="best")

ktemp1n <- Lest(pptemp1n, ratio=TRUE, correction="best")
ktemp2n <- Lest(pptemp2n, ratio=TRUE, correction="best")
ktemp3n <- Lest(pptemp3n, ratio=TRUE, correction="best")
ktemp4n <- Lest(pptemp4n, ratio=TRUE, correction="best")
ktemp5n <- Lest(pptemp5n, ratio=TRUE, correction="best")
ktemp6n <- Lest(pptemp6n, ratio=TRUE, correction="best")
ktemp7n <- Lest(pptemp7n, ratio=TRUE, correction="best")
ktemp8n <- Lest(pptemp8n, ratio=TRUE, correction="best")
ktemp9n <- Lest(pptemp9n, ratio=TRUE, correction="best")
ktemp10n <-Lest(pptemp10n, ratio=TRUE, correction="best")
K <- pool(ktemp6n,ktemp9n)
K <- pool(ktemp2n)
Kn <- pool(ktemp1n,ktemp7,ktemp5n,ktemp6n,ktemp8n,ktemp9n)

plot(K, cbind(pooltrans,pooltheo,hitrans,lotrans) ~ r, shade=c("hitrans", "lotrans"))
plot(Kn, cbind(pooltrans,pooltheo,hitrans,lotrans) - r ~ r, shade=c("hitrans", "lotrans"))

df <- hyperframe(x=c("one","one","one","one","one","one","one","one","two","two","two","two","two","two","two","two","two","two"),y=list(pptemp1,pptemp2,pptemp3,pptemp4,pptemp5,pptemp7,pptemp8,pptemp9,pptemp1n,pptemp2n,pptemp3n,pptemp4n,pptemp5n,pptemp6n,pptemp7n,pptemp8n,pptemp9n,pptemp10n))
testinal <- studpermu.test(df, y~x, minpoints = 4)
testinal

K1 <- Kest(runifpoint(42), ratio=TRUE, correction="iso")   
K2 <- Kest(runifpoint(42), ratio=TRUE, correction="iso")   
K3 <- Kest(runifpoint(42), ratio=TRUE, correction="iso")
K <- pool(K1, K2, K3)
plot(K, pooliso ~ r, shade=c("hiiso", "loiso"))



E <- envelope(pptemp5n, Lest, nsim = 19, rank = 1, global = TRUE)
E1<- envelope(pptemp4, Lest, nsim = 19, rank = 1, global = TRUE)
E2<- envelope(pptemp2n, Lest, nsim = 19, rank = 1, global = TRUE)
E3<- envelope(pptemp5n, Lest, nsim = 19, rank = 1, global = TRUE)
plot(E)
plot(E1)
plot(E2)
plot(E3)
ks.test(K,Kn)

plot(Kest(rpoispp(50)))


#Now that we have all of the PPP, will aggregate into a list so that we can add it to the hyperframe
wt_net_listofpoints <- list(pptemp1,pptemp2,pptemp3,pptemp4,pptemp5,pptemp6,pptemp7,pptemp8,pptemp9,pptemp1n,pptemp2n,pptemp3n,pptemp4n,pptemp5n,pptemp6n,pptemp7n,pptemp8n,pptemp9n,pptemp10n)

#create a genotype list
wt_net_listofnames <- c((replicate(9,"wildtype")),(replicate(10,"wt_netrin")))
master_ppp_list <- hyperframe()
master_ppp_list$pointPatter <- wt_net_listofpoints
master_ppp_list$condition <- wt_net_listofnames

masterK <- with(master_ppp_list, Kest(pointPatter))
plot(masterK)










###Everything below here is for something else.
help(spatstat)
bestden <- envelope.lpp(dendrite,global = TRUE, nsims = 39)
plot(bestden)
bleh <- data(simplenet)
#plottin' the already counted

stream2_countpoints <- read.table(file = "D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_2_finalpoints.csv", header = T, sep = ",")
stream4_countpoints <- read.table(file = "D:/Documents/ANALYSE_THESE/5_15_16/wt_netrin/tracks/stream_4_finalpoints.csv", header = T, sep = ",")
stream3_819_countpoints <- read.table(file = "D:/Documents/ANALYSE_THESE/8_19_16/wt/mtrack/stream_3_finalpoints.csv", header = T, sep = ",")
stream4_819_countpoints <- read.table(file = "D:/Documents/ANALYSE_THESE/8_19_16/wt/mtrack/stream_4_finalpoints.csv", header = T, sep = ",")
stream_819_wtn_countpoints <- read.table(file = "D:/Documents/ANALYSE_THESE/8_19_16/wt_n/mtrack/stream_finalpoints.csv", header = T, sep = ",")

stream_wt_819_countpoints <- read.table(file = "D:/Documents/ANALYSE_THESE/8_19_16/wt/mtrack/stream_wt_finalpoints.csv", header = T, sep = ",")

vignette("shapefiles", package="spatstat")
plot(dendrite,leg.side="bottom", main="", cex=0.75, cols=2:4)
plot(ecdf(wt2_xytData$centroids31))
#lines(ecdf(net3_xytData$centroids31))
#lines(ecdf(net2_xytData$V3))
lines(ecdf(hr24_xytData$V3))
lines(ecdf(hr242_xytData$V3))
#lines(ecdf(hr244_xytData$V3))
#lines(ecdf(hr245_xytData$V3))
lines(ecdf(hr245_xytData$V3))

stream_wt_819_countpoints