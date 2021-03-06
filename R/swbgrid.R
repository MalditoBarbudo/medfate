swbgrid<-function(y, SpParams, meteo, dates, 
                  summaryFreq = "years", trackSpecies = numeric(), 
                  control = defaultControl()) {

  if(!inherits(meteo,"SpatialGridMeteorology") && 
     !inherits(meteo,"data.frame")) 
    stop("'meteo' has to be of class 'SpatialGridMeteorology' or 'data.frame'.")
  
  date.factor = cut(dates, breaks=summaryFreq)
  df.int = as.numeric(date.factor)
  nDays = length(dates)
  nCells = length(y@forestlist) 
  nSummary = sum(table(date.factor)>0)
  
  #Print information area
  cat("\n------------  swbgrid ------------\n")
  cat(paste("Grid cells: ", nCells,", area: ", areaSpatialGrid(y)/10000," ha\n", sep=""))
  cat(paste("Number of days to simulate: ",nDays,"\n", sep=""))
  cat(paste("Number of summaries: ", nSummary,"\n\n", sep=""))
  
    
  if(control$verbose) cat(paste("Preparing swb input"))
  swbInputList = vector("list", nCells)
  for(i in 1:nCells) {
    yid = y@forestlist[[i]]
    soil = y@soillist[[i]]
    if((!is.na(yid)) && (!is.na(soil))) {             
      xi = forest2swbInput(yid, soil, SpParams, control)
      if(!inherits(xi,"data.frame")) stop("not a data frame!")
      swbInputList[[i]] = xi
    }  else {
      swbInputList[[i]] = NA
    }
  }
  cat(paste(" - number of cells with swbInput == NA: ", sum(is.na(swbInputList)),"\n\n", sep=""))
  

  #Output matrices
  Runon = matrix(0,nrow=nCells, ncol=nSummary)
  colnames(Runon) = levels(date.factor)[1:nSummary]
  Runoff = Runon
  Infiltration = Runon
  NetPrec =Runon
  DeepDrainage = Runon
  Esoil = Runon
  Eplant = Runon
  W1mean = Runon
  W2mean = Runon
  W3mean = Runon
  LandscapeBalance = data.frame(Rainfall = rep(0, nSummary),
                                Interception = rep(0, nSummary),
                                Esoil = rep(0,nSummary),
                                Eplant = rep(0, nSummary),
                                Runoff = rep(0, nSummary),
                                DeepDrainage= rep(0, nSummary))
                                
  
  nTrackSpecies = length(trackSpecies)
  if(nTrackSpecies>0) {
    DI = array(0.0,dim=c(nCells, nSummary, nTrackSpecies))
    Transpiration = array(0.0,dim=c(nCells, nSummary, nTrackSpecies))
  } else {
    DI = NULL
    Transpiration = NULL
  }
  
  ifactor = 1
  gridGDD = rep(0,nCells)
  for(day in 1:nDays) {
    cat(paste("Day #", day))
    doy = as.numeric(format(dates[day],"%j"))
    if(inherits(meteo,"SpatialGridMeteorology")) {
      ml = meteo@data[[i]]
    } else {
      f = paste(meteo$dir[i], meteo$filename[i],sep="/")
      if(!file.exists(f)) stop(paste("Meteorology file '", f,"' does not exist!", sep=""))
      ml = readmeteorologygrid(f)
    }
    gridMeanTemperature = as.numeric(ml["MeanTemperature"])
    gridPET = as.numeric(ml["PET"])
    gridPrecipitation = as.numeric(ml["Precipitation"])
    gridER = rep(.er(doy),nCells) #ER
    gridGDD = gridGDD + pmax(gridMeanTemperature - 5.0, 0.0) #Increase GDD
    if(doy>=365) gridGDD = rep(0, nCells) #Reset GDD 
    df = .swbgridDay(y@lct, swbInputList, y@soillist, 
                     y@waterO, y@queenNeigh, y@waterQ,
                     gridGDD, gridPET, gridPrecipitation, gridER, trackSpecies)      
    if(df.int[day]==ifactor) {
      Runon[,ifactor] = Runon[,ifactor] + df$WaterBalance$Runon
      Runoff[,ifactor] = Runoff[,ifactor] + df$WaterBalance$Runoff
      NetPrec[,ifactor] = NetPrec[,ifactor] + df$WaterBalance$NetPrec
      Infiltration[,ifactor] = Infiltration[,ifactor] + df$WaterBalance$Infiltration
      DeepDrainage[,ifactor] = DeepDrainage[,ifactor] + df$WaterBalance$DeepDrainage
      Esoil[,ifactor] = Esoil[,ifactor] + df$WaterBalance$Esoil
      Eplant[,ifactor] = Eplant[,ifactor] + df$WaterBalance$Eplant
      W1mean[,ifactor] = W1mean[,ifactor] + df$WaterBalance$W1
      W2mean[,ifactor] = W2mean[,ifactor] + df$WaterBalance$W2
      W3mean[,ifactor] = W3mean[,ifactor] + df$WaterBalance$W3
      Transpiration[,ifactor,] = Transpiration[,ifactor,]+df$Transpiration
      DI[,ifactor,] = DI[,ifactor,]+pmax((0.5-df$DDS)/0.5,0.0)
      #Landscape balance
      LandscapeBalance$Rainfall[ifactor]= LandscapeBalance$Rainfall[ifactor] + sum(gridPrecipitation)
      LandscapeBalance$Interception[ifactor]= LandscapeBalance$Interception[ifactor] + (sum(gridPrecipitation)-sum(df$WaterBalance$NetPrec, na.rm=T))
      LandscapeBalance$Runoff[ifactor] = LandscapeBalance$Runoff[ifactor] + df$RunoffExport
      LandscapeBalance$DeepDrainage[ifactor] = LandscapeBalance$DeepDrainage[ifactor] + sum(df$WaterBalance$DeepDrainage, na.rm=T)
      LandscapeBalance$Esoil[ifactor] = LandscapeBalance$Esoil[ifactor] + sum(df$WaterBalance$Esoil, na.rm=T)
      LandscapeBalance$Eplant[ifactor] = LandscapeBalance$Eplant[ifactor] + sum(df$WaterBalance$Eplant, na.rm=T)
    } else {
      W1mean[,ifactor] = W1mean[,ifactor]/nDays
      W2mean[,ifactor] = W2mean[,ifactor]/nDays
      W3mean[,ifactor] = W3mean[,ifactor]/nDays
      DI[,ifactor,] = DI[,ifactor,]/nDays
      ifactor = ifactor+1
    }
    if(control$verbose) cat("\n")
  }
  #Average last summary
  W1mean[,ifactor] = W1mean[,ifactor]/nDays
  W2mean[,ifactor] = W2mean[,ifactor]/nDays
  W3mean[,ifactor] = W3mean[,ifactor]/nDays
  DI[,ifactor,] = DI[,ifactor,]/nDays
  cat("\n------------  swbgrid ------------\n")
    
  l <- list(grid = y@grid, LandscapeBalance = LandscapeBalance, NetPrec = NetPrec, Runon = Runon, Runoff=Runoff, Infiltration=Infiltration, 
                    DeepDrainage = DeepDrainage, Esoil = Esoil, Eplant = Eplant, W1mean = W1mean,
                    W2mean = W2mean, W3mean = W3mean,  DI = DI, Transpiration = Transpiration)
  class(l)<-c("swbgrid","list")
  return(l)
}