
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
library(DT)

## END OF LOADING
##Commit from Rajwant Start
# Skip the 1st row "----------"
# Read the data 
# Reading File from Local
cd2 <-read_lines("tournamentinfo.txt",skip = 1)
cd2
# Reading File from Local END

# Reading File from Online  Working Code
# raw = "https://raw.githubusercontent.com/Rajwantmishra/ms-project-607_1/master/tournamentinfo.txt"
# cd2 <-read_lines(raw,skip = 1)
# cd2
# Reading File from Online END

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
##Commit from Rajwant End
##Commit from Santosh Start

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
#View(tempFull_Data_merged)

##Commit from Santosh End
##Commit from Rajwant Start
chessRound  <- tempFull_Data_merged[,c(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,22,23)]

# R1O, R2O are indicator of Opponent of respective rounds
names(chessRound) <- c("PID","PName","Total","R1","R1O","R2","R2O","R3","R3O","R4","R4O","R5","R5O","R6","R6O","R7","R7O","State","Pre","Post")

# Example For the first player, the information would be:
# 
# Gary Hua, ON, 6.0, 1794, 1605
# 
# 1605 was calculated by using the pre-tournament opponents’ ratings of 1436, 1563, 1600, 1610, 1649, 1663, 1716, and dividing by the total number of games played.

 # Convert All Pre to right number 
 chessRound[,18:20] <- mutate( chessRound[,18:20], 
                  Pre = ifelse( str_detect(Pre,"P\\d{2}$"), 
                                trimws(str_extract(Pre," \\d{3,4}")), 
                                trimws(str_extract(Pre," \\d{3,4}")) ))

# Convert all ROunds COlumn to NA if they have  B H U . Only keep W L ANF D
 chessRound_Temp <- mutate_at( chessRound[,1:17], vars(R1,R2,R3,R4,R5,R6,R7,R1O,R2O,R3O,R4O,R5O,R6O,R7O),
                        list(~ ifelse( str_detect(.,"B|H|U"), NA, .)))
 
 # Shift all NA to end of the Row 
 # Here I am grouping the data into non-NA set and NA , for each row and then using Tranpose get in right format. 

chessRound_Temp <- t(apply(chessRound_Temp, 1,  function(x) c(x[!is.na(x)], x[is.na(x)])))
 
 chessRound_Temp <- as.data.frame(chessRound_Temp,stringsAsFactors=F)

 Final_Chess_Data <- data.frame(chessRound_Temp[,],chessRound[,18:20])
 
 names(Final_Chess_Data) <- c("PID","PName","Total","R1","R1O","R2","R2O","R3","R3O","R4","R4O","R5","R5O","R6","R6O","R7","R7O","State","Pre","Post")
 
# "Average Pre Chess Rating of Opponents (1605 was calculated by using the pre-tournament opponents’ ratings of 1436, 1563, 1600, 1610, 1649, 1663, 1716, and
# dividing by the total number of games played.)"				
# Opponent	Rating	game Played
# 39	  1436	1
# 21	  1563	1
# 18	  1600	1
# 14	  1610	1
# 7	    1649	1
# 12	  1663	1
# 4	    1716	1
#-----------------------
# 	    1605	7
 
#  teamR <- 0
#  noMatch <- 0
# team<- Final_Chess_Data[1,c(5,7,9,11,13,15,17)]
#  for (n in team)
#  {
#    print.noquote(n)
#    if(is.na(n)|n==""){
#      noMatch = noMatch
#     } else{
#       noMatch = noMatch + 1
#       teamR<-  teamR + as.integer(Final_Chess_Data[as.integer(n),19])
#    }
# 
#    print.noquote(teamR)
# 
#  }
#  score <- round(teamR/noMatch)
# 
# Final_Chess_Data[39,19]

AVGS<- function(pid){
  score <- 0
  teamR <- 0
 noMatch <- 0
 suppressWarnings(rm(team))
team<- Final_Chess_Data[pid,c(5,7,9,11,13,15,17)] 
 for (n in 1:7)
 {
   if(is.na(team[1,n])||team[1,n]==""){
     noMatch = noMatch
    } else{
       noMatch = noMatch + 1
        teamR<-  teamR + as.integer(Final_Chess_Data[as.integer(team[1,n]),19])
   }
 }
  score <- round(teamR/noMatch)
  return(score[1])
}

for (n in 1:dim(Final_Chess_Data)[1]){
  Final_Chess_Data$score[n] <- AVGS(as.integer(Final_Chess_Data$PID[n]))
 
}
  
DT::datatable(Final_Chess_Data[,c(2,18,3,19,21)],colnames = c("PlayerName","State","Total Points","Pre rating","Avg Opp Rating"))                           
##Commit from Rajwant End

