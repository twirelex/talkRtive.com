---
title: Dimensionality Reduction in R
author: ''
date: '2023-06-13'
slug: dimensionality-reduction-in-r
categories:
  - r programming
  - statistics
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2023-06-13T20:53:00+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---




**Let's start by introducing the packages we'll be using**

```r
library(ggplot2)
library(dplyr)
library(tsne)
```


In data analysis and machine learning, dimensionality reduction is a technique used to reduce the number of variables or features in a dataset while preserving its underlying structure. It is particularly useful when dealing with high-dimensional data, as it can simplify the analysis, improve visualization, and reduce computational complexity.

# Principal Component Analysis (PCA)

One popular method for dimensionality reduction is Principal Component Analysis (PCA). PCA transforms the original variables into a new set of orthogonal variables called principal components. The principal components are ordered in terms of the amount of variance they explain in the data.

Let's demonstrate PCA using the famous Iris flower dataset:

**Load the Iris dataset**

```r
data(iris)
```

**Separate the features (independent variables) and the target variable**

```r
iris_features <- iris[, 1:4]
iris_species <- iris$Species
```

Before applying PCA, it is a good practice to scale the features to have zero mean and unit variance. This step ensures that variables with different scales do not dominate the analysis.

**Scale the features**

```r
scaled_features <- scale(iris_features)
```

Now, let's perform PCA on the scaled features:

**Perform PCA**


```r
pca_result <- prcomp(scaled_features)
```

The `prcomp()` function in R performs PCA and returns the result as an object. We can access different properties of the PCA result, such as the proportion of variance explained by each principal component:

**Proportion of variance explained by each principal component**


```r
variance_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2)
variance_explained
```

```
## [1] 0.729624454 0.228507618 0.036689219 0.005178709
```

The first principal component (PC1) explains the highest amount of variance, followed by PC2, PC3, and PC4. We can visualize the cumulative variance explained by the principal components:

**Cumulative variance explained**


```r
cumulative_variance <- cumsum(variance_explained)
df_variance <- data.frame(Principal_Component = 1:length(variance_explained), Cumulative_Variance_Explained = cumulative_variance)

ggplot(df_variance, aes(x = Principal_Component, y = Cumulative_Variance_Explained)) +
  geom_line() +
  labs(x = "Principal Component", y = "Cumulative Variance Explained") +
  geom_hline(yintercept = 0.9, linetype = "dashed", color = "red") +
  geom_text(aes(label = paste0(round(cumulative_variance * 100, 1), "%")), vjust = -0.5, hjust = 1) +
  theme_minimal()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-7-1.png" width="672" />
![cumulative variance explained](index.en_files/figure-html/unnamed-chunk-7-1.png)

From the plot, we can see that the first two principal components (PC1 and PC2) explain more than 95% of the variance in the data.

We can also visualize the transformed data in the PCA space:

**Create a data frame with the principal components**


```r
pca_data <- as.data.frame(pca_result$x[, 1:2])
pca_data$Species <- iris_species
```

**Plot the transformed data**


```r
ggplot(pca_data, aes(PC1, PC2, color = Species)) +
  geom_point() +
  labs(x = "Principal Component 1", y = "Principal Component 2") +
  theme_minimal()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-9-1.png" width="672" />
The scatter plot shows how the different species of Iris are distributed in the PCA space. We can observe that the setosa species is clearly separated from the versicolor species and virginica species.

#t-SNE (t-Distributed Stochastic Neighbor Embedding)

Another popular technique for dimensionality reduction is t-SNE, which is particularly effective for visualizing high-dimensional data in a lower-dimensional space. t-SNE aims to preserve the local structure of the data points, making it suitable for identifying clusters and patterns.

Let's apply t-SNE to the Iris dataset:

**Perform t-SNE**


```r
tsne_result <- tsne::tsne(scaled_features)
```
The `tsne()` function from the tsne package performs t-SNE and returns the transformed data as an object. We can visualize the t-SNE embedding using a scatter plot:

**Create a data frame with the t-SNE coordinates**


```r
tsne_data <- as.data.frame(tsne_result)

tsne_data$Species <- iris_species
```

**Plot the t-SNE embedding**

```r
ggplot(tsne_data, aes(V1, V2, color = Species)) +
  geom_point() +
  labs(x = "t-SNE Dimension 1", y = "t-SNE Dimension 2") +
  theme_minimal()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-12-1.png" width="672" />
The scatter plot shows the Iris species in the t-SNE embedding space. We can see that the three species are clearly separated, indicating distinct clusters.

# Conclusion

Dimensionality reduction techniques like PCA and t-SNE are valuable tools for analyzing and visualizing high-dimensional datasets. They allow us to reduce the complexity of the data while preserving its important structural information. In this post, we demonstrated how to perform dimensionality reduction using the iris dataset in R, showcasing the applications of PCA and t-SNE.

Remember to experiment with different parameters, explore additional dimensionality reduction algorithms, and adapt these techniques to your specific datasets and analysis goals.

