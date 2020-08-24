---
title: Logistic regression in r
author: ''
date: '2020-08-22'
slug: logistic-regression-in-r
categories:
  - r programming
tags: []
subtitle: ''
summary: 'In this lesson we will try to understand Logistic Regression in r and how to build a predictive model with it.'
authors: []
lastmod: '2020-08-23T17:09:56+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---  




In this lesson we will try and get an intuitive understanding of how Logistic Regression works.  
Logistic regression can be used for both regression and classification machine learning problems i.e When the dependent/response variable is continuous or discrete, but it does better when the dependent variable is discrete(Binary) i.e yes or no, good or bad, 0 or 1 etc....  

## So what exactly is Logistic regression?
I found a good definition on <a href="https://simple.wikipedia.org/wiki/Logistic_Regression" target="_blank" rel="nofollow noopener"> wikipedia </a>  
"Logistic Regression, also known as Logit Regression or Logit Model, is a mathematical model used in statistics to estimate (guess) the probability of an event occurring having been given some previous data".  

Unlike [linear regression]({{< ref "post/linear-regression-in-r/index.Rmarkdown" >}}) that tries to make predictions by finding a linear (straight line) equation to model or predict future data points. Logistic regression does not look at the relationship between the two variables as a straight line. Instead, Logistic regression uses the natural logarithm function to find the relationship between the variables and uses test data to find the coefficients.  
Below is a sigmoid curve representing the Logistic model  

{{< figure library="true" src="logistic-regression-in-r/sigmoid_curve.png" alt="logistic regression sigmoid curve">}}  

Probability lies between **0** and **1**.  
In summary; we try to find the best fit **sigmoid** curve through the points of our data with Logistic Regression.  

In Logistic regression the `odds ratio` can be used to measure the strength between two events. An odds ratio of **1** implies that both events are independent, if the odds ratio is greater than **1** it means that the presence of event A raises the odds of event B, vice versa. if the odds ratio is less than **1** it means that the presence of event A reduces the odds of event B and vice versa.  

Now that we have an understanding of how the logistic regression works let us use an example to gain practical knowledge.  

## EXAMPLE  

For this example we will make use of the popular <a href="https://www.kaggle.com/c/titanic/data target=_blank rel=nofollow noopener"> titanic dataset </a> from kaggle, we will try to create a model with the Logistic regression to predict whether a passenger in the titanic boat survived or died (survived = 1, died = 0).  

Let's start by loading required packages 


```r
require(tidyverse)
require(sjPlot)
require(InformationValue)
```

**Read in the train and test dataset**  


```r
titanic_train <- read_csv("https://raw.githubusercontent.com/twirelex/dataset/master/train(1).csv")
titanic_test <- read_csv("https://raw.githubusercontent.com/twirelex/dataset/master/test(1).csv")
```

**Let's take a look at the datasets and see what we have**  


```r
glimpse(titanic_train)
```

```
## Rows: 891
## Columns: 12
## $ PassengerId <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, ...
## $ Survived    <dbl> 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0...
## $ Pclass      <dbl> 3, 1, 3, 1, 3, 3, 1, 3, 3, 2, 3, 1, 3, 3, 3, 2, 3, 2, 3...
## $ Name        <chr> "Braund, Mr. Owen Harris", "Cumings, Mrs. John Bradley ...
## $ Sex         <chr> "male", "female", "female", "female", "male", "male", "...
## $ Age         <dbl> 22, 38, 26, 35, 35, NA, 54, 2, 27, 14, 4, 58, 20, 39, 1...
## $ SibSp       <dbl> 1, 1, 0, 1, 0, 0, 0, 3, 0, 1, 1, 0, 0, 1, 0, 0, 4, 0, 1...
## $ Parch       <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 1, 0, 0, 5, 0, 0, 1, 0, 0...
## $ Ticket      <chr> "A/5 21171", "PC 17599", "STON/O2. 3101282", "113803", ...
## $ Fare        <dbl> 7.2500, 71.2833, 7.9250, 53.1000, 8.0500, 8.4583, 51.86...
## $ Cabin       <chr> NA, "C85", NA, "C123", NA, NA, "E46", NA, NA, NA, "G6",...
## $ Embarked    <chr> "S", "C", "S", "S", "S", "Q", "S", "S", "S", "C", "S", ...
```


