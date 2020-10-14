---
title: Random forest in R using the tidymodels framework
author: ''
date: '2020-10-14'
slug: RandomForest-using-tidymodels-FrameWork
categories:
  - r programming
  - tidymodels
tags: []
subtitle: ''
summary: 'The Random forest algorithm is one of the most used algorithm for building machine learning models. The random forest algorithm is a tree based algorithm that combines several decision trees of varying depth, and it is mostly used for classification problems.'
authors: []
lastmod: '2020-10-09T12:52:55+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---  




The Random forest algorithm is one of the most used algorithm for building machine learning models. The random forest algorithm is a tree based algorithm that combines several decision trees of varying depth, and it is mostly used for classification problems. Every decision tree in the forest is trained on a subset of the dataset called the bootstrapped dataset.  

In this lesson we are going to build a random forest model using the tidymodels framework. We will use some great packages in the tidymodels framework to tune the hyperparameters of a random forest model and use the hyperparameters with the best performance to fit the final model.  

### PRACTICE  

The dataset we are going to make use of has a binary response (outcome, dependent) variable called `admit`. There are three predictor variables: `gre`, `gpa` and `rank`. We will treat the variables `gre` and `gpa` as continuous. The variable `rank` takes on the values 1 through 4. Our aim is to predict `admit` given the other three variables.

**LOAD REQUIRED PACKAGES**

```r
require(tidyverse)

require(tidymodels)

require(doSNOW)
```

## IMPORT DATASET  


```r
data <- read_csv("https://raw.githubusercontent.com/twirelex/dataset/master/binary.csv")
```

```
## Parsed with column specification:
## cols(
##   admit = col_double(),
##   gre = col_double(),
##   gpa = col_double(),
##   rank = col_double()
## )
```


We need to convert the `rank` variable and our `admit` (target) variable to a factor  



```r
data <- data %>% 
  mutate(rank = factor(rank)) %>% 
  mutate(admit = factor(admit))
```



## BUILD RANDOM FOREST MODEL IN R  

The first step in this model building process is to split our data into train and test.  

**MAKE TRAIN AND TEST DATA**  


```r
set.seed(123)

data_split <- initial_split(data, strata = admit)

data_train <- training(data_split)

data_test <- testing(data_split)
```

**HYPERPARAMETERS**  

Now we will create a model specification for a random forest where we will tune mtry (the number of predictors to sample at each split) and min_n (the number of observations needed to keep splitting nodes).  


```r
tuning_spec <- rand_forest(
  mtry = tune(),
  trees = 1000,
  min_n = tune()
) %>%
  set_mode("classification") %>%
  set_engine("ranger")  
```

**TRAIN HYERPARAMETERS**  

Now it’s time to tune the hyperparameters for a random forest model. we will first create a set of cross-validation resamples to use for tuning.


```r
set.seed(234)

data_folds <- vfold_cv(data_train)
```


We can’t learn the right values when training a single model, but we can train a whole bunch of models and see which ones turn out best. We can use parallel processing to make this go faster, since the different parts of the grid are independent. Let’s use grid = 20 to choose 20 grid points automatically.  




```r
cl <- makeSOCKcluster(6, type = "SOCK")

registerDoSNOW(cl)  # Activate parallel processing
```



```r
set.seed(345)


tune_result <- tune_grid(
  tuning_spec,
  admit~.,
  resamples = data_folds,
  grid = 20
)
```

```
## i Creating pre-processing data to finalize unknown parameter: mtry
```

```r
tune_result
```

```
## # Tuning results
## # 10-fold cross-validation 
## # A tibble: 10 x 4
##    splits           id     .metrics          .notes          
##    <list>           <chr>  <list>            <list>          
##  1 <split [270/31]> Fold01 <tibble [40 x 6]> <tibble [0 x 1]>
##  2 <split [271/30]> Fold02 <tibble [40 x 6]> <tibble [0 x 1]>
##  3 <split [271/30]> Fold03 <tibble [40 x 6]> <tibble [0 x 1]>
##  4 <split [271/30]> Fold04 <tibble [40 x 6]> <tibble [0 x 1]>
##  5 <split [271/30]> Fold05 <tibble [40 x 6]> <tibble [0 x 1]>
##  6 <split [271/30]> Fold06 <tibble [40 x 6]> <tibble [0 x 1]>
##  7 <split [271/30]> Fold07 <tibble [40 x 6]> <tibble [0 x 1]>
##  8 <split [271/30]> Fold08 <tibble [40 x 6]> <tibble [0 x 1]>
##  9 <split [271/30]> Fold09 <tibble [40 x 6]> <tibble [0 x 1]>
## 10 <split [271/30]> Fold10 <tibble [40 x 6]> <tibble [0 x 1]>
```

