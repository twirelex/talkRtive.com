---
title: Predicting the result of a Virtual football match of a betting site using R/Rstudio
author: ''
date: '2020-07-20'
slug: predicting-the-result-of-a-virtual-football-game
categories:
  - modelling
tags: []
subtitle: ''
summary: 'Predicting the result of a virtual football game with decision tree and random forest algorithms.'
authors: []
lastmod: '2020-07-20T17:39:32+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---
## After successfully scrapping data from a football betting site we will now build a simple model to see how well it will perform in predicting the result of any match.  

Below are some information about the dataset:  
   
* **home      -->** *A premier league club at home to play against an opponent*
* **away      -->** *A premier league club away from home to play against the home team*
* **homeOdd   -->** *the odds that the home team will win a particular match*
* **drawOdd   -->** *the odds that both teams will draw a particular match*
* **awaysOdd  -->** *the odds that the away team will win particular match*
* **homeR     -->** *result of the home team after a particular match*
* **awayR     -->** *result of the away team after a particular match*
* **matchtime -->** *the time a particular match was played*
* **leagueW   -->** *the week a particular match was played*
* **day       -->** *the day a particular match was played*


### Leggo.


```r
require(tidyverse)
```

Read in the dataset and check its dimension


```r
bet9ja <- read_csv("C:/Users/wirelex/Downloads/bet9ja(2).csv")
```

```
## Parsed with column specification:
## cols(
##   home = col_character(),
##   away = col_character(),
##   homeOdd = col_double(),
##   drawOdd = col_double(),
##   awaysOdd = col_double(),
##   homeR = col_double(),
##   awayR = col_double(),
##   matchtime = col_time(format = ""),
##   leagueWK = col_character(),
##   day = col_character()
## )
```

```r
dim(bet9ja) ## see the dimension of the data
```

```
## [1] 14410    10
```

Overview of the data


```r
require(knitr)

kable(head(bet9ja))
```



|home |away | homeOdd| drawOdd| awaysOdd| homeR| awayR|matchtime |leagueWK |day    |
|:----|:----|-------:|-------:|--------:|-----:|-----:|:---------|:--------|:------|
|WAT  |LIV  |    6.08|    4.37|     1.52|     0|     3|16:32:00  |WEEK 34  |Friday |
|EVE  |NWC  |    2.38|    3.20|     3.13|     0|     2|16:32:00  |WEEK 34  |Friday |
|TOT  |BUR  |    1.46|    4.38|     7.18|     3|     1|16:32:00  |WEEK 34  |Friday |
|BOU  |MNU  |    3.54|    3.00|     2.30|     0|     1|16:32:00  |WEEK 34  |Friday |
|BRI  |ASV  |    2.29|    3.02|     3.53|     0|     1|16:32:00  |WEEK 34  |Friday |
|CHE  |NOR  |    1.46|    4.38|     7.18|     3|     1|16:32:00  |WEEK 34  |Friday |



```r
glimpse(bet9ja)
```

```
## Observations: 14,410
## Variables: 10
## $ home      <chr> "WAT", "EVE", "TOT", "BOU", "BRI", "CHE", "WHU", "WOL", "...
## $ away      <chr> "LIV", "NWC", "BUR", "MNU", "ASV", "NOR", "SOU", "MNC", "...
## $ homeOdd   <dbl> 6.08, 2.38, 1.46, 3.54, 2.29, 1.46, 1.94, 4.16, 3.02, 2.0...
## $ drawOdd   <dbl> 4.37, 3.20, 4.38, 3.00, 3.02, 4.38, 3.32, 3.81, 3.19, 3.2...
## $ awaysOdd  <dbl> 1.52, 3.13, 7.18, 2.30, 3.53, 7.18, 4.25, 1.82, 2.46, 3.9...
## $ homeR     <dbl> 0, 0, 3, 0, 0, 3, 1, 2, 1, 1, 2, 1, 0, 3, 3, 5, 1, 0, 2, ...
## $ awayR     <dbl> 3, 2, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 2, 0, 3, 1, 3, 3, 1, ...
## $ matchtime <time> 16:32:00, 16:32:00, 16:32:00, 16:32:00, 16:32:00, 16:32:...
## $ leagueWK  <chr> "WEEK 34", "WEEK 34", "WEEK 34", "WEEK 34", "WEEK 34", "W...
## $ day       <chr> "Friday", "Friday", "Friday", "Friday", "Friday", "Friday...
```
we do not have a response variable yet so we need to first create a response variable before proceeding.  
we will create the new variable from our homeR and awayR variables and call the new variable "result", we will encode the "result" variable as follow:
* 1 when the home team wins
* 0 when the game ends in a draw
* 2 when the away team wins


