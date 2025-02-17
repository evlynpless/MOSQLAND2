#!/bin/bash                                        
#SBATCH -p day                                     
#SBATCH --mem=100g                                
#SBATCH -t 24:00:00                                
#SBATCH -o /gpfs/scratch60/fas/powell/esp38/stdout/rasterstack.sh.%J.out
#SBATCH -e /gpfs/scratch60/fas/powell/esp38/stderr/rasterstack.sh.%J.err
#SBATCH --mail-type=ALL                            
#SBATCH --mail-user=evlyn.pless@yale.edu           
#SBATCH --job-name=rasterstack.sh                                                                                        
# sbatch   /home/fas/powell/esp38/scripts/MOSQLAND/RF_EAfr/rasterstack.sh                                                     
ulimit -c 0 

module load R/3.5.3-foss-2018a-X11-20180131
module load GDAL/3.1.0-foss-2018a-Python-3.6.4
module load Rpkgs/RGDAL/1.2-5 #not working
module load Rpkgs/DOPARALLEL/1.0.3 #not working


R --vanilla -no-readline -q  << 'EOF'

#Purpose: creating North America raster stack for use in iterative RF model

#Download packages
library("sp")
#library("spatstat")
#library("maptools")
library("raster")
library("doParallel")
library("rgdal")
#library("gdistance")
#library("SDraw")
#library("tidyverse")

#Add coordinate system
crs.geo <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

###############################################
#Create raster stack
###############################################

#Upload each raster and define its coordinate system
#Multiply by 1 is a trick to save memory later

aridI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/AI_annual_EAfrClip.tif")
arid = aridI*1
proj4string(arid) <- crs.geo

accessI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/accessibility_to_cities_2015_v1.0_res_EAfrClip.tif")
access <- accessI*1
proj4string(access) <- crs.geo

precI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/bio12_mean_EAfrClip.tif")
prec <- precI*1
proj4string(prec) <- crs.geo

mean.tempI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/bio1_mean_EAfrClip.tif")
mean.temp <- mean.tempI*1
proj4string(mean.temp) <- crs.geo

human.densityI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/GHS_BUILT_LDS2014_GLOBE_R2016A_54009_1k_v1_0_WGS84_EAfrClip.tif")
human.density <- human.densityI*1
proj4string(human.density) <- crs.geo

frictionI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/friction_surface_2015_v1.0_EAfrClip.tif")
friction <- frictionI*1
proj4string(friction) <- crs.geo

min.tempI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/bio6_mean_EAfrClip.tif")
min.temp <- min.tempI*1
proj4string(min.temp) <- crs.geo

NeedleleafI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_1_EAfrClip.tif")
Needleleaf = NeedleleafI*1
proj4string(Needleleaf) <- crs.geo

EvBroadleafI  = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_2_EAfrClip.tif")
EvBroadleaf = EvBroadleafI*1
proj4string(EvBroadleaf) <- crs.geo

DecBroadleafI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_3_EAfrClip.tif")
DecBroadleaf = DecBroadleafI*1
proj4string(DecBroadleaf) <- crs.geo

MiscTreesI =  raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_4_EAfrClip.tif")
MiscTrees = MiscTreesI*1
proj4string(MiscTrees) <- crs.geo

ShrubsI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_5_EAfrClip.tif")
Shrubs = ShrubsI*1
proj4string(Shrubs) <- crs.geo

HerbI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_6_EAfrClip.tif")
Herb = HerbI*1
proj4string(Herb) <- crs.geo

CropI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_7_EAfrClip.tif")
Crop <- CropI*1
proj4string(Crop) <- crs.geo

FloodI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_8_EAfrClip.tif")
Flood = FloodI*1
proj4string(Flood) <- crs.geo

UrbanI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_9_EAfrClip.tif")
Urban <- UrbanI*1
proj4string(Urban) <- crs.geo

#SnowI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_10_EAfrClip.tif")
#Snow = SnowI*1
#proj4string(Snow) <- crs.geo

BarrenI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_11_EAfrClip.tif")
Barren = BarrenI*1
proj4string(Barren) <- crs.geo

WaterI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/consensus_full_class_12_EAfrClip.tif")
Water = WaterI*1
proj4string(Water) <- crs.geo

SlopeI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/slope_1KMmedian_MERIT_EAfrClip.tif")
Slope = SlopeI*1
proj4string(Slope) <- crs.geo

AltitudeI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/altitude_1KMmedian_MERIT_EAfrClip.tif")
Altitude = AltitudeI*1
proj4string(Altitude) <- crs.geo

