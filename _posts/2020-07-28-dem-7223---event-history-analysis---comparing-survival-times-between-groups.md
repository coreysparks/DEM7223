---
title: "DEM 7223 - Event History Analysis - Comparing Survival Times Between Groups"

author: "Corey Sparks, PhD"
date: "July 28, 2020"
layout: post
---


<section class="main-content">
<p>This example will illustrate how to test for differences between survival functions estimated by the Kaplan-Meier product limit estimator. The tests all follow the methods described by Harrington and Fleming (1982) <a href="http://biomet.oxfordjournals.org/content/69/3/553.short">Link</a>.</p>
<p>The first example will use as its outcome variable, the event of a child dying before age 1. The data for this example come from the model.data <a href="http://dhsprogram.com/data/dataset/model.dat_Standard-DHS_2012.cfm?flag=0">Demographic and Health Survey for 2012</a> children’s recode file. This file contains information for all births in the last 5 years prior to the survey.</p>
<p>The second example, we will examine how to calculate the survival function for a longitudinally collected data set. Here I use data from the <a href="http://nces.ed.gov/ecls/kinderdatainformation.asp">ECLS-K</a>. Specifically, we will examine the transition into poverty between kindergarten and fifth grade.</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb1-1" data-line-number="1"><span class="co">#load libraries</span></a>
<a class="sourceLine" id="cb1-2" data-line-number="2"><span class="kw">library</span>(haven)</a>
<a class="sourceLine" id="cb1-3" data-line-number="3"><span class="kw">library</span>(survival)</a>
<a class="sourceLine" id="cb1-4" data-line-number="4"><span class="kw">library</span>(car)</a></code></pre></div>
<pre><code>## Loading required package: carData</code></pre>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb3-1" data-line-number="1"><span class="kw">library</span>(muhaz)</a>
<a class="sourceLine" id="cb3-2" data-line-number="2">model.dat&lt;-<span class="kw">read_dta</span>(<span class="st">&quot;https://github.com/coreysparks/data/blob/master/ZZKR62FL.DTA?raw=true&quot;</span>)</a>
<a class="sourceLine" id="cb3-3" data-line-number="3">model.dat&lt;-<span class="kw">zap_labels</span>(model.dat)</a></code></pre></div>
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
<a class="sourceLine" id="cb4-7" data-line-number="7">model.dat<span class="op">$</span>d.eventfac&lt;-<span class="kw">factor</span>(model.dat<span class="op">$</span>d.event); <span class="kw">levels</span>(model.dat<span class="op">$</span>d.eventfac)&lt;-<span class="kw">c</span>(<span class="st">&quot;Alive at 1&quot;</span>, <span class="st">&quot;Dead by 1&quot;</span>)</a>
<a class="sourceLine" id="cb4-8" data-line-number="8"><span class="kw">table</span>(model.dat<span class="op">$</span>d.eventfac)</a></code></pre></div>
<pre><code>## 
## Alive at 1  Dead by 1 
##       5434        534</code></pre>
<div id="compairing-two-groups" class="section level3">
<h3>Compairing Two Groups</h3>
<p>We will now test for differences in survival by characteristics of the household. First we will examine whether the survival chances are the same for children in relatively high ses (in material terms) households, compared to those in relatively low-ses households.</p>
<p>This is the equvalent of doing a t-test, or Mann-Whitney U test for differences between two groups.</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" data-line-number="1"><span class="kw">library</span>(survminer)</a></code></pre></div>
<pre><code>## Loading required package: ggplot2</code></pre>
<pre><code>## Loading required package: ggpubr</code></pre>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb9-1" data-line-number="1">model.dat<span class="op">$</span>highses&lt;-<span class="kw">Recode</span>(model.dat<span class="op">$</span>v190, <span class="dt">recodes =</span><span class="st">&quot;1:3 = 0; 4:5=1; else=NA&quot;</span>)</a>
<a class="sourceLine" id="cb9-2" data-line-number="2">fit1&lt;-<span class="kw">survfit</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>highses, <span class="dt">data=</span>model.dat)</a>
<a class="sourceLine" id="cb9-3" data-line-number="3">fit1</a></code></pre></div>
<pre><code>## Call: survfit(formula = Surv(death.age, d.event) ~ highses, data = model.dat)
## 
##              n events median 0.95LCL 0.95UCL
## highses=0 4179    362     NA      NA      NA
## highses=1 1789    172     NA      NA      NA</code></pre>
<div class="sourceCode" id="cb11"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb11-1" data-line-number="1"><span class="kw">ggsurvplot</span>(fit1, <span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">conf.int=</span>T, <span class="dt">title=</span><span class="st">&quot;Survival Function for Infant Mortality - Low vs. High SES Households&quot;</span>, <span class="dt">ylim=</span><span class="kw">c</span>(.<span class="dv">8</span>, <span class="dv">1</span>))</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX2_comparing_survival_20_files/figure-html/unnamed-chunk-3-1.png" /><!-- --></p>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb12-1" data-line-number="1"><span class="kw">summary</span>(fit1)</a></code></pre></div>
<pre><code>## Call: survfit(formula = Surv(death.age, d.event) ~ highses, data = model.dat)
## 
##                 highses=0 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0   4179     134    0.968 0.00273        0.963        0.973
##     1   3992      18    0.964 0.00290        0.958        0.969
##     2   3914      28    0.957 0.00316        0.951        0.963
##     3   3808      24    0.951 0.00337        0.944        0.957
##     4   3709      10    0.948 0.00346        0.941        0.955
##     5   3625      15    0.944 0.00359        0.937        0.951
##     6   3520      20    0.939 0.00376        0.931        0.946
##     7   3414      14    0.935 0.00389        0.927        0.943
##     8   3325      21    0.929 0.00407        0.921        0.937
##     9   3238      17    0.924 0.00422        0.916        0.932
##    10   3159       3    0.923 0.00424        0.915        0.932
##    11   3090      10    0.920 0.00433        0.912        0.929
##    12   3015      48    0.906 0.00475        0.896        0.915
## 
##                 highses=1 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0   1789      75    0.958 0.00474        0.949        0.967
##     1   1698       8    0.954 0.00498        0.944        0.963
##     2   1659       9    0.948 0.00524        0.938        0.959
##     3   1615      14    0.940 0.00564        0.929        0.951
##     4   1573      15    0.931 0.00604        0.919        0.943
##     5   1536       7    0.927 0.00622        0.915        0.939
##     6   1501       6    0.923 0.00638        0.911        0.936
##     7   1466       4    0.921 0.00648        0.908        0.934
##     8   1430       5    0.918 0.00662        0.905        0.931
##     9   1383       6    0.914 0.00679        0.900        0.927
##    10   1348       2    0.912 0.00684        0.899        0.926
##    11   1315       3    0.910 0.00693        0.897        0.924
##    12   1288      18    0.897 0.00746        0.883        0.912</code></pre>
<p>Gives us the basic survival plot.</p>
<p>Next we will use <code>survtest()</code> to test for differences between the two or more groups. The <code>survdiff()</code> function performs the log-rank test to compare the survival patterns of two or more groups.</p>
<div class="sourceCode" id="cb14"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb14-1" data-line-number="1"><span class="co">#two group compairison</span></a>
<a class="sourceLine" id="cb14-2" data-line-number="2"><span class="kw">survdiff</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>highses, <span class="dt">data=</span>model.dat)</a></code></pre></div>
<pre><code>## Call:
## survdiff(formula = Surv(death.age, d.event) ~ highses, data = model.dat)
## 
##              N Observed Expected (O-E)^2/E (O-E)^2/V
## highses=0 4179      362      374     0.401      1.37
## highses=1 1789      172      160     0.940      1.37
## 
##  Chisq= 1.4  on 1 degrees of freedom, p= 0.2</code></pre>
<p>In this case, we see no difference in survival status based on household SES.</p>
<p>How about rural vs urban residence?</p>
<div class="sourceCode" id="cb16"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb16-1" data-line-number="1"><span class="kw">library</span>(dplyr)</a></code></pre></div>
<pre><code>## 
## Attaching package: &#39;dplyr&#39;</code></pre>
<pre><code>## The following object is masked from &#39;package:car&#39;:
## 
##     recode</code></pre>
<pre><code>## The following objects are masked from &#39;package:stats&#39;:
## 
##     filter, lag</code></pre>
<pre><code>## The following objects are masked from &#39;package:base&#39;:
## 
##     intersect, setdiff, setequal, union</code></pre>
<div class="sourceCode" id="cb21"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb21-1" data-line-number="1"><span class="kw">library</span>(car)</a>
<a class="sourceLine" id="cb21-2" data-line-number="2">model.dat&lt;-model.dat<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb21-3" data-line-number="3"><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">rural =</span> car<span class="op">::</span><span class="kw">Recode</span>(v025, <span class="dt">recodes =</span><span class="st">&quot;2 = &#39;0rural&#39;; 1=&#39;1urban&#39;; else=NA&quot;</span>, <span class="dt">as.factor =</span> T))</a>
<a class="sourceLine" id="cb21-4" data-line-number="4"></a>
<a class="sourceLine" id="cb21-5" data-line-number="5"></a>
<a class="sourceLine" id="cb21-6" data-line-number="6">fit2&lt;-<span class="kw">survfit</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>rural, <span class="dt">data=</span>model.dat, <span class="dt">conf.type =</span> <span class="st">&quot;log&quot;</span>)</a>
<a class="sourceLine" id="cb21-7" data-line-number="7">fit2</a></code></pre></div>
<pre><code>## Call: survfit(formula = Surv(death.age, d.event) ~ rural, data = model.dat, 
##     conf.type = &quot;log&quot;)
## 
##                 n events median 0.95LCL 0.95UCL
## rural=0rural 4138    346     NA      NA      NA
## rural=1urban 1830    188     NA      NA      NA</code></pre>
<div class="sourceCode" id="cb23"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb23-1" data-line-number="1"><span class="kw">summary</span>(fit2)</a></code></pre></div>
<pre><code>## Call: survfit(formula = Surv(death.age, d.event) ~ rural, data = model.dat, 
##     conf.type = &quot;log&quot;)
## 
##                 rural=0rural 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0   4138     130    0.969 0.00271        0.963        0.974
##     1   3959      15    0.965 0.00286        0.959        0.971
##     2   3879      29    0.958 0.00314        0.952        0.964
##     3   3775      24    0.952 0.00336        0.945        0.958
##     4   3682      15    0.948 0.00349        0.941        0.955
##     5   3590      13    0.944 0.00360        0.937        0.951
##     6   3491      17    0.940 0.00375        0.932        0.947
##     7   3382      13    0.936 0.00387        0.929        0.944
##     8   3299      19    0.931 0.00404        0.923        0.939
##     9   3208      17    0.926 0.00419        0.918        0.934
##    10   3126       3    0.925 0.00422        0.917        0.933
##    11   3060       9    0.922 0.00430        0.914        0.931
##    12   2990      42    0.909 0.00469        0.900        0.918
## 
##                 rural=1urban 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0   1830      79    0.957 0.00475        0.948        0.966
##     1   1731      11    0.951 0.00506        0.941        0.961
##     2   1694       8    0.946 0.00528        0.936        0.957
##     3   1648      14    0.938 0.00566        0.927        0.949
##     4   1600      10    0.932 0.00592        0.921        0.944
##     5   1571       9    0.927 0.00615        0.915        0.939
##     6   1530       9    0.922 0.00637        0.909        0.934
##     7   1498       5    0.918 0.00650        0.906        0.931
##     8   1456       7    0.914 0.00668        0.901        0.927
##     9   1413       6    0.910 0.00683        0.897        0.924
##    10   1381       2    0.909 0.00689        0.895        0.922
##    11   1345       4    0.906 0.00700        0.893        0.920
##    12   1313      24    0.890 0.00764        0.875        0.905</code></pre>
<div class="sourceCode" id="cb25"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb25-1" data-line-number="1"><span class="kw">ggsurvplot</span>(fit2, <span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">ylim=</span><span class="kw">c</span>(.<span class="dv">8</span>, <span class="dv">1</span>), <span class="dt">conf.int=</span>T, <span class="dt">title=</span><span class="st">&quot;Survival Function for Infant mortality - Rural vs Urban Residence&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX2_comparing_survival_20_files/figure-html/unnamed-chunk-5-1.png" /><!-- --></p>
</div>
</div>
<div id="two--sample-test" class="section level1">
<h1>Two- sample test</h1>
<div class="sourceCode" id="cb26"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb26-1" data-line-number="1"><span class="kw">survdiff</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>rural, <span class="dt">data=</span>model.dat)</a></code></pre></div>
<pre><code>## Call:
## survdiff(formula = Surv(death.age, d.event) ~ rural, data = model.dat)
## 
##                 N Observed Expected (O-E)^2/E (O-E)^2/V
## rural=0rural 4138      346      371      1.67      5.55
## rural=1urban 1830      188      163      3.79      5.55
## 
##  Chisq= 5.6  on 1 degrees of freedom, p= 0.02</code></pre>
<div class="sourceCode" id="cb28"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb28-1" data-line-number="1"><span class="kw">prop.table</span>(<span class="kw">table</span>(model.dat<span class="op">$</span>d.event, model.dat<span class="op">$</span>rural), <span class="dt">margin =</span> <span class="dv">2</span>)</a></code></pre></div>
<pre><code>##    
##         0rural     1urban
##   0 0.91638473 0.89726776
##   1 0.08361527 0.10273224</code></pre>
<div class="sourceCode" id="cb30"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb30-1" data-line-number="1"><span class="kw">chisq.test</span>(<span class="kw">table</span>(model.dat<span class="op">$</span>d.event, model.dat<span class="op">$</span>rural))</a></code></pre></div>
<pre><code>## 
##  Pearson&#39;s Chi-squared test with Yates&#39; continuity correction
## 
## data:  table(model.dat$d.event, model.dat$rural)
## X-squared = 5.4595, df = 1, p-value = 0.01946</code></pre>
<p>Which shows a statistically significant difference in survival between rural and urban children, with rural children showing lower survivorship at all ages.</p>
<p>We can also compare the 95% survival point for rural and urban residents</p>
<div class="sourceCode" id="cb32"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb32-1" data-line-number="1"><span class="kw">quantile</span>(fit2, <span class="dt">probs=</span>.<span class="dv">05</span>)</a></code></pre></div>
<pre><code>## $quantile
##              5
## rural=0rural 4
## rural=1urban 2
## 
## $lower
##              5
## rural=0rural 3
## rural=1urban 0
## 
## $upper
##              5
## rural=0rural 6
## rural=1urban 3</code></pre>
<p>We can also calculate the hazard function for each group using the <code>kphaz.fit</code> function in the <code>muhaz</code> library.</p>
<div class="sourceCode" id="cb34"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb34-1" data-line-number="1">haz2&lt;-<span class="kw">kphaz.fit</span>(model.dat<span class="op">$</span>death.age, model.dat<span class="op">$</span>d.event, model.dat<span class="op">$</span>rural)</a>
<a class="sourceLine" id="cb34-2" data-line-number="2">haz2</a></code></pre></div>
<pre><code>## $time
##  [1]  0.5  1.5  2.5  3.5  4.5  5.5  6.5  7.5  8.5  9.5 10.5 11.5  0.5  1.5  2.5
## [16]  3.5  4.5  5.5  6.5  7.5  8.5  9.5 10.5 11.5
## 
## $haz
##  [1] 0.0038314014 0.0075716497 0.0064378810 0.0041197145 0.0036742403
##  [6] 0.0049398949 0.0038930677 0.0058337248 0.0053636408 0.0009670736
## [11] 0.0029830591 0.0143373352 0.0064084477 0.0047764602 0.0086460188
## [16] 0.0063018400 0.0058154299 0.0059338979 0.0033648177 0.0048901211
## [21] 0.0042929999 0.0014588521 0.0030184080 0.0185979202
## 
## $var
##  [1] 9.786715e-07 1.976995e-06 1.727037e-06 1.131544e-06 1.038557e-06
##  [6] 1.435586e-06 1.165912e-06 1.791334e-06 1.692389e-06 3.117631e-07
## [11] 9.887982e-07 4.894885e-06 3.733606e-06 2.852025e-06 5.339922e-06
## [16] 3.971474e-06 3.757836e-06 3.912526e-06 2.264454e-06 3.416455e-06
## [21] 3.071735e-06 1.064171e-06 2.277779e-06 1.441308e-05
## 
## $strata
##  [1] 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2</code></pre>
<div class="sourceCode" id="cb36"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb36-1" data-line-number="1"><span class="kw">plot</span>(<span class="dt">y=</span>haz2<span class="op">$</span>haz[<span class="dv">1</span><span class="op">:</span><span class="dv">12</span>], <span class="dt">x=</span>haz2<span class="op">$</span>time[<span class="dv">1</span><span class="op">:</span><span class="dv">12</span>], <span class="dt">col=</span><span class="dv">1</span>, <span class="dt">lty=</span><span class="dv">1</span>, <span class="dt">type=</span><span class="st">&quot;s&quot;</span>)</a>
<a class="sourceLine" id="cb36-2" data-line-number="2"><span class="kw">lines</span>(<span class="dt">y=</span>haz2<span class="op">$</span>haz[<span class="dv">13</span><span class="op">:</span><span class="dv">24</span>], <span class="dt">x=</span>haz2<span class="op">$</span>time[<span class="dv">13</span><span class="op">:</span><span class="dv">24</span>], <span class="dt">col=</span><span class="dv">2</span>, <span class="dt">lty=</span><span class="dv">1</span>, <span class="dt">type=</span><span class="st">&quot;s&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX2_comparing_survival_20_files/figure-html/unnamed-chunk-8-1.png" /><!-- --></p>
<p>This may be suggestive that children in urban areas may live in poorer environmental conditions.</p>
<div id="k--sample-test" class="section level3">
<h3>k- sample test</h3>
<p>Next we illustrate a k-sample test. This would be the equivalent of the ANOVA if we were doing ordinary linear models.</p>
<p>In this example, I use the <code>v024</code> variable, which corresponds to the region of residence in this data. Effectively we are testing for differences in risk of infant mortality by region.</p>
<div class="sourceCode" id="cb37"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb37-1" data-line-number="1"><span class="kw">table</span>(model.dat<span class="op">$</span>v024, model.dat<span class="op">$</span>d.eventfac)</a></code></pre></div>
<pre><code>##    
##     Alive at 1 Dead by 1
##   1       2229       181
##   2       1435       141
##   3        631        94
##   4       1139       118</code></pre>
<div class="sourceCode" id="cb39"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb39-1" data-line-number="1">fit3&lt;-<span class="kw">survfit</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>v024, <span class="dt">data=</span>model.dat)</a>
<a class="sourceLine" id="cb39-2" data-line-number="2">fit3</a></code></pre></div>
<pre><code>## Call: survfit(formula = Surv(death.age, d.event) ~ v024, data = model.dat)
## 
##           n events median 0.95LCL 0.95UCL
## v024=1 2410    181     NA      NA      NA
## v024=2 1576    141     NA      NA      NA
## v024=3  725     94     NA      NA      NA
## v024=4 1257    118     NA      NA      NA</code></pre>
<div class="sourceCode" id="cb41"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb41-1" data-line-number="1"><span class="co">#summary(fit3)</span></a>
<a class="sourceLine" id="cb41-2" data-line-number="2"><span class="co">#quantile(fit3, probs=.05)</span></a>
<a class="sourceLine" id="cb41-3" data-line-number="3"></a>
<a class="sourceLine" id="cb41-4" data-line-number="4"><span class="kw">ggsurvplot</span>(fit3,<span class="dt">conf.int =</span> T, <span class="dt">risk.table =</span> F, <span class="dt">title =</span> <span class="st">&quot;Survivorship Function for Infant Mortality&quot;</span>, <span class="dt">xlab =</span> <span class="st">&quot;Time in Months&quot;</span>, <span class="dt">xlim =</span> <span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">ylim=</span><span class="kw">c</span>(.<span class="dv">8</span>, <span class="dv">1</span>))</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX2_comparing_survival_20_files/figure-html/unnamed-chunk-9-1.png" /><!-- --></p>
<div class="sourceCode" id="cb42"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb42-1" data-line-number="1"><span class="kw">survdiff</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>v024, <span class="dt">data=</span>model.dat)</a></code></pre></div>
<pre><code>## Call:
## survdiff(formula = Surv(death.age, d.event) ~ v024, data = model.dat)
## 
##           N Observed Expected (O-E)^2/E (O-E)^2/V
## v024=1 2410      181    215.5   5.52534   9.43344
## v024=2 1576      141    141.9   0.00537   0.00745
## v024=3  725       94     62.9  15.33021  17.70233
## v024=4 1257      118    113.7   0.16401   0.21218
## 
##  Chisq= 21.4  on 3 degrees of freedom, p= 9e-05</code></pre>
<p>Which shows significant variation in survival between regions. The biggest difference we see is between region 3 green) and region 1 (black line) groups.</p>
<p>Lastly, we examine comparing survival across multiple variables, in this case the education of the mother (<code>secedu</code>) and the rural/urban residence <code>rural</code>:</p>
<div class="sourceCode" id="cb44"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb44-1" data-line-number="1">model.dat&lt;-model.dat<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb44-2" data-line-number="2"><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">secedu=</span><span class="kw">Recode</span>(v106, <span class="dt">recodes =</span><span class="st">&quot;2:3 = 1; 0:1=0; else=NA&quot;</span>))</a>
<a class="sourceLine" id="cb44-3" data-line-number="3"></a>
<a class="sourceLine" id="cb44-4" data-line-number="4"><span class="kw">table</span>(model.dat<span class="op">$</span>secedu, model.dat<span class="op">$</span>d.eventfac)</a></code></pre></div>
<pre><code>##    
##     Alive at 1 Dead by 1
##   0       4470       430
##   1        964       104</code></pre>
<div class="sourceCode" id="cb46"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb46-1" data-line-number="1">fit4&lt;-<span class="kw">survfit</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>rural<span class="op">+</span>secedu, <span class="dt">data=</span>model.dat)</a>
<a class="sourceLine" id="cb46-2" data-line-number="2"><span class="co">#summary(fit4)</span></a>
<a class="sourceLine" id="cb46-3" data-line-number="3"><span class="kw">ggsurvplot</span>(fit4,<span class="dt">conf.int =</span> T, <span class="dt">risk.table =</span> F, <span class="dt">title =</span> <span class="st">&quot;Survivorship Function for Infant Mortality&quot;</span>, <span class="dt">xlab =</span> <span class="st">&quot;Time in Months&quot;</span>, <span class="dt">xlim =</span> <span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">ylim=</span><span class="kw">c</span>(.<span class="dv">8</span>, <span class="dv">1</span>))</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX2_comparing_survival_20_files/figure-html/unnamed-chunk-10-1.png" /><!-- --></p>
<div class="sourceCode" id="cb47"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb47-1" data-line-number="1"><span class="co">#plot(fit4, ylim=c(.85,1), xlim=c(0,12), col=c(1,1,2,2),lty=c(1,2,1,2), conf.int=F)</span></a>
<a class="sourceLine" id="cb47-2" data-line-number="2"><span class="co">#title(main=&quot;Survival Function for Infant Mortality&quot;, sub=&quot;Rural/Urban * Mother&#39;s Education&quot;)</span></a>
<a class="sourceLine" id="cb47-3" data-line-number="3"><span class="co">#legend(&quot;topright&quot;, legend = c(&quot;Urban, Low Edu&quot;,&quot;Urban High Edu     &quot;, &quot;Rural, Low Edu&quot;,&quot;Rural High Edu     &quot; ), col=c(1,1,2,2),lty=c(1,2,1,2))</span></a>
<a class="sourceLine" id="cb47-4" data-line-number="4"></a>
<a class="sourceLine" id="cb47-5" data-line-number="5"><span class="co"># test</span></a>
<a class="sourceLine" id="cb47-6" data-line-number="6"><span class="kw">survdiff</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>rural<span class="op">+</span>secedu, <span class="dt">data=</span>model.dat)</a></code></pre></div>
<pre><code>## Call:
## survdiff(formula = Surv(death.age, d.event) ~ rural + secedu, 
##     data = model.dat)
## 
##                           N Observed Expected (O-E)^2/E (O-E)^2/V
## rural=0rural, secedu=0 3707      308    333.3   1.92685   5.22186
## rural=0rural, secedu=1  431       38     37.5   0.00632   0.00693
## rural=1urban, secedu=0 1193      122    107.1   2.07801   2.64671
## rural=1urban, secedu=1  637       66     56.1   1.76227   2.00529
## 
##  Chisq= 5.9  on 3 degrees of freedom, p= 0.1</code></pre>
<p>Which shows a marginally significant difference between at <em>least</em> two of the groups, in this case, I would say that it’s most likely finding differences between the Urban, low Education and the Rural low education, because there have the higher ratio of observed vs expected.</p>
</div>
</div>
<div id="survival-analysis-using-survey-design" class="section level1">
<h1>Survival analysis using survey design</h1>
<p>This example will cover the use of R functions for analyzing complex survey data. Most social and health surveys are not simple random samples of the population, but instead consist of respondents from a complex survey design. These designs often stratify the population based on one or more characteristics, including geography, race, age, etc. In addition the designs can be multi-stage, meaning that initial strata are created, then respondents are sampled from smaller units within those strata. An example would be if a school district was chosen as a sample strata, and then schools were then chosen as the primary sampling units (PSUs) within the district. From this 2 stage design, we could further sample classrooms within the school (3 stage design) or simply sample students (or whatever our unit of interest is).</p>
<p>A second feature of survey data we often want to account for is differential respondent weighting. This means that each respondent is given a weight to represent how common that particular respondent is within the population. This reflects the differenital probability of sampling based on respondent characteristics. As demographers, we are also often interested in making inference for the population, not just the sample, so our results must be generalizable to the population at large. Sample weights are used in the process as well.</p>
<p>When such data are analyzed, we must take into account this nesting structure (sample design) as well as the respondent sample weight in order to make valid estimates of <strong>ANY</strong> statistical parameter. If we do not account for design, the parameter standard errors will be incorrect, and if we do not account for weighting, the parameters themselves will be incorrect and biased.</p>
<p>In general there are typically three things we need to find in our survey data codebooks: The sample strata identifier, the sample primary sampling unit identifier (often called a cluster identifier) and the respondent survey weight. These will typically have one of these names and should be easily identifiable in the codebook.</p>
<p>Statistical software will have special routines for analyzing these types of data and you must be aware that the diversity of statistical routines that generally exists will be lower for analyzing complex survey data, and some forms of analysis <em>may not be available!</em></p>
<p>In the DHS <a href="http://dhsprogram.com/pubs/pdf/DHSG4/Recode6_DHS_22March2013_DHSG4.pdf">Recode manual</a>, the sampling information for the data is found in variables <code>v021</code> and <code>v022</code>, which are the primary sampling unit (PSU) and sample strata, respectively. The person weight is found in variable <code>v005</code>, and following DHS protocol, this has six implied decimal places, so we must divide it by 1000000, again, following the DHS manual.</p>
<div class="sourceCode" id="cb49"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb49-1" data-line-number="1"><span class="kw">library</span>(survey)</a></code></pre></div>
<pre><code>## Loading required package: grid</code></pre>
<pre><code>## Loading required package: Matrix</code></pre>
<pre><code>## 
## Attaching package: &#39;survey&#39;</code></pre>
<pre><code>## The following object is masked from &#39;package:graphics&#39;:
## 
##     dotchart</code></pre>
<div class="sourceCode" id="cb54"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb54-1" data-line-number="1">model.dat<span class="op">$</span>wt&lt;-model.dat<span class="op">$</span>v005<span class="op">/</span><span class="dv">1000000</span></a>
<a class="sourceLine" id="cb54-2" data-line-number="2"></a>
<a class="sourceLine" id="cb54-3" data-line-number="3"><span class="co">#create the design: ids == PSU, strata==strata, weights==weights.</span></a>
<a class="sourceLine" id="cb54-4" data-line-number="4"><span class="kw">options</span>(<span class="dt">survey.lonely.psu =</span> <span class="st">&quot;adjust&quot;</span>)</a>
<a class="sourceLine" id="cb54-5" data-line-number="5">des&lt;-<span class="kw">svydesign</span>(<span class="dt">ids=</span><span class="op">~</span>v021, <span class="dt">strata =</span> <span class="op">~</span>v022, <span class="dt">weights=</span><span class="op">~</span>wt, <span class="dt">data=</span>model.dat)</a>
<a class="sourceLine" id="cb54-6" data-line-number="6"></a>
<a class="sourceLine" id="cb54-7" data-line-number="7">fit.s&lt;-<span class="kw">svykm</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>rural, <span class="dt">design=</span>des, <span class="dt">se=</span>T)</a>
<a class="sourceLine" id="cb54-8" data-line-number="8"></a>
<a class="sourceLine" id="cb54-9" data-line-number="9"><span class="co">#use svyby to find the %of infants that die before age 1, by rural/urban status</span></a>
<a class="sourceLine" id="cb54-10" data-line-number="10"><span class="kw">svyby</span>(<span class="op">~</span>d.event, <span class="op">~</span>rural, des, svymean)</a></code></pre></div>
<pre><code>##         rural    d.event          se
## 0rural 0rural 0.08655918 0.005201127
## 1urban 1urban 0.10760897 0.009765244</code></pre>
<p>The plotting is a bit more of a challenge, as the survey version of the function isn’t as nice</p>
<div class="sourceCode" id="cb56"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb56-1" data-line-number="1"><span class="kw">plot</span>(fit.s[[<span class="dv">2</span>]], <span class="dt">ylim=</span><span class="kw">c</span>(.<span class="dv">8</span>,<span class="dv">1</span>), <span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>),<span class="dt">col=</span><span class="dv">1</span>, <span class="dt">ci=</span>F )</a>
<a class="sourceLine" id="cb56-2" data-line-number="2"><span class="kw">lines</span>(fit.s[[<span class="dv">1</span>]], <span class="dt">col=</span><span class="dv">2</span>) </a>
<a class="sourceLine" id="cb56-3" data-line-number="3"><span class="kw">title</span>(<span class="dt">main=</span><span class="st">&quot;Survival Function for Infant Mortality&quot;</span>, <span class="dt">sub=</span><span class="st">&quot;Rural vs Urban Residence&quot;</span>)</a>
<a class="sourceLine" id="cb56-4" data-line-number="4"><span class="kw">legend</span>(<span class="st">&quot;topright&quot;</span>, <span class="dt">legend =</span> <span class="kw">c</span>(<span class="st">&quot;Urban&quot;</span>,<span class="st">&quot;Rural&quot;</span> ), <span class="dt">col=</span><span class="kw">c</span>(<span class="dv">1</span>,<span class="dv">2</span>), <span class="dt">lty=</span><span class="dv">1</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX2_comparing_survival_20_files/figure-html/unnamed-chunk-12-1.png" /><!-- --></p>
<div class="sourceCode" id="cb57"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb57-1" data-line-number="1"><span class="co">#test statistic</span></a>
<a class="sourceLine" id="cb57-2" data-line-number="2"><span class="kw">svylogrank</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span>rural, <span class="dt">design=</span>des)</a></code></pre></div>
<pre><code>## Warning in regularize.values(x, y, ties, missing(ties), na.rm = na.rm):
## collapsing to unique &#39;x&#39; values</code></pre>
<pre><code>## [[1]]
##         score                             
## [1,] 26.88143 15.11796 1.778112 0.07538546
## 
## [[2]]
##      chisq          p 
## 3.16168231 0.07538546 
## 
## attr(,&quot;class&quot;)
## [1] &quot;svylogrank&quot;</code></pre>
<p>And we see the p-value is larger than assuming random sampling.</p>
</div>
</section>
