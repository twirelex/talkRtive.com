---
title: Predicting the result of a Virtual football match using tidymodels
author: ''
date: '2023-06-02'
slug: tidymodels-virtual-football-prediction
categories: [r programming, tidymodels]
tags: []
subtitle: ''
summary: 'Predicting the result of a virtual football game with SVM and random forest algorithms using the tidymodels r package'
authors: []
lastmod: '2023-06-02T17:31:32+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---



## After successfully [scraping data from a football betting site]({{< ref "post/RSelenium-web-scraping" >}})  i will now build a simple model using tidymodels r package to see how well it will perform in predicting the result of the games.  

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

**install the tidymodels r package**

```
install.packages("tidymodels") # skip this step if you already have the tidymodels package
```
**load the package**


```r
require(tidyverse)
```

**Read in the dataset and check its dimension**


```r
bet9ja <- read_csv("https://raw.githubusercontent.com/twirelex/dataset/master/bet9ja(2).csv")
```

```
## Rows: 14410 Columns: 10
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (4): home, away, leagueWK, day
## dbl  (5): homeOdd, drawOdd, awaysOdd, homeR, awayR
## time (1): matchtime
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
dim(bet9ja) ## see the dimension of the data
```

```
## [1] 14410    10
```

**Overview of the data**


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
## Rows: 14,410
## Columns: 10
## $ home      <chr> "WAT", "EVE", "TOT", "BOU", "BRI", "CHE", "WHU", "WOL", "SHU…
## $ away      <chr> "LIV", "NWC", "BUR", "MNU", "ASV", "NOR", "SOU", "MNC", "CRY…
## $ homeOdd   <dbl> 6.08, 2.38, 1.46, 3.54, 2.29, 1.46, 1.94, 4.16, 3.02, 2.05, …
## $ drawOdd   <dbl> 4.37, 3.20, 4.38, 3.00, 3.02, 4.38, 3.32, 3.81, 3.19, 3.21, …
## $ awaysOdd  <dbl> 1.52, 3.13, 7.18, 2.30, 3.53, 7.18, 4.25, 1.82, 2.46, 3.95, …
## $ homeR     <dbl> 0, 0, 3, 0, 0, 3, 1, 2, 1, 1, 2, 1, 0, 3, 3, 5, 1, 0, 2, 2, …
## $ awayR     <dbl> 3, 2, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 2, 0, 3, 1, 3, 3, 1, 2, …
## $ matchtime <time> 16:32:00, 16:32:00, 16:32:00, 16:32:00, 16:32:00, 16:32:00,…
## $ leagueWK  <chr> "WEEK 34", "WEEK 34", "WEEK 34", "WEEK 34", "WEEK 34", "WEEK…
## $ day       <chr> "Friday", "Friday", "Friday", "Friday", "Friday", "Friday", …
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
  transmute(result, homeOdd = factor(
    case_when(
      homeOdd <= 1.5 ~ "smallO",
      homeOdd > 1.5 &
        homeOdd <= 2 ~ "mediumO",
      homeOdd > 2 ~ "bigO"
    )
  )) %>%
  ggplot(aes(result, fill = result)) + geom_bar(show.legend = FALSE) + facet_wrap( ~ homeOdd) + theme_bw() + scale_y_continuous(labels = NULL) + labs(y = NULL, title = "HOME TEAM ODDS PLOT") + theme(plot.title = element_text(hjust = 0.5))
```

{{<figure src="index_files/figure-html/unnamed-chunk-8-1.png" alt="barplot showing the home team odds">}}
**The plot above is trying to convince us that when a team is home and its winning odds is big i.e above 2 then the match will likely end up in favor of its opponent(away team), but when its winning odds is small or medium i.e between 1 and 2 then the match will most likely end in favor of the team..**


```r
bet9ja %>%
  transmute(result, awaysOdd = factor(
    case_when(
      awaysOdd <= 1.5 ~ "smallO",
      awaysOdd > 1.5 &
        awaysOdd <= 2 ~ "mediumO",
      awaysOdd > 2 ~ "bigO"
    )
  )) %>%
  ggplot(aes(result, fill = result)) + geom_bar(show.legend = FALSE) + facet_wrap( ~ awaysOdd) + theme_bw() + scale_y_continuous(labels = NULL) + labs(y = NULL, title = "AWAY TEAM ODDS PLOT") + theme(plot.title = element_text(hjust = 0.5))
