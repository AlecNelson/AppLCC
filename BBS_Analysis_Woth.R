#Clean and Prepare BBS Data
library(maps)
library(mapdata)
library(dismo)
library(maptools)
library(raster)
library(rgdal)
library(sp)
library(rgeos)


setwd("~/AppLCC/Data/BBS_FTP_2015")
list.files()

GnatLongs<-read.csv("GnatLongs.csv")
routes<-read.csv("routes.csv")

WOTH<-GnatLongs[which(GnatLongs$Aou==7550),]
str(WOTH)
summary(WOTH)
str(routes)

plot(WOTH$Year,WOTH$count10)

WOTH.r <- merge(WOTH,routes,by=c("Route","statenum","countrynum"))
names(WOTH.r)

WOTH.df <-WOTH.r[,c(5,7,15,16)]
coords = cbind(WOTH.df$Longi, WOTH.df$Lati)
sp = SpatialPointsDataFrame(coords,WOTH.df)
writeOGR(sp, ".", "WOTH_BBS_points2", driver="ESRI Shapefile")

write.csv(sp, file = "WOTH_BBS_LatLong.csv")


#Read in data that was clipped in Arcgis after Projected
data = read.table("WOTH_BBSPoints_App.txt", header=TRUE,sep=",")
WOTH.BBS <- data[,-1]
str(WOTH.BBS)

setwd("~/AppLCC/Data")
data = read.table("WOTH_App_Points.txt", header=TRUE,sep=",")
WOTH.App <- data[,-1]

str(WOTH.App)
summary(WOTH.App)
getwd()


