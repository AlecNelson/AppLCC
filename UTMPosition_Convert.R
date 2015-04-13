#Clean and Prepare Spotted Skunk Data
library(maps)
library(mapdata)
library(dismo)
library(maptools)
library(raster)
library(rgdal)
library(sp)
library(rgeos)

setwd("~/AppLCC/Data/SpottedSkunk")

SS_VA<-read.csv("SpottedSkunk_VA.csv")
SS_WV<-read.csv("SpottedSkunk_WV.csv")

#17N 542166mE 4138849mN 

pos<-paste("17N ",SS_VA[1,1],"mE ",SS_VA[1,2],"mN",sep="")

table.i<-SS_VA
for(i in 1:nrow(table.i)){
  #print(i)
  pos_i<-paste("17N ",table.i[i,1],"mE ",table.i[i,2],"mN",sep="")
  table.i[i,3]<-pos_i
}
names(table.i)[3]<-"Position"
SS_VA_Pos<-table.i

table.i<-SS_WV
for(i in 1:nrow(table.i)){
  #print(i)
  pos_i<-paste("17N ",table.i[i,1],"mE ",table.i[i,2],"mN",sep="")
  table.i[i,3]<-pos_i
}
names(table.i)[3]<-"Position"
SS_WV_Pos<-table.i

write.csv(SS_VA_Pos, file = "SS_VA_Pos.csv")
write.csv(SS_WV_Pos, file = "SS_WV_Pos.csv")

names(occurrence)

occurrence1 <- occurrence[,78:79]

write.csv(occurrence1, file = "occurrence.csv")
