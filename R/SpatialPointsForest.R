SpatialPointsForest<-function(SFItreeData, SFIshrubData, SFIherbData=NULL, SpatialPointsIDs, 
                              elevation, slope, aspect,
                              SpParams, SoilParamData = NULL, 
                              SFIcodes=NULL, 
                              control = defaultControl()) {  
  IDs = rownames(SpatialPointsIDs@coords)
  if(is.null(IDs)) stop("SpatialPoints must have forest plot IDs in coordinate row names.")
  if(!is.null(SoilParamData)) if(length(IDs)!=nrow(SoilParamData)) stop("The number of spatial points has to be the same as the number of rows in SoilParamsData")
  
  x = SFItreeData[SFItreeData$ID %in% IDs, ]
  y = SFIshrubData[SFIshrubData$ID %in% IDs, ]
  if(!is.null(SFIcodes)) {
    x$Species = translateSpeciesCodes(x, SFIcodes)
    y$Species = translateSpeciesCodes(y, SFIcodes)
  } 

  if(control$verbose) cat("Extracting SFI data")  
  lx = split(x, factor(x$ID, levels=IDs))
  ly = split(y, factor(y$ID, levels=IDs))
  forestlist = Map(function(x,y, id) {
    extractSFIforest(x,y, id, SFIherbData = SFIherbData, SpParams=SpParams,setDefaults = TRUE)
  }, lx, ly, IDs)  

  if(control$verbose) cat(" - Initializing soils")
  soillist = vector("list",length(IDs))
  for(i in 1:length(IDs)) {
    if(!is.null(SoilParamData)) {
      spl = as.list(SoilParamData[i,])
      soilParams = list()
      soilParams$widths = c(300,spl$SoilDepth-300)
      soilParams$clay = c(spl$TS_clay, spl$SS_clay)
      soilParams$sand = c(spl$TS_sand, spl$SS_sand)
      soilParams$macro = c(spl$TS_macro, spl$SS_macro)
      soilParams$rfc = c(spl$TS_rfc, spl$SS_rfc)
      soilParams$Gsoil = spl$Gsoil
      soilParams$Ksoil = spl$Ksoil
      if(sum(is.na(soilParams))>0) soilParams = defaultSoilParams()
    } else {
      soilParams = defaultSoilParams()
    }
    soillist[[i]] = soil(soilParams)
  }
  if(control$verbose) cat(" - done.\n")
  
  sfp = new("SpatialPointsForest", 
          forestlist = forestlist, 
          soillist = soillist,
          data = data.frame(elevation = elevation, slope = slope, aspect = aspect),
          coords = SpatialPointsIDs@coords, 
          bbox = SpatialPointsIDs@bbox, 
          proj4string = SpatialPointsIDs@proj4string)
  return(sfp)
}