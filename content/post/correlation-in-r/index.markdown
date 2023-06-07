---
title: Visualizing and interpreting correlation in R
author: ''
date: '2023-06-04'
slug: visualizing-and-interpreting-correlation-in-r
categories: [r programming, statistics]
tags: []
subtitle: ''
summary: 'R is a good statistical tool for performing so many statistical tests. In this lesson i will walk you through how to test/interpret correlation between varibles in r.'
authors: []
lastmod: '2023-06-04T13:53:22+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---  


Correlation analysis is a statistical analysis for understanding the relationship/association between continuous variables. Essentially what we are interested-in in a correlation analysis is a value called the correlation coefficient. This value ranges from **-1** to **+1**, it tells us how strong or weak the relationship is between a pair of variables.  
Generally:  
  
* A value of **-1** translates to a perfect negative correlation between the two variables  
  + a value between **-0.1** and **-0.49** implies that there is a weak negative correlation between the two variables(Low negative correlation)  
  + a value between **-0.5** and **-0.99** implies that there is a strong negative correlation between the two variables(High negative correlation)  
    
* A value of **+1** translates to a perfect positive correlation between the two variables  
  + a value between **+0.1** and **+0.49** implies that there is a weak positive correlation between the two variables(Low negative correlation)  
  + a value between **+0.5** and **+0.99** implies that there is a strong positive correlation between the two variables(High negative correlation)  
    
    
* A value of **0** translates to no correlation between the two variables(No relationship)  

{{% alert note %}}Notice that we didn't use the adverb "very" to describe how strong or weak the correlation is. This is because people tend to set different threshold value depending on the requirement of their analysis. {{% /alert %}}


### THREE MAJOR METHODS OF CORRELATION COEFFICIENT CAN BE COMPUTED IN BASE R
1. <center> <h3> Pearson's product-moment correlation </h3> </center>  

Pearson's product-moment correlation is a parametric measure of the linear association between two continuous random variables  

#### ASSUMPTIONS:  
* The two variables are continuous  
* The variable values are pairs(there are two values, two measurements for each sample case)  
* The relationship between the variables are approximately linear  
* The variables are normally distributed  
* There exist no outliers

2. <center> <h3> Spearman's rank correlation </h3> </center>  
Spearman's rank correlation is a non-parametric measure of the monotonic association between two continuous random variables  

#### ASSUMPTIONS:  
* Both variables are ordinal and/or continuous  
* The relationship between the variables is monotonic  
* The variable values are pairs(there are two values, two measurements for each sample case)

3. <center> <h3> Kendall's rank correlation  </h3> </center>  
kendall's rank correlation is a non-parametric measure of the association, based on concordance or discordance of two continuous random variables.  


### HYPOTHESIS TESTING  

When performing correlation analysis in R we can also test for hypothesis as follows:  
* **Ho** (Null hypothesis): correlation between the two variables is equal to Zero  
* **H1** (Alternative hypothesis): correlation between the two variables is not equal to Zero  

### REJECTION REGION  
Reject the Null hypothesis when the p-value is smaller than 0.05  
Reject the Alternative hypothesis when the p-value is greater than 0.05  


### EXAMPLE  

For this example we will make use of the popular mtcars dataset that comes with R. The dataset contains information about 32 cars, including their weight, fuel efficiency (in miles_per_gallon), speed, Rear axle ratio, etc... you can use the `help(mtcars)` function in r to know more about the dataset.  
Our aim is to analyze the correlation between the Miles_per_gallon(mpg) variable and few other continuous variables in the dataset.  

**Load required packages and dataset**  

```r
require(tidyverse)
require(corrplot)
data("mtcars")
```

**See what the data looks like**

```r
mtcars %>% head() %>% knitr::kable()
```



