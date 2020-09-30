---
title: web scraping using RSelenium in R/Rstudio
author: ''
date: '2020-07-07'
slug: web-scraping-using-RSelenium
categories: [r programming, web scraping]
tags: []
subtitle: ''
summary: 'Scraping the content of a site with login requirement and iframe using the RSelenium r package can be very easy. In this lesson you will learn how.....'
authors: []
lastmod: '2020-07-07T00:21:57+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---

## **In this tutorial i will explain how the RSelenium r package can be used to scrape data from a Dynamic web page with login requirement easily.**   

Like so many of you i have also asked myself if it is possible to predict the result of the virtual football matches we play online using a machine learning model. Well, in this post i am going to show you how i was able to satisfy my curiosity with R programming and the package called RSelenium, if you are an R programmer chances are that you have used R's popular rvest package for web scraping but yet to explore the RSelenium package. The RSelenium package is a good web browser automation tool that can serve as a bot in place of human to automate certain tasks. One of the difference between the RSelenium package and the rvest package is that unlike rvest that loads only the html content of a web page the RSelenium package loads everything including the page's Javascript content and therefore may take a bit longer to deliver than rvest depending on internet speed among other things. You can however use RSelenium in an headless mode so that all its graphical content won't display to improve the speed but in this tutorial we will display all content.


**Some RSelenium methods and how they can be used**  
* **$navigate()            -->** *for navigating to urls pages*
* **$findElement()         -->** *for identifying elements within a web page*
* **$getElementText()      -->** *for getting the text of elements in a web page*
* **$sendKeysToElement()   -->** *for sending values into an input field within a web page*
* **$clickElement()        -->** *for clicking elements within a web page*
* **$switchToFrame()       -->** *for switching between frames within a web page*
* **$switchToWindow()      -->** *for switching from one window to another* 
* **$open()                -->** *for opening a webBrowser client*
* **$close()               -->** *for closing a webBrowser client*

RSelenium server requires java runtime so you need to make sure that you have java runtime installed in your system before proceeding..

**we start by loading the RSelenium package:**

```r
require(RSelenium)
```

```
## Loading required package: RSelenium
```

```r
require(readr) # we will make use of the write_csv() function from this package
```

```
## Loading required package: readr
```
**if you don't have the RSelenium package installed you can first use the code below to install before loading for use**
```
install.packages("RSelenium")
install.packages("readr")
```  
**Now we start a selenium server and browser with the rsDriver function and store it in a variable named rd(short for remote driver) and create another variable "remdr" that will handle how we control the browser.**  

```
rd <- rsDriver(browser = "firefox")
remdr <- rd[["client"]]
```
**you should see something like this**

{{< figure library="true" src="web-scraping-selenium/remdr.png" alt="connecting to an RSelenium server">}}

**NOTE:** if you are using the rsDriver function for the first time what you will see will be different from mine but after the first run your output should be similar to mine (for this lesson i used Windows 10).

**By this time your firefox browser is triggered and is ready to work according to your instructions**

{{< figure library="true" src="web-scraping-selenium/firefox.png" alt="RSelenium firefox browser client started">}}

**We now have access to all the methods that is contained in the remdr variable that we created earlier, we can navigate to web pages and do a lot of interesting things from now.**  

```
url <- "http://old-mobile.bet9ja.com/Account/Login.aspx"  # url of the site's login page

remdr$navigate(url)  # Navigating to the page
```  
{{< figure library="true" src="web-scraping-selenium/Bet9jaLoginPage.png" alt="the website's login page">}}

