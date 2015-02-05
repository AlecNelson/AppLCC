#Clean and Prepare Data for E-Bird Data
library(maps)
library(mapdata)
library(dismo)
library(maptools)
library(raster)
library(rgdal)
library(sp)
library(rgeos)

setwd("~/AppLCC/Data")

file<-"ebd_US_woothr_relNov-2014.txt"

#Use Import Dataset function from RStudio
WOTH<-ebd_US_woothr_relNov.2014

#Clean data and subset to important variables
for(i in 1:length(WOTH[1,])){
  names(WOTH)[i]<-as.character(WOTH[1,][i][1,1])
}
WOTH <- WOTH[-1,]
WOTH <- WOTH[,-43]
WOTH.df<-WOTH[c(8,22,23,24)]

names(WOTH.df)[1]<-"Count"
names(WOTH.df)[2]<-"Lat"
names(WOTH.df)[3]<-"Lon"
names(WOTH.df)[4]<-"Date"

WOTH.df$Count<-(as.numeric(levels(WOTH.df$Count))[WOTH.df$Count])
WOTH.df$Lat<-(as.numeric(levels(WOTH.df$Lat))[WOTH.df$Lat])
WOTH.df$Lon<-(as.numeric(levels(WOTH.df$Lon))[WOTH.df$Lon])

WOTH.df<-WOTH.df[complete.cases(WOTH.df[,2:4]),]

summary(WOTH.df)

#Subset to region of interest
#WOTH.App <- WOTH.df[ which(WOTH.df$"BCR CODE"=='28' | WOTH.df$"BCR CODE"=='24') ,]
# dups <- duplicated(WOTH.df[, c('species','lon','lat')])
# WOTH.df.dup <- WOTH.df[!dups, ]
# georef<-subset(WOTH.df, (is.na(Lon)|is.na(Lat)))
# dim(georef)

coords = cbind(WOTH.df$Lon, WOTH.df$Lat)
sp = SpatialPointsDataFrame(coords,WOTH.df)
writeOGR(sp, ".", "WOTHpoints", driver="ESRI Shapefile")

# proj4string(sp)
# proj4string(Boundary)
# over(sp,Boundary)

#Read in data that was clipped in Arcgis after Projected
data = read.table("WOTH_App_Points.txt", header=TRUE,sep=",")
WOTH.App <- data[,-1]

str(WOTH.App)
summary(WOTH.App)

#Plot to observe/check Data
data(stateMapEnv)
Boundary<-readOGR(".","Current_Boundary")

plot(c(-90,-70), c(31,44), mar=par("mar"), xlab="longitude", ylab="latitude", xaxt="n", yaxt="n", type="n", main="Wood Thrush presence data")
rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4], col="lightblue")
map("state", xlim=c(-90,-70), ylim=c(31,44), fill=T, col="cornsilk", add=T)
axis(1,las=1)
axis(2,las=1)
box()
# plot points
points(WOTH.App$Lon, WOTH.App$Lat, col='orange', pch=20, cex=0.75)
# plot points again to add a border, for better visibility
points(WOTH.App$Lon, WOTH.App$Lat, col='red', cex=0.75)
plot(Boundary,border="deepskyblue4",lwd=1.5,add=TRUE)

#How Much Data and when is it from?
dim(WOTH.App)
plot(WOTH.App$Date,WOTH.App$Count)
WOTH.App$Date<-as.Date(WOTH.App$Date)
length(WOTH.App$Date[which(WOTH.App$Date >= "2000-01-01",)])
#Subset to data from 1980 onward
WOTH.App = subset(WOTH.App, WOTH.App$Date >= "1980-01-01")

str(WOTH.App)
summary(WOTH.App)

###################################################################
#Consider subsampling data to reduce some observation bias
r<-raster(Boundary)
res(r)<-0.2
r <- extend(r, extent(r)+1)
WOTH.Sample <- gridSample(cbind(WOTH.App$Lon, WOTH.App$Lat), r, n=1)
dim(WOTH.Sample)

p <- rasterToPolygons(r)
plot(p, border='gray')
points(WOTH.App$Lon, WOTH.App$Lat, col='dark grey', pch=20, cex=0.75)
points(WOTH.Sample, cex=1, col='red', pch=1)

#write.csv(WOTH.Sample, file = "WOTH_Sample.csv")
###################################################################
###################################################################

WOTH.Sample <- read.csv("WOTH_Sample.csv")

str(WOTH.Sample)
summary(WOTH.Sample)
###################################################################

#Calculate psuedo-abscences of WOTH data in this area 
  # using random points with circles() and spsample()
#Consider what is a reasonable distance to assume similar habitat
  #e.g. 30 km radius of reasonably similar habitat

x = circles(WOTH.Sample[,c("Lon","Lat")], d=30000, lonlat=T)
bg = spsample(x@polygons, 800, type='random', iter=1000)

length(bg)
dim(WOTH.Sample)


#Plot data to observe trends:
data(stateMapEnv)
plot(c(-90,-70), c(31,44), mar=par("mar"), xlab="longitude", ylab="latitude", xaxt="n", yaxt="n", type="n", main="Wood Thrush presence and pseudo-absence data")
rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4], col="lightblue")
map("state", xlim=c(-90,-70), ylim=c(31,44), fill=T, col="cornsilk", add=T)
axis(1,las=1)
axis(2,las=1)
box()

plot(x@polygons, border='dark grey', lwd=2,col=c("ghostwhite",alpha=0.7),add=TRUE)
points(bg, col='darkorange1', pch=1, cex=0.9)
points(WOTH.Sample, col="darkolivegreen3", pch=20, cex=0.9)
plot(Boundary,border="deepskyblue4",lwd=1.5,add=TRUE)




#Collect and Integrate Environmental Data into the Model framework



























