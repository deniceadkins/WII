Sys.setenv(PATH = paste("C:/Rtools/bin", Sys.getenv("PATH"), sep=";"))
Sys.setenv(BINPREF = "C:/Rtools/mingw_$(WIN)/bin/")
##Sys.setenv to tell RStudio to use Rtools

install.packages("bibliometrix", dependencies = TRUE)
##Install bibliometrix so it will use Rtools

##
##
##
##PHASE 1 - GETTING DATA FROM WOS AND TESTING BIBLIOMETRIX

library(bibliometrix)

##Downloaded 1495 records from WOS by database, merged them in one file

file <- "~\\Downloads\\1495-together.txt"
M <- convert2df("~//Downloads//1495-together.txt")
##Created data frame from records

results <- biblioAnalysis(M, sep = ";")
results
#Analyzes and shows descriptive summary of data set

S <- summary(object = results, k = 10, pause = FALSE)
##Creates a summary of top 10 results

plot(x = results, k = 10, pause = FALSE)
##Creates plots for results



##
##
##
##PHASE 2 - DATA CLEANING 
##Used OpenRefine to clean data and save as xlsx file. Cannot import xlsx file into bibliometrix. 

##Painful workaround #1: Copy entries from author column of xlsx file to author column of data frame in R. 
##See info on editData package here: https://cran.r-project.org/web/packages/editData/README.html

require(editData)
result <- editData(M)
##Creates file called result that is the result of editing M. 
##In editData, make the change to the column and then scroll down to hit "update" for Every. Single. Record.

View(result)
##Will show new result data frame with edited cells. 

M <- editData(result)
##Do this as last option for clean-up to get back to the data frame labeled M and run bibliometrix tests. 

##Less painful workaround #2: Use R editor to copy from xlsx spreadsheet without having to save every time
result3 <-edit(result2)
##Then cut and paste a lot. When ready, exit out of the text editor.
View(result3)
##Repeat process until last step, when M <- edit(result)
result <- edit(M)
result2 <- edit (result)
result3 <- edit (result2)
result4 <- edit (result3)
result5 <- edit (result4)
result6 <- edit (result5)
result7 <- edit (result6)
result8 <- edit (result7)
result9 <- edit (result8)
result10 <- edit (result9)
result11 <- edit (result10)
result12 <- edit (result11)
result13 <- edit (result12)
result14 <- edit (result13)
M <- edit (result14)
##Batch edited results 100 at a time, ending with data frame named M. 


##
##
##
##PHASE 3 - RUNNING BIBLIOMETRIX PROCESSES ON CLEANED DATA

library(bibliometrix)

results <- biblioAnalysis(M, sep = ";")
results
#Analyzes and shows descriptive summary of data set

S <- summary(object = results, k = 10, pause = FALSE)
##Creates a summary of top 10 results

plot(x = results, k = 10, pause = FALSE)
##Creates plots for results

CR <- citations(M, field = "article", sep = ";")
cbind(CR$Cited[1:10])
##Lists the most cited manuscripts

CR <- citations(M, field = "author", sep = ";")
cbind(CR$Cited[1:10])
##Lists the most cited first authors

CR <- localCitations(M, sep = ";")
CR$Authors[1:10,]
CR$Papers[1:10,]
##Lists the most frequently cited local authors and papers

DF <- dominance(results, k = 10)
DF
##Analyzes authors' dominance ranking per Kumar & Kumar (2008)

indices <- Hindex(M, field = "author", elements="SANKAR K", sep = ";", years = 10)
indices$H
##Calculates h-index of SANKAR K or other author put therein
indices$CitationList
##Calculates citations for SANKAR K 

authors=gsub(","," ",names(results$Authors)[1:10])
indices <- Hindex(M, field = "author", elements=authors, sep = ";", years = 50)
indices$H
##Calculates h-indexes for top ten productive authors

topAU <- authorProdOverTime(M, k = 10, graph = TRUE)
##Shows productivity over time for top ten productive authors

