\encoding{UTF-8}
\name{SpatialGridForest-class}
\Rdversion{1.1}
\docType{class}
\alias{SpatialGridForest-class}

\title{Class \code{"SpatialGridForest"}}
\description{
An S4 class that represents a set of forest stands located over a grid of coordinates.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("SpatialGridForest", ...)}, or by calls to the function \code{\link{SpatialGridForest}}.
}
\section{Slots}{
  \describe{
    \item{\code{lct}:}{A character vector of land cover type for each cell. Values allowed are: 'wildland', 'agriculture', 'rock' and 'static'.  }
    \item{\code{forestlist}:}{Object of class \code{"list"} containing a set of \code{\link{forest}} objects.  }
    \item{\code{soillist}:}{Object of class \code{"list"} containing a set of \code{\link{soil}} objects.}
    \item{\code{data}:}{Object of class "data.frame" containing the elevation (in m), slope (in degrees) and aspect (in degrees from North) of every cell.}
    \item{\code{grid}:}{Object of class \code{"GridTopology"}. }
    \item{\code{bbox}:}{Object of class \code{"matrix"} with the boundary box. }
    \item{\code{proj4string}:}{Object of class \code{"CRS"} with the projection string.}   
    }
}
\section{Extends}{
Class \code{"\linkS4class{SpatialGridTopography}"}, directly.
Class \code{"\linkS4class{SpatialGridDataFrame}"}, distance 2.
Class \code{"\linkS4class{SpatialGrid}"}, distance 3.
Class \code{"\linkS4class{Spatial}"}, by class "SpatialGrid", distance 4.
}
\section{Methods}{
  \describe{
    \item{getLCTs}{\code{signature(object = "SpatialGridForest")}: returns a SpatialGridDataFrame with the land cover types of the landscape cells.}
    \item{spatialForestSummary}{\code{signature(object = "SpatialGridForest")}: calculates a summary function for all forest stands and returns an object of class \code{\link{SpatialGridDataFrame-class}}. }
    \item{spatialSoilSummary}{\code{signature(object = "SpatialGridForest")}: calculates a summary function for the soil of all stands and returns an object of class \code{\link{SpatialGridDataFrame-class}}. }
    \item{spplot}{\code{signature(object = "SpatialGridForest")}: allows plotting maps of the landscape state.}
	 }
}

\author{
Miquel De \enc{Cáceres}{Caceres} Ainsa, Centre Tecnologic Forestal de Catalunya
}

\seealso{
\code{\link{SpatialGridTopography-class}}, \code{\link{SpatialPointsForest-class}}, \code{\link{spatialForestSummary}}, \code{\link{forest}}, \code{\link{soil}}
}
\examples{
#Structure of the S4 object
showClass("SpatialGridForest")
}
\keyword{classes}