```r
glimpse(titanic_test)
```

```
## Rows: 418
## Columns: 11
## $ PassengerId <dbl> 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 902, ...
## $ Pclass      <dbl> 3, 3, 2, 3, 3, 3, 3, 2, 3, 3, 3, 1, 1, 2, 1, 2, 2, 3, 3...
## $ Name        <chr> "Kelly, Mr. James", "Wilkes, Mrs. James (Ellen Needs)",...
## $ Sex         <chr> "male", "female", "male", "male", "female", "male", "fe...
## $ Age         <dbl> 34.5, 47.0, 62.0, 27.0, 22.0, 14.0, 30.0, 26.0, 18.0, 2...
## $ SibSp       <dbl> 0, 1, 0, 0, 1, 0, 0, 1, 0, 2, 0, 0, 1, 1, 1, 1, 0, 0, 1...
## $ Parch       <dbl> 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ Ticket      <chr> "330911", "363272", "240276", "315154", "3101298", "753...
## $ Fare        <dbl> 7.8292, 7.0000, 9.6875, 8.6625, 12.2875, 9.2250, 7.6292...
## $ Cabin       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "B45", ...
## $ Embarked    <chr> "Q", "S", "Q", "S", "S", "S", "Q", "S", "C", "S", "S", ...
```
Notice that the train set has 11 independent variables with one dependent variable (`Survived`) while the test set has 11 independent variables without the dependent variable, this is because the test set is the unseen data that we want to predict on, so it does not have a dependent/response variable yet.  

**Let us view a summary statistics of these datasets to know if there are problems that we may need to first resolve before continuing**  


```r
summary(titanic_train)
```

```
##   PassengerId       Survived          Pclass          Name          
##  Min.   :  1.0   Min.   :0.0000   Min.   :1.000   Length:891        
##  1st Qu.:223.5   1st Qu.:0.0000   1st Qu.:2.000   Class :character  
##  Median :446.0   Median :0.0000   Median :3.000   Mode  :character  
##  Mean   :446.0   Mean   :0.3838   Mean   :2.309                     
##  3rd Qu.:668.5   3rd Qu.:1.0000   3rd Qu.:3.000                     
##  Max.   :891.0   Max.   :1.0000   Max.   :3.000                     
##                                                                     
##      Sex                 Age            SibSp           Parch       
##  Length:891         Min.   : 0.42   Min.   :0.000   Min.   :0.0000  
##  Class :character   1st Qu.:20.12   1st Qu.:0.000   1st Qu.:0.0000  
##  Mode  :character   Median :28.00   Median :0.000   Median :0.0000  
##                     Mean   :29.70   Mean   :0.523   Mean   :0.3816  
##                     3rd Qu.:38.00   3rd Qu.:1.000   3rd Qu.:0.0000  
##                     Max.   :80.00   Max.   :8.000   Max.   :6.0000  
##                     NA's   :177                                     
##     Ticket               Fare           Cabin             Embarked        
##  Length:891         Min.   :  0.00   Length:891         Length:891        
##  Class :character   1st Qu.:  7.91   Class :character   Class :character  
##  Mode  :character   Median : 14.45   Mode  :character   Mode  :character  
##                     Mean   : 32.20                                        
##                     3rd Qu.: 31.00                                        
##                     Max.   :512.33                                        
## 
```

```r
summary(titanic_test)
```

