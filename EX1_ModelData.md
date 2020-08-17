---
title: "DEM 7223 - Introduction to Event History Analysis and Functions of Survival Time"
author: "Corey S. Sparks, Ph.D."
date: "17 August, 2020"
output: 
  html_document:
    toc: yes
    includes:
    in_header: logo.html
    keep_md: true
---



# Rational for Event history analysis

### When to conduct an event history analysis?
* When you questions include
  + When or Whether
  + When > how long until an event occurs
  + Whether > does an event occur or not
*  If your question does not include either of these ideas (or cannot be made to) then you do not need to do event history analysis

### Basic Propositions
* Since most of the methods we will discuss originate from studies of mortality, they have morbid names
  + Survival – This is related to how long a case lasts until it experiences the event of interest
  + How long does it take?
  + Risk – How likely is it that the case will experience the event
  + Will it happen or not?

### Focus on comparison
* Most of the methods we consider are comparative by their nature
* How long does a case with trait x survive, compared to a case with trait y?
* How likely is it for a person who is married to die of homicide relative to someone who is single?
* Generally we are examining relative risk and relative survival

### Some terminology
* **State** – discrete condition an individual may occupy that occur within a state space.  Most survival analysis methods assume a single state to state transition
* **State space** – full set of state alternatives
* **Episodes/Events/Transitions** – a change in states
* **Durations** – length of an episode
* **Time axis** – Metric for measuring durations (days, months, years)

### Issues in event history data
#### Censoring
* **Censoring** occurs when you do not actually observe the event of interest within the period of data collection
  + e.g. you know someone gets married, but you never observe them having a child
  + e.g. someone leaves alcohol treatment and is never observed drinking again

![Censoring](images/censoring.png)

#### Non-informative censoring
* The individual is not observed because the observer ends the study period
* The censoring is not related to any trait or action of the case, but related to the observer
  + We want most of our censoring to be this kind

#### Informative censoring
* The individual is not observed because they represent a special case
* The censoring IS related to something about the individual, and these people differ inherently from uncensored cases
* People that are censored ARE likely to have experience the event


#### Right censoring
* An event time is unknown because it is not observed.
  + This is easier to deal with

#### Left censoring
* An event time is unknown because it occurred prior to the beginning of data collection, but not when
  + This is difficult to deal with

#### Interval censoring
* The event time is known to have occurred within a period of time, but it is unknown exactly when
  + This can be dealt with


## Time Scales
* Continuous time
  + Time is measured in very precise, unique increments > miles until a tire blows out 
  + Each observed duration is unique
* Discrete time
  + Time is measured in discrete lumps > semester a student leaves college
  + Each observed duration is not necessarily unique, and takes one of a set of discrete values

#### Making continuous outcomes discrete
* Ideally you should measure the duration as finely as possible (see Freedman et al)
* Often you may choose to discretize the data > take continuous time and break it into discrete chunks

* Problems
  + This removes possibly informative information on duration variability
  + Any discrete dividing point is arbitrary
  + You may arrive at different conclusions given the interval you choose
  + You lose information about late event occurrence
  + Lose all information on mean or average durations


## Kinds of studies with event history data

* Cross sectional
  + Measured at one time point (no change observed)
  + Can measure lots of things at once
* Panel data
  + Multiple measurements at discrete time points on the same individuals
  + Can look at change over time
* Event history
  + Continuous measurement of units over a fixed period of time, focusing on change in states
  + Think clinical follow-ups

* Longitudinal designs
  + Prospective designs
  + Studies that follow a group (cohort) and follow them over time
  + Expensive and take a long time, but can lead to extremely valuable information on changes in behaviors

 * Retrospective designs
  + Taken at a cross section
  + Ask respondents about events that have previously occurred. 
  + Generate birth/migration/marital histories for individuals
  + Problems with recall bias
  + DHS includes a detailed history of births over the last 5 years

* Record linkage procedures
  + Begin with an event of interest (birth, marriage) and follow individuals using various record types
  + Birth > Census 1880 > Census 1890 > Marriage > Birth of children > Census 1900 > Tax records >Death certificate
  + Mostly used in historical studies
  + Modern studies link health surveys to National Death Index (NHANES, NHIS)

