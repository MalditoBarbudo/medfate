plot.swb.day<-function(x, type="PlantPsi", xlab = NULL, ylab = NULL, ...) {
  DailyBalance = x$DailyBalance
  SoilWaterBalance = x$SoilWaterBalance
  if(!("EnergyBalance" %in% names(x))) stop("Plotting function available for transpirationMode = 'Complex' only.")
  EB = x$EnergyBalance
  Plants = x$Plants
  TYPES = c("PlantPsi","PlantTranspiration","PlantPhotosynthesis","PlantAbsorbedSWR",
            "LeafTranspiration","LeafPhotosynthesis", "LeafAbsorbedSWR",
            "LeafVPD","LeafStomatalConductance", "LeafTemperature",
            "Temperature","CanopyEnergyBalance", "SoilEnergyBalance")
  type = match.arg(type,TYPES)  
  cohortnames = names(Plants$EplantCoh)
  timesteps = as.numeric(colnames(x$Plants$PsiPlantinst))
  if(is.null(xlab)) xlab = "Time step"
  if(type=="PlantPsi") {
    if(is.null(ylab)) ylab = "Plant water potential (MPa)"
    matplot(timesteps, t(Plants$PsiPlantinst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab=ylab, xlab=xlab, frame=FALSE, ...)
    legend("bottomright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  }
  else if(type=="PlantTranspiration") {
    if(is.null(ylab)) ylab = "Plant transpiration"
    matplot(timesteps, t(Plants$Einst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab=ylab, xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  }
  else if(type=="LeafTranspiration") {
    if(is.null(ylab)) ylab = "Transpiration per leaf area"
    matplot(timesteps, t(sweep(Plants$Einst,1,Plants$LAI,"/")), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab=ylab, xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  }
  else if(type=="PlantPhotosynthesis") {
    if(is.null(ylab)) ylab = "Net photosynthesis"
    matplot(timesteps, t(Plants$Aninst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab=ylab, xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  }
  else if(type=="LeafPhotosynthesis") {
    if(is.null(ylab)) ylab = "Net photosynthesis per leaf area"
    matplot(timesteps, t(sweep(Plants$Aninst,1,Plants$LAI,"/")), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab=ylab, xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  }
  else if(type=="PlantAbsorbedSWR") {
    old = par(mfrow=c(1,2), mar=c(5,5,3,1))
    
    matplot(timesteps, t(Plants$AbsRadinst$SWR_SL), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Absorbed SWR sunlit (W·m-2)", xlab=xlab, frame=FALSE, ...)
    matplot(timesteps, t(Plants$AbsRadinst$SWR_SH), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Absorbed SWR shade (W·m-2)", xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
    par(old)
  }
  else if(type=="LeafAbsorbedSWR") {
    old = par(mfrow=c(1,2), mar=c(5,5,3,1))
    
    matplot(timesteps, t(Plants$AbsRadinst$SWR_SL/Plants$LAIsunlit), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Absorbed SWR sunlit per leaf (W·m-2)", xlab=xlab, frame=FALSE, ...)
    matplot(timesteps, t(Plants$AbsRadinst$SWR_SH/Plants$LAIshade), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Absorbed SWR shade per leaf (W·m-2)", xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
    par(old)
  }
  else if(type=="LeafTemperature") {
    old = par(mfrow=c(1,2), mar=c(5,5,3,1))
    
    matplot(timesteps, t(Plants$Tempsunlitinst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Leaf temperature sunlit (ºC)", xlab=xlab, frame=FALSE, ...)
    matplot(timesteps, t(Plants$Tempshadeinst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Leaf temperature shade (ºC)", xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
    par(old)
  }
  else if(type=="LeafVPD") {
    old = par(mfrow=c(1,2), mar=c(5,5,3,1))
    
    matplot(timesteps, t(Plants$VPDsunlitinst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Vapour pressure deficit sunlit (kPa)", xlab=xlab, frame=FALSE, ...)
    matplot(timesteps, t(Plants$VPDshadeinst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Vapour pressure deficit shade (kPa)", xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
    par(old)
  }
  else if(type=="LeafStomatalConductance") {
    old = par(mfrow=c(1,2), mar=c(5,5,3,1))
    
    matplot(timesteps, t(Plants$GWsunlitinst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Stomatal conductance sunlit (mmol·m-2·s-1)", xlab=xlab, frame=FALSE, ...)
    matplot(timesteps, t(Plants$GWshadeinst), lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", ylab="Stomatal conductance shade (mmol·m-2·s-1)", xlab=xlab, frame=FALSE, ...)
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
    par(old)
  }
  else if(type=="Temperature") {
    
    if(is.null(ylab)) ylab = "Temperature (ºC)"
    plot(timesteps, EB$Temperature$Tatm, 
         ylim = c(min(c(EB$Temperature$Tatm,EB$Temperature$Tcan,EB$Temperature$Tsoil.1)),
                  max(c(EB$Temperature$Tatm,EB$Temperature$Tcan,EB$Temperature$Tsoil.1))),
         lty=1, col = "black",
          type="l", ylab=ylab, xlab=xlab, frame=FALSE, ...)
    lines(timesteps, EB$Temperature$Tcan, col="red", lty=2)
    lines(timesteps, EB$Temperature$Tsoil.1, col="gray", lty=3)
    
    legend("topleft", legend = c("Above-canopy", "Inside canopy",
                                  "Soil"), 
           lty=1:3, 
           col = c("black", "red", "gray"), bty="n")
  } 
  else if(type=="CanopyEnergyBalance") {
    if(is.null(ylab)) ylab = "W·m-2"    
    mxmn = max(abs(EB$CanopyEnergyBalance))    
    plot(timesteps, EB$CanopyEnergyBalance$Ebalcan, type="n", 
         ylab=ylab, xlab=xlab, ylim = c(-mxmn,mxmn),
         frame=FALSE,...)
    abline(h=0, col="black", lwd=1.5)
    lines(timesteps, EB$CanopyEnergyBalance$Ebalcan, col="black",...)
    lines(timesteps, EB$CanopyEnergyBalance$SWRcanin, col="red",...)
    lines(timesteps, EB$CanopyEnergyBalance$LWRcanin, col="brown",...)
    lines(timesteps, -EB$CanopyEnergyBalance$LWRcanout, col="blue",...)
    lines(timesteps, EB$CanopyEnergyBalance$LWRsoilcan, col="orange",...)
    lines(timesteps, -EB$CanopyEnergyBalance$LEcan, col="green",...)
    lines(timesteps, -EB$CanopyEnergyBalance$Hcan, col="gray",...)
    lines(timesteps, -EB$SoilEnergyBalance$Hcansoil, col="dark gray",...)
    legend("topright", bty="n", col=c("red","brown","orange", "blue","green", "gray", "dark gray", "black"), lty=1,
           legend=c("SWR abs. from atm.","LWR abs. from atm.","LWR abs. from soil","LWR emmited", "Latent heat (L)",
                    "Convection can./atm.","Convection soil/can.", "Balance"),...)        
  }
  else if(type=="SoilEnergyBalance") {
    if(is.null(ylab)) ylab = "W·m-2"    
    mxmn = max(abs(EB$SoilEnergyBalance))    
    plot(timesteps, EB$SoilEnergyBalance$Ebalsoil, type="n", 
         ylab=ylab, xlab=xlab, ylim = c(-mxmn,mxmn),
         frame=FALSE,...)
    abline(h=0, col="black", lwd=1.5)
    lines(timesteps, EB$SoilEnergyBalance$Ebalsoil, col="black",...)
    lines(timesteps, EB$SoilEnergyBalance$SWRsoilin, col="red",...)
    lines(timesteps, EB$SoilEnergyBalance$LWRsoilin, col="brown",...)
    lines(timesteps, EB$CanopyEnergyBalance$LWRcanout, col="orange",...)
    lines(timesteps, -EB$SoilEnergyBalance$LWRsoilout, col="blue",...)
    lines(timesteps, EB$SoilEnergyBalance$Hcansoil, col="gray",...)
    legend("topright", bty="n", col=c("red","brown","orange", "blue", "gray", "black"), lty=1,
           legend=c("SWR abs. from atm.","LWR abs. from atm.", "LWR abs. from canopy","LWR emmited", "Convection soil/can.", "Balance"),...)        
  }
}
