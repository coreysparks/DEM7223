---
title: "Event History Analysis - Example 1 Functions of Survival Time"

author: "Corey S. Sparks, Ph.D."
date: "July 28, 2020"
layout: post
---


<section class="main-content">
<p>This example will illustrate how to construct a basic survival function from individual-level data. The example will use as its outcome variable, the event of a child dying before age 1. The data for this example come from the <a href="http://dhsprogram.com/data/Download-Model-Datasets.cfm?flag=1">Demographic and Health Survey Model Data Files</a> children’s recode file.</p>
<p>The DHS Program has created example datasets for users to practice with. These datasets have been created strictly for practice and do not represent any actual country’s data. See more <a href="http://dhsprogram.com/data/Download-Model-Datasets.cfm?flag=1#sthash.HRINGQ00.dpuf">here</a>.</p>
<p>This file contains information for all births to the sample of women between the ages of 15 and 49 in the last 5 years prior to the survey.</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb1-1" data-line-number="1"><span class="co">#Example 1</span></a>
<a class="sourceLine" id="cb1-2" data-line-number="2"><span class="kw">library</span>(haven)</a>
<a class="sourceLine" id="cb1-3" data-line-number="3"><span class="kw">library</span>(survival)</a>
<a class="sourceLine" id="cb1-4" data-line-number="4"></a>
<a class="sourceLine" id="cb1-5" data-line-number="5">model.dat&lt;-<span class="kw">read_dta</span>(<span class="st">&quot;https://github.com/coreysparks/data/blob/master/ZZKR62FL.DTA?raw=true&quot;</span>)</a></code></pre></div>
<p>##Event - Infant Mortality In the DHS, they record if a child is dead or alive and the age at death if the child is dead. This can be understood using a series of variables about each child.</p>
<p>If the child is alive at the time of interview, then the variable B5==1, and the age at death is censored.</p>
<p>If the age at death is censored, then the age at the date of interview (censored age at death) is the date of the interview - date of birth (in months).</p>
<p>If the child is dead at the time of interview,then the variable B5!=1, then the age at death in months is the variable B7. Here we code this:</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb2-1" data-line-number="1">model.dat<span class="op">$</span>death.age&lt;-<span class="kw">ifelse</span>(model.dat<span class="op">$</span>b5<span class="op">==</span><span class="dv">1</span>,</a>
<a class="sourceLine" id="cb2-2" data-line-number="2">                          ((((model.dat<span class="op">$</span>v008))<span class="op">+</span><span class="dv">1900</span>)<span class="op">-</span>(((model.dat<span class="op">$</span>b3))<span class="op">+</span><span class="dv">1900</span>)) </a>
<a class="sourceLine" id="cb2-3" data-line-number="3">                          ,model.dat<span class="op">$</span>b7)</a>
<a class="sourceLine" id="cb2-4" data-line-number="4"></a>
<a class="sourceLine" id="cb2-5" data-line-number="5"><span class="co">#censoring indicator for death by age 1, in months (12 months)</span></a>
<a class="sourceLine" id="cb2-6" data-line-number="6">model.dat<span class="op">$</span>d.event&lt;-<span class="kw">ifelse</span>(<span class="kw">is.na</span>(model.dat<span class="op">$</span>b7)<span class="op">==</span>T<span class="op">|</span>model.dat<span class="op">$</span>b7<span class="op">&gt;</span><span class="dv">12</span>,<span class="dv">0</span>,<span class="dv">1</span>)</a>
<a class="sourceLine" id="cb2-7" data-line-number="7">model.dat<span class="op">$</span>d.eventfac&lt;-<span class="kw">factor</span>(model.dat<span class="op">$</span>d.event); <span class="kw">levels</span>(model.dat<span class="op">$</span>d.eventfac)&lt;-<span class="kw">c</span>(<span class="st">&quot;Alive at 1&quot;</span>, <span class="st">&quot;Dead by 1&quot;</span>)</a>
<a class="sourceLine" id="cb2-8" data-line-number="8"><span class="kw">table</span>(model.dat<span class="op">$</span>d.eventfac)</a></code></pre></div>
<pre><code>## 
## Alive at 1  Dead by 1 
##       5434        534</code></pre>
<p>We see 534 infant deaths among the 5968 births in the last 5 years.</p>
<p>##Example of Estimating Survival Time Functions from data## To generate a basic life table, we use the <code>survfit()</code> procedure in the <code>survival</code> library. The data for this is a <code>Surv()</code> object, which typically has 2 arguments, the duration, and the censoring indicator. This uses age at death (the <code>death.age</code> variable from above) for children dying before age 1 as the outcome, and the <code>d.event</code> variable from above as the censoring indicator.</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb4-1" data-line-number="1"><span class="co">#Here we see the data</span></a>
<a class="sourceLine" id="cb4-2" data-line-number="2"><span class="kw">head</span>(model.dat[,<span class="kw">c</span>(<span class="st">&quot;death.age&quot;</span>,<span class="st">&quot;d.event&quot;</span>)], <span class="dt">n=</span><span class="dv">20</span>)</a></code></pre></div>
<pre><code>## # A tibble: 20 x 2
##    death.age d.event
##        &lt;dbl&gt;   &lt;dbl&gt;
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
## 20         0       0</code></pre>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" data-line-number="1"><span class="co">#The Surv() object</span></a>
<a class="sourceLine" id="cb6-2" data-line-number="2"><span class="kw">head</span>(<span class="kw">Surv</span>(model.dat<span class="op">$</span>death.age, model.dat<span class="op">$</span>d.event), <span class="dt">n=</span><span class="dv">20</span>)</a></code></pre></div>
<pre><code>##  [1]  5+ 37+ 30+ 10+ 30+  0  34+  1  18+  3  27+ 24+ 12+  9+  5  54+ 16+ 37+ 30+
## [20]  0+</code></pre>
<p>In the first 20 cases from the data, several children died (no <code>+</code> after the time), while all the other children had not experienced the event (they were still alive at age 12 months), these have a <code>+</code> after their censored age at death.</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb8-1" data-line-number="1">mort&lt;-<span class="kw">survfit</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span><span class="dv">1</span>, <span class="dt">data=</span>model.dat,<span class="dt">conf.type=</span><span class="st">&quot;none&quot;</span>)</a>
<a class="sourceLine" id="cb8-2" data-line-number="2"><span class="kw">plot</span>(mort, <span class="dt">ylim=</span><span class="kw">c</span>(.<span class="dv">9</span>,<span class="dv">1</span>), <span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">main=</span><span class="st">&quot;Survival Function for Infant Mortality&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-4-1.png" /><!-- --></p>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb9-1" data-line-number="1"><span class="kw">summary</span>(mort)</a></code></pre></div>
<pre><code>## Call: survfit(formula = Surv(death.age, d.event) ~ 1, data = model.dat, 
##     conf.type = &quot;none&quot;)
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
##    12   4303      66    0.903 0.00401</code></pre>
<p>This is the so-called Kaplan-Meier estimate of the survival function. At each month, we see the number of children at risk and the number dying. We see the highest number of deaths occurred between 0 and 1 month, which is not surprising.</p>
<p>The estimate is that the infant morality rate is 82.7382814, I get this by doing <code>1000*(1-summary(mort)$surv[12])</code>.</p>
<p>We can likewise get an estimate of the hazard function using the Kaplan-Meier method as well, using the <code>muhaz</code> library.</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb11-1" data-line-number="1"><span class="kw">library</span>(muhaz)</a>
<a class="sourceLine" id="cb11-2" data-line-number="2">haz&lt;-<span class="kw">kphaz.fit</span>(<span class="dt">time=</span>model.dat<span class="op">$</span>death.age, <span class="dt">status=</span>model.dat<span class="op">$</span>d.event, <span class="dt">method =</span> <span class="st">&quot;product-limit&quot;</span>)</a>
<a class="sourceLine" id="cb11-3" data-line-number="3"><span class="kw">kphaz.plot</span>(haz, <span class="dt">main=</span><span class="st">&quot;Hazard function plot&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-5-1.png" /><!-- --></p>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb12-1" data-line-number="1"><span class="kw">data.frame</span>(haz)</a></code></pre></div>
<pre><code>##    time         haz          var
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
## 12 11.5 0.015646925 3.709910e-06</code></pre>
<p>This illustrates, that while the largest drop in survivorship occurred between 0 and 1, the hazard is actually higher in the 1-3 month range, illustrating the conditionality of that probability. There is also a large jump in risk at age 1, which may indicate something about age-heaping in the data.</p>
<p>Now we have our S(t) and h(t) functions. We can derive the other functions of survival time from these but integrating (summing) and differentiating these functions.</p>
<div class="sourceCode" id="cb14"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb14-1" data-line-number="1"><span class="co">#cumulative hazard</span></a>
<a class="sourceLine" id="cb14-2" data-line-number="2"><span class="kw">plot</span>(<span class="kw">cumsum</span>(haz<span class="op">$</span>haz)<span class="op">~</span>haz<span class="op">$</span>time, </a>
<a class="sourceLine" id="cb14-3" data-line-number="3">     <span class="dt">main =</span> <span class="st">&quot;Cumulative Hazard function&quot;</span>,</a>
<a class="sourceLine" id="cb14-4" data-line-number="4">     <span class="dt">ylab=</span><span class="st">&quot;H(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>, </a>
<a class="sourceLine" id="cb14-5" data-line-number="5">     <span class="dt">type=</span><span class="st">&quot;l&quot;</span>,<span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">lwd=</span><span class="dv">2</span>,<span class="dt">col=</span><span class="dv">3</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-6-1.png" /><!-- --></p>
<div class="sourceCode" id="cb15"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb15-1" data-line-number="1"><span class="co">#Survival function, I just store this in an object so I can use it</span></a>
<a class="sourceLine" id="cb15-2" data-line-number="2">surv&lt;-mort</a>
<a class="sourceLine" id="cb15-3" data-line-number="3"></a>
<a class="sourceLine" id="cb15-4" data-line-number="4"><span class="co">#here is a cheap version of the pdf</span></a>
<a class="sourceLine" id="cb15-5" data-line-number="5">ft&lt;-<span class="st"> </span><span class="op">-</span><span class="kw">diff</span>(mort<span class="op">$</span>surv)</a>
<a class="sourceLine" id="cb15-6" data-line-number="6"><span class="kw">plot</span>(ft, <span class="dt">xlim=</span><span class="kw">c</span>(.<span class="dv">5</span>,<span class="fl">11.5</span>), </a>
<a class="sourceLine" id="cb15-7" data-line-number="7">     <span class="dt">type=</span><span class="st">&quot;s&quot;</span>,</a>
<a class="sourceLine" id="cb15-8" data-line-number="8">     <span class="dt">ylab=</span><span class="st">&quot;f(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>,</a>
<a class="sourceLine" id="cb15-9" data-line-number="9">     <span class="dt">main=</span><span class="st">&quot;Probability Density Function&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-6-2.png" /><!-- --></p>
<div class="sourceCode" id="cb16"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb16-1" data-line-number="1"><span class="co">#here is the cumulative distribution function</span></a>
<a class="sourceLine" id="cb16-2" data-line-number="2">Ft&lt;-<span class="kw">cumsum</span>(ft)</a>
<a class="sourceLine" id="cb16-3" data-line-number="3"><span class="kw">plot</span>(Ft, <span class="dt">xlim=</span><span class="kw">c</span>(<span class="fl">0.5</span>,<span class="dv">12</span>), <span class="dt">type=</span><span class="st">&quot;s&quot;</span>, <span class="dt">ylab=</span><span class="st">&quot;F(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>, <span class="dt">main=</span><span class="st">&quot;Cumulative Distribution Function&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-6-3.png" /><!-- --></p>
<p>So in this example, we calculated the censored ages at death for children under age 1, we estimated the survival function, hazard and Cumulative hazard functions, and the associated pdf and cdf’s.</p>
</section>
