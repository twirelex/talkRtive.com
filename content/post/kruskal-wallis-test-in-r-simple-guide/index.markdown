---
title: Kruskal-wallis test in r (Simple guide)
author: ''
date: '2020-09-17'
slug: kruskal-wallis-test-in-r-simple-guide
categories: [r programming, statistics]
tags: []
subtitle: ''
summary: 'A simple guide to performing kruskal wallis test in R'
authors: []
lastmod: '2020-09-17T21:31:34+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---  



  

Let us start by understanding what the kruskal-wallis test is.  

## **What is Kruskal-Wallis test?**  
Kruskal-wallis test is a non-parametric alternative to the One-way [Analysis of variance]({{< ref "post/anova-in-r" >}}) for comparing means across two or more groups. The kruskal-wallis test is used when some important assumptions of the One-way analysis of variance are not met.  
These assumptions are listed below:  

1. Absence of outliers in the data
2. Normality of data  

# **Kruskal-wallis test hypothesis:**  

* **H0** (Null hypothesis): There is no significant difference in the medians of the different groups.  
* **H1** (Alternative hypothesis): At least one group has a different median.  

## **Rejection region for kruskal wallis test**  

For this lesson we will use a rejection region of 0.05 i.e we reject the null hypothesis if our p-value is less than 0.05%  

# **Assumptions of the kruskal-wallis test**  

* The dependent variable is ordinal or continuous  
* The independent variable is categorical, having three or more groups  
* The distribution shapes are approximately similar in all groups.  

# **Computing kruskal-wallis test in r**  

### Example  

We will work with the diet dataset for this example. Our aim is to compare weight loss for 3 different diets. The original dataset was downloaded from the sheffield website. We will be using the modified version that can be found here.  

**Load required packages**  


```r
require(tidyverse)
```


**Read in the dataset**  


```r
dietdata <- read_csv("https://raw.githubusercontent.com/twirelex/dataset/master/dietdata.csv")
```

```
## Parsed with column specification:
## cols(
##   diet = col_character(),
##   weightloss = col_double()
## )
```
**View first 6 observations of the data**

```r
head(dietdata)
```

```
## # A tibble: 6 x 2
##   diet  weightloss
##   <chr>      <dbl>
## 1 B           60  
## 2 B          103  
## 3 A           54.2
## 4 A           54  
## 5 A           63.3
## 6 A           61.1
```
**View structure of the data**


```r
glimpse(dietdata)
```

```
## Rows: 78
## Columns: 2
## $ diet       <chr> "B", "B", "A", "A", "A", "A", "A", "A", "A", "A", "A", "...
## $ weightloss <dbl> 60.0, 103.0, 54.2, 54.0, 63.3, 61.1, 62.2, 64.0, 65.0, 6...
```
The `diet` variable appears to be a character variable, we need to make it a categorical variable to be able to use it in the analysis.  


```r
dietdata <- dietdata %>% mutate(diet = factor(diet))
```

**Verify that the `diet` variable is now a categorical variable**  


```r
glimpse(dietdata)
```

```
## Rows: 78
## Columns: 2
## $ diet       <fct> B, B, A, A, A, A, A, A, A, A, A, A, A, A, A, A, B, B, B,...
## $ weightloss <dbl> 60.0, 103.0, 54.2, 54.0, 63.3, 61.1, 62.2, 64.0, 65.0, 6...
```

**See the count for each diet category**  


```r
dietdata %>% count(diet)
```

```
## # A tibble: 3 x 2
##   diet      n
##   <fct> <int>
## 1 A        24
## 2 B        27
## 3 C        27
```


**visualize the count for each diet category**  

```r
dietdata %>% ggplot(aes(diet, fill = diet)) + geom_bar(show.legend = FALSE)
```

{{<figure src="/post/kruskal-wallis-test-in-r-simple-guide/index_files/figure-html/unnamed-chunk-9-1.png" alt="barplot for diet variable">}}

**Visualize the weightloss variable**  


```r
dietdata %>% ggplot(aes(weightloss)) + geom_density() 
```

{{<figure src="/post/kruskal-wallis-test-in-r-simple-guide/index_files/figure-html/unnamed-chunk-10-1.png" alt="density plot for weightloss variable">}}


**Visualize the weightloss variable for each diet category**  


```r
dietdata %>% ggplot(aes(weightloss, diet, fill = diet)) + geom_boxplot(show.legend = FALSE) + coord_flip()
```

{{<figure src="/post/kruskal-wallis-test-in-r-simple-guide/index_files/figure-html/unnamed-chunk-11-1.png" alt="boxplot of weightloss and diet variable">}}

Notice that the median weightloss for group **B** is slightly different from that of group **A** and group **C**.  

We will now use the kruskal-wallis test to check if the difference is significant  

the `kruskal.test` function can be used to compute the kruskal-wallis test in r  


```r
kruskal_wallis_test <- kruskal.test(weightloss ~ diet, data = dietdata) 

kruskal_wallis_test
```

```
## 
## 	Kruskal-Wallis rank sum test
## 
## data:  weightloss by diet
## Kruskal-Wallis chi-squared = 0.68734, df = 2, p-value = 0.7092
```

With a p-value greater than 0.05 significance level we will accept the Null hypothesis and conclude that we have evidence to believe that all medians are equal.

  

























