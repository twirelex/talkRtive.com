---
title: Text mining with R
author: ''
date: '2020-08-31'
slug: text-mining-with-r
categories: [r programming, text mining]
tags: []
subtitle: ''
summary: 'Text mining gets easier everyday with advent of new methods and approach. In this lesson i will walk you through how you can use R/Rstudio with the combination of some powerful packages to make sense out of unstructured text data and even go further to build a predictive model.'
authors: []
lastmod: '2020-08-31T22:15:51+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---  



Text mining gets easier everyday with advent of new methods and approach. In this lesson i will walk you through how you can use R/Rstudio with the combination of some powerful packages to make sense out of unstructured text data and even go further to build a predictive model.  
Before we go into practical example let's first understand what text mining is. 

## What is text mining?   
In the world we are today a lot of big companies and organizations have started incorporating the "data-driven" approach in their day-to-day activities, hence the need for efficient text mining process.  
**Text mining or text data mining, similar to text analytics, is the process of deriving high quality information from text.**  

**EXAMPLE**  

For this example we will make use of a dataset made available to us by `Cochtane`. He did a great job scraping the data from a popular Nigerian Forum <a href="https://nairaland.com" target="_blank" rel="nofollow noopener"> nairaland </a>. Nairaland is an online community and public space that serves as a meeting place for Nigerians at Home and in the Diaspora. The dataset contains information about posts that were featured in the frontpage of the forum over a period of 1 year. The dataset has about 28,800 observations and 7 variables/features, Our focus however will only be on 2 variables:  
`title`   **===>** Title of each post  
`section` **===>** section/category the post falls under  

Our aim is to create a model that will take the title of a post and predict which section the post fall under..  

**Load required packages**  


```r
require(tidyverse)
require(tidytext) # Explore text data
require(wordcloud2)
require(tidymodels)
require(textrecipes) # prep-rocess text data
require(doSNOW) # parallel processing
```

**Read in the dataset**  


```r
nairaland_data <- read_csv("https://raw.githubusercontent.com/twirelex/dataset/master/nl_data.csv") %>% 
  select(title, section)
```

```
## Parsed with column specification:
## cols(
##   X1 = col_double(),
##   link = col_character(),
##   title = col_character(),
##   section = col_character(),
##   author = col_character(),
##   frontPageDate = col_datetime(format = ""),
##   postedDate = col_datetime(format = "")
## )
```



## EXPLORATORY ANALYSIS  

**See what the content of the data looks like**

```
head(wire)
```  
{{< figure library="true" src="text-mining-with-r/reactable1.png" alt="text mining in r data">}}


### Let's first explore the `section` variable


```r
nairaland_data %>% count(section) %>% arrange(desc(n))
```

```
## # A tibble: 37 x 2
##    section         n
##    <chr>       <int>
##  1 Politics     9892
##  2 Celebrities  4095
##  3 Crime        2932
##  4 Sports       2023
##  5 Health       1581
##  6 Religion     1090
##  7 Travel       1090
##  8 Education     892
##  9 Romance       858
## 10 Business      615
## # ... with 27 more rows
```

There are 37 different categories in the `section` variable. Working with such number of categories for a response variable in a classification model is out of the scope of this lesson so we may have to use the categories that appears in the top 10 i.e categories with the highest count/frequency.

**let's view the counts in a plot**

```r
nairaland_data %>% count(section) %>% 
  ggplot(aes(fct_reorder(section, n), n)) + geom_col(fill = "lightblue") + coord_flip() +
  theme_bw() + labs(x = "SECTION", y = "")
```

{{<figure src="/post/text-mining-with-r/index_files/figure-html/unnamed-chunk-5-1.png" alt="text mining in r bar chart of counts">}}
We can see from the plot above that categories like computers, gaming, autos had very few posts in them, and categories like Politics, Celebrities, Crime are where most of the posts that were featured on the forum fall under.  

### Let's also explore the `title` variable

**A wordcloud of the top most frequent words that appeared in the title variable**

