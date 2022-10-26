# Project Title

Deep learning of extreme rainfall events from convective atmospheres

## Summary

Abstract. Our subject is a new Catalogue of radar-based heavy Rainfall Events (CatRaRE) over
Germany, and how it relates to the concurrent atmospheric circulation. We classify daily
atmospheric ERA5 fields of convective indices according to CatRaRE, using an array of
conventional statistical and more recent machine learning (ML) algorithms, and apply them
to corresponding fields of simulated present and future atmospheres from the CORDEX
project. Due to the stochastic nature of ML optimization there is some spread in the
results. The ALL-CNN network performs best on average, with several learning runs
exceeding an Equitable Threat Score (ETS) of 0.52; the single best result was from ResNet
with ETS = 0.54. The best performing classical scheme was a Random Forest with ETS = 0.51.
Regardless of the method, increasing trends are predicted for the probability of
CatRaRE-type events, from ERA5 as well as from the CORDEX fields.

## Octave call

The main program call is

octave carlofff.m

In carlofff.m, the main variables and their defaults are:

GLON = [5.75 15.25] ; GLAT = [47.25 55.25] ; GREG = "DE" ; # predictor region  
LON = GLON ; LAT = GLAT ; REG = "DE" ; # predictand region (whole Germany)  
ID = [2001 5 1 0 ; 2020 8 31 23] ;  
MON = 5 : 8 ;  
IND = "01010000010" ; # default atm. indices (cape, tcw, cp)  
CNVDUR = 9 ; # maximum duration

It is expected that Caffe is installed under /opt/caffe.