**Now we will use the selector gadget add-on in chrome browser to locate the elements we are interested in within any page. If you have not used the selector gadget add-on before here is a <a href="https://selectorgadget.com/" target="_blank" rel="nofollow noopener">link<a/> to a quick guide on how to begin or use your browser's inspect element option by just right clicking at any particular place of interest and select "inspect" / "inspect element" .**  
**we first locate the username element and store it in a variable called username**
```
username <- remdr$findElement(using = 'css selector',"#ctl00_w_ContentMain_ContentMain_LoginUser1_ctrlLogin_Username")
```  
**we do something similar to locate the password element**
```
password <- remdr$findElement(using = 'css selector',"#ctl00_w_ContentMain_ContentMain_LoginUser1_ctrlLogin_Password")
```  
**we also locate the login button element**
```
login <- remdr$findElement(using = 'css selector',"#ctl00_w_ContentMain_ContentMain_LoginUser1_ctrlLogin_lnkBtnLogin")
```

**Now that we have the location of these elements we can then insert our username and password into their respective fields in the page**

```
username$sendKeysToElement(list("username")) # your bet9ja username

password$sendKeysToElement(list("password")) # your bet9ja password
```  
**you should have something like this**

{{< figure library="true" src="web-scraping-selenium/Bet9jaUsernamePassword.png" alt="the website's username and password input field">}}

**we then click on the login button**
```
login$clickElement()
```  
**it is advisable to pause your script sometimes so that the current page gets loaded completely before your next line of code runs to avoid errors, especially when your internet connection isn't too good.**

```
Sys.sleep(5) # giving the current page 5 seconds to finish loading its content
```  
{{< figure library="true" src="web-scraping-selenium/Bet9jaHomePage.png" alt="the website's homepage">}}

**Now that we are logged in we will need to navigate to the page where the virtual game is displayed.**

```
league <- remdr$findElement(using = 'css selector', ".miBet9jaLeague")
league$clickElement() # click on the League button in the page
```  
```
Sys.sleep(5) # giving the current page 5 seconds to finish loading its content
```  
```
premier <- remdr$findElement(using = 'css selector', ".col-xs-6:nth-child(1) > div")
premier$clickElement() # click on the premier button
```  
```
Sys.sleep(20) # giving the current page 20 seconds to finish loading its content
```  
**Now we are at the page we want to scrape from** 

{{< figure library="true" src="web-scraping-selenium/Bet9jaVirtualHome.png" alt="the website's virtual football main page">}}

{{< figure library="true" src="web-scraping-selenium/Bet9jaVirtualResult.png" alt="the website's virtual football result page">}}

**We will extract some information from these pages to make our dataset. The information in these pages changes every 2 minutes so we will need to create a while-loop so that we can capture all the information we need even as it changes.**  

Here is a list of what we will need from these pages:
* the bet week
* the bet countdown timer 
* the match table
* the result table  

There is a little problem that we have to address before proceeding to get this data. Unlike the other pages where we just went ahead to get Elements from, in this page the Elements are inside a frame (use the selector gadget to verify), this restricts us from carrying out the findElement method that we have been using for the other pages directly. The RSelenium web driver provides us methods to handle situations like this, we will first need to switch to the frame so we can have access to the data therein.

```
iframe = remdr$findElement(using = "css selector", "#playAreaFrame")

remdr$switchToFrame(iframe)
```  

We have switched to the frame and can now perform the findElement method to obtain the data that we need.



**Final step:**

```
bet9ja <- NULL  ## initialize an empty data frame
```
```
TimeIn2days <- Sys.time() + 172800 ## we get the day and time we want our loop to exit

## 172800 in seconds is equivalent to 48hours

```

