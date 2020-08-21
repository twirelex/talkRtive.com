---
title: Data Cleaning and Analysis with the tidyverse r package
author: ''
date: '2020-07-27'
slug: data-analysis-tidyverse-r-package
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
```

**Read in the data**

```r
blog_data <- read_csv("https://raw.githubusercontent.com/twirelex/dataset/master/linda.csv") # 64mb+ in size
```

```
## Parsed with column specification:
## cols(
##   unlist.strsplit.unlist.wirewire.......... = col_character()
## )
```

```r
dim(blog_data) # check dimension
```

```
## [1] 246585      1
```

**See what the data looks like**



```r
head(blog_data, 10)
```

```
## # A tibble: 10 x 1
##    unlist.strsplit.unlist.wirewire..........                                    
##    <chr>                                                                        
##  1 "Court dismisses case against Senator Abbo after he was filmed slapping a nu~
##  2 "1 comments Read More...         Woman crashes wedding claiming to be pregna~
##  3 "1 comments Read More...            Insecurity: Nigerians know we have done ~
##  4 "104 comments Read More...         Victor Osimhen becomes Nigeria's most exp~
##  5 "15 comments Read More...           \n\n\r\n    (adsbygoogle = window.adsbyg~
##  6 "[]).push({});\r\n     Jude Okoye's wife, Ifeoma, shares hot new photos as s~
##  7 "60 comments Read More...         \"I’m concerned for the world that feels I~
##  8 "42 comments Read More...            You Do Not Want To Miss This!      \nDu~
##  9 "9 comments Read More...         After waiting for 18 years, woman dies thre~
## 10 "36 comments Read More...           \n\n\r\n    (adsbygoogle = window.adsbyg~
```


**Change the name of the column to something meaningful**


```r
colnames(blog_data) <- "title"
```
<b> Since i am only interested in posts/news that are rape related i will filter the dataframe down to posts/news that has the words *"rape"*, *"rapes"*, *"raped"*, *"rapist"*, *"raping"*, *"defiling"*, *"defiled"*, *"defile"*, *"defiles"* or *"defilement"* </b>


```r
rape_related <- blog_data %>% filter(
    str_detect(title, fixed("rape", ignore_case = TRUE))  |
    str_detect(title, fixed("rapes", ignore_case = TRUE)) |
    str_detect(title, fixed("raped", ignore_case = TRUE)) |
    str_detect(title, fixed("raping", ignore_case = TRUE))|
    str_detect(title, fixed("rapist", ignore_case = TRUE))|
    str_detect(title, fixed("defiling", ignore_case = TRUE))|
    str_detect(title, fixed("defiled", ignore_case = TRUE))|
    str_detect(title, fixed("defile", ignore_case = TRUE))|
    str_detect(title, fixed("defiles", ignore_case = TRUE))|
    str_detect(title, fixed("defilement", ignore_case = TRUE))
)

dim(rape_related) # check dimension
```

```
## [1] 2859    1
```

**Now that i have all the rape related cases i want to create another column called "state" to represent the state each event occurred, i will do this by creating a vector of character with all the states and capitals in Nigeria and then use the map_chr function from purrr in tidyverse to loop over all the titles, and extract the first matched state**


```r
states = c("Abia","Umuahia","Adamawa","Yola","Akwa Ibom","Uyo","Anambra","Awka","Bauchi", "Bayelsa","Yenagoa","Benue","Makurdi","Borno","Maiduguri","Cross River","Calabar","Delta","Asaba","Ebonyi","Abakaliki","Edo","Benin","Ekiti","Ado Ekiti", "Abuja", "Fct","FCT","Enugu","Gombe","Imo","Owerri","Jigawa","Dutse","Kaduna","Kano","Katsina","Kebbi","Birnin Kebbi","Kogi","Lokoja","Kwara","Ilorin","Lagos","Ikeja","Nasarawa","Lafia","Niger ","Minna","Ogun","Abeokuta","Ondo","Akure","Osun","Oshogbo","Oyo","Ibadan", "Plateau","Jos","Rivers","Port Harcourt","Sokoto","Taraba","Jalingo","Yobe","Damaturu", "Zamfara","Gusau")
```


```r
rape_related <- rape_related %>% mutate(state = map_chr(title, function(i){
  first(str_extract(i, states)[which(str_extract(i, states) != "NA")])
}))
```

**I will also create another column called date_published to show the dates each rape_related news was posted. i will do this by extracting the dates from each news in the title column with the str_trunc function from stringr in tidyverse.**  


```r
rape_related <- rape_related %>% 
 mutate(date_published = lubridate::dmy(str_trunc(title, width = 8,side = "left", ellipsis = "")))  
