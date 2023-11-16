---
title: 'College Success'
author: SAMIYA WEST
date: '3/25/21'
output:
  html_document:
    number_sections: true
abstract: Conducting a series of regression analyses to investigate the proposition that high-achieving high school students also perform well in college, utilizing a dataset containing information on high school SAT percentiles, high school GPA, and first-year college GPA.
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(tidyr)
library(dplyr)
library(ggplot2)
library(car)
```

# Overview

This project aims to examine the connection between high school academic performance and subsequent college success among a sample of 1000 students from an undisclosed college. The overall hypothesis is that students who excel in high school continue to excel academically in college. To examine this hypothesis, an array of statistical tests and analyses have been conducted on the data set, aiming to generate substantial evidence to either support or reject the null and alternate hypotheses.

Null Hypothesis (Ho): There is no significant relationship between high school performance (measured by SAT percentile and high school GPA) and college success (measured by first-year college GPA).
Alternate Hypothesis (Ha): There is a significant relationship between high school performance (measured by SAT percentile and high school GPA) and college success (measured by first-year college GPA).

# Data 

```{r}
sg = read.csv("satgpa_data.csv")
head(sg)
```

# Analysis
```{r}
lm_1 = lm(fy_gpa ~ hs_gpa, data = sg)
summary(lm_1)
cor(x = sg$hs_gpa,y = sg$fy_gpa)
```

```{r}
ggplot(data = sg, aes(x = hs_gpa, y = fy_gpa)) + geom_point() + geom_abline(intercept = 0.09132,slope = 0.74314) + labs(title = "First Year College GPA vs High School GPA")
```

fy_gpa = 0.74314 * hs_gpa + 0.9132
First year college GPA (fy_gpa) is modeled 0.74314*hs_gpa+0.9132. This implies that the intercept (when high school GPA is 0) is 0.9132, and for every one unit increase in high school GPA (hs_gpa) the first year college GPA is expected to increase by 0.74314.

```{r}
lm_2 = lm(fy_gpa ~ sat_sum, data = sg)
summary(lm_2)
cor(x = sg$sat_sum,y = sg$fy_gpa)
```

```{r}
ggplot(data = sg, aes(x = sat_sum, y = fy_gpa)) + geom_point() + geom_abline(intercept = 0.001927, slope = 0.023866 ) + labs(title = "First Year College GPA vs SAT Percentile Total")
```

fy_gpa = 0.023866 * sat_sum + 0.001927
First year college GPA (fy_gpa) is modeled 0.023866*sat_sum+0.001927. This implies that the intercept (when sat sum is 0) is 0.001927, and for every one unit increase in sat sum the first year college GPA  is expected to increase by 0.023866. 

## Model 1

```{r}
mod1 = lm(fy_gpa ~ sat_sum + hs_gpa, data = sg)
summary(mod1)
cor(x= sg$sat_sum+sg$hs_gpa, y = sg$fy_gpa)
```

## Model 2

```{r}
mod2 = lm(fy_gpa ~ sat_sum+hs_gpa+I(sat_sum*hs_gpa), data = sg)
summary(mod2)
cor(sg$sat_sum+sg$hs_gpa+I(sg$sat_sum*sg$hs_gpa), y = sg$fy_gpa)
```

The interaction term of high school GPA and sat sum is the only significant predictor in this model.

## Model 3 

```{r}
mod3 = lm(fy_gpa ~ I(sat_sum * hs_gpa), data = sg)
summary(mod3)
cor(x = I(sg$sat_sum * sg$hs_gpa), y = sg$fy_gpa)
```

## Assumptions
```{r}
hist(mod3$residuals, breaks = 30,
     xlab = "residuals",
     main = "Histogram of Residuals")