```

{{<figure src="index_files/figure-html/unnamed-chunk-9-1.png" alt="barplot showing the away team odds.">}}
**According to the plot above, when a team is away and it is giving a big winning odds in a particular match i.e odds above 2, the game will likely end up in favor of the opposition team(home team), but when the team is giving a small/medium winning odds i.e between 1 and 2 then the match will likely end up in the team's favor**  

## MODELING  

Now that we have an idea of what the relationship between the odds variables and the result variable looks like let us go ahead and build a predictive model using the tidymodels r package.


let's build a svm model using tidymodels parsnip 


```r
require(doSNOW) # for parallel processing in windows OS

cl <- makeCluster(6, type = "SOCK") 
registerDoSNOW(cl)
```

**split data into training and testing**


```r
require(tidymodels) # for modeling

set.seed(111) # setting seed for reproducibility

splitdata <- initial_split(bet9ja)
traindata <- training(splitdata)
testdata <- testing(splitdata)
```


**fitting**


```r
svm_model <- svm_rbf(mode = "classification") %>% 
  set_engine("kernlab") %>% 
  fit(result~., data = traindata)
```

**make prediction on test data and view confusion matrix**


```r
prediction <- svm_model %>% 
  predict(testdata) %>% 
  transmute(actual = testdata$result, rename(.,predicted = .pred_class)) 
kable(head(prediction, 10))
```



|actual |predicted |
|:------|:---------|
|2      |2         |
|2      |1         |
|2      |0         |
|0      |1         |
|0      |1         |
|2      |2         |
|0      |1         |
|0      |1         |
|0      |1         |
|1      |1         |
we can see that there are few misclassifications


```r
prediction %>% 
  conf_mat(actual, predicted) # view confusion matrix
```

```
##           Truth
## Prediction    0    1    2
##          0    8   11   17
##          1  677 1244  548
##          2  300  290  508
```


```r
prediction %>% accuracy(actual, predicted) # check accuracy
```

```
## # A tibble: 1 × 3
##   .metric  .estimator .estimate
##   <chr>    <chr>          <dbl>
## 1 accuracy multiclass     0.488
```


 The svm model produced an accuracy of about 49%

Now let us try to build a random forest model to see if there will be any improvement


```r
rf_model <- rand_forest(mode = "classification") %>% 
  set_engine("ranger", importance = "permutation") %>% 
  fit(result~., data = traindata)
```

**make prediction on test data and view confusion matrix**


```r
prediction2 <- rf_model %>% 
  predict(testdata) %>% 
  transmute(actual = testdata$result, rename(., predicted = .pred_class)) 
kable(head(prediction2, 10))
```



|actual |predicted |
|:------|:---------|
|2      |2         |
|2      |1         |
|2      |0         |
|0      |1         |
|0      |2         |
|2      |2         |
|0      |1         |
|0      |1         |
|0      |1         |
|1      |1         |



```r
prediction2 %>% 
  conf_mat(actual, predicted) # view confusion matrix
```

```
##           Truth
## Prediction    0    1    2
##          0  131  166  143
##          1  548 1074  441
##          2  306  305  489
```



```r
prediction2 %>% accuracy(actual, predicted) # check accuracy
```

```
## # A tibble: 1 × 3
##   .metric  .estimator .estimate
##   <chr>    <chr>          <dbl>
## 1 accuracy multiclass     0.470
```


The svm model performed better judging with the Accuracy

lets view how well each of the variables performed in the model


```r
require(vip) # variable importance plot function "vip()"

rf_model %>% 
  vip(geom = "point")
```

{{<figure src="index_files/figure-html/unnamed-chunk-20-1.png" alt="scatterplot showing variable importance of the variables">}}
From the plot above we can clearly see that the odds variables were the most effective predictor variables.  

### OBSERVATION  

Both models didn't give us the best result but from our analysis we can see that variables that are the most significant determinant of the outcome of any virtual football game are the odds variables, the teams involved or the time/day the game is played doesn't matter that much...  

### CONCLUSION  

With an accuracy less than 50% the SVM and a random forest model are probably not the best models to depend on when it comes to virtual football game prediction.  


### Wrap-up  
Shifting from the base r and caret way of modeling can be hard for some of us but seeing how far the tidymodels is preparing to take us (timely upgrade/update) is enough reason for everyone to start trying it out. And also, knowing that the brain behind the caret package is also part  of the tidymodels team makes it even more interesting. I have prepared a short and comprehensive lesson on tidymodels that might be helpful.. [Tidymodels for beginners]({{< ref "post/tidymodels-for-beginners" >}})