# the date any particular news was published is the last 8 strings in each post
```



**Now that i have the state and date_published variables i will clean the title variable so that only the title of each post displays, all other content is no longer useful..**


```r
rape_related <- rape_related %>% 
  mutate(title = str_remove(title, '^.*      \n')) %>% 
  mutate(title = str_remove(title, ".*;\r\n")) %>% 
  mutate(title = trimws(str_remove(title, ".*comments Read More...")))
# remove everything before the main title 
```


```r
rape_related <- rape_related %>% 
  mutate(title = str_remove(title, ".\n.*[0-9]")) %>% 
  mutate(title = trimws(str_remove(title , "...       by Linda Ikeji.*")))
# remove everything after the main title
```



```r
head(rape_related, 5) # first 5 observations
```

```
## # A tibble: 5 x 3
##   title                                                     state date_published
##   <chr>                                                     <chr> <date>        
## 1 "Former Nollywood actress, Victoria Inyama, has advised ~ <NA>  2020-07-31    
## 2 "The Commissioner of Police (CP) Rivers state, Joseph Mu~ Jos   2020-07-31    
## 3 "British-Ghanaian rapper, Solo 45 is jailed for 24 years~ <NA>  2020-07-31    
## 4 "A human rights activist, Prince Wiro, has charged the R~ Rive~ 2020-07-30    
## 5 "A 24-year-old man identified as Godwin Akpan has been a~ Ogun  2020-07-30
```


**Eventho the filtered data is rape related some of them are just mere accusations and unconfirmed stories, so i will narrow my filtered data down to only the cases that were confirmed i.e Perpetrator was arrested or sentenced or imprisoned.. etc....**  


```r
rape_related <- rape_related %>% filter(
  str_detect(title, fixed("arrest", ignore_case = TRUE))        |
    str_detect(title, fixed("arrested", ignore_case = TRUE))    |
    str_detect(title, fixed("court", ignore_case = TRUE))       |
    str_detect(title, fixed("sentence", ignore_case = TRUE))    |
    str_detect(title, fixed("sentenced", ignore_case = TRUE))   |
    str_detect(title, fixed("prison", ignore_case = TRUE))      |
    str_detect(title, fixed("imprisonmnet", ignore_case = TRUE))|
    str_detect(title, fixed("jail", ignore_case = TRUE))        |
    str_detect(title, fixed("jailed", ignore_case = TRUE))
)

dim(rape_related)
```

```
## [1] 895   3
```
**In other not to look too far i will focus on cases 2019-2020. so i will filter and keep observations from 2019 to 2020.**

```r
rape_related <- rape_related %>% 
  filter(date_published >= as.Date("2019-01-01"))
