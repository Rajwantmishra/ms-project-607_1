
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


tempFull_Data <- trimws(unlist(str_extract_all(cd2_data,"[[:alpha:] ?]{2,}|[\\d.?\\d? +]{2,}|[\\d +]{1,2}|[\\w:?\\d? +]{2,}",simplify = TRUE)))

tempFull_Data <- as.data.frame(tempFull_Data)

tempFull_Data <- tempFull_Data[which(!tempFull_Data$V1=="NA"),]
View(tempFull_Data)
