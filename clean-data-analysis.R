## Install package and load data for full results
install.packages("bibliometrix")
library(bibliometrix)



## Getting results for full-data-set. 
load("C:/Users/dcadk/R/full-data-set.RData")
results <- biblioAnalysis(M, sep = ";")
S <- summary(object = results, k = 30, pause = FALSE)
##Annual Scientific Production used for Figure 1.
##Most Productive Authors used for Table 2. 
##Most Relevant Sources used for journal scope in section 5.3, paragraph 1.
##Most Relevant Keywords used for Table 4. 
##Word Growth diagram (Figure 2) produced with biblioshiny. 
## biblioshiny() > Load bibliometrix file full-data-set.Rdata > Start.
## Documents > Word Dynamics, Field: Author's keywords, Occurrences: Per Year, Confidence Interval: No




## Getting results for oa-data-set
load("C:/Users/dcadk/R/oa-data-set.Rdata")
results <- biblioAnalysis(M, sep = ";")
S <- summary(object = results, k = 30, pause = FALSE)
##Annual Scientific Production used for  Figure 1.
##Most Productive Authors used for Table 3. 
##Most Relevant Sources used for journal scope in section 5.3, paragraph 2.
##Most Relevant Keywords used for Table 5. 
##Word Growth diagram (Figure 3) produced with biblioshiny. 
## biblioshiny() > Load bibliometrix file full-data-set.Rdata > Start.
## Documents > Word Dynamics, Field: Author's keywords, Occurrences: Per Year, Confidence Interval: No
