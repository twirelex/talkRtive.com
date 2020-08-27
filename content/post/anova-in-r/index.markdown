---
title: Anova in r
author: ''
date: '2020-08-26'
slug: anova-in-r
categories: []
tags: []
subtitle: ''
summary: 'Conducting one-way and two-way analysis of variance (ANOVA) test in R'
authors: []
lastmod: '2020-08-26T13:59:55+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---



Let us start by understanding what analysis of variance is.   

# WHAT IS ANALYSIS OF VARIANCE?  

Analysis of variance (ANOVA) also known as Fisher's analysis of variance is a parametric extension of the t and z-test. It is a statistical method employed whenever there is a need to compare the means of 2 or more independent population.  

You may wonder why ANOVA exist if the 2 sample t-test can also be used to compare means in different groups. Well, the 2 sample t-test can be used to compare means in different groups but when using it one risks making a type 1 error (alpha inflation) i.e (rejecting the null hypothesis even though it is accurate/correct), also, if the 2 sample t-test is used to compare means in different groups one would also need to run multiple significance test and that is what leads to making the type 1 error. Conversely, Analysis of variance (ANOVA) looks across multiple groups of populations, compares their means to produce one score and one significance value, i.e running a single ANOVA test to compare multiple groups.  

Before running an Analysis of variance (ANOVA) test there is need to first formulate an hypothesis.  

### Analysis of variance (ANOVA) hypothesis:  
* **H0** (Null hypothesis): There is no significant difference in the means of the different groups.  
* **H1** (Alternative hypothesis): At least one sample mean is not equal to the others.  

When we run an Analysis of variance (ANOVA), the test statistics that is obtained is called the F-Statistics. The F-Statistics tries to capture the ratio of the variance between groups divided by variance within groups

<center>{{< figure library="true" src="anova-in-r/F-statistic.png" alt="Anova F-statistic ">}}</center>  
if the groups are very similar to one another, the variance between groups will be close to the variance within a group i.e the F-Statistic will have a value very close of 1. But if the groups are not similar to one another the F-Statistics will be large.  

### Analysis of variance (ANOVA) Best Practices:  
* Accept the Alternative hypothesis and reject the Null hypothesis when you have a large F-statistic and small p-value less than 0.05 significance level  
* Accept the Null hypothesis and reject the Alternative hypothesis when you have a small F-statistic and large p-value greater than 0.05 significance level  

# ONE-WAY ANOVA  
One-way analysis of variance is used to compare means across 2 or more groups. In the one-way analysis of variance a single categorical variable is used to split the population into the different groups.  Just like with other parametric statistical tests the one-way ANOVA makes some assumptions about the data.  

### Assumptions of the one-way ANOVA test
1. The **Y** variable is continuously distributed
2. There is only one categorical independent **X** variable
3. The observations are independent
4. The **Y** variable is normally distributed for each **X** category
5. No outliers in the data
6. Equality of variance  

# TWO-WAY ANOVA  
Two-way analysis of variance is used to compare means across 2 or more groups in a continuous dependent **Y** variable using 2 independent **X** variables  


### Assumptions of the two-way ANOVA test
1. The **Y** variable is continuously distributed
2. There are two categorical independent **X** variable
3. The observations are independent
4. The **Y** variable is normally distributed for each **X** category
5. No outliers in the data
6. Equality of variance  


## EXAMPLE  

For this example we will work with the diet dataset. Our aim is to compare weight loss for 3 different diets. The original dataset was downloaded from the sheffield website. We will be using the modified version that can be found here.  

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

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-9-1.png" alt="barplot for diet variable">}}

**Visualize the weightloss variable**  


```r
dietdata %>% ggplot(aes(weightloss)) + geom_density() 
```

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-10-1.png" alt="density plot for weightloss variable">}}


**Visualize the weightloss variable for each diet category**  


```r
dietdata %>% ggplot(aes(weightloss, diet, fill = diet)) + geom_boxplot(show.legend = FALSE) + coord_flip()
```

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-11-1.png" alt="boxplot of weightloss and diet variable">}}
Notice that the median weightloss for group **B** is slightly different from that of group **A** and group **C**.  

We will now use the one-way analysis of variance (ANOVA) to check if the difference is significant  

**One-way Anova test**  
Anova in r can be computed using the function `aov`

```r
anova_test <- aov(weightloss ~ diet, data = dietdata)
```

**View summary of the test**  

```r
summary(anova_test)
```

```
##             Df Sum Sq Mean Sq F value Pr(>F)
## diet         2     30   14.92   0.183  0.833
## Residuals   75   6103   81.37
```
With a p-value greater than 0.05 significance level we will accept the Null hypothesis and conclude that we have evidence to believe that all means are equal.  

**Two-way Anova**  
We are going to use the `birthwt` dataset that comes with the `MASS` package in r.
The birthweight dataset contains the birthweight in grams of children along with some specific information about their mother. Our aim is to carry out a two-way analysis of variance test to check if the ethnicity of a mother and whether she smokes(1) or not(0) have effect on the birthweight of her child. 


**Select the variables of interest**