PETI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/pet_mean_EAfrClip.tif")
PET = PETI*1
proj4string(PET) <- crs.geo

DailyTempRangeI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/bio2_mean_EAfrClip.tif")
DailyTempRange = DailyTempRangeI*1
proj4string(DailyTempRange) <- crs.geo

max.tempI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/bio5_mean_EAfrClip.tif")
max.temp = max.tempI*1
proj4string(max.temp) <- crs.geo

AnnualTempRangeI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/bio7_mean_EAfrClip.tif")
AnnualTempRange = AnnualTempRangeI*1
proj4string(AnnualTempRange) <- crs.geo

prec.wetI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/bio13_mean_EAfrClip.tif")
prec.wet = prec.wetI*1
proj4string(prec.wet) <- crs.geo

prec.dryI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/bio14_mean_EAfrClip.tif")
prec.dry = prec.dryI*1
proj4string(prec.dry) <- crs.geo

GPPI = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/GPP_mean_EAfrClip.tif")
GPP = GPPI*1
proj4string(GPP) <- crs.geo

kernel100I = raster("/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_clips/kernel_res_cubicSP.tif")
kernel100 = kernel100I*1
proj4string(kernel100) <- crs.geo

#Create raster stack named env
env=stack(arid, access, prec, mean.temp, human.density, friction, min.temp, Needleleaf, EvBroadleaf, DecBroadleaf, MiscTrees, Shrubs, Herb, Crop, Flood, Urban, Barren, Water, Slope, Altitude, PET, DailyTempRange, max.temp, AnnualTempRange, prec.wet, prec.dry, GPP, kernel100) 

#Rename each raster in env so they can be referenced later
names(env) [1] <- "arid"
names(env) [2] <- "access"
names(env) [3] <- "prec"
names(env) [4] <- "mean.temp"
names(env) [5] <- "human.density"
names(env) [6] <- "friction"
names(env) [7] <- "min.temp"
names(env) [8] <- "Needleleaf"
names(env) [9] <- "EvBroadleaf"
names(env) [10] <- "DecBroadleaf"
names(env) [11] <- "MiscTrees"
names(env) [12] <- "Shrubs"
names(env) [13] <- "Herb"
names(env) [14] <- "Crop"
names(env) [15] <- "Flood"
names(env) [16] <- "Urban"
names(env) [17] <- "Barren"
names(env) [18] <- "Water"
names(env) [19] <- "Slope"
names(env) [20] <- "Altitude"
names(env) [21] <- "PET"
names(env) [22] <- "DailyTempRange"
names(env) [23] <- "max.temp"
names(env) [24] <- "AnnualTempRange"
names(env) [25] <- "prec.wet"
names(env) [26] <- "prec.dry"
names(env) [27] <- "GPP"
names(env) [28] <- "kernel100"

print("raster stack done")

value.raster = as.data.frame(getValues(arid))
names(value.raster) = "arid"
value.raster$access = getValues(access)
value.raster$prec = getValues(prec)
value.raster$mean.temp = getValues(mean.temp)
value.raster$human.density = getValues(human.density)
value.raster$friction = getValues(friction)
value.raster$min.temp = getValues(min.temp)
value.raster$Needleleaf = getValues(Needleleaf)
value.raster$EvBroadleaf = getValues(EvBroadleaf)
value.raster$DecBroadleaf = getValues(DecBroadleaf)
value.raster$MiscTrees = getValues(MiscTrees)
value.raster$Shrubs = getValues(Shrubs)
value.raster$Herb = getValues(Herb)
value.raster$Crop = getValues(Crop)
value.raster$Flood = getValues(Flood)
value.raster$Urban = getValues(Urban)
#value.raster$Snow = getValues(Snow)
value.raster$Barren = getValues(Barren)
value.raster$Water = getValues(Water)
value.raster$Slope = getValues(Slope)
value.raster$Altitude = getValues(Altitude)
value.raster$PET = getValues(PET)
value.raster$DailyTempRange = getValues(DailyTempRange)
value.raster$max.temp = getValues(max.temp)
value.raster$AnnualTempRange = getValues(AnnualTempRange)
value.raster$prec.wet = getValues(prec.wet)
value.raster$prec.dry = getValues(prec.dry)
value.raster$GPP = getValues(GPP)
value.raster$kernel100 = getValues(kernel100)
save.image(file = "/project/fas/powell/esp38/dataproces/MOSQLAND/consland/EAfrica_output/rasterstack.RData")

EOF
