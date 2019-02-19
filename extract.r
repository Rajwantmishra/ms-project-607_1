
#install.packages("tidyverse")
suppressWarnings(library(tidyverse))
suppressWarnings(library(stringr))
suppressWarnings(library(data.table))
library(plyr)
library(XML)
library(crayon)
library(lubridate)
library(rjson)
library(readxl) 

## END OF LOADING

# Skip the 1st row "----------"
# Read the data 
cd2 <-read_lines("tournamentinfo.txt",skip = 1)
cd2

# Repalce all "------" by NA
# Read only data apart from header
cd2_data <- unlist(str_replace_all(cd2,"(-{89})","NA"))[-c(1:3)]
cd2_head <- unlist(str_replace_all(cd2,"(-{89})","NA"))[c(1:2)]

# Creating a smple to work with small data 
tempdata <- unlist(str_replace_all(cd2,"(-{89})","NA"))[c(4:5,7:8)]

#player -ID
playerID <- trimws(unlist(str_extract_all(cd2_data," \\d{1,2} ")))



head(playerID)

# [1] "    1 | GARY HUA                        |6.0  |W  39|W  21|W  18|W  14|W   7|D  12|D   4|"
# [2] "   ON | 15445895 / R: 1794   ->1817     |N:2  |W    |B    |W    |B    |W    |B    |W    |"
# [3] "    2 | DAKSHESH DARURI                 |6.0  |W  63|W  58|L   4|W  17|W  16|W  20|W   7|"
# [4] "   MI | 14598900 / R: 1553   ->1663     |N:2  |B    |W    |B    |W    |B    |W    |B    |"


tempFull_Data <-  trimws(unlist(str_extract_all(cd2_data,"[[:alpha:]-? ?]{2,}|[\\d.?\\d? +]{2,}|[\\d +]{1,2}|[\\w:?\\d? +]{2,}",simplify = TRUE)))

tempFull_Data <- as.data.frame(tempFull_Data, stringsAsFactors=F)

tempFull_Data <- tempFull_Data[which(!tempFull_Data$V1=="NA"),]
# View(tempFull_Data)
tempFull_Data_merged <- tempFull_Data

##This is a test comment by Santosh

#Create two empty data frames which can hold first and second rows respectively (2nd row belongs to player in 1st row)
tempFull_Data_first <- data.frame()
tempFull_Data_second <- data.frame()

#Iterator over full dataset and load the first and second data frames
for(rowNum in 1:nrow(tempFull_Data)) {
  if(rowNum %% 2 == 0) {
    tempFull_Data_second <- rbind(tempFull_Data_second, tempFull_Data[rowNum,])
  } else {
    tempFull_Data_first <- rbind(tempFull_Data_first, tempFull_Data[rowNum,])
  }
}

#Set colnames for 2nd dataframe so that it doesn't conflict with first dataframe i.e., from V20 to V33

columnNames1 <- c()
for (i in 20:33) {
  columnNames1 <- c(columnNames1, paste("V", i, sep = ""))
}

colnames(tempFull_Data_second) <- columnNames1

#Merge both the dataframes using cbind
tempFull_Data_merged <- cbind(tempFull_Data_first, tempFull_Data_second)
View(tempFull_Data_merged)

chessRound  <- tempFull_Data_merged[,c(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,23,24)]

names(chessRound) <- c("PID","PName","Total","R1","R1R","R2","R2R","R3","R3R","R4","R4R","R5","R5R","R6","R6R","R7","R7R","State","Pre","Post")
