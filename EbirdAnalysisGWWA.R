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
list.files()

file<-"ebd_US_gowwar_relNov-2014.txt"

#Use Import Dataset function from RStudio
GWWA<-ebd_US_gowwar_relNov.2014

#Clean data and subset to important variables
for(i in 1:length(GWWA[1,])){
  names(GWWA)[i]<-as.character(GWWA[1,][i][1,1])
}
GWWA <- GWWA[-1,]
GWWA <- GWWA[,-43]
GWWA.df<-GWWA[c(8,22,23,24)]

names(GWWA.df)[1]<-"Count"
names(GWWA.df)[2]<-"Lat"
names(GWWA.df)[3]<-"Lon"
names(GWWA.df)[4]<-"Date"

GWWA.df$Count<-(as.numeric(levels(GWWA.df$Count))[GWWA.df$Count])
GWWA.df$Lat<-(as.numeric(levels(GWWA.df$Lat))[GWWA.df$Lat])
GWWA.df$Lon<-(as.numeric(levels(GWWA.df$Lon))[GWWA.df$Lon])

GWWA.df<-GWWA.df[complete.cases(GWWA.df[,2:4]),]

summary(GWWA.df)

#Subset to region of interest
#GWWA.App <- GWWA.df[ which(GWWA.df$"BCR CODE"=='28' | GWWA.df$"BCR CODE"=='24') ,]
# dups <- duplicated(GWWA.df[, c('species','lon','lat')])
# GWWA.df.dup <- GWWA.df[!dups, ]
# georef<-subset(GWWA.df, (is.na(Lon)|is.na(Lat)))
# dim(georef)

coords = cbind(GWWA.df$Lon, GWWA.df$Lat)
sp = SpatialPointsDataFrame(coords,GWWA.df)
writeOGR(sp, ".", "GWWApoints", driver="ESRI Shapefile")

# proj4string(sp)
# proj4string(Boundary)
# over(sp,Boundary)

#Read in data that was clipped in Arcgis after Projected
data = read.table("GWWA_App_Points.txt", header=TRUE,sep=",")
GWWA.App <- data[,-1]

str(GWWA.App)
summary(GWWA.App)

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
points(GWWA.App$Lon, GWWA.App$Lat, col='orange', pch=20, cex=0.75)
# plot points again to add a border, for better visibility
points(GWWA.App$Lon, GWWA.App$Lat, col='red', cex=0.75)
plot(Boundary,border="deepskyblue4",lwd=1.5,add=TRUE)

#How Much Data and when is it from?
dim(GWWA.App)
plot(GWWA.App$Date,GWWA.App$Count)
GWWA.App$Date<-as.Date(GWWA.App$Date)
length(GWWA.App$Date[which(GWWA.App$Date >= "2000-01-01",)])
#Subset to data from 1980 onward
GWWA.App = subset(GWWA.App, GWWA.App$Date >= "1980-01-01")

str(GWWA.App)
summary(GWWA.App)

###################################################################
#Consider subsampling data to reduce some observation bias
r<-raster(Boundary)
res(r)<-0.2
r <- extend(r, extent(r)+1)
GWWA.Sample <- gridSample(cbind(GWWA.App$Lon, GWWA.App$Lat), r, n=1)
dim(GWWA.Sample)

p <- rasterToPolygons(r)
plot(p, border='gray')
points(GWWA.App$Lon, GWWA.App$Lat, col='dark grey', pch=20, cex=0.75)
points(GWWA.Sample, cex=1, col='red', pch=1)

#write.csv(GWWA.Sample, file = "GWWA_Sample.csv")
###################################################################
###################################################################

GWWA.Sample <- read.csv("GWWA_Sample.csv")

str(GWWA.Sample)
summary(GWWA.Sample)

coords = cbind(GWWA.Sample$Lon, GWWA.Sample$Lat)
sp = SpatialPointsDataFrame(coords,GWWA.Sample)
writeOGR(sp, ".", "GWWA.Sample", driver="ESRI Shapefile")

###################################################################

#Calculate psuedo-abscences of GWWA data in this area 
# using random points with circles() and spsample()
#Consider what is a reasonable distance to assume similar habitat
#e.g. 30 km radius of reasonably similar habitat

x = circles(GWWA.Sample[,c("Lon","Lat")], d=30000, lonlat=T)
bg = spsample(x@polygons, 800, type='random', iter=1000)

length(bg)
dim(GWWA.Sample)


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
points(GWWA.Sample, col="darkolivegreen3", pch=20, cex=0.9)
plot(Boundary,border="deepskyblue4",lwd=1.5,add=TRUE)




#Collect and Integrate Environmental Data into the Model framework


























