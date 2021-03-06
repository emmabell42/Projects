#######################################################
#
# This is a quick explore of how MPs voted on the
# Article 50 vote
#
#######################################################
#
####################
# Load in tables
####################
setwd("C:/Users/emmab/Documents/Article50/")
#library(XML)
#URL <- "http://www.politicsresources.net/area/uk/mps.htm"
#tables <- readHTMLTable(URL)
#mps <- tables[[3]]
#mps <- mps[,2:5]
#write.table(mps,"mps.txt",sep="\t",col.names=F,row.names=F,quote=F)
mps <- read.table("mps.txt",sep="\t",stringsAsFactors=F,head=F,comment="",quote=NULL)
refByConstituency <- read.table("referendumByConstituency.txt",sep="\t",fill=F,stringsAsFactors=F)
colnames(mps) <- c("Constituency","Name","Party","Size")
correctNames <- c("mps")
nope <- c("Mr ","Sir ","Dame ","Ms ","Miss ","Mrs ","Dr ","Lady ")
for(i in 1:3){
toCorrect <- get(correctNames[i])
toCorrect$Name <- gsub(paste0(nope,collapse="|"),"",toCorrect$Name)
assign(correctNames[i],toCorrect)
}
mps[grep("Vacant",mps[,2]),2] <- NA
#mps[grep("Dr",as.character(mps[,2])),2][c(1,3,7,8)] <- c("Alasdair McDonnell","Caroline Lucas","Liam Fox","Sarah Wollaston")
votes <- read.table("Commons 01-02-2017 Division No 135.txt",sep="\t",head=T,stringsAsFactors=F)
####################
# Descriptive stats
####################
#
## How many MPs abstained?
#
# There are 647 MPs that are eligible to vote
#
647-nrow(votes) # 35 MPs abstained
#
## What proportion of each party voted aye or no?
#
votes$Vote <- gsub("Aye",1,votes$Vote)
votes$Vote <- gsub("No",0,votes$Vote)
aye <- votes[grep("1",votes$Vote),]
no <- votes[grep("0",votes$Vote),]
parties <- unique(c(names(table(nay$Party)),names(table(aye$Party))))
numbers <- array(NA,dim=c(length(parties),2))
colnames(numbers) <- c("Aye","No")
rownames(numbers) <- parties
for(i in 1:nrow(numbers)){
party <- parties[i]
numbers[i,1] <- ifelse(party %in% aye$Party,table(aye$Party)[[party]],0)
numbers[i,2] <- ifelse(party %in% no$Party,table(no$Party)[[party]],0)
}
numbers <- cbind(numbers,Total=numbers[,1]+numbers[,2])
#> numbers
#                                 Aye No Total
#Conservative                     319  1   320
#Green Party                        0  1     1
#Independent                        1  3     4
#Labour                           167 47   214
#Liberal Democrat                   0  7     7
#Plaid Cymru                        0  2     2
#Scottish National Party            0 50    50
#Social Democratic & Labour Party   0  3     3
#Democratic Unionist Party          8  0     8
#UK Independence Party              1  0     1
#Ulster Unionist Party              2  0     2
proportions <- cbind(Aye=numbers[,1]/numbers[,3],No=numbers[,2]/numbers[,3
#
## What proportion of eligible voters voted in the 2014 European Parliament elections?
#
ep2014 <- read.table("ep2014.txt",sep="\t",head=T,comment="",quote="",stringsAsFactors=F)
ep2014 <- ep2014[,1:45]
ep2014 <- cbind(ep2014[,1:5],ep2014[,colnames(ep2014)[which(colnames(ep2014) %in% gsub(" ",".",parties))]])
sum(as.numeric(ep2014[,4])) # 46,481,532 were eligible to vote
sum(as.numeric(ep2014[,5])) # 16,454,949 voted
sum(as.numeric(ep2014[,5]))/sum(as.numeric(ep2014[,4])) # 0.3540105 of those eligible to vote did so voted.
#
## How did this vary by region?
#
ep2014.region <- array(NA,dim=c(length(table(ep2014$Region),2))
rownames(ep2014.region) <- names(table(ep2014$Region))
for(i in 1:nrow(ep2014.region)){
region <- rownames(ep2014.region)[i]
numbers[i,1] <- ifelse(party %in% aye$Party,table(aye$Party)[[party]],0)
numbers[i,2] <- ifelse(party %in% no$Party,table(no$Party)[[party]],0)
}
par(mar=c(11,4,2,2))
boxplot(ep2014[,5]/ep2014[,4]~ep2014$Region,las=2,horizontal=F,notch=T,main="Valid votes/eligible electorate")
#
## Does voter turnout correlate with how the electorate voted in the referendum?
#
area <- read.table("referendumByArea.txt",sep="\t",head=T,comment="",quote="",stringsAsFactors=F)
par(mar=c(11,4,2,2))
boxplot(as.numeric(area[,6])/as.numeric(area[,8])~area$Region,las=2,horizontal=F,notch=T,main="Valid votes/eligible electorate")
ep2014[1,1] <- "GI"
ep2014 <- ep2014[order(ep2014$Code),]
area <- area[order(area$Area_Code),]
identical(nrow(area),nrow(ep2014))
turnout <- array(NA,dim=c(nrow(ep2014),2))
colnames(turnout) <- c("EP2014","Referendum")
rownames(turnout) <- sort(ep2014$Code)
for(i in 1:nrow(turnout)){
code <- as.character(rownames(turnout)[i])
turnout[i,1] <- ep2014[grep(code,ep2014$Code),5]/ep2014[grep(code,ep2014$Code),4]
turnout[i,2] <- area[grep(code,area$Area_Code),8]/area[grep(code,area$Area_Code),6]
}