head(topAU$dfAU)
##Calculates productivity by year for authors

L <- lotka(results)
##Estimates Lotka's law coefficients
L$AuthorProd
##Empirical distribution of author productivity
L$Beta
#Beta coefficient estimate
L$C
L$R2
L$p.value
##Constant, goodness of fit, and p-value for Lotka coefficient
Observed=L$AuthorProd[,3]
Theoretical=10^(log10(L$C)-2*log10(L$AuthorProd[,1]))
eta = 2
Theoretical=10^(log10(L$C)-2*log10(L$AuthorProd[,1]))
plot(L$AuthorProd[,1],Theoretical,type="l",col="red",ylim=c(0, 1), xlab="Articles",ylab="Freq. of Authors",main="Scientific Productivity")
lines(L$AuthorProd[,1],Observed,col="blue")
legend(x="topright",c("Theoretical (B=2)","Observed"),col=c("red","blue"),lty = c(1,1,1),cex=0.6,bty="n")
##Produces table comparing observed and theoretical Lotka distributions

A <- cocMatrix(M, Field = "SO", sep = ";")
sort(Matrix::colSums(A), decreasing = TRUE)[1:5]
##Creates bibliographic network matrix for Source

A <- cocMatrix(M, Field = "CR", sep = ".  ")
sort(Matrix::colSums(A), decreasing = TRUE)[1:5]
##Creates bibliographic network matrix for Cited Reference
##Check to see if that's the right punctuation for that field.

A <- cocMatrix(M, Field = "AU", sep = ";")
sort(Matrix::colSums(A), decreasing = TRUE)[1:5]
##Creates bibliographic network matrix for Author

M <- metaTagExtraction(M, Field = "AU_CO", sep = ";")
A <- cocMatrix(M, Field = "AU_CO", sep = ";")
sort(Matrix::colSums(A), decreasing = TRUE)[1:5]
##Extracts author country from affiliation attribute and creates author country network

A <- cocMatrix(M, Field = "DE", sep = ";")
sort(Matrix::colSums(A), decreasing = TRUE)[1:5]
##Creates author keyword matrix

A <- cocMatrix(M, Field = "ID", sep = ";")
sort(Matrix::colSums(A), decreasing = TRUE)[1:5]
##Creates keyword-plus matrix

NetMatrix <- biblioNetwork(M, analysis = "coupling", network = "references", sep = ".  ")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 100, Title = "Authors' Coupling", type = "fruchterman", size=5,size.cex=T,remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
##Shows bibliographic coupling by author

NetMatrix <- biblioNetwork(M, analysis = "co-citation", network = "references", sep = ".  ")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 100, Title = "Bibliographic Co-Citation", type = "fruchterman", size=5,size.cex=T,remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
##Shows bibliographic co-citation networks

NetMatrix <- biblioNetwork(M, analysis = "collaboration", network = "authors", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 100, Title = "Author Collaboration", type = "fruchterman", size=5,size.cex=T,remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
##Shows bibliogrphic collaboration and co-authorships

NetMatrix <- biblioNetwork(M, analysis = "collaboration", network = "countries", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 100, Title = "Country Collaboration", type = "fruchterman", size=5,size.cex=T,remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
##Shows collaboration by country


NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "keywords", sep = ";")
netstat <- networkStat(NetMatrix)
##Creates summary statistics for the network (size, density, distribution, etc.)
names(netstat$network)
names(netstat$vertex)
summary(netstat, k=10)
##Shows summary of statistics for the top 10 vertices (k)


NetMatrix <- biblioNetwork(M, analysis = "co-citation", network = "references", sep = ";")
net=networkPlot(NetMatrix, n = 30, Title = "Co-Citation Network", type = "fruchterman", size=T, remove.multiple=FALSE, labelsize=0.7,edgesize = 5)
##Creates and plots a co-citation network

NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "keywords", sep = ";")
net=networkPlot(NetMatrix, normalize="association", weighted=T, n = 30, Title = "Keyword Co-occurrences", type = "fruchterman", size=T,edgesize = 5,labelsize=0.7)
##Creates and plots keyword co-occurences