We can take a look at AUC to see the various mtry and min_n values  


```r
tune_result %>%
  collect_metrics() %>%
  filter(.metric == "roc_auc") %>%
  select(mean, min_n, mtry) %>%
  pivot_longer(min_n:mtry,
    values_to = "value",
    names_to = "parameter"
  ) %>%
  ggplot(aes(value, mean, color = parameter)) +
  geom_point(show.legend = FALSE) +
  facet_wrap(~parameter, scales = "free_x") +
  labs(x = NULL, y = "AUC")
```

{{<figure src="/post/randomforest-using-tidymodels-framework/index_files/figure-html/unnamed-chunk-10-1.png" alt="r random forest hyperparameters scatter plot">}}

clearly, lower values of `mtry` are good (below 2) and higher values of `min_n` are good (above 30). We can get a better handle on the hyperparameters by tuning one more time, this time using regular_grid(). Let’s set ranges of hyperparameters we want to try, based on the results from our initial tune.  


```r
data_grid <- grid_regular(
  mtry(range = c(1, 2)),
  min_n(range = c(30, 40)),
  levels = 5
)

data_grid
```

```
## # A tibble: 10 x 2
##     mtry min_n
##    <int> <int>
##  1     1    30
##  2     2    30
##  3     1    32
##  4     2    32
##  5     1    35
##  6     2    35
##  7     1    37
##  8     2    37
##  9     1    40
## 10     2    40
```


We can tune one more time, but this time in a more targeted way with this `data_grid`.  


```r
set.seed(456)

regular_res <- tune_grid(
  tuning_spec,
  admit~.,
  resamples = data_folds,
  grid = data_grid
)

regular_res
```

```
## # Tuning results
## # 10-fold cross-validation 
## # A tibble: 10 x 4
##    splits           id     .metrics          .notes          
##    <list>           <chr>  <list>            <list>          
##  1 <split [270/31]> Fold01 <tibble [20 x 6]> <tibble [0 x 1]>
##  2 <split [271/30]> Fold02 <tibble [20 x 6]> <tibble [0 x 1]>
##  3 <split [271/30]> Fold03 <tibble [20 x 6]> <tibble [0 x 1]>
##  4 <split [271/30]> Fold04 <tibble [20 x 6]> <tibble [0 x 1]>
##  5 <split [271/30]> Fold05 <tibble [20 x 6]> <tibble [0 x 1]>
##  6 <split [271/30]> Fold06 <tibble [20 x 6]> <tibble [0 x 1]>
##  7 <split [271/30]> Fold07 <tibble [20 x 6]> <tibble [0 x 1]>
##  8 <split [271/30]> Fold08 <tibble [20 x 6]> <tibble [0 x 1]>
##  9 <split [271/30]> Fold09 <tibble [20 x 6]> <tibble [0 x 1]>
## 10 <split [271/30]> Fold10 <tibble [20 x 6]> <tibble [0 x 1]>
```

What the results look like now?  


```r
regular_res %>%
  collect_metrics() %>%
  filter(.metric == "roc_auc") %>%
  mutate(min_n = factor(min_n)) %>%
  ggplot(aes(mtry, mean, color = min_n)) +
  geom_line(alpha = 0.5, size = 1.5) +
  geom_point() +
  labs(y = "AUC")
```

{{<figure src="/post/randomforest-using-tidymodels-framework/index_files/figure-html/unnamed-chunk-13-1.png" alt="scatter plot for random forest r hyperparameters">}}

**CHOSE THE BEST MODEL**  

We can simply use the `select_best` function to select the best hyper-parameters for our model, and then update our original model specification `tuning_spec` to create our final model specification. 


```r
best_auc <- select_best(regular_res, "roc_auc")

final_rf <- finalize_model(
  tuning_spec,
  best_auc
)

final_rf
```

```
## Random Forest Model Specification (classification)
## 
## Main Arguments:
##   mtry = 1
##   trees = 1000
##   min_n = 35
## 
## Computational engine: ranger
```

We can now use the **last_fit()** function to fit a final model on the entire training set and evaluate on the testing set. We just need to give this function our original train/test split.  


```r
last_fit(final_rf, admit~., data_split) %>% 
  
  collect_metrics()
```

```
## # A tibble: 2 x 3
##   .metric  .estimator .estimate
##   <chr>    <chr>          <dbl>
## 1 accuracy binary         0.768
## 2 roc_auc  binary         0.742
```

The result above is a clear indication that we did not overfit during tuning. 


















