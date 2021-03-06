#include <Rcpp.h>

#ifndef TRANSPIRATION_H
#define TRANSPIRATION_H
#endif
using namespace Rcpp;

List profitMaximization1(List supplyFunction, List photosynthesisFunction, double Gmax);
List profitMaximization2(List supplyFunction, List photosynthesisFunction, double Gmax, double kstemmax);
List profitMaximization3(List supplyFunction, List photosynthesisFunction, double Gmax, double kstemmax);
List profitMaximization(List supplyFunction, List photosynthesisFunction, int type, double Gmax, double kstemmax = NA_REAL);
