# Chess Data extraction for MS Project class of 607 

In this project, you’re given a text file with chess tournament results where the information has some structure. Your job is to create an R Markdown file that generates a .CSV file (that could for example be imported into a SQL database) with the ``following information for all of the players``:

|Player's Name|Player's State|Total Number of Points|Player's Pre-Rating|Average Pre-Chess Rating of Opponents|
|-------------|--------------|----------------------|-------------------|-------------------------------------|
GARY HUA |	ON |	6.0 |	1794 |	1605 |
-------------------------------------------

1605 was calculated by using the pre-tournament opponents’ ratings of 1436, 1563, 1600, 1610, 1649, 1663, 1716, and dividing by the total number of games played.

[text File can be downloaded from here ](https://github.com/Rajwantmishra/ms-project-607_1/blob/master/tournamentinfo.txt)

#### Group Members and Contributors:

* [Santosh Cheruku](https://github.com/san123i)
* [Samantha Deokinanan](https://github.com/greeneyefirefly)
* [Rajwant Mishra](https://github.com/rajwantmishra)
* [Priya Shaji](https://github.com/PriyaShaji)

#### Rpub 

Rpub Link [Project Page](http://rpubs.com/Rajwantmishra/project_spark_607_1) 
 


***Data in Text File***

[![Data in Text File](https://i2.wp.com/whatsq.com/wp-content/uploads/2018/08/sample.png)]()

***Data after work in R***

[![Data After](https://i2.wp.com/whatsq.com/wp-content/uploads/2018/08/workingsample.png)]()

***
Summary of the Approaches
==========================

Each contributor decided to work on a solution in order to identify the different ways this task can be solved. However, there were key steps we took which were similar.

#### Extract 

1. Loading the specific R packages we felt that could solve this problem easily.
![](https://github.com/Rajwantmishra/ms-project-607_1/blob/master/Graphics/Slide2.PNG?raw=true) 



#### Transform

2. The different methods of cleaning and formatting with text file
![](https://github.com/Rajwantmishra/ms-project-607_1/blob/master/Graphics/Slide3.PNG?raw=true) 


#### Publish

3. Lastly, building and exporting the final CSV 
![](https://github.com/Rajwantmishra/ms-project-607_1/blob/master/Graphics/Slide4.PNG?raw=true)

#### Final Exporting of the CSV

The appropriate columns were selected and ordered as indicated in the beginning. Each method exported the data frame as a csv file using `write.csv()`. These csv file can then be stored as a SQL database.

***
Works Cited
==============
1. Wickham, H. (2017). R: Package `stringr`. Retrieved February 12, 2019, from https://cran.r-project.org/web/packages/stringr/stringr.pdf
