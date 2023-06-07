---
title: Cluster analysis in r (Clustering)
author: ''
date: '2023-06-05'
slug: cluster-analysis-in-r
categories: [clustering]
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2023-06-05T16:56:28+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---  




Clustering is a way of dividing data points with shared attribute into groups(clusters). The clustering system falls under unsupervised learning, where a data set is provided without label and the algorithm tries to figure out groups to assign each data point based on how similar or dissimilar they are to each other.  

Example use cases  

* Natural Language Processing (NLP)
* Computer vision  
* Customer/Market segmentation  
* Stock markets  


Let us try to understand clustering with a graphical illustration  

{{< figure library="true" src="cluster-analysis/clusters.png" alt="r cluster analysis fig ">}}

The above 2D graph shows how data points are grouped into Four distinct clusters.  

We are going to discuss two major types of clustering in R  

1. The hierarchical clustering
2. The k-means clustering  

## **Hierarchical clustering in R**  

Hierarchical clustering is separating data points into different groups based on some measures of similarities  

### **EXAMPLE**  

For this example we will make use of the popular iris data set in r. The iris data set contains the measurements in centimeters of the variables sepal length and width and petal length and width, respectively, for 50 flowers from each of 3 species of iris. The species are Iris *setosa*, *versicolor*, and *virginica*.  

Ideally, because of the presence of a label this data set falls in the **Supervised** category but for the sake of this lesson i will remove the labeled variable thereby making the data set good for **Unsupervised** learning.  

**STEPS**  

1. Load the data set  
2. Create a scatter plot  
3. Normalize the data  
4. Calculate Euclidean distance  
5. Create a dendogram  


**STEP 1**  

**Load the data set**


```r
iris_data <- iris

head(iris_data) # View first 6 observations
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

Now let's remove the `Species` label variable  


```r
iris_data$Species <- NULL
```


**STEP 2**

**Create a scatter plot**  


`Sepal.Width` VS `Sepal.Length`

```r
require(ggplot2)

ggplot(iris_data, aes(Sepal.Width, Sepal.Length)) + geom_point()
```

{{<figure src="index_files/figure-html/unnamed-chunk-4-1.png" alt="scatter plot showing sepal.width vs sepal.length">}}

`Petal.Width` VS `Petal.Length`  


```r
ggplot(iris_data, aes(Petal.Width, Petal.Length)) + geom_point()
```

{{<figure src="index_files/figure-html/unnamed-chunk-5-1.png" alt="scatter plot showing petal.width vs petal.length">}}

**STEP 3**  

**Normalize the data**  


```r
iris_data <- scale(iris_data)

head(iris_data) # View first 6 observations of the normalized data
```

```
##      Sepal.Length Sepal.Width Petal.Length Petal.Width
## [1,]   -0.8976739  1.01560199    -1.335752   -1.311052
## [2,]   -1.1392005 -0.13153881    -1.335752   -1.311052
## [3,]   -1.3807271  0.32731751    -1.392399   -1.311052
## [4,]   -1.5014904  0.09788935    -1.279104   -1.311052
## [5,]   -1.0184372  1.24503015    -1.335752   -1.311052
## [6,]   -0.5353840  1.93331463    -1.165809   -1.048667
```

**STEP 4**  

**Calculate Euclidean distance**  


```r
Eu_dist <- dist(iris_data, method = "euclidean")
```

**Compute hierarchical clustering using the** `hclust` **function in R**  


```r
h_clust <- hclust(Eu_dist) 
```

**STEP 5**  

**Create a dendogram**  

We can use the `color_branches` function from the <span style = "color:blue;"> dendextend </span> package to color out the number of groups/clusters we would like to see


```r
require(dendextend)


h_clust$labels <-  " "

plot(color_branches(as.dendrogram(h_clust), k = 3))
```

{{<figure src="index_files/figure-html/unnamed-chunk-9-1.png" alt="dendogram showing clustered data">}}

**View how many observations were assigned to each cluster**  


```r
table(cutree(h_clust, k = 3))
```

```
## 
##  1  2  3 
## 49 24 77
```
Knowing that our original data set had 3 categories of data points i.e three classes of Species (50 each). We would expect a good model to be able to group the data set evenly into three distinct clusters. The hierarchical clustering model above assigned few data points to the wrong groups.  

## **k-means clustering in R** 

The k-means clustering is a similar cluster analysis technique like the hierarchical clustering discussed above, the main difference however, is that the number of groups/clusters to be computed is known prior to building the model in k-means clustering while there is no prior knowledge of the number of clusters to be computed in the hierarchical clustering.

#### Build model  


```r
kmeans_model <- kmeans(x = iris_data, centers=3, nstart = 20)
```

Let's Walk through the code above  

* The `kmeans` function is a base R function for computing kmeans unsupervised learning in r, the function takes some parameter arguments, three of which were used above  
  + the *x* parameter represents the dataframe to be used  
  + the *centers* parameter represents the number of clusters/groups that we want  
  + the *nstart* parameter represents the number of random sets that should be chosen  
  
**View summary of the model**  


```r
summary(kmeans_model)
```

```
##              Length Class  Mode   
## cluster      150    -none- numeric
## centers       12    -none- numeric
## totss          1    -none- numeric
## withinss       3    -none- numeric
## tot.withinss   1    -none- numeric
## betweenss      1    -none- numeric
## size           3    -none- numeric
## iter           1    -none- numeric
## ifault         1    -none- numeric
```

**See how well the data points were clustered using the** `Sepal.length` **and** `Sepal.width` **variables**  


```r
plot(iris$Sepal.Length, iris$Sepal.Width, col = kmeans_model$cluster)
```

{{<figure src="index_files/figure-html/unnamed-chunk-12-1.png" alt="scatter plot showing three clusters of sepal.width vs sepal.lenth ">}}

The above plot shows that the data points were decently clustered.