## Some arrangements for event history data
### Counting process data
* This is what we are accustomed to in the life table


```r
t1<-data.frame(Time_start=c(1,2,3,4),
               Time_end=c(2,3,4,5),
               Failing=c(25,15,12,20),
               At_Risk=c(100, 75, 60, 40))
t1%>%
  kable()%>%
  column_spec(1:4, border_left = T, border_right = T)%>%
  kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Time_start </th>
   <th style="text-align:right;"> Time_end </th>
   <th style="text-align:right;"> Failing </th>
   <th style="text-align:right;"> At_Risk </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 25 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 15 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 75 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 12 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 60 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 5 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 20 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 40 </td>
  </tr>
</tbody>
</table>

```r
#knitr::kable(t1,format = "html", caption = "Counting Process data" ,align = "c", )
```
### Case - duration, or person level data
* This is the general form of continuous time survival data.


```r
t2<-data.frame(ID = c(1,2,3,4),
               Duration=c(5, 2, 9 , 6), 
               Event_Occurred=c("Yes (1)","Yes (1)","No (0)", "Yes (1)" ))
t2%>%
  kable()%>%
  column_spec(1:3, border_left = T, border_right = T)%>%
  kable_styling(row_label_position = "c", position = "center" )
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> ID </th>
   <th style="text-align:right;"> Duration </th>
   <th style="text-align:left;"> Event_Occurred </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 5 </td>
   <td style="text-align:left;border-left:1px solid;border-right:1px solid;"> Yes (1) </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:left;border-left:1px solid;border-right:1px solid;"> Yes (1) </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 9 </td>
   <td style="text-align:left;border-left:1px solid;border-right:1px solid;"> No (0) </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 6 </td>
   <td style="text-align:left;border-left:1px solid;border-right:1px solid;"> Yes (1) </td>
  </tr>
</tbody>
</table>

```r
#knitr::kable(t2, format = "html", caption = "Case-duration data", align = "c")
```

This can be transformed into person-period data, or discrete time data.

### Person – Period data
* Express exposure as discrete periods
* Event occurrence is coded at each period

```r
t3<-data.frame(ID=c(rep(1, 5), rep(2, 2), rep(3, 9), rep(4, 6)),
                    Period = c(seq(1:5), seq(1:2), seq(1:9), seq(1:6)),
                    Event=c(0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
t3%>%
  kable()%>%
  column_spec(1:3, border_left = T, border_right = T)%>%
  kable_styling(row_label_position = "c", position = "center" )
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> ID </th>
   <th style="text-align:right;"> Period </th>
   <th style="text-align:right;"> Event </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 5 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 5 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 6 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 7 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 8 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 9 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 1 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 2 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 3 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 5 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 4 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 6 </td>
   <td style="text-align:right;border-left:1px solid;border-right:1px solid;"> 0 </td>
  </tr>
</tbody>
</table>

# Functions of Survival Time
### From the life table

We had functions $l(x)$ and $q(x)$, representing survival to age $x$ and risk of decrementing at age $x$, respectively. 

Now we must generalize these ideas to incorporate them into the broader event-history framework

Survival/duration times measure the *time to a certain event.*

These times are subject to random variations, and are considered to be random *iid* (independent and identically distributed; random) variates from some distribution

* The distribution of survival times is described by 3 functions
* The survivorship function, $S(t)$
* The probability density function, $f(t)$
* The hazard function, $h(t)$

![3 functions](images/functions.png)

```r
Ft<-cumsum(dlnorm(x = seq(0, 110, 1), meanlog = 4.317488, sdlog = 2.5)) #mean of 75 years, sd of 12.1 years
ft<-diff(Ft)
St<-1-Ft
ht<-ft/St[1:110]
plot(Ft, ylim=c(0,1))
lines(St, col="red")
```

![](EX1_ModelData_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
plot(ht, col="green")
```

![](EX1_ModelData_files/figure-html/unnamed-chunk-5-2.png)<!-- -->

* These three are mathematically related, and if given one, we can calculate the others
  + These 3 functions each represent a different aspect of the survival time distribution.  

