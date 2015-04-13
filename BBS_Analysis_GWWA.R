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

NWWarbler<-read.csv("NWWarbler.csv")
routes<-read.csv("routes.csv")

str(NWWarbler)

GWWA<-NWWarbler[which(NWWarbler$Aou==6420),]
str(GWWA)
str(routes)

GWWA.r <- merge(GWWA,routes,by=c("Route","statenum","countrynum"))
names(GWWA.r)

GWWA.df <-GWWA.r[,c(5,7,15,16)]
coords = cbind(GWWA.df$Longi, GWWA.df$Lati)
sp = SpatialPointsDataFrame(coords,GWWA.df)
writeOGR(sp, ".", "GWWA_BBS_points", driver="ESRI Shapefile")


#Read in data that was clipped in Arcgis after Projected
data = read.table("GWWA_BBSPoints_App.txt", header=TRUE,sep=",")
GWWA.BBS <- data[,-1]
str(GWWA.BBS)

setwd("~/AppLCC/Data")
data = read.table("GWWA_App_Points.txt", header=TRUE,sep=",")
GWWA.App <- data[,-1]

str(GWWA.App)
summary(GWWA.App)


#REMOVE ROWS WITH 0 FOR COUNT, AS THE SPECIES WAS OBSERVED ALONG
#THE ROUTE BUT NOT WITHIN THE FIRST 10