```
##   PassengerId         Pclass          Name               Sex           
##  Min.   : 892.0   Min.   :1.000   Length:418         Length:418        
##  1st Qu.: 996.2   1st Qu.:1.000   Class :character   Class :character  
##  Median :1100.5   Median :3.000   Mode  :character   Mode  :character  
##  Mean   :1100.5   Mean   :2.266                                        
##  3rd Qu.:1204.8   3rd Qu.:3.000                                        
##  Max.   :1309.0   Max.   :3.000                                        
##                                                                        
##       Age            SibSp            Parch           Ticket         
##  Min.   : 0.17   Min.   :0.0000   Min.   :0.0000   Length:418        
##  1st Qu.:21.00   1st Qu.:0.0000   1st Qu.:0.0000   Class :character  
##  Median :27.00   Median :0.0000   Median :0.0000   Mode  :character  
##  Mean   :30.27   Mean   :0.4474   Mean   :0.3923                     
##  3rd Qu.:39.00   3rd Qu.:1.0000   3rd Qu.:0.0000                     
##  Max.   :76.00   Max.   :8.0000   Max.   :9.0000                     
##  NA's   :86                                                          
##       Fare            Cabin             Embarked        
##  Min.   :  0.000   Length:418         Length:418        
##  1st Qu.:  7.896   Class :character   Class :character  
##  Median : 14.454   Mode  :character   Mode  :character  
##  Mean   : 35.627                                        
##  3rd Qu.: 31.500                                        
##  Max.   :512.329                                        
##  NA's   :1
```


## DATA PREPARATION

It appears that there are missing values in both the train set and the test set and this can be a problem for our machine learning algorithm. So to fix this problem it will make sense if we first combine the train and test set into one dataframe and then go ahead to clean the combined dataframe as we see fit, and separate them again into train and test. We do not necessarily have to combine both dataset before performing the cleaning operation but in other for us not to repeat the same process on both dataset it will be more efficient if we first treat them as one.  

Combining the datasets is easy but we will need a way to be able to identify them separately when we want to split them back into train and test so that we don't end up having a mixed up train and test set that is different from our original sets.  

Let's create a variable called `identifier` where the train set will take values **TRUE** and the test set will take values **FALSE**, this way we will be able to differentiate the datasets after combining them.  

```r
titanic_train <- titanic_train %>% mutate(identifier = TRUE)

titanic_test <- titanic_test %>% mutate(identifier = FALSE)
```

Now that we have created an `identifier` column, for us to be able to combine the datasets we need to make sure that we have the same number of variables in both datasets, remember that the `test` set doesn't have response/dependent variable. 
so we will create `Survived` variable with values that doesn't really matter and then combine the datasets.


```r
titanic_test <- titanic_test %>% mutate(Survived = 0)

dim(titanic_test)
```

```
## [1] 418  13
```

now we have the same number of variables in both datasets  

**Combine datasets**  


```r
titanic_combined <- titanic_train %>% bind_rows(titanic_test)

dim(titanic_combined)
```

```
## [1] 1309   13
```

**To reduce computational time we are only going to use the independent variables  `Age`, `Pclass`, `SibSp`, `Sex`, `Parch`, `Fare`, `Embarked` in our model**  



```r
knitr::kable(head(titanic_combined))
```



| PassengerId| Survived| Pclass|Name                                                |Sex    | Age| SibSp| Parch|Ticket           |    Fare|Cabin |Embarked |identifier |
|-----------:|--------:|------:|:---------------------------------------------------|:------|---:|-----:|-----:|:----------------|-------:|:-----|:--------|:----------|
|           1|        0|      3|Braund, Mr. Owen Harris                             |male   |  22|     1|     0|A/5 21171        |  7.2500|NA    |S        |TRUE       |
|           2|        1|      1|Cumings, Mrs. John Bradley (Florence Briggs Thayer) |female |  38|     1|     0|PC 17599         | 71.2833|C85   |C        |TRUE       |
|           3|        1|      3|Heikkinen, Miss. Laina                              |female |  26|     0|     0|STON/O2. 3101282 |  7.9250|NA    |S        |TRUE       |
|           4|        1|      1|Futrelle, Mrs. Jacques Heath (Lily May Peel)        |female |  35|     1|     0|113803           | 53.1000|C123  |S        |TRUE       |
|           5|        0|      3|Allen, Mr. William Henry                            |male   |  35|     0|     0|373450           |  8.0500|NA    |S        |TRUE       |
|           6|        0|      3|Moran, Mr. James                                    |male   |  NA|     0|     0|330877           |  8.4583|NA    |Q        |TRUE       |