* The fundamental problem in survival analysis is coming up with a way to estimate these functions.

### Defining the functions
Let *T* denote the survival time, our goal is to characterize the distribution of *T* using these 3 functions.

Let *T* be a discrete(or continuous) *iid* random variable and let $t_i$, be an occurrence of that variable, such that $Pr(t_i)=Pr(T=t_i)$

### The distribution function, or *pdf*
Like any other random variates survival times have a simple distribution function that gives the probability of observing a particular survival time within a finite interval

The density function is defined as the limit of the probability that an individual fails (experiences the event) in a short interval $t+\Delta t$ (read delta t), per width of $\Delta t$, or simply the probability of failure in a small interval per unit time, $f(t_i) = Pr(T=t_i)$. 

If $F(t)$ is the cumulative distribution function for *T*, given by:

$$ F(t) = \int_{0}^{t} f(u) du = Pr(T \leqslant t )$$ 
Which is the probability of observing a value of *T* prior to the current value, *t*.

The density function is then:

$$ f(t) = \frac{F(t)}{d(t)} = F'(t)$$ 
or

$$ f(t) = \lim_{\delta t \rightarrow 0} \frac{F(t+\Delta t) - F(t)}{\Delta t}$$

The density function gives the unconditional instantaneous failure rate in the (very small) interval between *t* and *dt*, $\Delta t$

### Survival Function
The survival function, *S(t)* is expressed:

$$ S(t) = 1 - F(t) = Pr (T \geqslant t)$$

Which is the probability that *T* takes a value larger than *t*.  i.e. the event happens some time after the present time.

At $t = 0, S(t) =1 \text { and  at } t= \infty, \text { and } S(t) =0$

As time passes, *S(t)* decreases, and is called a *strictly decreasing function of time*.

Empirically, *S(t)* takes the form of a step function:


```r
St<- c(1, cumprod(1-(t1$Failing/t1$At_Risk)))

plot(St, type="s", xlab = "Time", ylab="S(t)", ylim=c(0,1))
```

![](EX1_ModelData_files/figure-html/unnamed-chunk-6-1.png)<!-- -->




### The hazard function

The hazard function relates death, *f(t)*, and survival, *S(t)*, to one another

$$h(t) = \frac{f(t)}{S(t)}$$
$$h(t) = \lim_{\Delta t \rightarrow 0} \frac{Pr(t \leqslant T \leqslant t + \Delta t | T \geqslant t)}{\Delta t}$$

Which is the failure rate per unit time in the interval *t*, $t+\Delta t$, the hazard may increase or decrease with time, or stay the same. This is really dependent on the distribution of failure times.

## Relationships among the three functions

If $ft = \frac{dF(t)}{dt}$ and $S(t) = 1- F(t)$ and, $h(t) = \frac{f(t)}{S(t)}$, then we can write:

$$f(t) = \frac{-dS(t)}{dt}$$

and the hazard function as:

