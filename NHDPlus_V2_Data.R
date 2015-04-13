#Check and Utilize NHDPlus V2 data
library(maps)
library(mapdata)
library(dismo)
library(maptools)
library(raster)
library(rgdal)
library(sp)
library(rgeos)
library(foreign)

setwd("~/AppLCC/Data/Hellbender_Data")

list.files()

##################################################
# CumArea <- read.dbf(("CumulativeArea.dbf"))
# str(CumArea)
# DFrac <- read.dbf(("DivFracMP.dbf" ))
# str(DFrac)
# ElSlope <- read.dbf(("elevslope.dbf"))
# str(ElSlope)
# HNodeArea <- read.dbf(("HeadwaterNodeArea.dbf" ))
# str(HNodeArea)
# MeaDiv <- read.dbf(("MegaDiv.dbf"))
# str(MeaDiv)
# PlusAR <- read.dbf(("PlusARPointEvent.dbf" ))
# str(PlusAR)
# PlusFlow <- read.dbf(("PlusFlow.dbf"  ))
# str(PlusFlow)
# PlusFlowAR <- read.dbf(("PlusFlowAR.dbf"   ))
# str(PlusFlowAR)
# FlowLinesVAA <- read.dbf(("PlusFlowlineVAA.dbf"   ))
# str(FlowLinesVAA)
# summary(FlowLinesVAA)

##############################
Hell<-read.csv("Hellbender_Table2.csv")
str(Hell)
summary(Hell)



Occur<-read.csv("occurrence.csv")
str(Occur)
summary(Hell)