Once again let us see the variables that has missing values  

```r
colSums(is.na(titanic_combined))
```

```
## PassengerId    Survived      Pclass        Name         Sex         Age 
##           0           0           0           0           0         263 
##       SibSp       Parch      Ticket        Fare       Cabin    Embarked 
##           0           0           0           1        1014           2 
##  identifier 
##           0
```

we can see that  `Age`, `Fare`, `Cabin` and `Embarked` has missing values

We could omit the observations with missing values and go on with modeling but there appears to be much missing values so omitting values could cause lost of vital patterns/information for our model.  

For numeric variables with missing values like `Age` and `Fare` we will replace all the missing values with the mean value,  for `Embarked` that has only 3 unique values we are going to replace the missing values with the most frequent among the 3 unique values, and for `Cabin` we won't bother replacing the missing values since we won't be making use of it in our model.  

**Replace missing values**  


```r
titanic_combined <- titanic_combined %>% 
  mutate(Age = replace_na(titanic_combined$Age, mean(titanic_combined$Age, na.rm = TRUE)))

titanic_combined <- titanic_combined %>% 
  mutate(Fare = replace_na(titanic_combined$Fare, mean(titanic_combined$Fare, na.rm = TRUE)))

titanic_combined <- titanic_combined %>% 
  mutate(Embarked = replace_na(titanic_combined$Embarked, "S")) # S has the highest frequency
```

Let us convert mis-represented variables to their right classes before splitting back the dataframe  


```r
titanic_combined <- titanic_combined %>% 
  mutate(Pclass = factor(Pclass), Sex = factor(Sex), Embarked = factor(Embarked))
```



Our next step will be to split the dataframe back into train and test  


```r
titanic_train <- titanic_combined %>% filter(identifier == TRUE)

titanic_test <- titanic_combined %>% filter(identifier == FALSE)
```

**It is time to build our machine learning model with the Logistic Regression algorithm.**  


## BUILD MODEL  

In base r the `glm` function can be used to build a logistic regression model. glm stands for Generalized Linear Model  

**Build model with variables `Age`, `Pclass`, `SibSp`, `Sex`, `Parch`, `Fare`, `Embarked` on train set**  


```r
glm_model <- glm(factor(Survived) ~ Age + Pclass + SibSp + Sex + Parch + Fare + Embarked, data = titanic_train, family = "binomial")
```
By specifying `family = "binomial"` we are simply indicating that we want to build a model where the dependent variable has a binary class.


**View summary of the model**  

```r
summary(glm_model)
```

```
## 
## Call:
## glm(formula = factor(Survived) ~ Age + Pclass + SibSp + Sex + 
##     Parch + Fare + Embarked, family = "binomial", data = titanic_train)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.6271  -0.6093  -0.4218   0.6173   2.4497  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  4.108317   0.476722   8.618  < 2e-16 ***
## Age         -0.039136   0.007872  -4.972 6.64e-07 ***
## Pclass2     -0.932800   0.297867  -3.132  0.00174 ** 
## Pclass3     -2.156069   0.297799  -7.240 4.49e-13 ***
## SibSp       -0.323596   0.109731  -2.949  0.00319 ** 
## Sexmale     -2.718678   0.201099 -13.519  < 2e-16 ***
## Parch       -0.097449   0.119052  -0.819  0.41305    
## Fare         0.002292   0.002469   0.928  0.35325    
## EmbarkedQ   -0.025521   0.382000  -0.067  0.94673    
## EmbarkedS   -0.440410   0.239742  -1.837  0.06621 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1186.66  on 890  degrees of freedom
## Residual deviance:  784.29  on 881  degrees of freedom
## AIC: 804.29
## 
## Number of Fisher Scoring iterations: 5
```


