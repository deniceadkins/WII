This repository includes the data, R script, and draft paper based on research into WII publications. 

A search of Web of Science (WOS) was made to identify articles authored by WII researchers. Search string is indicated in article. 

ARTICLE:
* 

DATA:
* 1495-together.txt is the data downloaded from WOS and joined together. 
* wii-1495-clean.csv is a CSV file containing downloaded and cleaned data from Web of Science with WII researchers listed as authors. 
* full-data-set.RData should be the R data file of cleaned-up results, and should work in biblioshiny(). 
* oa-clean.csv is a CSV file containing the OA listings extracted from the larger set of data. 
* oa-data-set.Rdata is  the R data file of cleaned-up OA results, and should work in biblioshiny().

R SCRIPT
* 1495-together-bibliometrix.script.R is the script I used to do several analyses and get the files to work in biblioshiny. It can also serve as a log to summarize my learning process. 
* clean-data-analysis.R is the script for running the data analyses on the cleaned data set. 
