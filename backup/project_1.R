## I understood this method , so used it in my code:)
## read the data
tmp <- read.delim("tournamentinfo.txt", header=FALSE, sep="|", skip = 4 ,stringsAsFactors = FALSE)
str(tmp)
tmp

## create a dataframe called chess
##extarct the data from column 1 and column 2
chess <- data.frame(Name = tmp$V2[c(TRUE, FALSE, FALSE)], State = tmp$V1[c(FALSE, TRUE, FALSE)], Points = round(as.numeric(tmp$V3[c(TRUE, FALSE, FALSE)]), 1), Rating = integer(64), opponents_averageRating = integer(64))
chess

##load the stringr package
library(stringr)
## extraxt the pre-rating score using regular expressions
tmp_rate <- str_extract(tmp$V2[c(FALSE, TRUE, FALSE)], "R:[:blank:]+[:digit:]+")
tmp_rate
chess$Rating <- as.numeric(str_extract(tmp_rate, "[:digit:]+"))
chess

##include all the necessary columns in the ratings dataframe
ratings <- data.frame(playnum = str_trim(tmp$V1[c(TRUE, FALSE, FALSE)]), rate = chess$Rating, R1 = as.numeric(str_extract(tmp$V4[c(TRUE, FALSE, FALSE)], "[:digit:]+")), R2 = as.numeric(str_extract(tmp$V5[c(TRUE, FALSE, FALSE)], "[:digit:]+")), R3 = as.numeric(str_extract(tmp$V6[c(TRUE, FALSE, FALSE)], "[:digit:]+")), R4 = as.numeric(str_extract(tmp$V7[c(TRUE, FALSE, FALSE)], "[:digit:]+")), R5 =  as.numeric(str_extract(tmp$V8[c(TRUE, FALSE, FALSE)], "[:digit:]+")), R6 =  as.numeric(str_extract(tmp$V9[c(TRUE, FALSE, FALSE)], "[:digit:]+")), R7 =  as.numeric(str_extract(tmp$V10[c(TRUE, FALSE, FALSE)], "[:digit:]+")), avg_rate = numeric(64))
           
ratings

## Found the for loop and rowMeans method online.
## Replace the player numbers in each round with their pre-rating number
for (i in 1:64) {
  ratings$R1[i] <- ratings$rate[ratings$R1[i]]
  ratings$R2[i] <- ratings$rate[ratings$R2[i]]
  ratings$R3[i] <- ratings$rate[ratings$R3[i]]
  ratings$R4[i] <- ratings$rate[ratings$R4[i]]
  ratings$R5[i] <- ratings$rate[ratings$R5[i]]
  ratings$R6[i] <- ratings$rate[ratings$R6[i]]
  ratings$R7[i] <- ratings$rate[ratings$R7[i]]
}
ratings

## use rowMeans function for calculating the average rating of each player
for (i in 1:64) {
  ratings$avg_rate[i] <- rowMeans(ratings[i, 3:9], na.rm = TRUE)
}
ratings


chess$opponents_averageRating <- round(ratings$avg_rate, digits = 0)
chess