|                  |  mpg| cyl| disp|  hp| drat|    wt|  qsec| vs| am| gear| carb|
|:-----------------|----:|---:|----:|---:|----:|-----:|-----:|--:|--:|----:|----:|
|Mazda RX4         | 21.0|   6|  160| 110| 3.90| 2.620| 16.46|  0|  1|    4|    4|
|Mazda RX4 Wag     | 21.0|   6|  160| 110| 3.90| 2.875| 17.02|  0|  1|    4|    4|
|Datsun 710        | 22.8|   4|  108|  93| 3.85| 2.320| 18.61|  1|  1|    4|    1|
|Hornet 4 Drive    | 21.4|   6|  258| 110| 3.08| 3.215| 19.44|  1|  0|    3|    1|
|Hornet Sportabout | 18.7|   8|  360| 175| 3.15| 3.440| 17.02|  0|  0|    3|    2|
|Valiant           | 18.1|   6|  225| 105| 2.76| 3.460| 20.22|  1|  0|    3|    1|


To compute the Pearson, Speaman or kendall correlation coefficient test in R we use the `cor.test` function. We can indicate the method we want to use with the **method** parameter, by default the pearson's method is used.  


**Compute Pearson correlation test for MPG vs DISP variables**  

```r
cor.test(mtcars$dis, mtcars$mpg, method = "pearson") 
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  mtcars$dis and mtcars$mpg
## t = -8.7472, df = 30, p-value = 9.38e-10
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  -0.9233594 -0.7081376
## sample estimates:
##        cor 
## -0.8475514
```
We can see that we get a lot of important information like the p-value, hypothesis, confidence interval, degree-of-freedom, and correlation coefficient when we use the `cor.test` function.  
A correlation coefficient value of -0.8475514 means that there is strong negative correlation between the MPG and DISP variable. We can simply use the `cor` function if we are only interested in the value of the  correlation coefficient between the variables. i.e `cor(mtcars$mpg, mtcars$disp, method = "pearson")`  

**Visualize the variables**  
We can also visualize the variables to understand the association  


```r
mtcars %>% ggplot(aes(disp, mpg)) + geom_point() + geom_smooth(se = FALSE)
```

{{<figure src="index_files/figure-html/unnamed-chunk-5-1.png" alt="correlation in r scatter plot of variables">}}
Obviously as the **disp** increases the **mpg** decreases and the relationship is fairly linear.  

**Compute Spearman's rank correlation test for MPG vs DISP variables**  

```r
cor.test(mtcars$dis, mtcars$mpg, method = "spearman") 
```

```
## 
## 	Spearman's rank correlation rho
## 
## data:  mtcars$dis and mtcars$mpg
## S = 10415, p-value = 6.37e-13
## alternative hypothesis: true rho is not equal to 0
## sample estimates:
##        rho 
## -0.9088824
```
We get a higher correlation coefficient in the Spearman's test  

**NOTE:** It is always advisable to first verify which of the assumptions are satisfied before going ahead to compute any of these tests.  


**Compute Pearson correlation test for MPG vs DRAT variables**  


```r
cor.test(mtcars$drat, mtcars$mpg, method = "pearson") 
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  mtcars$drat and mtcars$mpg
## t = 5.096, df = 30, p-value = 1.776e-05
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.4360484 0.8322010
## sample estimates:
##       cor 
## 0.6811719
```
We get a correlation coefficient value of 0.6811719 indicating that there is a strong correlation between the **mpg** and **drat** variables  


**Visualize the variables**  
We can also visualize the variables to understand the association  


```r
mtcars %>% ggplot(aes(drat, mpg)) + geom_point() + geom_smooth(se = FALSE)
```

{{<figure src="index_files/figure-html/unnamed-chunk-8-1.png" alt="A scatter plot display of correlation in r">}}
We can see that the **mpg** increases as **drat** increases and the relationhip is fairly linear  

#### COMPUTING AND VISUALIZING THE CORRELATION OF MULTIPLE VARIABLES  

it is also possible to compute correlation coefficient for multiple variables, each pairs combined to form a matrix. This can also be achieved with the `cor` function, this time instead of supplying the function with two continuous variables we supply an entire data frame with several continuous variables.  

**Correlation matrix for the mtcars dataframe**  


```r
cor(mtcars) %>% 
  knitr::kable()
```



