---
title: Data Cleaning and Analysis with the tidyverse r package
author: ''
date: '2020-07-27'
slug: data-cleaning-tidyverse-r-package
categories: [r programming, tidyverse]
tags: []
subtitle: ''
summary: 'A detailed explanation on how the tidyverse r package can be used to perform data cleaning and analysis'
authors: []
lastmod: '2020-07-27T15:05:45+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---

## I am going to show you how you can do a simple and fast data analysis using tidyverse r package without stress.

The dataset i will be using for this lesson is one i scraped from a popular blog in Nigeria. The dataset contains all the news that has ever been featured on the blog from when it started operating to the day i scraped the data (31-07-2020). My interest however, is only on the "Rape" related news.
So without wasting much time let me get on with the analysis..


**Load the tidyverse r package**

```r
require(tidyverse)
require(widgetframe)
```

**Read in the data**
```
blog_data <- read_csv("C:/Users/wirelex/Downloads/linda.csv") # 64mb+ in size

dim(blog_data) # check dimension
```

**See what the data looks like**

























