```
## set a while loop so that we can get the data we need continuously every two minutes for as long as we want ##
while (Sys.time() <= TimeIn2days) { ## checks if the current day is equal or less than 2 days later, stops running if it isn't..
  
  ## we then locate and get the element of the betweek of the game which we will use as variable in our dataset ##
  betweek <- remdr$findElement(using = 'css selector', "#leagueWeek")
  betweek <- unlist(betweek$getElementText())
  
  ## we locate the countdown element and then convert it to numeric (the time we have left before the game starts),
  # this is very important ##
  
  countdown <- remdr$findElement(using = 'css selector',"#bets-time-betContdown")
  countdown1 <- as.numeric(substr(unlist(countdown$getElementText()), 1, 2))
  countdown2 <- as.numeric(substr(unlist(countdown$getElementText()), 4, 5))
    
  ## we locate the main table where the countries to play against each other and their odds are, and we store it 
  # in a variable mtable(match table) ##
  
  mtable <- remdr$findElement(using = 'css selector', "#tab_id_Match_Result")
  mtable <-unlist(strsplit(unlist(mtable$getElementText()), "\n"))
  mtable <- mtable[-1]
  
  ## we will need a precise timing to be able to capture the result of the matches accurately. 
  # the matches gets played and the final results is displayed in the 28th second, So we pause our code using an 
  #addition of the time we have left from the current page where we got the betweek and the match table with the 28th 
  # second of the next page where we will obtain the final result of the games played. ##
  
  Sys.sleep((countdown1 * 60) + countdown2 + 28)
  
  ## now we get the result of the games played and clean it up a bit ##
  rstable <- remdr$findElement(using = 'css selector', "#live-list-match")
  rstable <- unlist(strsplit(unlist(rstable$getElementText()), "\n"))
  rstable <- rstable[-c(4, 8, 12, 16, 20, 24, 28, 32, 36, 40)]
  
  ## make a data frame with variavbles: home, away, homeOdd, drawOdd, awayOdd, homeR, awayR, matchtime, leagueWK 
  # and day ##
  
  df = data.frame(
    home = paste0(substr(mtable[seq(2,29,3)], 1,3)),
    away = paste0(substr(mtable[seq(2,29,3)], 7,9)),
    homeOdd = paste0(substr(mtable[seq(3,30,3)], 1,4)),
    drawOdd = paste0(substr(mtable[seq(3,30,3)], 6,9)),
    awaysOdd = paste0(substr(mtable[seq(3,30,3)], 11,14)),
    homeR = paste0(substr(rstable[seq(1,28,3)], 5,5)),
    awayR = paste0(substr(rstable[seq(3,30,3)], 1,1)),
    matchtime = mtable[1], ## the time a match was played as a variable
    leagueWK = betweek,  ## the week a match was played as a variable
    day = weekdays(Sys.Date()) ## the day a match was played as a variable
  )
  ## Note: i am able to do the above step because i scraped the data before this tutorial and noted the 
  #position of the information i needed. ##
  
  
  ## bind rows and save the dataset in the current directory of your rstudio
  bet9ja <- rbind(bet9ja, df)
  write_csv(bet9ja, "bet9ja.csv")
  
  
  ## Navigate back to the page, switch to the frame and do this till the while loop becomes "FALSE" (2 days later) ##
  remdr$navigate("https://vsmobile.bet9ja.com/bet9ja-mobile/login/?mode=premier&lang=tryhtml_iframe")

iframe = remdr$findElement(using = "css selector", "#playAreaFrame")
remdr$switchToFrame(iframe)

Sys.sleep(25)
  }
```
**The above while loop will run continuously for 2 days and each time a loop is completed a dataset gets saved to the current working directory rstudio is pointing to and it will subsequently get overwritten until the loop completes.**

**you should get a data frame like the one below after each run**

{{< figure library="true" src="web-scraping-selenium/betgames.png" alt="scraped data in an excel sheet">}}

It takes exactly 2 minutes for a game circle to be completed (match-fix-time + match-play-time), so if you do exactly what was taught in this tutorial, after 2 days of looping you should get a dataset with <span style = "color:blue;"> 10 x 30 x 48 </span> **=** <span style = "color:blue;"> 14400 </span> observations for 2 days..


Now that we have gotten the dataset that  we want, our next step is to build a model to see how well we can predict the outcome of any match in the virtual football game.  

##### Please refer to this [post]({{< ref "post/predicting-the-result-of-a-virtual-football-match-of-a-betting-site/index.Rmarkdown" >}}) for the modelling part...

### Wrap-up  
I use both rvest and RSelenium for web scraping and i must say, both are excellent tools that will always get the job done, the rvest package has a lot of people using it compared to the RSelenium package so you will most likely get solutions online for most rvest related problems than RSelenium. 

  