```r
bet9ja <- bet9ja %>% 
  mutate(result = factor(case_when(homeR > awayR ~ 1, homeR < awayR ~ 2, TRUE ~ 0))) %>%
  select(-homeR, -awayR) # remove the homeR variable and awayR variable as we will no longer need them
```

we have now added a 3 category response/dependent variable and this means that we will be building a multiclass classification model. 

some of the variables are represented as character variables but we will need them to be categorical variables for the sake of the algorithm we want to make use of.


```r
bet9ja <- bet9ja %>% 
  mutate_if(is.character, as.factor)
```



## DATA EXPLORATION

If you are familiar with the way football betting works you will know that "odds" play a huge role on whether a team will win a particular game or not. So let us first visually see the relationship between the odds variables and the result variable.

Let us discretize the odds variables and do a plot

```r
bet9ja %>% 
  transmute(result, homeOdd = factor(case_when(homeOdd <= 1.5 ~ "smallO", homeOdd > 1.5 & homeOdd <= 2 ~ "mediumO", homeOdd > 2 ~ "bigO"))) %>% 
  ggplot(aes(result, fill = result)) + geom_bar(show.legend = FALSE) + facet_wrap(~homeOdd) + theme_bw() +scale_y_continuous(labels = NULL) + labs(y = NULL, title = "HOME TEAM ODDS PLOT") + theme(plot.title = element_text(hjust = 0.5))
```

<img src="/post/predicting-the-result-of-a-virtual-football-match-of-a-betting-site/index_files/figure-html/unnamed-chunk-7-1.png" width="768" />
**The plot above is trying to convince us that when a team is home and its winning odds is big i.e above 2 then the match will likely end up in favor of its opponent(away team), but when its winning odds is small or medium i.e between 1 and 2 then the match will most likely end in favor of the team..**


```r
bet9ja %>% 
  transmute(result, awaysOdd = factor(case_when(awaysOdd <= 1.5 ~ "smallO", awaysOdd > 1.5 & awaysOdd <= 2 ~ "mediumO", awaysOdd > 2 ~ "bigO"))) %>% 
  ggplot(aes(result, fill = result)) + geom_bar(show.legend = FALSE) + facet_wrap(~awaysOdd) + theme_bw() +scale_y_continuous(labels = NULL) + labs(y = NULL, title = "AWAY TEAM ODDS PLOT") + theme(plot.title = element_text(hjust = 0.5))
```

<img src="/post/predicting-the-result-of-a-virtual-football-match-of-a-betting-site/index_files/figure-html/unnamed-chunk-8-1.png" width="768" />
**According to the plot above, when a team is away and it is giving a big winning odds in a particular match i.e odds above 2, the game will likely end up in favor of the opposition team(home team), but when the team is giving a small/medium winning odds i.e between 1 and 2 then the match will likely end up in the team's favor**  

## MODELING  

Now that we have an idea of what the relationship between the odds variables and the result variable looks like let us go ahead and build a predictive model.


let's build a decision tree model using tidymodels parsnip 


```r
require(doSNOW) # for parallel processing in windows OS

cl <- makeCluster(6, type = "SOCK") 
registerDoSNOW(cl)
```

**split data into training and testing**


```r
require(tidymodels) # for modeling

splitdata <- initial_split(bet9ja)
traindata <- training(splitdata)
testdata <- testing(splitdata)
```

**fitting**

