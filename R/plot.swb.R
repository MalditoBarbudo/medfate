plot.swb<-function(x, type="PET_Precipitation", yearAxis=FALSE, xlim = NULL, ylim=NULL, xlab=NULL, ylab=NULL, add=FALSE,...) {
  dates = as.Date(rownames(x$DailyBalance))
  transpMode = x$control$transpirationMode
  DailyBalance = x$DailyBalance
  SoilWaterBalance = x$SoilWaterBalance
  nlayers = x$NumSoilLayers
  if(transpMode=="Complex") {
    TYPES = c("PET_Precipitation","PET_NetPrec","ET","Psi","Theta","Vol", "LAI", "PlantLAI",
              "PlantStress", "PlantPsi","PlantPhotosynthesis","PlantTranspiration",
              "PlantPhotosynthesisLeaf","PlantTranspirationLeaf","Export",
              "PlantAbsorbedSWR", "PlantAbsorbedSWRLeaf",
              "PlantAbsorbedLWR", "PlantAbsorbedLWRLeaf",
              "AirTemperature","SoilTemperature", "CanopyTemperature",
              "CanopyEnergyBalance", "SoilEnergyBalance")
  } else {
    TYPES = c("PET_Precipitation","PET_NetPrec","ET","Psi","Theta","Vol", "LAI", "PlantLAI",
              "PlantStress", "PlantPsi","PlantPhotosynthesis","PlantTranspiration",
              "PlantPhotosynthesisLeaf","PlantTranspirationLeaf",
              "Export")
  }
  type = match.arg(type,TYPES)  
  numDays = length(dates)
  numYears = round(numDays/365)
  firstYear=as.numeric(format(dates[1],"%Y"))
  cohortnames = colnames(x$PlantTranspiration)
  plotAxes<-function(){
    if(!yearAxis) axis.Date(1, dates)
    else {
      axis(1, at = (0:numYears)*365, labels=FALSE)
      axis(1, at = -182+365*(1:numYears), tick = FALSE, line=FALSE, labels=firstYear:(firstYear+numYears-1))
    }
    axis(2)    
  }
  mnp = max(DailyBalance$Precipitation)
  if(is.null(xlab)) xlab = ifelse(yearAxis,"Year", "Date")  
  if(type=="PET_Precipitation") {
    if(is.null(ylab)) ylab = "mm water"
    if(!is.null(xlim)) span = xlim[1]:xlim[2]
    else span = 1:numDays
    if(is.null(ylim)) ylim = c(0,mnp)
    barplot(DailyBalance$Precipitation[span], ylim=ylim, col="black",space=0, ylab=ylab, 
            xlab=xlab, axes=FALSE)
    plotAxes()
    lines(1:length(span), DailyBalance$PET[span], col="gray")    
    legend("topleft", bty="n", col=c("black","gray"),lty=c(1,1), lwd=2,
           legend=c("Precipitation","PET"))
    
  } else if(type=="PET_NetPrec") {
    if(is.null(ylab)) ylab = "mm water"    
    if(!is.null(xlim)) span = xlim[1]:xlim[2]
    else span = 1:numDays
    if(is.null(ylim)) ylim = c(0,mnp)
    barplot(DailyBalance$NetPrec[span], ylim=ylim, col="black",space=0, ylab=ylab, 
            xlab=xlab, axes=FALSE)
    plotAxes()
    lines(1:length(span), DailyBalance$PET[span], col="gray")    
    legend("topleft", bty="n", col=c("black","gray"),lty=c(1,1), lwd=2,
           legend=c("NetPrec","PET"))        
  } else if(type=="ET") {
    if(is.null(ylab)) ylab = "mm water"
    if(is.null(ylim)) ylim = c(0,max(DailyBalance$Etot))
    plot(dates, DailyBalance$Etot, ylim=ylim, type="l", ylab=ylab, 
         xlab=xlab, xlim=xlim,frame=FALSE, col="black", axes=FALSE, lwd=2)
    plotAxes()
    lines(dates, DailyBalance$Eplanttot, col="gray", lty=2, lwd=1.5)
    lines(dates, DailyBalance$Esoil, col="black", lty=3, lwd=1.5)
    legend("topleft", bty="n", col=c("black","gray","black"),lty=c(1,2,3), lwd=c(2,1.5,1.5),
           legend=c("Total evapotranspiration","Plant transpiration","Bare soil evaporation"))
  } else if(type=="LAI") {
    if(is.null(ylab)) ylab = "LAI (m2/m2)"
    if(is.null(ylim)) ylim = c(0,max(DailyBalance$LAIcell))
    plot(dates, DailyBalance$LAIcell, ylim=ylim, type="l", ylab=ylab, 
         xlab=xlab, xlim=xlim,frame=FALSE, col="black", axes=FALSE, lwd=1)
    plotAxes()
    lines(dates, DailyBalance$LAIcelldead, lty=2)
  } else if(type=="Psi") {
    PsiM = SoilWaterBalance[,paste("psi",1:nlayers,sep=".")]
    if(is.null(ylab)) ylab = "Soil water potential (MPa)"    
    if(is.null(ylim)) ylim =c(min(PsiM),0)
    matplot(dates, PsiM, lwd=1.5,
         ylim=ylim, type="l", ylab=ylab, xlab=xlab, xlim=xlim,
         frame=FALSE, lty=c(1,2,3,4,5), col="black",axes=FALSE)
    plotAxes()
    legend("bottomleft", bty="n", lty=c(1,2,3,4,5), col="black", lwd=1.5,
           legend=paste("Layer", 1:nlayers))
    
  } else if(type=="Theta") {
    WM = SoilWaterBalance[,paste("W",1:nlayers,sep=".")]
    if(is.null(ylab)) ylab = "% field capacity"
    if(is.null(ylim)) ylim = c(0,100)
    matplot(dates, WM*100, lwd=1.5,
            ylim=ylim, type="l", ylab=ylab, xlab=xlab, xlim=xlim,
            frame=FALSE, lty=c(1,2,3,4,5), col="black",axes=FALSE)
    plotAxes()
    legend("bottomleft", bty="n", col="black",lty=1:nlayers, lwd=1.5,
           legend=paste("Layer", 1:nlayers))
  } else if(type=="Vol") {
    MLM= SoilWaterBalance[,paste("ML",1:nlayers,sep=".")]
    MLTot = SoilWaterBalance$MLTot
    if(is.null(ylim)) ylim =c(0,max(MLTot)*1.3)
    if(is.null(ylab)) ylab = "mm soil water"
    plot(dates, MLTot, ylim=ylim, lwd=2, type="l",xlim=xlim,
         ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()
    matlines(dates, MLM, lty = 1:nlayers, col="black", lwd=1.5)
    legend("topleft", bty="n", col="black",lty=c(1,1:nlayers), lwd=c(2,rep(1.5,5)),
           legend=c("Total",paste("Layer", 1:nlayers)))
    
  } else if(type=="PlantLAI") {
    if(is.null(ylab)) ylab = "Leaf Area Index (m2/m2)"
    if(is.null(ylim)) ylim = c(0,max(x$PlantLAI))
    matplot(dates, x$PlantLAI, ylim = ylim, lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantStress") {
    if(is.null(ylab)) ylab = "Drought stress [0-1]"
    if(is.null(ylim)) ylim = c(0,1)
    matplot(dates, x$PlantStress, lty=1:length(cohortnames), col = 1:length(cohortnames),
            ylim = ylim, lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantPsi") {
    if(is.null(ylab)) ylab = "Plant water potential (MPa)"
    if(is.null(ylim)) ylim = c(min(x$PlantPsi),0)
    matplot(dates, x$PlantPsi, ylim = ylim, lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()
    legend("bottomright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantTranspiration") {
    if(is.null(ylab)) ylab = "Plant transpiration (mm)"
    if(is.null(ylim)) ylim = c(0,max(x$PlantTranspiration))
    matplot(dates, x$PlantTranspiration, ylim = ylim,
            lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()      
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantTranspirationLeaf") {
    pt = x$PlantTranspiration/x$PlantLAI
    pt[x$PlantLAI==0] = NA
    if(is.null(ylab)) ylab = "Plant transpiration per leaf area (mm)"
    if(is.null(ylim)) ylim = c(0,max(pt, na.rm=T))
    matplot(dates, pt, ylim = ylim, 
            lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()      
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantPhotosynthesis") {
    if(is.null(ylab)) ylab = "Plant photosynthesis (gC/m2)"
    if(is.null(ylim)) ylim = c(min(x$PlantPhotosynthesis),max(x$PlantPhotosynthesis))
    matplot(dates, x$PlantPhotosynthesis, ylim = ylim, 
            lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()     
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantPhotosynthesisLeaf") {
    pf = x$PlantPhotosynthesis/x$PlantLAI
    pf[x$PlantLAI==0] = NA
    if(is.null(ylab)) ylab = "Plant photosynthesis per leaf area (gC/m2)"
    if(is.null(ylim)) ylim = c(min(pf, na.rm=T),max(pf, na.rm=T))
    matplot(dates, pf, ylim = ylim, 
            lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()     
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantAbsorbedSWR") {
    if(is.null(ylab)) ylab = "Plant absorbed SWR (MJ/m2)"
    if(is.null(ylim)) ylim = c(0,max(x$PlantAbsorbedSWR))
    matplot(dates, x$PlantAbsorbedSWR, 
            lty=1:length(cohortnames), col = 1:length(cohortnames), 
            ylim = ylim, lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()     
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantAbsorbedSWRLeaf") {
    pf = x$PlantAbsorbedSWR/x$PlantLAI
    pf[x$PlantLAI==0] = NA
    if(is.null(ylab)) ylab = "Plant absorbed SWR per leaf area (MJ/m2)"
    if(is.null(ylim)) ylim = c(min(pf, na.rm=T),max(pf, na.rm=T))
    matplot(dates, pf, ylim = ylim, lwd=1, type="l", 
            lty=1:length(cohortnames), col = 1:length(cohortnames),xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()     
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantAbsorbedLWR") {
    if(is.null(ylab)) ylab = "Plant absorbed LWR (MJ/m2)"
    if(is.null(ylim)) ylim = c(0,max(x$PlantAbsorbedLWR))
    matplot(dates, x$PlantAbsorbedLWR, ylim = ylim, 
            lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()     
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="PlantAbsorbedLWRLeaf") {
    pf = x$PlantAbsorbedLWR/x$PlantLAI
    pf[x$PlantLAI==0] = NA
    if(is.null(ylab)) ylab = "Plant absorbed LWR per leaf area (MJ/m2)"
    if(is.null(ylim)) ylim = c(min(pf, na.rm=T),max(pf, na.rm=T))
    matplot(dates, pf, ylim = ylim, 
            lty=1:length(cohortnames), col = 1:length(cohortnames),
            lwd=1, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE)
    plotAxes()     
    legend("topright", legend = cohortnames, lty=1:length(cohortnames), 
           col = 1:length(cohortnames), bty="n")
  } else if(type=="AirTemperature") {
    if(is.null(ylab)) ylab = "Above-canopy temperature (Celsius)"
    if(is.null(ylim)) ylim = c(min(x$Temperature$Tatm_min),max(x$Temperature$Tatm_max))
    if(!add) {
      plot(dates, x$Temperature$Tatm_mean, ylim = ylim, type="l", xlim=xlim,
         ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE, ...)
      plotAxes()   
    } else {
      lines(dates, x$Temperature$Tatm_min, col="black", ...)
    }
    lines(dates, x$Temperature$Tatm_min, col="blue", ...)
    lines(dates, x$Temperature$Tatm_max, col="red", ...)
  } else if(type=="CanopyTemperature") {
    if(is.null(ylab)) ylab = "Canopy temperature (Celsius)"
    if(is.null(ylim)) ylim = c(min(x$Temperature$Tcan_min),max(x$Temperature$Tcan_max))
    if(!add) {
      plot(dates, x$Temperature$Tcan_mean, ylim = ylim, type="l", xlim=xlim,
         ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE, ...)
      plotAxes()   
    } else {
      lines(dates, x$Temperature$Tcan_mean, col="black", ...)
    }
    lines(dates, x$Temperature$Tcan_min, col="blue", ...)
    lines(dates, x$Temperature$Tcan_max, col="red", ...)
  } else if(type=="SoilTemperature") {
    if(is.null(ylab)) ylab = "Soil temperature (Celsius)"
    if(is.null(ylim)) ylim = c(min(x$Temperature$Tsoil_min),max(x$Temperature$Tsoil_max))
    if(!add) {
      plot(dates, x$Temperature$Tsoil_mean, ylim = ylim, type="l", xlim=xlim,
            ylab=ylab, xlab=xlab, frame=FALSE, axes=FALSE, ...)
      plotAxes()   
    } else {
      lines(dates, x$Temperature$Tsoil_mean, col="black", ...)
    }
    lines(dates, x$Temperature$Tsoil_min, col="blue", ...)
    lines(dates, x$Temperature$Tsoil_max, col="red", ...)
  } else if(type=="Export") {
    if(is.null(ylab)) ylab = "mm water"    
    mnp = max(DailyBalance$DeepDrainage+DailyBalance$Runoff)    
    if(is.null(ylim)) ylim = c(0,mnp)
    plot(dates, DailyBalance$DeepDrainage+DailyBalance$Runoff, ylim=ylim, col="black", type="l", 
         ylab=ylab, xlab=xlab, xlim=xlim,
         frame=FALSE, axes=FALSE)
    lines(dates, DailyBalance$DeepDrainage, col="blue")
    lines(dates, DailyBalance$Runoff, col="red")
    plotAxes()
    legend("topright", bty="n", col=c("black","blue","red"),lty=c(1,1,1), lwd=c(1.5,1,1),
           legend=c("DD+R","Deep drainage (DD)","Runoff (R)"))        
  } else if(type=="CanopyEnergyBalance") {
    if(is.null(ylab)) ylab = "MJ/m2"    
    mxin = max(c(x$EnergyBalance$SWRcanin,x$EnergyBalance$LWRcanin,x$EnergyBalance$LWRsoilcan,-x$EnergyBalance$LEcan,-x$EnergyBalance$Hcan))    
    mxout = max(c(x$EnergyBalance$LWRcanout,x$EnergyBalance$LEcan,x$EnergyBalance$Hcan))    
    if(is.null(ylim)) ylim = c(-mxout,mxin)
    plot(dates, x$EnergyBalance$Ebalcan, ylim=ylim, type="n", 
         ylab=ylab, xlab=xlab, xlim=xlim,
         frame=FALSE, axes=FALSE,...)
    plotAxes()
    abline(h=0, col="black", lwd=1.5)
    lines(dates, x$EnergyBalance$Ebalcan, col="black",...)
    lines(dates, x$EnergyBalance$SWRcanin, col="red",...)
    lines(dates, x$EnergyBalance$LWRcanin, col="brown",...)
    lines(dates, -x$EnergyBalance$LWRcanout, col="blue",...)
    lines(dates, x$EnergyBalance$LWRsoilcan, col="orange",...)
    lines(dates, -x$EnergyBalance$LEcan, col="green",...)
    lines(dates, -x$EnergyBalance$Hcan, col="gray",...)
    lines(dates, -x$EnergyBalance$Hcansoil, col="dark gray",...)
    legend("topright", bty="n", col=c("red","brown","orange", "blue","green", "gray", "dark gray", "black"), lty=1,
           legend=c("SWR abs. from atm.","LWR abs. from atm.","LWR abs. from soil","LWR emmited", "Latent heat (L)",
                    "Convection can./atm.","Convection soil/can.", "Balance"),...)        
  } else if(type=="SoilEnergyBalance") {
    if(is.null(ylab)) ylab = "MJ/m2"    
    mxin = max(c(x$EnergyBalance$SWRsoilin, x$EnergyBalance$LWRsoilin,x$EnergyBalance$LWRcanout,x$EnergyBalance$Hcansoil))    
    mxout = max(c(x$EnergyBalance$LWRsoilout,-x$EnergyBalance$Hcansoil))    
    if(is.null(ylim)) ylim = c(-mxout,mxin)
    plot(dates, x$EnergyBalance$Ebalsoil, ylim=ylim, type="n", 
         ylab=ylab, xlab=xlab, xlim=xlim,
         frame=FALSE, axes=FALSE,...)
    plotAxes()
    abline(h=0, col="black", lwd=1.5)
    lines(dates, x$EnergyBalance$Ebalsoil, col="black",...)
    lines(dates, x$EnergyBalance$SWRsoilin, col="red",...)
    lines(dates, x$EnergyBalance$LWRsoilin, col="brown",...)
    lines(dates, x$EnergyBalance$LWRcanout, col="orange",...)
    lines(dates, -x$EnergyBalance$LWRsoilout, col="blue",...)
    lines(dates, x$EnergyBalance$Hcansoil, col="gray",...)
    legend("topright", bty="n", col=c("red","brown","orange", "blue", "gray", "black"), lty=1,
           legend=c("SWR abs. from atm.","LWR abs. from atm.", "LWR abs. from canopy","LWR emmited", "Convection soil/can.", "Balance"),...)        
  }
}
