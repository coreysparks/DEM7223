---
title: "DEM 7223 - Event History Analysis - Example 1 Functions of Survival Time"

author: "Corey S. Sparks, PhD"
date: "September 3, 2019"
layout: post
---


<section class="main-content">
<div id="functions-of-survival-time" class="section level1">
<h1>Functions of survival time</h1>
<p>Survival or event history data have special functions of the duration aspect. Remember, survival or event history data are generally represented by a dyad of information, so the outcome has two parts. The first part being the actual <em>time duration</em>, and the second being the <em>censoring, or event indicator</em>, which indicates whether the event of interest was observed or not at that time point.</p>
<div id="homage-to-the-life-table" class="section level2">
<h2>Homage to the life table</h2>
<p>In life tables, we had lots of functions of the death process. Some of these were more interesting than others, with two being of special interest to use here. These are the <span class="math inline">\(l(x)\)</span> and <span class="math inline">\(q(x, n)\)</span> functions. If you recall, <span class="math inline">\(l(x)\)</span> represents the population size of the stationary population that is alive at age <span class="math inline">\(x\)</span>, and the risk of dying between age <span class="math inline">\(x, x+n\)</span> is <span class="math inline">\(q(x, n)\)</span>.</p>
<p>These are genearlized more in the event history analysis literature, but we can still describe the distrubion of survival time using three functions. These are the <strong>Survival Function</strong>, <span class="math inline">\(S(t)\)</span>, the <strong>probability density function</strong>, <span class="math inline">\(f(t)\)</span>, and the <strong>hazard function</strong>, <span class="math inline">\(h(t)\)</span>. These three are related and we can derive one from the others.</p>
</div>
<div id="defining-the-functions" class="section level2">
<h2>Defining the functions</h2>
<p>If we take statistical notation for a while, then we can say that our duration variable can be a discrete or continuous random variable, <span class="math inline">\(T\)</span>, where we observe <span class="math inline">\(t_i\)</span>.</p>
<p>The probability density, <span class="math inline">\(f(t)\)</span> is the probability that an individual observation falls within a short interval (if we are using a discrete function), such that <span class="math inline">\(f(t) = Pr(T = t_i)\)</span>, and the <strong>cumulative distribution function</strong>, or CDF of <span class="math inline">\(t\)</span> is <span class="math inline">\(F(t) = \sum_t^{t + \delta_t} Pr(T \le t) = \sum_t^{t + \delta_t} f(t)\)</span>. This tells us the probability of seeing a time before a given value of <span class="math inline">\(T\)</span>.</p>
<p>From the CDF, we can get the pdf by differentiating it.</p>
<p><span class="math inline">\(f(t) = \frac {dF(t)}{d(t)} = F(t)&#39;\)</span> or <span class="math inline">\(f(t) =\lim_{\Delta_t \to 0} \frac {F(t+ \Delta_t) - F(t)}{d(t)}\)</span></p>
<p>This give us the unconditional probablity of failing in a very small interval of time.</p>
<p>The Survival function, <span class="math inline">\(S(t)\)</span> is the completment of the CDF, <span class="math inline">\(S(t) = 1- F(t) = Pr(T \geq t)\)</span>, and is the probabilty of surviving longer than a given time point. At time 0, <span class="math inline">\(S(t)= 1\)</span> and at time = <span class="math inline">\(\infty\)</span>, <span class="math inline">\(S(t)= 0\)</span>, so <span class="math inline">\(S(t)\)</span> is a strictly decreasing function of time. Take-away - everything dies.</p>
<p>The hazard function, <span class="math inline">\(h(t)\)</span> is the conditional probability of experienceing the event at time <span class="math inline">\(t\)</span>. It is related to the other functions as: <span class="math inline">\(h(t) = \frac{f(t)}{S(t)}\)</span>. So, it’s the probability of dying at time t, conditional on surviving to that time.</p>
<p>It can also be written: <span class="math inline">\(h(t) = \frac{Pr(t \leq T \leq t+\Delta_t | T\geq t)}{\Delta_t}\)</span></p>
<p>It is also called the <strong>Instantaneous failure rate</strong>, and is of interest because it tells you how likely it is something is going to happen at a given time. If we have people with different values of a predictor, <span class="math inline">\(x\)</span>, then we can rewrite this as:</p>
<p><span class="math inline">\(h(t) = \frac{Pr(t \leq T \leq t+\Delta_t | T\geq t, x)}{\Delta_t}\)</span></p>
<p>We can also integrate the hazard function to get the summed risk of failure up to a particular time, this is called the <strong>Cumulative Hazard Function</strong>, <span class="math inline">\(H(t)\)</span>, <span class="math inline">\(H(t) = \int_0^t h(t) dt\)</span></p>
</div>
</div>
<div id="empirical-examples" class="section level1">
<h1>Empirical examples</h1>
<p>This example will illustrate how to construct a basic survival function from individual-level data. The example will use as its outcome variable, the event of a child dying before age 1. The data for this example come from the <a href="http://dhsprogram.com/data/Download-Model-Datasets.cfm?flag=1">Demographic and Health Survey Model Data Files</a> children’s recode file.</p>
<p>The DHS Program has created example datasets for users to practice with. These datasets have been created strictly for practice and do not represent any actual country’s data. See more <a href="http://dhsprogram.com/data/Download-Model-Datasets.cfm?flag=1#sthash.HRINGQ00.dpuf">here</a>.</p>
<p>This file contains information for all births to the sample of women between the ages of 15 and 49 in the last 5 years prior to the survey.</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb1-1" data-line-number="1"><span class="co">#Example 1</span></a>
<a class="sourceLine" id="cb1-2" data-line-number="2"><span class="kw">library</span>(haven)</a>
<a class="sourceLine" id="cb1-3" data-line-number="3"><span class="kw">library</span>(survival)</a>
<a class="sourceLine" id="cb1-4" data-line-number="4"><span class="kw">library</span>(car)</a></code></pre></div>
<pre><code>## Loading required package: carData</code></pre>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb3-1" data-line-number="1"><span class="kw">library</span>(muhaz)</a>
<a class="sourceLine" id="cb3-2" data-line-number="2">model.dat&lt;-<span class="kw">read_dta</span>(<span class="st">&quot;https://github.com/coreysparks/data/blob/master/ZZKR62FL.DTA?raw=true&quot;</span>)</a></code></pre></div>
<div id="event---infant-mortality" class="section level2">
<h2>Event - Infant Mortality</h2>
<p>In the DHS, they record if a child is dead or alive and the age at death if the child is dead. This can be understood using a series of variables about each child.</p>
<p>If the child is alive at the time of interview, then the variable B5==1, and the age at death is censored.</p>
<p>If the age at death is censored, then the age at the date of interview (censored age at death) is the date of the interview - date of birth (in months).</p>
<p>If the child is dead at the time of interview,then the variable B5!=1, then the age at death in months is the variable B7. Here we code this:</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb4-1" data-line-number="1">model.dat<span class="op">$</span>death.age&lt;-<span class="kw">ifelse</span>(model.dat<span class="op">$</span>b5<span class="op">==</span><span class="dv">1</span>,</a>
<a class="sourceLine" id="cb4-2" data-line-number="2">                          ((((model.dat<span class="op">$</span>v008))<span class="op">+</span><span class="dv">1900</span>)<span class="op">-</span>(((model.dat<span class="op">$</span>b3))<span class="op">+</span><span class="dv">1900</span>)) </a>
<a class="sourceLine" id="cb4-3" data-line-number="3">                          ,model.dat<span class="op">$</span>b7)</a>
<a class="sourceLine" id="cb4-4" data-line-number="4"></a>
<a class="sourceLine" id="cb4-5" data-line-number="5"><span class="co">#censoring indicator for death by age 1, in months (12 months)</span></a>
<a class="sourceLine" id="cb4-6" data-line-number="6">model.dat<span class="op">$</span>d.event&lt;-<span class="kw">ifelse</span>(<span class="kw">is.na</span>(model.dat<span class="op">$</span>b7)<span class="op">==</span>T<span class="op">|</span>model.dat<span class="op">$</span>b7<span class="op">&gt;</span><span class="dv">12</span>,<span class="dv">0</span>,<span class="dv">1</span>)</a>
<a class="sourceLine" id="cb4-7" data-line-number="7"></a>
<a class="sourceLine" id="cb4-8" data-line-number="8">model.dat<span class="op">$</span>d.eventfac&lt;-<span class="kw">factor</span>(model.dat<span class="op">$</span>d.event)</a>
<a class="sourceLine" id="cb4-9" data-line-number="9"></a>
<a class="sourceLine" id="cb4-10" data-line-number="10"><span class="kw">levels</span>(model.dat<span class="op">$</span>d.eventfac)&lt;-<span class="kw">c</span>(<span class="st">&quot;Alive at 1&quot;</span>, <span class="st">&quot;Dead by 1&quot;</span>)</a>
<a class="sourceLine" id="cb4-11" data-line-number="11"></a>
<a class="sourceLine" id="cb4-12" data-line-number="12"><span class="kw">table</span>(model.dat<span class="op">$</span>d.eventfac)</a></code></pre></div>
<pre><code>## 
## Alive at 1  Dead by 1 
##       5434        534</code></pre>
<p>We see 534 infant deaths among the 5968 births in the last 5 years.</p>
</div>
<div id="example-of-estimating-survival-time-functions-from-data" class="section level2">
<h2>Example of Estimating Survival Time Functions from data</h2>
<p>To generate a basic life table, we use the <code>survfit()</code> procedure in the <code>survival</code> library. The data for this is a <code>Surv()</code> object, which typically has 2 arguments, the duration, and the censoring indicator. This uses age at death (the <code>death.age</code> variable from above) for children dying before age 1 as the outcome, and the <code>d.event</code> variable from above as the censoring indicator.</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" data-line-number="1"><span class="co">#Here we see the data</span></a>
<a class="sourceLine" id="cb6-2" data-line-number="2"><span class="kw">head</span>(model.dat[,<span class="kw">c</span>(<span class="st">&quot;death.age&quot;</span>,<span class="st">&quot;d.event&quot;</span>)], <span class="dt">n=</span><span class="dv">20</span>)</a></code></pre></div>
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
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb8-1" data-line-number="1"><span class="co">#The Surv() object</span></a>
<a class="sourceLine" id="cb8-2" data-line-number="2"><span class="kw">head</span>(<span class="kw">Surv</span>(model.dat<span class="op">$</span>death.age, model.dat<span class="op">$</span>d.event), <span class="dt">n=</span><span class="dv">20</span>)</a></code></pre></div>
<pre><code>##  [1]  5+ 37+ 30+ 10+ 30+  0  34+  1  18+  3  27+ 24+ 12+  9+  5  54+ 16+ 37+ 30+
## [20]  0+</code></pre>
<p>In the first 20 cases from the data, several children died (no <code>+</code> after the time), while all the other children had not experienced the event (they were still alive at age 12 months), these have a <code>+</code> after their censored age at death.</p>
<div class="sourceCode" id="cb10"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb10-1" data-line-number="1">mort&lt;-<span class="kw">survfit</span>(<span class="kw">Surv</span>(<span class="dt">time=</span>death.age, <span class="dt">event =</span> d.event)<span class="op">~</span>b4, <span class="dt">data=</span>model.dat)</a>
<a class="sourceLine" id="cb10-2" data-line-number="2"><span class="kw">summary</span>(mort)</a></code></pre></div>
<pre><code>## Call: survfit(formula = Surv(time = death.age, event = d.event) ~ b4, 
##     data = model.dat)
## 
##                 b4=1 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0   2991     112    0.963 0.00347        0.956        0.969
##     1   2845      16    0.957 0.00371        0.950        0.964
##     2   2775      20    0.950 0.00399        0.942        0.958
##     3   2697      16    0.945 0.00421        0.936        0.953
##     4   2630      12    0.940 0.00437        0.932        0.949
##     5   2572      14    0.935 0.00455        0.926        0.944
##     6   2504      12    0.931 0.00471        0.922        0.940
##     7   2431      10    0.927 0.00484        0.917        0.936
##     8   2365      14    0.921 0.00503        0.912        0.931
##     9   2294      10    0.917 0.00517        0.907        0.928
##    10   2239       2    0.917 0.00520        0.906        0.927
##    11   2187       8    0.913 0.00531        0.903        0.924
##    12   2126      36    0.898 0.00581        0.886        0.909
## 
##                 b4=2 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0   2977      97    0.967 0.00325        0.961        0.974
##     1   2845      10    0.964 0.00342        0.957        0.971
##     2   2798      17    0.958 0.00368        0.951        0.965
##     3   2726      22    0.950 0.00400        0.943        0.958
##     4   2652      13    0.946 0.00418        0.938        0.954
##     5   2589       8    0.943 0.00430        0.934        0.951
##     6   2517      14    0.938 0.00450        0.929        0.946
##     7   2449       8    0.935 0.00461        0.926        0.944
##     8   2390      12    0.930 0.00478        0.921        0.939
##     9   2327      13    0.925 0.00497        0.915        0.934
##    10   2268       3    0.923 0.00501        0.914        0.933
##    11   2218       5    0.921 0.00509        0.911        0.931
##    12   2177      30    0.909 0.00552        0.898        0.920</code></pre>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb12-1" data-line-number="1"><span class="kw">library</span>(survminer)</a></code></pre></div>
<pre><code>## Loading required package: ggplot2</code></pre>
<pre><code>## Loading required package: ggpubr</code></pre>
<div class="sourceCode" id="cb15"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb15-1" data-line-number="1"><span class="kw">library</span>(ggplot2)</a>
<a class="sourceLine" id="cb15-2" data-line-number="2"><span class="kw">ggsurvplot</span>(mort, <span class="dt">conf.int =</span> T, <span class="dt">risk.table =</span> T</a>
<a class="sourceLine" id="cb15-3" data-line-number="3">           , <span class="dt">title=</span><span class="st">&quot;Survival to Age 1&quot;</span>,</a>
<a class="sourceLine" id="cb15-4" data-line-number="4">           <span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>, <span class="dv">12</span>), <span class="dt">ylim=</span><span class="kw">c</span>(.<span class="dv">9</span>,<span class="dv">1</span>))</a></code></pre></div>
<pre><code>## Warning: Vectorized input to `element_text()` is not officially supported.
## Results may be unexpected or may change in future versions of ggplot2.</code></pre>
<pre><code>## Warning: Removed 48 row(s) containing missing values (geom_path).</code></pre>
<pre><code>## Warning: Removed 48 rows containing missing values (geom_point).</code></pre>
<pre><code>## Warning: Removed 48 row(s) containing missing values (geom_path).</code></pre>
<pre><code>## Warning: Removed 48 rows containing missing values (geom_point).</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_SurvivalTime_2020_files/figure-html/unnamed-chunk-5-1.png" /><!-- --></p>
<p>This is the so-called Kaplan-Meier estimate of the survival function. At each month, we see the number of children at risk and the number dying. We see the highest number of deaths occurred between 0 and 1 month, which is not surprising.</p>
<p>The estimate is that the infant morality rate is 86.8083468, I get this by doing <code>1000*(1-summary(mort)$surv[12])</code>.</p>
<p>We can likewise get an estimate of the hazard function using the Kaplan-Meier method as well, using the <code>muhaz</code> library.</p>
<div class="sourceCode" id="cb21"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb21-1" data-line-number="1">haz&lt;-<span class="kw">kphaz.fit</span>(<span class="dt">time=</span>model.dat<span class="op">$</span>death.age, <span class="dt">status=</span>model.dat<span class="op">$</span>d.event, <span class="dt">method =</span> <span class="st">&quot;product-limit&quot;</span>)</a>
<a class="sourceLine" id="cb21-2" data-line-number="2"><span class="kw">kphaz.plot</span>(haz, <span class="dt">main=</span><span class="st">&quot;Hazard function plot&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_SurvivalTime_2020_files/figure-html/unnamed-chunk-6-1.png" /><!-- --></p>
<div class="sourceCode" id="cb22"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb22-1" data-line-number="1"><span class="kw">data.frame</span>(haz)</a></code></pre></div>
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
<div class="sourceCode" id="cb24"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb24-1" data-line-number="1"><span class="co">#cumulative hazard</span></a>
<a class="sourceLine" id="cb24-2" data-line-number="2"><span class="kw">plot</span>(<span class="kw">cumsum</span>(haz<span class="op">$</span>haz)<span class="op">~</span>haz<span class="op">$</span>time, </a>
<a class="sourceLine" id="cb24-3" data-line-number="3">     <span class="dt">main =</span> <span class="st">&quot;Cumulative Hazard function&quot;</span>,</a>
<a class="sourceLine" id="cb24-4" data-line-number="4">     <span class="dt">ylab=</span><span class="st">&quot;H(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>, </a>
<a class="sourceLine" id="cb24-5" data-line-number="5">     <span class="dt">type=</span><span class="st">&quot;l&quot;</span>,<span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">lwd=</span><span class="dv">2</span>,<span class="dt">col=</span><span class="dv">3</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_SurvivalTime_2020_files/figure-html/unnamed-chunk-7-1.png" /><!-- --></p>
<div class="sourceCode" id="cb25"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb25-1" data-line-number="1"><span class="co">#Survival function, I just store this in an object so I can use it</span></a>
<a class="sourceLine" id="cb25-2" data-line-number="2">surv&lt;-mort</a>
<a class="sourceLine" id="cb25-3" data-line-number="3"></a>
<a class="sourceLine" id="cb25-4" data-line-number="4"><span class="co">#here is a cheap version of the pdf</span></a>
<a class="sourceLine" id="cb25-5" data-line-number="5">ft&lt;-<span class="st"> </span><span class="op">-</span><span class="kw">diff</span>(mort<span class="op">$</span>surv)</a>
<a class="sourceLine" id="cb25-6" data-line-number="6"><span class="kw">plot</span>(ft, <span class="dt">xlim=</span><span class="kw">c</span>(.<span class="dv">5</span>,<span class="fl">11.5</span>), </a>
<a class="sourceLine" id="cb25-7" data-line-number="7">     <span class="dt">type=</span><span class="st">&quot;s&quot;</span>,</a>
<a class="sourceLine" id="cb25-8" data-line-number="8">     <span class="dt">ylab=</span><span class="st">&quot;f(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>,</a>
<a class="sourceLine" id="cb25-9" data-line-number="9">     <span class="dt">main=</span><span class="st">&quot;Probability Density Function&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_SurvivalTime_2020_files/figure-html/unnamed-chunk-7-2.png" /><!-- --></p>
<div class="sourceCode" id="cb26"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb26-1" data-line-number="1"><span class="co">#here is the cumulative distribution function</span></a>
<a class="sourceLine" id="cb26-2" data-line-number="2">Ft&lt;-<span class="kw">cumsum</span>(ft)</a>
<a class="sourceLine" id="cb26-3" data-line-number="3"><span class="kw">plot</span>(Ft, <span class="dt">xlim=</span><span class="kw">c</span>(<span class="fl">0.5</span>,<span class="dv">12</span>), <span class="dt">type=</span><span class="st">&quot;s&quot;</span>, <span class="dt">ylab=</span><span class="st">&quot;F(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>, <span class="dt">main=</span><span class="st">&quot;Cumulative Distribution Function&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_SurvivalTime_2020_files/figure-html/unnamed-chunk-7-3.png" /><!-- --></p>
<p>So in this example, we calculated the censored ages at death for children under age 1, we estimated the survival function, hazard and Cumulative hazard functions, and the associated pdf and cdf’s.</p>
</div>
</div>
</section>