|     |        mpg|        cyl|       disp|         hp|       drat|         wt|       qsec|         vs|         am|       gear|       carb|
|:----|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|mpg  |  1.0000000| -0.8521620| -0.8475514| -0.7761684|  0.6811719| -0.8676594|  0.4186840|  0.6640389|  0.5998324|  0.4802848| -0.5509251|
|cyl  | -0.8521620|  1.0000000|  0.9020329|  0.8324475| -0.6999381|  0.7824958| -0.5912421| -0.8108118| -0.5226070| -0.4926866|  0.5269883|
|disp | -0.8475514|  0.9020329|  1.0000000|  0.7909486| -0.7102139|  0.8879799| -0.4336979| -0.7104159| -0.5912270| -0.5555692|  0.3949769|
|hp   | -0.7761684|  0.8324475|  0.7909486|  1.0000000| -0.4487591|  0.6587479| -0.7082234| -0.7230967| -0.2432043| -0.1257043|  0.7498125|
|drat |  0.6811719| -0.6999381| -0.7102139| -0.4487591|  1.0000000| -0.7124406|  0.0912048|  0.4402785|  0.7127111|  0.6996101| -0.0907898|
|wt   | -0.8676594|  0.7824958|  0.8879799|  0.6587479| -0.7124406|  1.0000000| -0.1747159| -0.5549157| -0.6924953| -0.5832870|  0.4276059|
|qsec |  0.4186840| -0.5912421| -0.4336979| -0.7082234|  0.0912048| -0.1747159|  1.0000000|  0.7445354| -0.2298609| -0.2126822| -0.6562492|
|vs   |  0.6640389| -0.8108118| -0.7104159| -0.7230967|  0.4402785| -0.5549157|  0.7445354|  1.0000000|  0.1683451|  0.2060233| -0.5696071|
|am   |  0.5998324| -0.5226070| -0.5912270| -0.2432043|  0.7127111| -0.6924953| -0.2298609|  0.1683451|  1.0000000|  0.7940588|  0.0575344|
|gear |  0.4802848| -0.4926866| -0.5555692| -0.1257043|  0.6996101| -0.5832870| -0.2126822|  0.2060233|  0.7940588|  1.0000000|  0.2740728|
|carb | -0.5509251|  0.5269883|  0.3949769|  0.7498125| -0.0907898|  0.4276059| -0.6562492| -0.5696071|  0.0575344|  0.2740728|  1.0000000|


Notice how the leading diagonal is 1 all through, this means that there is always a perfect positive correlation when a variable is paired with itself.

we can tell how much each variable is correlated with another by observing the correlation matrix, but some people may not be too comfortable seeing just numbers, it may be hard for them to interpret results is this form.  
Another good way to compute a correlation matrix is by making an heatmap. With heatmap it is easy to tell which variables have high and low correlation without having to be looking at numbers  


**Visualize the correlation of the mtcars dataframe using the** `corrplot` **function from the** <span style = "color:blue;"> corrplot </span> **package**

```r
corrplot(cor(mtcars), method = "pie")
```

{{<figure src="index_files/figure-html/unnamed-chunk-10-1.png" alt="corrplot correlation in r">}}
Each pie from the plot above shows how strong or weak correlation between pairs is, more filled pies indicates strong relationship between the pairs and less filled pie indicates weak relationship between the pairs. The color of each pairs tells us the sign/direction of the relationship i.e `Negative` or `Positive`

With plots like the one above one would not need to be struggling to understand numbers. Mere looking at the plot one can tell how much each pairs correlates with one another compared to the rest.  


The **method** parameter in the `corrplot` function allows us to choose the visualization method of correlation matrix to be used. It currently supports the seven methods below:  
* circle  
* square  
* ellipse  
* number  
* pie  
* shade  
* color  

for example we can use the "square" method as follows:


```r
corrplot(cor(mtcars), method = "square")
```

{{<figure src="index_files/figure-html/unnamed-chunk-11-1.png" alt="heatmap plot showing correlation in r">}}
and so on.......






































