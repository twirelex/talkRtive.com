---
title: Predicting the result of a Virtual football match using tidymodels
author: ''
date: '2020-07-20'
slug: tidymodels-virtual-football-prediction
categories: [r programming, tidymodels]
tags: []
subtitle: ''
summary: 'Predicting the result of a virtual football game with SVM and random forest algorithms using the tidymodels r package'
authors: []
lastmod: '2020-07-20T17:39:32+01:00'
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





































