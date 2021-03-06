#include <Rcpp.h>

#ifndef FORESTUTILS_H
#define FORESTUTILS_H
#endif
using namespace Rcpp;

DataFrame forest2aboveground(List x, DataFrame SpParams, double gdd = NA_REAL);

NumericVector leafDevelopmentStatus(NumericVector Sgdd, double gdd);
double leafDevelopmentStatus(double Sgdd, double gdd);

NumericVector cohortParameter(List x, DataFrame SpParams, String parName);
CharacterVector cohortCharacterParameter(List x, DataFrame SpParams, String parName);

NumericVector cohortHeight(List x);

NumericVector cohortDensity(List x, DataFrame SpParams);

NumericVector treeBasalArea(NumericVector N, NumericVector dbh);
NumericVector treeCohortBasalArea(List x);
NumericVector cohortBasalArea(List x);
NumericVector dbhClassBasalArea(List x, NumericVector DBHbreaks);
double forestBasalArea(List x);
double forestBasalAreaForMinDBH(List x, double minDBH);

double treeDensity(List x);
double minDBHDensity(List x, double minDBH);
NumericVector dbhClassDensity(List x, NumericVector DBHbreaks);

NumericVector treeCrownRatio(NumericVector N, NumericVector dbh, NumericVector H, 
                             NumericVector Acw, NumericVector Bcw,
                             NumericVector Acr, NumericVector B1cr, NumericVector B2cr, NumericVector B3cr,
                             NumericVector C1cr, NumericVector C2cr);

NumericVector treeFuel(IntegerVector SP, NumericVector N, NumericVector dbh, DataFrame SpParams, double gdd = NA_REAL, bool includeDead = true);
NumericVector shrubFuel(IntegerVector SP, NumericVector Cover, NumericVector H, DataFrame SpParams, double gdd = NA_REAL, bool includeDead = true);
NumericVector cohortFuel(List x, DataFrame SpParams, double gdd = NA_REAL, bool includeDead = true);

NumericVector cohortCrownRatio(List x, DataFrame SpParams);
NumericVector cohortCrownBaseHeight(List x, DataFrame SpParams);
NumericVector cohortCrownLength(List x, DataFrame SpParams);

NumericVector cohortFoliarBiomass(List x, DataFrame SpParams, double gdd = NA_REAL);
NumericVector cohortEquilibriumLeafLitter(List x, DataFrame SpParams, double AET = 800);
NumericVector cohortEquilibriumSmallBranchLitter(List x, DataFrame SpParams, double smallBranchDecompositionRate = 0.81);

NumericVector treeLAI(IntegerVector SP, NumericVector N, NumericVector dbh, DataFrame SpParams, NumericVector pEmb=NumericVector(0), double gdd = NA_REAL);
NumericVector shrubLAI(IntegerVector SP, NumericVector Cover, NumericVector H, DataFrame SpParams, double gdd = NA_REAL);
NumericVector cohortLAI(List x, DataFrame SpParams, double gdd = NA_REAL);
NumericMatrix LAIdistribution(NumericVector z, NumericVector LAI, NumericVector H, NumericVector CR);
NumericMatrix LAIdistribution(NumericVector z, List x, DataFrame SpParams, double gdd = NA_REAL);

double shrubCover(List x, double excludeMinHeight = 0.0);

void deleteTreeCohort(List x, int treeCohort);
void deleteShrubCohort(List x, int shrubCohort);

int minDBHTreeCohort(List x, double excludeMin = 0.0);