$$h(t) = \frac{{-dS(t)}/{dt}{S(t)}$$ 

If we integrate this and let $S(0)=1$, then

$$S(t) = exp^{-\int_{0}^t h(u) du} = e^{-H(t)}$$

where the quantity, $H(t)$ is called the *cumulative hazard function* and, $H(t) = \int h(u) du$, then

$$H(t) = -\text{log }  S(t)$$

The density can be written as:

$$f(t) = h(t) e ^{-H(t)}$$
and

$$h(t) = \frac{h(t) e^{-H(t)}}{e^{-H(t)}} = \frac{f(t)}{S(t)}$$

### More on the hazard function...

Unlike the *f(t)* or *S(t)*, *h(t)* describes the risk an individual faces of experiencing the event, given they have survived up to that time.

This kind of conditional probability is of special interest to us.

We can extend this framework to include effects of *individual characteristics on one's risk*, thus not only introducing dependence on time, but also on these characteristics (covariates).  

We can re-express the hazard rate with both these conditions as:

$$h(t|x) = \lim_{\Delta t \rightarrow 0} \frac{Pr(t \leqslant T \leqslant t + \Delta t | T \geqslant t, x)}{\Delta t}$$

## Quantiles of Survival time

Since *S(t)* is a cumulative function $S(t) = 1-F(t)$

We can calculate quantiles of its distribution, or the time by which (for example) 10, 25, 50, 75 % of the sample have experienced the event. 

#### Median life time
This is the time by which 50% of the sample has experienced the event. 
To estimate median life time, if $S(t)=.5$ is not directly observed:

$$\text{Est. Median Life Time} = m + \left [ \frac{\hat{S(t_m)-.5}}{\hat{S(t_m)}-\hat{S(t_m)}}  \right ] ((m+1)-m)$$
And you can use this method of interpolation to find any percentile of the survival function, as long as it is bound by other values. 

Another note, in data, often times 50% of the observations do not fail in the study period, so the median may not be observed. Also, don't assume that the median survival time is a particularly high period of risk, medians are just a point in a distribution, nothing more, nothing less.

## Example from data

This example will illustrate how to construct a basic survival function from individual-level data. The example will use as its outcome variable, the event of a child dying before age 1. The data for this example come from the  [Demographic and Health Survey Model Data Files](http://dhsprogram.com/data/Download-Model-Datasets.cfm?flag=1) children's recode file. 

The DHS Program has created example datasets for users to practice with. These datasets have been created strictly for practice and do not represent any actual country's data. See more [here](http://dhsprogram.com/data/Download-Model-Datasets.cfm?flag=1#sthash.HRINGQ00.dpuf). 

This file contains information for all births to the sample of women between the ages of 15 and 49 in the last 5 years prior to the survey.



```r
#Example 1
library(haven)
library(survival)

model.dat<-read_dta("https://github.com/coreysparks/data/blob/master/ZZKR62FL.DTA?raw=true")
```


## Event - Infant Mortality
In the DHS, they record if a child is dead or alive and the age at death if the child is dead. This can be understood using a series of variables about each child. 

If the child is alive at the time of interview, then the variable B5==1, and the age at death is censored. 

If the age at death is censored, then the age at the date of interview (censored age at death) is the date of the interview - date of birth (in months). 

If the child is dead at the time of interview,then the variable B5!=1, then the age at death in months is the variable B7. Here we code this:


```r
model.dat$death.age<-ifelse(model.dat$b5==1,
                          ((((model.dat$v008))+1900)-(((model.dat$b3))+1900)) 
                          ,model.dat$b7)

#censoring indicator for death by age 1, in months (12 months)
model.dat$d.event<-ifelse(is.na(model.dat$b7)==T|model.dat$b7>12,0,1)
model.dat$d.eventfac<-factor(model.dat$d.event); levels(model.dat$d.eventfac)<-c("Alive at 1", "Dead by 1")
table(model.dat$d.eventfac)
```

```
## 
## Alive at 1  Dead by 1 
##       5434        534
```

We see 534 infant deaths among the 5968 births in the last 5 years.

## Example of Estimating Survival Time Functions from data##
To generate a basic life table, we use the `survfit()` procedure in the `survival` library. The data for this is a `Surv()` object, which typically has 2 arguments, the duration, and the censoring indicator. This uses age at death (the `death.age` variable from above) for children dying before age 1 as the outcome, and the `d.event` variable from above as the censoring indicator.


```r
#Here we see the data
head(model.dat[,c("death.age","d.event")], n=20)
```

```
## # A tibble: 20 x 2
##    death.age d.event
##        <dbl>   <dbl>
##  1         5       0
##  2        37       0
##  3        30       0
##  4        10       0
##  5        30       0
##  6         0       1
##  7        34       0
##  8         1       1
##  9        18       0
## 10         3       1
## 11        27       0
## 12        24       0
## 13        12       0
## 14         9       0
## 15         5       1
## 16        54       0
## 17        16       0
## 18        37       0
## 19        30       0
## 20         0       0
```

```r
#The Surv() object
head(Surv(model.dat$death.age, model.dat$d.event), n=20)
```

```
##  [1]  5+ 37+ 30+ 10+ 30+  0  34+  1  18+  3  27+ 24+ 12+  9+  5  54+ 16+ 37+ 30+
## [20]  0+
```

In the first 20 cases from the data, several children died (no `+` after the time), while all the other children had not experienced the event (they were still alive at age 12 months), these have a `+` after their censored age at death.


```r
mort<-survfit(Surv(death.age, d.event)~1, data=model.dat,conf.type="none")
plot(mort, ylim=c(.9,1), xlim=c(0,12), main="Survival Function for Infant Mortality")
```

![](EX1_ModelData_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

```r
summary(mort)
```

```
## Call: survfit(formula = Surv(death.age, d.event) ~ 1, data = model.dat, 
##     conf.type = "none")
## 
##  time n.risk n.event survival std.err
##     0   5968     209    0.965 0.00238
##     1   5690      26    0.961 0.00252
##     2   5573      37    0.954 0.00271
##     3   5423      38    0.948 0.00290
##     4   5282      25    0.943 0.00302
##     5   5161      22    0.939 0.00313
##     6   5021      26    0.934 0.00326
##     7   4880      18    0.931 0.00334
##     8   4755      26    0.926 0.00347
##     9   4621      23    0.921 0.00359
##    10   4507       5    0.920 0.00361
##    11   4405      13    0.917 0.00368
##    12   4303      66    0.903 0.00401
```

This is the so-called Kaplan-Meier estimate of the survival function. At each month, we see the number of children at risk and the number dying. We see the highest number of deaths occurred between 0 and 1 month, which is not surprising.

The estimate is that the infant morality rate is 82.7382814, I get this by doing `1000*(1-summary(mort)$surv[12])`. 

We can likewise get an estimate of the hazard function using the Kaplan-Meier method as well, using the `muhaz` library.


```r
library(muhaz)
haz<-kphaz.fit(time=model.dat$death.age, status=model.dat$d.event, method = "product-limit")
kphaz.plot(haz, main="Hazard function plot")
```

![](EX1_ModelData_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

```r
data.frame(haz)
```

```
##    time         haz          var
## 1   0.5 0.004617002 8.198994e-07
## 2   1.5 0.006722906 1.221621e-06
## 3   2.5 0.007109508 1.330224e-06
## 4   3.5 0.004784710 9.157877e-07
## 5   4.5 0.004326655 8.509621e-07
## 6   5.5 0.005244306 1.057883e-06
## 7   6.5 0.003732925 7.741945e-07
## 8   7.5 0.005545073 1.182716e-06
## 9   8.5 0.005037790 1.103514e-06
## 10  9.5 0.001118111 2.500496e-07
## 11 10.5 0.002993934 6.895473e-07
## 12 11.5 0.015646925 3.709910e-06
```

This illustrates, that while the largest drop in survivorship occurred between 0 and 1, the hazard is actually higher in the 1-3 month range, illustrating the conditionality of that probability. There is also a large jump in risk at age 1, which may indicate something about age-heaping in the data.

Now we have our S(t) and h(t) functions. We can derive the other functions of survival time from these but integrating (summing) and differentiating these functions. 


```r
#cumulative hazard
plot(cumsum(haz$haz)~haz$time, 
     main = "Cumulative Hazard function",
     ylab="H(t)",xlab="Time in Months", 
     type="l",xlim=c(0,12), lwd=2,col=3)
```

![](EX1_ModelData_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

```r
#Survival function, I just store this in an object so I can use it
surv<-mort

#here is a cheap version of the pdf
ft<- -diff(mort$surv)
plot(ft, xlim=c(.5,11.5), 
     type="s",
     ylab="f(t)",xlab="Time in Months",
     main="Probability Density Function")
```

![](EX1_ModelData_files/figure-html/unnamed-chunk-13-2.png)<!-- -->

```r
#here is the cumulative distribution function
Ft<-cumsum(ft)
plot(Ft, xlim=c(0.5,12), type="s", ylab="F(t)",xlab="Time in Months", main="Cumulative Distribution Function")
```

![](EX1_ModelData_files/figure-html/unnamed-chunk-13-3.png)<!-- -->

So in this example, we calculated the censored ages at death for children under age 1, we estimated the survival function, hazard and Cumulative hazard functions, and the associated pdf and cdf's.