```r
nairaland_cloud <- nairaland_data %>% select(title) %>% 
  unnest_tokens(word, title) %>% 
  count(word, sort = TRUE) %>% 
  filter(n>200)
```
Let's work through the code above:  
* First the `select` function was used to select the column of interest **title**  
* then the `unnest_tokens` function from the <span style = "color:blue;">tidytext</span> package was used to  break the **title** text into individual tokens (a process called tokenization) and transform it to a tidy data structure
  + A token is a meaningful unit of text, most often a word, that we are interested in using for further analysis, and tokenization is the process of splitting text into tokens.  
* we then used the `count` function to compute the count/frequency of each word and sorted the counts in descending order
* the `filter` function was then used to filter out words that didn't appear up to **200** times i.e words whose frequency were not up to 200  

```
nairaland_cloud %>% anti_join(get_stopwords()) %>% 
  filter(!word %in% c("pictures", "photos", "video", "photo", "pix", "pics")) %>% 
  mutate(word = str_remove(word, "[:digit:]+")) %>%
  wordcloud2(size = 0.5) # wordcloud plot
```
* going further we used the `anti_join` function to filter out stopwords, the **get_stopwords** function as a parameter in the `anti_join` function provided an in-built vector of stopwords that we could match with what we have & get rid of.  
  + Stopwords are a set of commonly used words like "a", "the", "are", etc.... that carry very little useful information  
* again we filtered out words like "pictures", "photos", "video", "photo", "pix" and "pics" that didn't add useful information  
* finally, all numeric strings were removed with the `str_remove` function and then we used the <span style = "color:blue;">wordcloud2</span> package to make a wordcloud plot.

{{< figure library="true" src="text-mining-with-r/wordcloud2.png" alt="text mining with r wordcloud">}}  

It is no surprise that words like *coronavirus*, *president*, *buhari*, *governor*, *actress*, *arrested* etc.. appeared to have higher frequencies. These are all words that can be found in the categories that dominated the `section` variable, i.e **politics**, **celebrities**, **crime**, **health**, **sports**, etc.....  



## BUILD MODEL  

As we earlier mentioned, our interest is on the top categories of the `section` variable so we will filter the top 10 categories and make this a multi-class classification problem with 10 classes

**Filter down to the 10 categories**  

```r
categories <- c("Politics", "Celebrities", "Crime", "Sports", "Health",
                "Travel", "Religion", "Education", "Romance", "Business")

nairaland_filtered <- nairaland_data %>% filter(section %in% categories)
```


```r
dim(nairaland_filtered)
```

```
## [1] 25068     2
```
Even after filtering and keeping the top 10 categories we are still left with a large dataset, for the sake of this lesson we will only make use of 2,000 observations.

**Barplot of the first 10 categories**  

```r
nairaland_filtered %>% count(section) %>% ggplot(aes(fct_reorder(section, n), n, fill = section)) + 
  geom_col(show.legend = FALSE) + labs(x = "Section", y = "")
```

{{<figure src="/post/text-mining-with-r/index_files/figure-html/unnamed-chunk-9-1.png" alt="text mining with r top 10 variables barplot">}}

**Sample out 2,000 observations**  


```r
set.seed(111)
nairaland_filtered <- nairaland_filtered %>% sample_n(2000)
```



### Split data into train and test



```r
set.seed(222)

split_data <- initial_split(nairaland_filtered, strata = section)

train_split <- training(split_data) 

test_split <- testing(split_data)
```


### Data Pre-processing  



```r
prep_rec <- recipe(section ~ title, data = train_split) %>%
  step_tokenize(title) %>% 
  step_stopwords(title) %>% 
  step_tokenfilter(title, max_tokens = 300) %>% 
  step_tf(title) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_predictors()) %>% 
  prep()
```
Let us walkthrough the code above  
* we first define a formula in the `recipe` function (A way to prepare ahead for the pre-processing steps to be taken)  
* then we use the `step_tokonize` function to break the **title** text into individual tokens (a process called tokenization).  
* next we use the `step_stopwords` function to remove all the stopwords from the individual tokens that were created from the initial step  
* and then we use the `step_tokenfilter` function to reduce the number of tokens created from the initial step, setting the **max-token** parameter to **300** to keep only 300 tokens per **title** text 
* the `step_tf` function was used to make numeric features out from the tokens  
* then we remove zero-variance variables if any exist with the `step_zv` function  
* finally we normalize the newly created variables i.e center and scale, and prepare the recipe with the `prep` function  


**Get the prepared data(train set) out with the** `juice` **function**