```

**The dataframe now has only confirmed cases of rape. i still will like to look through the data to see if i truly have what i am looking for**




```r
rape_related %>% head(20) 
```

```
## # A tibble: 20 x 3
##    title                                                  state   date_published
##    <chr>                                                  <chr>   <date>        
##  1 "British-Ghanaian rapper, Solo 45 is jailed for 24 ye~  <NA>   2020-07-31    
##  2 "A human rights activist, Prince Wiro, has charged th~ "River~ 2020-07-30    
##  3 "A 24-year-old man identified as Godwin Akpan has bee~ "Ogun"  2020-07-30    
##  4 "An 18-year-old boy has been arrested by men of the A~ "Adama~ 2020-07-29    
##  5 "The police in Ogun State have arrested three suspect~ "Ogun"  2020-07-29    
##  6 "A former X-Factor contestant has been jailed for lif~  <NA>   2020-07-27    
##  7 "A Court of Appeal sitting in Lagos on Monday, July 2~ "Lagos" 2020-07-27    
##  8 "26-year-old Pwadimadi Zeham, pictured above, has bee~ "Adama~ 2020-07-27    
##  9 "Men of the Katsina state police command have arreste~ "Katsi~ 2020-07-24    
## 10 "Men of the Niger state police command have arrested ~ "Niger~ 2020-07-24    
## 11 "A 70-year-old man, Mohammed Sani Umar, has been sent~ "Niger~ 2020-07-23    
## 12 "Adamawa police arrest 44-year-old man for allegedly ~ "Adama~ 2020-07-23    
## 13 "Men of the Rivers state police command have arrested~ "River~ 2020-07-23    
## 14 "The Yobe state police command has arrested an Assist~ "Yobe"  2020-07-22    
## 15 "Justice Abiodun Akinyemi of an Ogun State High Court~ "Ogun"  2020-07-22    
## 16 "A man has been sentenced to 9 years in prison for de~ "Edo"   2020-07-21    
## 17 "39-year-old man arrested for defiling 9-year-old dau~ "Adama~ 2020-07-21    
## 18 "A popular singer based in Imo state, Uba Obinna Agba~ "Imo"   2020-07-20    
## 19 "Rivers police arrest man for impregnating his 16-yea~ "River~ 2020-07-17    
## 20 "The police in Anambra state have arrested a 31-year-~ "Anamb~ 2020-07-15
```


**Looking at the data above it appears that there is still filtering that needs to be done as some of the observations are either alleged, accusations that are being investigated or rape cases that occurred outside Nigeria. One thing that i noticed however is that most of these cases are cases without state in their title i.e observations without state in the state column. To verify this i will filter the observations down to cases where the state variable is Empty/NotAvailable and investigate the observations**




```r
rape_related %>% filter(is.na(state) == TRUE) %>% head(10)
```

```
## # A tibble: 10 x 3
##    title                                                    state date_published
##    <chr>                                                    <chr> <date>        
##  1 "British-Ghanaian rapper, Solo 45 is jailed for 24 year~ <NA>  2020-07-31    
##  2 "A former X-Factor contestant has been jailed for life ~ <NA>  2020-07-27    
##  3 "The senate on Tuesday July 14, passed a bill prescribi~ <NA>  2020-07-14    
##  4 "Mary Kay Letourneau, the former Washington middle scho~ <NA>  2020-07-08    
##  5 "Cricketer Alex Hepburn jailed for raping a sleeping wo~ <NA>  2020-06-30    
##  6 "The Inspector-General of Police, Mohammed Adamu, has o~ <NA>  2020-06-30    
##  7 "Rapist, 18, begins two-year jail sentence after his pa~ <NA>  2020-06-29    
##  8 "An aggrieved Kenyan mother has called for the arrest o~ <NA>  2020-06-25    
##  9 "A 43-year-old father has been arrested for allegedly r~ <NA>  2020-06-25    
## 10 "American adult film star and stand-up comedian, Ron Je~ <NA>  2020-06-24
```


**Took my time to investigate the posts and discovered that truly most of the cases without states are rape events outside Nigeria, and few cases are accusations that are being discussed (No proof). However, i noticed that very few of the post didn't have state in them either because the blogger did not include state or because the state was written in the main news/post and not in the title/summary that i scraped. I selected the few posts(216,352,42,119,210,247,318,320) and manually researched the states they occurred, (Delta,Lagos,Imo,Niger,Adamawa,Abuja,Lagos,Niger) respectively. Now i will include those states to the observations (i will make use of the rows_update function from dplyr in tidyverse**  



```r
rape_related <-
  rape_related %>% mutate(rowid = 1:nrow(rape_related)) # create a variable "rowid" to update by