CS <- conceptualStructure(M,field="ID", method="CA", minDegree=4, clust=5, stemming=FALSE, labelsize=10, documents=10)
##Creates and plots conceptual structure map based on co-word analysis

options(width=130)
histResults <- histNetwork(M, min.citations = 1, sep = ";")
net <- histPlot(histResults, n=15, size = 10, labelsize=5)
##Creates and plots a historical citation network

##
##
##
##PHASE 4 - WHAT I ACTUALLY USED FOR THE ARTICLE

library(bibliometrix)
results <- biblioAnalysis(M, sep = ";")
results

S <- summary(object = results, k = 35, pause = FALSE)
##To get names of the top-producing WII authors

plot(x = results, k = 10, pause = FALSE)
##To get plot of annual scienctific production

View(results[["Authors"]])
##To look at table of author results and filter by publications

View(results[["Sources"]])
##To look at the table of publication sources 

View(results[["DE"]])
View(results[["ID"]])
##To look at table of most frequently used Author Keywords and Keywords-Plus

##Problem - country collaboration uses only corresponding author country. 
##Can this be solved with OpenRefine? Or can this line of inquiry be abandoned? 

library(dplyr)
openaccess <- M %>% 
  filter(!is.na(OA))
View(openaccess)
##Filters data set to look at just the ones that are open access
##Except for 10 arbitrary blank OA fields that need manual deleting.

##Method 1: Save to CSV file and edit CSV file. 
save(openaccess, file = "openaccess.Rdata")
load("~/WII-1495-data/openaccess.Rdata")
##Saved openaccess results as a separate data frame, loaded it into RStudio environment

write.csv(openaccess, "openaccess-data.csv")
##To get an Excel-compatible version of the file to check for errors
##Then cleaned errors using editData. 

##Lots of data cleaning between then and now. 
##Saved clean data set as CSV. 
##Then used "Import Dataset" > from text (readr) to import clean data set. 
## https://support.rstudio.com/hc/en-us/articles/218611977-Importing-Data-with-RStudio
library(readr)
openaccess_data_clean <- read_csv("openaccess-data-clean.csv")
View(openaccess_data_clean)

##Method 2: Used negative indexing to remove blank OA rows left by dplyr. 
## https://stackoverflow.com/questions/7541610/how-to-delete-the-first-row-of-a-dataframe-in-r
oa_clean <- openaccess[-294, ]
oa_clean2 <- oa_clean[-293, ]
oa_clean <- oa_clean2[-292, ]
oa_clean2 <- oa_clean[-291, ]
oa_clean <- oa_clean2[-284, ]
oa_clean2 <- oa_clean[-251, ]
oa_clean <- oa_clean2[-250, ]
oa_clean2 <- oa_clean[-243, ]
oa_clean <- oa_clean2[-53, ]
View(oa_clean)
write.csv(oa_clean, "~/WII-1495-data/oa-clean.csv", row.names = FALSE)



##Now need to save file to something that will open in biblioshiny and can be used in bibliometrix
save(oa_clean, file = "~/WII-1495-data/oa_clean3.Rdata")
##when opened in biblioshiny(), brings down 1495 records, not 301. 
##Alternately, when opened in biblioshiny(), "Error: object'M' not found"

##Solution: Save oa_clean file under name M with editData, then save M file as Rdata file. 
library(editData)
M <- editData(oa_clean)
save(M, file = "~/WII-1495-data/oa_clean4.Rdata")
biblioshiny()


##Doing what can be done in RStudio & bibliometrix
OAresults <- biblioAnalysis(openaccess_data_clean, sep = ";")
S <- summary(object = OAresults, k = 20, pause = FALSE)
plot(x = OAresults, K = 10, pause = FALSE)

OAresults <- biblioAnalysis(oa_clean, sep = ";")
S <- summary(object = OAresults, k=10, pause = FALSE)
plot(x = OAresults, K = 10, pause = FALSE)