```r
pre_pro_train <- juice(prep_rec)
```

**Apply the pre-processing steps with the** `bake` **function to the test set**  

```r
pre_pro_test <- bake(prep_rec, test_split)
```


**Activate parallel processing for faster computing**

```r
cl <- makeCluster(6, type = "SOCK")
registerDoSNOW(cl)
```


**Configure a model specification and fit the model on the train set**

```r
set.seed(333)
randomForest_model <- rand_forest() %>% 
  set_engine("randomForest") %>% 
  set_mode("classification") %>% 
  fit(section~., data = pre_pro_train)
```

**Make prediction on the test set**


```r
predicted <- predict(randomForest_model, pre_pro_test) %>% 
  mutate(truth = pre_pro_test$section) # Create a new column with the test set response variable
```

### MODEL EVALUATION

**Create an heatmap to see the result of the true values VS predicted values** 

```r
predicted %>% conf_mat(truth = truth, estimate = .pred_class) %>% autoplot(type = "heatmap")
```

{{<figure src="/post/text-mining-with-r/index_files/figure-html/unnamed-chunk-18-1.png" alt="text mining in r heatmap showing confusion matrix">}}
From the heatmap above it is obvious that the randomforest model got more correct predictions for  *Politics*, *Celebrities* and *Crime* category than it did for the other categories. This is definitely because of the inbalanced nature of the **title** variable.

**view accuracy metric**

```r
predicted %>% metrics(truth, .pred_class) 
```

```
## # A tibble: 2 x 3
##   .metric  .estimator .estimate
##   <chr>    <chr>          <dbl>
## 1 accuracy multiclass     0.647
## 2 kap      multiclass     0.526
```
given that we sampled the observations down to 2,000 and used only about 75% of the 2,000 observations to train the model an accuracy of %60+ isn't too bad.  


**Create a function to be able to use our model on unpre-processed raw data**  


```r
get_section <- function(title, section = NA){
  data = data.frame(section = section, title = title)
  baked_data = bake(prep_rec, data)
  predict(randomForest_model, baked_data)
}
```

After creating the function i headed over to <a href="https://nairaland.com" target="_blank" rel="nofollow noopener"> nairaland </a>, got some 5 front-page posts title and tested the function.  

1. **Crime:**     8 Cars Recovered As EFCC Arrests 14 Suspected Fraudsters In Anambra (Photos)  
2. **Health:**    143 New COVID-19 Cases, 125 Discharged And No Deaths On August 31
3. **Education:** Our Public Universities Are Still Unsafe For Reopening - ASUU  
4. **Politics:**  Buhari Forms Exco-Legislative Party Forum, Names Osinbajo As Chair  
5. **Romance:**   Can Someone Explain The Feeling Of Disgust, Remorse And Disdain After Sex.?  

Now let's see how our model will classify these 5 titles


```r
cbind(get_section(title = "8 Cars Recovered As EFCC Arrests 14 Suspected Fraudsters In Anambra (Photos)"),
                  truth = "Crime") %>% knitr::kable()
```



|.pred_class |truth |
|:-----------|:-----|
|Crime       |Crime |


```r
cbind(get_section(title = "143 New COVID-19 Cases, 125 Discharged And No Deaths On August 31"), 
                  truth = "Health") %>% knitr::kable()
```



|.pred_class |truth  |
|:-----------|:------|
|Health      |Health |


```r
cbind(get_section(title = "Our Public Universities Are Still Unsafe For Reopening - ASUU"), 
                  truth = "Education") %>% knitr::kable()
```



|.pred_class |truth     |
|:-----------|:---------|
|Politics    |Education |


```r
cbind(get_section(title = "Buhari Forms Exco-Legislative Party Forum, Names Osinbajo As Chair"), 
                  truth = "Politics") %>% knitr::kable()
```



|.pred_class |truth    |
|:-----------|:--------|
|Politics    |Politics |


```r
cbind(get_section(title = "Can Someone Explain The Feeling Of Disgust, Remorse And Disdain After Sex.?"),
                  truth = "Romance") %>% knitr::kable()
```



|.pred_class |truth   |
|:-----------|:-------|
|Education   |Romance |

As expected, the model got prediction right for Crime, Politics, Health because these categories had more posts than the rest.