```r
set.seed(112)
dt_model <- decision_tree(mode = "classification") %>% 
  set_engine("C5.0") %>% 
  fit(result~., data = traindata)
```

**make prediction on test data and view confusion matrix**


```r
prediction <- dt_model %>% 
  predict(testdata) %>% 
  transmute(actual = testdata$result, rename(.,predicted = .pred_class)) 
kable(head(prediction, 10))
```



|actual |predicted |
|:------|:---------|
|2      |2         |
|2      |1         |
|2      |2         |
|1      |1         |
|1      |1         |
|2      |2         |
|1      |1         |
|0      |1         |
|0      |2         |
|0      |2         |
we can see that there are few misclassifications


```r
require(caret) # confusionMatrix function

confusionMatrix(prediction$actual, prediction$predicted)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    0    1    2
##          0    0  610  364
##          1    0 1179  330
##          2    0  491  628
## 
## Overall Statistics
##                                           
##                Accuracy : 0.5017          
##                  95% CI : (0.4852, 0.5181)
##     No Information Rate : 0.633           
##     P-Value [Acc > NIR] : 1               
##                                           
##                   Kappa : 0.1973          
##                                           
##  Mcnemar's Test P-Value : <2e-16          
## 
## Statistics by Class:
## 
##                      Class: 0 Class: 1 Class: 2
## Sensitivity                NA   0.5171   0.4750
## Specificity            0.7296   0.7504   0.7846
## Pos Pred Value             NA   0.7813   0.5612
## Neg Pred Value             NA   0.4740   0.7205
## Prevalence             0.0000   0.6330   0.3670
## Detection Rate         0.0000   0.3273   0.1743
## Detection Prevalence   0.2704   0.4189   0.3107
## Balanced Accuracy          NA   0.6337   0.6298
```

 The decision tree model produced an accuracy of about 49%

Now let us try to build a random forest model to see if there will be any improvement


```r
set.seed(111)
rf_model <- rand_forest(mode = "classification") %>% 
  set_engine("ranger", importance = "permutation") %>% 
  fit(result~., data = traindata)
```



```r
prediction2 <- rf_model %>% 
  predict(testdata) %>% 
  transmute(actual = testdata$result, rename(., predicted = .pred_class)) 
confusionMatrix(prediction2$actual, prediction2$predicted)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    0    1    2
##          0  129  559  286
##          1  187 1077  245
##          2  176  453  490
## 
## Overall Statistics
##                                           
##                Accuracy : 0.4708          
##                  95% CI : (0.4544, 0.4873)
##     No Information Rate : 0.58            
##     P-Value [Acc > NIR] : 1               
##                                           
##                   Kappa : 0.1628          
##                                           
##  Mcnemar's Test P-Value : <2e-16          
## 
## Statistics by Class:
## 
##                      Class: 0 Class: 1 Class: 2
## Sensitivity           0.26220   0.5156   0.4799
## Specificity           0.72830   0.7145   0.7563
## Pos Pred Value        0.13244   0.7137   0.4379
## Neg Pred Value        0.86187   0.5165   0.7861
## Prevalence            0.13659   0.5800   0.2835
## Detection Rate        0.03581   0.2990   0.1360
## Detection Prevalence  0.27041   0.4189   0.3107
## Balanced Accuracy     0.49525   0.6150   0.6181
```
The decision tree model performed better judging with the Accuracy

lets view how well each of the variables performed in the model


```r
require(vip) # variable importance plot function "vip()"

rf_model %>% 
  vip(geom = "point")
```

<img src="/post/predicting-the-result-of-a-virtual-football-match-of-a-betting-site/index_files/figure-html/unnamed-chunk-16-1.png" width="672" />
From the plot above we can clearly see that the odds variables were the most effective predictor variables.  

### OBSERVATION  

Both models didn't give us the best result but from our analysis we can see that variables that are the most significant determinant of the outcome of any virtual football game are the odds variables, the teams involved or the time/day the game is played doesn't matter that much...  

### CONCLUSION  

With an accuracy less than 50% a decision tree and a random forest model are probably not the best models to depend on when it comes to virtual football game prediction. 