rape_related <- rows_update(rape_related ,
                            tibble(
                              rowid = c(216, 352, 42, 119, 210, 247, 318, 320),
                              state = c("Delta", "Lagos", "Imo", "Niger", "Adamawa", "Abuja", "Lagos", "Niger")
                            )) %>% select(-rowid) # update the affected observations and de-select "rowid"
```

```
## Matching, by = "rowid"
```

**Now i will also look at observations with state to see if there is any that shouldn't be there**



```r
rape_related %>% filter(is.na(state) == FALSE) %>% head(10)
```

```
## # A tibble: 10 x 3
##    title                                                  state   date_published
##    <chr>                                                  <chr>   <date>        
##  1 "A human rights activist, Prince Wiro, has charged th~ "River~ 2020-07-30    
##  2 "A 24-year-old man identified as Godwin Akpan has bee~ "Ogun"  2020-07-30    
##  3 "An 18-year-old boy has been arrested by men of the A~ "Adama~ 2020-07-29    
##  4 "The police in Ogun State have arrested three suspect~ "Ogun"  2020-07-29    
##  5 "A Court of Appeal sitting in Lagos on Monday, July 2~ "Lagos" 2020-07-27    
##  6 "26-year-old Pwadimadi Zeham, pictured above, has bee~ "Adama~ 2020-07-27    
##  7 "Men of the Katsina state police command have arreste~ "Katsi~ 2020-07-24    
##  8 "Men of the Niger state police command have arrested ~ "Niger~ 2020-07-24    
##  9 "A 70-year-old man, Mohammed Sani Umar, has been sent~ "Niger~ 2020-07-23    
## 10 "Adamawa police arrest 44-year-old man for allegedly ~ "Adama~ 2020-07-23
```


**It appears that some of the cases are cases where the accused denies and sues the accuser but no arrest or sentencing was made. An example of such cases is the COZA pastor rape allegation case, that particular story appeared a few times, also there are cases where arrest were made for attempted rape (not really what we want), and a case where the victim was an Animal and lots more. I have investigated these cases and will have to remove them from the observations**  


```r
rape_related <- rape_related[-c(27,34,51,60,65,71,75,114,116,122,126,149,173,190,192,193,223,230,237,275,289,298,299,301,319,351,135,162,308,333,2,145,53,89,90,223,348),] # Delete all the unwanted observations
```

**I am now only going to keep observations with state and perform one final check "whether the state variable captured the actual state where each event occurred"**  


```r
rape_related %>% filter(is.na(state) == FALSE) %>% head(10)
```

```
## # A tibble: 10 x 3
##    title                                                  state   date_published
##    <chr>                                                  <chr>   <date>        
##  1 "A 24-year-old man identified as Godwin Akpan has bee~ "Ogun"  2020-07-30    
##  2 "An 18-year-old boy has been arrested by men of the A~ "Adama~ 2020-07-29    
##  3 "The police in Ogun State have arrested three suspect~ "Ogun"  2020-07-29    
##  4 "A Court of Appeal sitting in Lagos on Monday, July 2~ "Lagos" 2020-07-27    
##  5 "26-year-old Pwadimadi Zeham, pictured above, has bee~ "Adama~ 2020-07-27    
##  6 "Men of the Katsina state police command have arreste~ "Katsi~ 2020-07-24    
##  7 "Men of the Niger state police command have arrested ~ "Niger~ 2020-07-24    
##  8 "A 70-year-old man, Mohammed Sani Umar, has been sent~ "Niger~ 2020-07-23    
##  9 "Adamawa police arrest 44-year-old man for allegedly ~ "Adama~ 2020-07-23    
## 10 "Men of the Rivers state police command have arrested~ "River~ 2020-07-23
```


**After carrying out the final check i discovered that about 2 states were misrepresented, and the misrepresentation was because i had initially set my map(loop) to extract the first state in the title/summary that matches any state in the states i provided. There are 2 cases where the first state in the title/summary was the state of the culprit and not the state of occurrence. An example of such case is; *"A bricklayer from Cross River has been arrested for raping his 9-year-old sister-in-law in Osun state"*.... the event occurred in Osun but since Cross River was mentioned first Cross River was picked..**  


```r
rape_final <- rape_related %>% filter(is.na(state) == FALSE) # keep only observations where the state is present
```


```r
rape_final <-
  rape_final %>% mutate(rowid = 1:nrow(rape_final)) # create a variable "rowid" to update by