```

```{r}
res = resid(mod3)
plot(mod3)
```

```{r}
durbinWatsonTest(mod3)
```

```{r}
cooks3 = cooks.distance(mod3)
influential3 = cooks3[(cooks3 > (3 * mean(cooks3)))]
num3 = length(influential3)
num3
non_influential = which(!(1:length(cooks3) %in% influential3))
data_without_outliers = sg[non_influential, ]
mod4 = lm(fy_gpa ~ I(sat_sum * hs_gpa), data = data_without_outliers)
summary(mod4)
```

95% Confidence for Model 3
```{r}
beta_0 = 0.0051153    
SE = 0.0002161
qmin = qt(.025,df=998)
qmax = (qt(1-.025,df=998))
beta_0 + qmax*SE
beta_0 + qmin*SE
```

(0.004691237,0.005539363)

# Results

Among the three models, Model 3 emerges as the preferred choice. The decision to build Model 3 was influenced by the significance of the interaction term observed in Models 1 and 2. Despite the adjusted R-squared values and residual standard error being comparable throughout the models, Model 3 stands out with a higher F-statistic and correlation coefficient. Model 3 is a simpler model because it contains fewer predictors. It demonstrates statistical significance, but also presents a greater overall fit to the data.

After deciding model 3 was the best fit it needed to be tested against the assumptions. 

1. Linearity: The presence of a linear relationship between each independent variable and the dependent variable was examined through scatter plots, focusing on the relationships between high school GPA and first-year college GPA, as well as SAT sum percentiles and first-year college GPA. 

2. Normality of Residuals: The normality of residuals was evaluated using a histogram and a Q-Q plot. This allowed for an assessment of whether the residuals approximated a normal distribution.

3. Homoscedasticity: To ensure equal or similar variance in residuals, a Residuals vs. Fitted plot was examined. This visual inspection aimed to identify patterns in the spread of residuals across the range of fitted values.

4. Independence: The Durbin-Watson Test was utilized to evaluate the residuals' independence. This test offered insights into whether autocorrelation might be present in the residuals.

5. Outliers or High Influential points: Exploration for potential outliers or highly influential points was analyzed through a Residuals vs. Leverage Plot. Additionally, Cook's distance formula was applied to identify them. With 7.9% of the data points being outliers meant accessing their influence on the model. With removing the points from the linear model no influence was found.  

These tests collectively contributed to a comprehensive evaluation of the validity of Model 3.

For the interaction term 'I(sat_sum * hs_gpa)' in the regression model predicting first-year college GPA, the estimated coefficient is 0.0051 (95% CI: 0.0047, 0.0055). This suggests that, with 95% confidence, the true effect of the interaction between SAT percentile and high school GPA on first-year college GPA falls within the range of 0.0047 to 0.0055.

# Conclusion

Null Hypothesis (Ho): There is no significant relationship between high school performance (measured by SAT percentiles and high school GPAs) and college success (measured by first-year college GPAs).
Alternate Hypothesis (Ha): There is a significant relationship between high school performance (measured by SAT percentiles and high school GPAs) and college success (measured by first-year college GPAs).

Based on the analysis conducted there is strong evidence to support the alternate hypothesis that there is a significant relationship between high school performance (measured by SAT percentiles and high school GPAs) and college success (measured by first-year college GPAs).
The key findings and evidence are summarized below:

The analysis, focusing on Model 3 as the preferred model implies that there is a significant relationship between high school performance (measured by SAT percentiles and high school GPAs) and college success (measured by first-year college GPAs). Model 3 was chosen as the preferred model due to the significance of the interaction term in Model 2 and it's simplicity. Despite having comparable adjusted R-squared values and residual standard errors across all models, Model 3 stood out with a higher F-statistic and correlation coefficient, indicating a more overall fit. The assumption testing included testing for linearity by examining scatter plots, examining a histogram and a Q-Q plot to determine if residuals were nearly normal, residuals vs fitted plot to assess homoscedasticity, independence validations through the Durbin-Watson test, and the identification of outliers through a Residuals vs. Leverage and Cook's Distance Formula. All findings contributed to the validation of model 3. As a result the evidence from the analysis supports the existence of a significant relationship between high school performance and college success. The null hypothesis (Ho) of no significant relationship is rejected in favor of the alternate hypothesis (Ha). These findings contribute valuable insights into the predictive power of high school academic indicators on first-year college GPA.

# References

“SAT and GPA Data.” Data Sets, [Link](https://www.openintro.org/data/index.php?data=satgpa)