View odds ratio for the different variables and their confidence interval

```r
cbind(OddsRatio = exp(coef(glm_model)), exp(confint(glm_model)))
```

```
## Waiting for profiling to be done...
```

```
##               OddsRatio       2.5 %       97.5 %
## (Intercept) 60.84423629 24.32071866 158.09150061
## Age          0.96161966  0.94661598   0.97632183
## Pclass2      0.39345059  0.21881391   0.70486069
## Pclass3      0.11577933  0.06432297   0.20737196
## SibSp        0.72354242  0.57726681   0.88778644
## Sexmale      0.06596191  0.04406360   0.09701964
## Parch        0.90714829  0.71368308   1.14206703
## Fare         1.00229446  0.99775065   1.00771029
## EmbarkedQ    0.97480158  0.45905843   2.05650258
## EmbarkedS    0.64377261  0.40262763   1.03184763
```

We can also visualize the odds ratio using a forest plot of estimates

```r
plot_model(glm_model)
```

{{<figure src="/post/logistic-regression-in-r/index_files/figure-html/unnamed-chunk-19-1.png" alt="forest plot showing the odds ratio for the different variables">}}
Most of the variables falls at the left side of the plot, this means that they have a relationship with the response variable.

**Evaluate the performance of our model on the same train set with a ROC curve**  



```r
plotROC(titanic_train$Survived, predict(glm_model, titanic_train, type = "response"))
```

{{<figure src="/post/logistic-regression-in-r/index_files/figure-html/unnamed-chunk-20-1.png" alt="ROC auc curve showing model performance">}}


An AUC of 85 is fairly okay but since we fitted this model on the same train set we predicted on without cross-validation, there is a high possibility that the model overfitted. For the sake of trying to keep things simple we won't apply cross-validation in this example.  

**Predict on test set**  


```r
test_predict <- predict(glm_model, titanic_test, type = "response")

head(test_predict) %>% knitr::kable()
```



|         x|
|---------:|
| 0.1067660|
| 0.3463505|
| 0.1220747|
| 0.0958972|
| 0.5641337|
| 0.1501270|



We get a probability score for our response variable when using glm, we can however set a threshold score depending on our preference. i.e we can classify all predictions with probability score greater than or equal to 0.5 as 1 and all probability score less than 0.5 as 0, where **1** indicates that a passenger survived and **0** means that the passenger didn't survive  

**Make a threshold**  
Now we will create a threshold of **0.5**. all values greater than or equal to **0.5** will be classified as **1** and **0** otherwise


```r
bind_cols(titanic_test[, c(3, 5, 6, 7, 8, 10, 12)], Survived = if_else(test_predict >= 0.5, 1, 0)) %>% head(10) %>% knitr::kable()
```



|Pclass |Sex    |  Age| SibSp| Parch|    Fare|Embarked | Survived|
|:------|:------|----:|-----:|-----:|-------:|:--------|--------:|
|3      |male   | 34.5|     0|     0|  7.8292|Q        |        0|
|3      |female | 47.0|     1|     0|  7.0000|S        |        0|
|2      |male   | 62.0|     0|     0|  9.6875|Q        |        0|
|3      |male   | 27.0|     0|     0|  8.6625|S        |        0|
|3      |female | 22.0|     1|     1| 12.2875|S        |        1|
|3      |male   | 14.0|     0|     0|  9.2250|S        |        0|
|3      |female | 30.0|     0|     0|  7.6292|Q        |        1|
|2      |male   | 26.0|     1|     1| 29.0000|S        |        0|
|3      |female | 18.0|     0|     0|  7.2292|C        |        1|
|3      |male   | 21.0|     2|     0| 24.1500|S        |        0|

With the simple example above we have successfully built a Logistic Regression model.