rape_final <- rows_update(rape_final ,
                          tibble(rowid = c(170, 198),
                                 state = c("Lagos", "Osun"))) %>% select(-rowid) # update the affected observations and de-select "rowid"
```

```
## Matching, by = "rowid"
```

**Some states capital was used in the state column instead of the state, since the state itself is what i am interested in i will replace those capitals by their respective states**  


```r
rape_final <- rape_final %>%
  mutate(
    state = case_when(
      state == "Makurdi" ~ "Benue",
      state == "Ikeja" ~ "Lagos",
      state == "Akure" ~ "Ondo",
      state == "FCT" ~ "Abuja",
      state == "Niger " ~ "Niger",
      state == "Port Harcourt" ~ "Rivers",
      state == "Calabar" ~ "Cross River",
      TRUE ~ state
    )
  )
```

**Finally i will like to represent the data graphically**



```r
rape_final %>% count(state) %>% ggplot(aes(fct_reorder(state, n), n , fill = state)) + geom_bar(show.legend = FALSE, stat = "identity") + coord_flip() + labs(x = "STATE", y = "", title = "Confirmed rape cases according to state from Jan-2019 to July-2020 as posted on Lindaikejisblog") + theme_bw() + theme(
  axis.text.y = element_text(face = "bold", size = 15),
  axis.text.x = element_blank(),
  axis.title.y = element_text(size = 15),
  plot.title = element_text(
    hjust = 0.3,
    size = 24,
    colour = "grey50"
  )
)
```

{{<figure src="/post/Data-cleaning-tidyverse-r-package/index_files/figure-html/unnamed-chunk-24-1.png" alt="barplot showing states of confirmed rape cases created with ggplot in tidyverse">}}

Lagos state, Ogun state and Niger state happen to have recorded more confirmed rape cases than the other states, with Anambara and Abuja following..



```r
require(lubridate)

rape_final %>% mutate(date_published = floor_date(date_published, "month")) %>% count(date_published) %>% ggplot(aes(date_published, n)) + geom_point(color = "black") + geom_line(color = "grey50") + geom_text(aes(label = n), vjust = -0.35, hjust = 0.5, size = 5) + scale_x_date(date_breaks = "1 month", date_labels = "%b %Y") + theme(
  axis.text.x.bottom = element_text(size = 10, face = "bold"),
  panel.grid = element_blank(),
  axis.title.x = element_text(size = 15),
  plot.title = element_text(
    colour = "grey50",
    size = 25,
    hjust = 0.5
  )
) + labs(x = "Date", y = "", title = "Distribution of confirmed Rape cases from Jan-2019 to July-2020 as posted on Lindaikejisblog")
```

{{<figure src="/post/Data-cleaning-tidyverse-r-package/index_files/figure-html/unnamed-chunk-25-1.png" alt="scatterplot of rape cases created with ggplot in tidyverse">}}

There have been quite a number of incident of Rape between 2019 and half-way 2020, despite not being a complete year yet there have been more rape cases in 2020 than in 2019, obviously because of the Lockdown that started in April.  


### Wrap-up  
The tidyverse r package for me has become a compulsory tool for making sense out of data. If you are new to Data science my advice to you is to try as much as you can to familiarize with the tidyverse package, it will make your job much easier and fun.