```r
birthweight_data <- MASS::birthwt %>% select(smoke, race, birth_weight = bwt)

head(birthweight_data)
```

```
##    smoke race birth_weight
## 85     0    2         2523
## 86     0    3         2551
## 87     1    1         2557
## 88     1    1         2594
## 89     1    1         2600
## 91     0    3         2622
```

**Create a boxplot of the `birth_weight` variable to see if there are outliers**  


```r
birthweight_data %>% ggplot(aes(birth_weight)) + geom_boxplot(fill = "lightblue") + coord_flip()
```

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-15-1.png" alt="boxplot of birth_weight variable">}}
The variable appears to be okay  

**View the structure of the data**  


```r
glimpse(birthweight_data)
```

```
## Rows: 189
## Columns: 3
## $ smoke        <int> 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, ...
## $ race         <int> 2, 3, 1, 1, 1, 3, 1, 3, 1, 1, 3, 3, 3, 3, 1, 1, 2, 1, ...
## $ birth_weight <int> 2523, 2551, 2557, 2594, 2600, 2622, 2637, 2637, 2663, ...
```

Variables `smoke` and `race` are currently **int** variables but these variables have discrete values, so for the sake of our analysis we will have to convert both variables to categorical variables.  

**Categorical variables**  


```r
birthweight_data <- birthweight_data %>% mutate(smoke = factor(smoke), race = factor(race))
```

**Create a barplot to visualize the frequencies of the smoke variable**

```r
birthweight_data %>% ggplot(aes(smoke)) + geom_bar(fill = "lightblue")
```

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-18-1.png" alt="barplot of smoke variable">}}
There appears to be more non-smokers than smokers  

**Create a barplot to visualize the frequencies of the race variable**  


```r
birthweight_data %>% ggplot(aes(race)) + geom_bar(fill = "lightblue")
```

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-19-1.png" alt="barplot of race variable">}}
Most of the mothers are from the **1** ethnicity  

**Create a boxplot to visualize the influence the smoke variable has on the child's birth_weight variable** 

```r
birthweight_data %>% ggplot(aes(birth_weight, smoke)) + geom_boxplot(fill = "lightblue") + coord_flip()
```

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-20-1.png" alt="boxplot of birth_weight variable and smoke">}}
From the plot above it appears that the median birth_weight of children whose mother does not smoke is higher than that of children whose mother smokes. We will very with ANOVA if the difference is significant.  

**Create a boxplot to visualize the influence the race variable has on the child's birth_weight variable**  


```r
birthweight_data %>% ggplot(aes(birth_weight, race)) + geom_boxplot(fill = "lightblue") + coord_flip()
```

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-21-1.png" alt="boxplot of birth_weight variable and race">}}
The plot above suggests that there is difference in the median of the birth_weight for the 3 ethnic groups. We will verify if the difference are significant with the ANOVA test.  

**Two-way anova test**  

```r
TwoWay_anova <- aov(birth_weight ~ smoke + race, data = birthweight_data)
TwoWay_anova
```

```
## Call:
##    aov(formula = birth_weight ~ smoke + race, data = birthweight_data)
## 
## Terms:
##                    smoke     race Residuals
## Sum of Squares   3625946  8712354  87631356
## Deg. of Freedom        1        2       185
## 
## Residual standard error: 688.2463
## Estimated effects may be unbalanced
```

**View summary of the test**  


```r
summary(TwoWay_anova)
```

```
##              Df   Sum Sq Mean Sq F value   Pr(>F)    
## smoke         1  3625946 3625946   7.655 0.006237 ** 
## race          2  8712354 4356177   9.196 0.000156 ***
## Residuals   185 87631356  473683                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
With p-value less than 0.05 for both the `smoke` variable and the `race` variables we can say that both variables are significant in determining a child's weight.  

Before rejecting the null hypothesis let us first check to see if all the ANOVA assumptions were satisfied in the dataset

### TWO WAY ANOVA ASSUMPTIONS VERIFICATION  
1. **Check for equal variance**  
  The levene test can be used to check for equality of variance  


```r
levene_test <- car::leveneTest(birth_weight ~ smoke * race, data = birthweight_data)

levene_test
```

```
## Levene's Test for Homogeneity of Variance (center = median)
##        Df F value Pr(>F)
## group   5   0.345  0.885
##       183
```
p-value greater than 0.05 tells us that there is no significance difference in the mean, hence the assumption is satisfied  

2. **Check if residuals are normally distributed**  


```r
plot(TwoWay_anova, 2, col = "lightblue")
```

{{<figure src="/post/anova-in-r/index_files/figure-html/unnamed-chunk-25-1.png" alt="two way anova in r normallity plot">}}
We can see that the residuals are normally distributed i.e follows the straight line.  

**Verify normality using the shapiro wilk test**

```r
shapiro.test(TwoWay_anova$residuals)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  TwoWay_anova$residuals
## W = 0.98926, p-value = 0.1664
```
p-value greater than our 0.05 threshold.  

We can now reject the null hypothesis and conclude that both the `smoke` and the `race` variables are significant in determining a child's birth_weight.  





