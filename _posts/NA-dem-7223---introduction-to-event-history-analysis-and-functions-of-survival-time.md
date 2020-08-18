---
title: "DEM 7223 - Introduction to Event History Analysis and Functions of Survival Time"

author: "list(name = "[Corey S. Sparks, PhD](https://coreysparks.github.io)", affiliation = "[The University of Texas at San Antonio](https://hcap.utsa.edu/demography)")"
date: "`r format(Sys.time(), '%B %d, %Y')`"
layout: post
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/kePrint-0.0.1/kePrint.js"></script>

<section class="main-content">
<div id="rational-for-event-history-analysis" class="section level1">
<h1>Rational for Event history analysis</h1>
<div id="when-to-conduct-an-event-history-analysis" class="section level3">
<h3>When to conduct an event history analysis?</h3>
<ul>
<li>When you questions include
<ul>
<li>When or Whether</li>
<li>When &gt; how long until an event occurs</li>
<li>Whether &gt; does an event occur or not</li>
</ul></li>
<li>If your question does not include either of these ideas (or cannot be made to) then you do not need to do event history analysis</li>
</ul>
</div>
<div id="basic-propositions" class="section level3">
<h3>Basic Propositions</h3>
<ul>
<li>Since most of the methods we will discuss originate from studies of mortality, they have morbid names
<ul>
<li>Survival – This is related to how long a case lasts until it experiences the event of interest</li>
<li>How long does it take?</li>
<li>Risk – How likely is it that the case will experience the event</li>
<li>Will it happen or not?</li>
</ul></li>
</ul>
</div>
<div id="focus-on-comparison" class="section level3">
<h3>Focus on comparison</h3>
<ul>
<li>Most of the methods we consider are comparative by their nature</li>
<li>How long does a case with trait x survive, compared to a case with trait y?</li>
<li>How likely is it for a person who is married to die of homicide relative to someone who is single?</li>
<li>Generally we are examining relative risk and relative survival</li>
</ul>
</div>
<div id="some-terminology" class="section level3">
<h3>Some terminology</h3>
<ul>
<li><strong>State</strong> – discrete condition an individual may occupy that occur within a state space. Most survival analysis methods assume a single state to state transition</li>
<li><strong>State space</strong> – full set of state alternatives</li>
<li><strong>Episodes/Events/Transitions</strong> – a change in states</li>
<li><strong>Durations</strong> – length of an episode</li>
<li><strong>Time axis</strong> – Metric for measuring durations (days, months, years)</li>
</ul>
</div>
<div id="issues-in-event-history-data" class="section level3">
<h3>Issues in event history data</h3>
<div id="censoring" class="section level4">
<h4>Censoring</h4>
<ul>
<li><strong>Censoring</strong> occurs when you do not actually observe the event of interest within the period of data collection
<ul>
<li>e.g. you know someone gets married, but you never observe them having a child</li>
<li>e.g. someone leaves alcohol treatment and is never observed drinking again</li>
</ul></li>
</ul>
<div class="figure">
<img src="{{ site.url }}{{ site.baseurl }}/images/censoring.png" alt="Censoring" />
<p class="caption">Censoring</p>
</div>
</div>
<div id="non-informative-censoring" class="section level4">
<h4>Non-informative censoring</h4>
<ul>
<li>The individual is not observed because the observer ends the study period</li>
<li>The censoring is not related to any trait or action of the case, but related to the observer
<ul>
<li>We want most of our censoring to be this kind</li>
</ul></li>
</ul>
</div>
<div id="informative-censoring" class="section level4">
<h4>Informative censoring</h4>
<ul>
<li>The individual is not observed because they represent a special case</li>
<li>The censoring IS related to something about the individual, and these people differ inherently from uncensored cases</li>
<li>People that are censored ARE likely to have experience the event</li>
</ul>
</div>
<div id="right-censoring" class="section level4">
<h4>Right censoring</h4>
<ul>
<li>An event time is unknown because it is not observed.
<ul>
<li>This is easier to deal with</li>
</ul></li>
</ul>
</div>
<div id="left-censoring" class="section level4">
<h4>Left censoring</h4>
<ul>
<li>An event time is unknown because it occurred prior to the beginning of data collection, but not when
<ul>
<li>This is difficult to deal with</li>
</ul></li>
</ul>
</div>
<div id="interval-censoring" class="section level4">
<h4>Interval censoring</h4>
<ul>
<li>The event time is known to have occurred within a period of time, but it is unknown exactly when
<ul>
<li>This can be dealt with</li>
</ul></li>
</ul>
</div>
</div>
<div id="time-scales" class="section level2">
<h2>Time Scales</h2>
<ul>
<li>Continuous time
<ul>
<li>Time is measured in very precise, unique increments &gt; miles until a tire blows out</li>
<li>Each observed duration is unique</li>
</ul></li>
<li>Discrete time
<ul>
<li>Time is measured in discrete lumps &gt; semester a student leaves college</li>
<li>Each observed duration is not necessarily unique, and takes one of a set of discrete values</li>
</ul></li>
</ul>
<div id="making-continuous-outcomes-discrete" class="section level4">
<h4>Making continuous outcomes discrete</h4>
<ul>
<li>Ideally you should measure the duration as finely as possible (see Freedman et al)</li>
<li><p>Often you may choose to discretize the data &gt; take continuous time and break it into discrete chunks</p></li>
<li>Problems
<ul>
<li>This removes possibly informative information on duration variability</li>
<li>Any discrete dividing point is arbitrary</li>
<li>You may arrive at different conclusions given the interval you choose</li>
<li>You lose information about late event occurrence</li>
<li>Lose all information on mean or average durations</li>
</ul></li>
</ul>
</div>
</div>
<div id="kinds-of-studies-with-event-history-data" class="section level2">
<h2>Kinds of studies with event history data</h2>
<ul>
<li>Cross sectional
<ul>
<li>Measured at one time point (no change observed)</li>
<li>Can measure lots of things at once</li>
</ul></li>
<li>Panel data
<ul>
<li>Multiple measurements at discrete time points on the same individuals</li>
<li>Can look at change over time</li>
</ul></li>
<li>Event history
<ul>
<li>Continuous measurement of units over a fixed period of time, focusing on change in states</li>
<li>Think clinical follow-ups</li>
</ul></li>
<li>Longitudinal designs
<ul>
<li>Prospective designs</li>
<li>Studies that follow a group (cohort) and follow them over time</li>
<li>Expensive and take a long time, but can lead to extremely valuable information on changes in behaviors</li>
</ul></li>
<li>Retrospective designs</li>
<li>Taken at a cross section</li>
<li>Ask respondents about events that have previously occurred.</li>
<li>Generate birth/migration/marital histories for individuals</li>
<li>Problems with recall bias</li>
<li><p>DHS includes a detailed history of births over the last 5 years</p></li>
<li>Record linkage procedures
<ul>
<li>Begin with an event of interest (birth, marriage) and follow individuals using various record types</li>
<li>Birth &gt; Census 1880 &gt; Census 1890 &gt; Marriage &gt; Birth of children &gt; Census 1900 &gt; Tax records &gt;Death certificate</li>
<li>Mostly used in historical studies</li>
<li>Modern studies link health surveys to National Death Index (NHANES, NHIS)</li>
</ul></li>
</ul>
</div>
<div id="some-arrangements-for-event-history-data" class="section level2">
<h2>Some arrangements for event history data</h2>
<div id="counting-process-data" class="section level3">
<h3>Counting process data</h3>
<ul>
<li>This is what we are accustomed to in the life table</li>
</ul>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb1-1" title="1">t1&lt;-<span class="kw">data.frame</span>(<span class="dt">Time_start=</span><span class="kw">c</span>(<span class="dv">1</span>,<span class="dv">2</span>,<span class="dv">3</span>,<span class="dv">4</span>),</a>
<a class="sourceLine" id="cb1-2" title="2">               <span class="dt">Time_end=</span><span class="kw">c</span>(<span class="dv">2</span>,<span class="dv">3</span>,<span class="dv">4</span>,<span class="dv">5</span>),</a>
<a class="sourceLine" id="cb1-3" title="3">               <span class="dt">Failing=</span><span class="kw">c</span>(<span class="dv">25</span>,<span class="dv">15</span>,<span class="dv">12</span>,<span class="dv">20</span>),</a>
<a class="sourceLine" id="cb1-4" title="4">               <span class="dt">At_Risk=</span><span class="kw">c</span>(<span class="dv">100</span>, <span class="dv">75</span>, <span class="dv">60</span>, <span class="dv">40</span>))</a>
<a class="sourceLine" id="cb1-5" title="5">t1<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb1-6" title="6"><span class="st">  </span><span class="kw">kable</span>()<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb1-7" title="7"><span class="st">  </span><span class="kw">column_spec</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">4</span>, <span class="dt">border_left =</span> T, <span class="dt">border_right =</span> T)<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb1-8" title="8"><span class="st">  </span><span class="kw">kable_styling</span>()</a></code></pre></div>
<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
Time_start
</th>
<th style="text-align:right;">
Time_end
</th>
<th style="text-align:right;">
Failing
</th>
<th style="text-align:right;">
At_Risk
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
25
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
100
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
15
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
75
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
12
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
60
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
5
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
20
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
40
</td>
</tr>
</tbody>
</table>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb2-1" title="1"><span class="co">#knitr::kable(t1,format = &quot;html&quot;, caption = &quot;Counting Process data&quot; ,align = &quot;c&quot;, )</span></a></code></pre></div>
</div>
<div id="case---duration-or-person-level-data" class="section level3">
<h3>Case - duration, or person level data</h3>
<ul>
<li>This is the general form of continuous time survival data.</li>
</ul>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb3-1" title="1">t2&lt;-<span class="kw">data.frame</span>(<span class="dt">ID =</span> <span class="kw">c</span>(<span class="dv">1</span>,<span class="dv">2</span>,<span class="dv">3</span>,<span class="dv">4</span>),</a>
<a class="sourceLine" id="cb3-2" title="2">               <span class="dt">Duration=</span><span class="kw">c</span>(<span class="dv">5</span>, <span class="dv">2</span>, <span class="dv">9</span> , <span class="dv">6</span>), </a>
<a class="sourceLine" id="cb3-3" title="3">               <span class="dt">Event_Occurred=</span><span class="kw">c</span>(<span class="st">&quot;Yes (1)&quot;</span>,<span class="st">&quot;Yes (1)&quot;</span>,<span class="st">&quot;No (0)&quot;</span>, <span class="st">&quot;Yes (1)&quot;</span> ))</a>
<a class="sourceLine" id="cb3-4" title="4">t2<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb3-5" title="5"><span class="st">  </span><span class="kw">kable</span>()<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb3-6" title="6"><span class="st">  </span><span class="kw">column_spec</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">3</span>, <span class="dt">border_left =</span> T, <span class="dt">border_right =</span> T)<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb3-7" title="7"><span class="st">  </span><span class="kw">kable_styling</span>(<span class="dt">row_label_position =</span> <span class="st">&quot;c&quot;</span>, <span class="dt">position =</span> <span class="st">&quot;center&quot;</span> )</a></code></pre></div>
<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
ID
</th>
<th style="text-align:right;">
Duration
</th>
<th style="text-align:left;">
Event_Occurred
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
5
</td>
<td style="text-align:left;border-left:1px solid;border-right:1px solid;">
Yes (1)
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:left;border-left:1px solid;border-right:1px solid;">
Yes (1)
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
9
</td>
<td style="text-align:left;border-left:1px solid;border-right:1px solid;">
No (0)
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
6
</td>
<td style="text-align:left;border-left:1px solid;border-right:1px solid;">
Yes (1)
</td>
</tr>
</tbody>
</table>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb4-1" title="1"><span class="co">#knitr::kable(t2, format = &quot;html&quot;, caption = &quot;Case-duration data&quot;, align = &quot;c&quot;)</span></a></code></pre></div>
<p>This can be transformed into person-period data, or discrete time data.</p>
</div>
<div id="person-period-data" class="section level3">
<h3>Person – Period data</h3>
<ul>
<li>Express exposure as discrete periods</li>
<li>Event occurrence is coded at each period</li>
</ul>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb5-1" title="1">t3&lt;-<span class="kw">data.frame</span>(<span class="dt">ID=</span><span class="kw">c</span>(<span class="kw">rep</span>(<span class="dv">1</span>, <span class="dv">5</span>), <span class="kw">rep</span>(<span class="dv">2</span>, <span class="dv">2</span>), <span class="kw">rep</span>(<span class="dv">3</span>, <span class="dv">9</span>), <span class="kw">rep</span>(<span class="dv">4</span>, <span class="dv">6</span>)),</a>
<a class="sourceLine" id="cb5-2" title="2">                    <span class="dt">Period =</span> <span class="kw">c</span>(<span class="kw">seq</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">5</span>), <span class="kw">seq</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">2</span>), <span class="kw">seq</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">9</span>), <span class="kw">seq</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">6</span>)),</a>
<a class="sourceLine" id="cb5-3" title="3">                    <span class="dt">Event=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">1</span>,<span class="dv">0</span>,<span class="dv">1</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>,<span class="dv">0</span>))</a>
<a class="sourceLine" id="cb5-4" title="4">t3<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb5-5" title="5"><span class="st">  </span><span class="kw">kable</span>()<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb5-6" title="6"><span class="st">  </span><span class="kw">column_spec</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">3</span>, <span class="dt">border_left =</span> T, <span class="dt">border_right =</span> T)<span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb5-7" title="7"><span class="st">  </span><span class="kw">kable_styling</span>(<span class="dt">row_label_position =</span> <span class="st">&quot;c&quot;</span>, <span class="dt">position =</span> <span class="st">&quot;center&quot;</span> )</a></code></pre></div>
<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
ID
</th>
<th style="text-align:right;">
Period
</th>
<th style="text-align:right;">
Event
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
5
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
5
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
6
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
7
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
8
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
9
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
1
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
2
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
3
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
5
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
<tr>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
4
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
6
</td>
<td style="text-align:right;border-left:1px solid;border-right:1px solid;">
0
</td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<div id="functions-of-survival-time" class="section level1">
<h1>Functions of Survival Time</h1>
<div id="homage-to-the-life-table" class="section level2">
<h2>Homage to the life table</h2>
<p>In life tables, we had lots of functions of the death process. Some of these were more interesting than others, with two being of special interest to use here. These are the <span class="math inline">\(l(x)\)</span> and <span class="math inline">\(q(x, n)\)</span> functions. If you recall, <span class="math inline">\(l(x)\)</span> represents the population size of the stationary population that is alive at age <span class="math inline">\(x\)</span>, and the risk of dying between age <span class="math inline">\(x, x+n\)</span> is <span class="math inline">\(q(x, n)\)</span>.</p>
<p>These are genearlized more in the event history analysis literature, but we can still describe the distrubion of survival time using three functions. These are the <strong>Survival Function</strong>, <span class="math inline">\(S(t)\)</span>, the <strong>probability density function</strong>, <span class="math inline">\(f(t)\)</span>, and the <strong>hazard function</strong>, <span class="math inline">\(h(t)\)</span>. These three are related and we can derive one from the others.</p>
<p>Now we must generalize these ideas to incorporate them into the broader event-history framework</p>
<p>Survival/duration times measure the <em>time to a certain event.</em></p>
<p>These times are subject to random variations, and are considered to be random <em>iid</em> (independent and identically distributed; random) variates from some distribution</p>
<ul>
<li>The distribution of survival times is described by 3 functions</li>
<li>The survivorship function, <span class="math inline">\(S(t)\)</span></li>
<li>The probability density function, <span class="math inline">\(f(t)\)</span></li>
<li>The hazard function, <span class="math inline">\(h(t)\)</span></li>
</ul>
<div class="figure">
<img src="{{ site.url }}{{ site.baseurl }}/images/functions.png" alt="3 functions" />
<p class="caption">3 functions</p>
</div>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" title="1">Ft&lt;-<span class="kw">cumsum</span>(<span class="kw">dlnorm</span>(<span class="dt">x =</span> <span class="kw">seq</span>(<span class="dv">0</span>, <span class="dv">110</span>, <span class="dv">1</span>), <span class="dt">meanlog =</span> <span class="fl">4.317488</span>, <span class="dt">sdlog =</span> <span class="fl">2.5</span>)) <span class="co">#mean of 75 years, sd of 12.1 years</span></a>
<a class="sourceLine" id="cb6-2" title="2">ft&lt;-<span class="kw">diff</span>(Ft)</a>
<a class="sourceLine" id="cb6-3" title="3">St&lt;-<span class="dv">1</span><span class="op">-</span>Ft</a>
<a class="sourceLine" id="cb6-4" title="4">ht&lt;-ft<span class="op">/</span>St[<span class="dv">1</span><span class="op">:</span><span class="dv">110</span>]</a>
<a class="sourceLine" id="cb6-5" title="5"><span class="kw">plot</span>(Ft, <span class="dt">ylim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">1</span>))</a>
<a class="sourceLine" id="cb6-6" title="6"><span class="kw">lines</span>(St, <span class="dt">col=</span><span class="st">&quot;red&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-5-1.png" /><!-- --></p>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb7-1" title="1"><span class="kw">plot</span>(ht, <span class="dt">col=</span><span class="st">&quot;green&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-5-2.png" /><!-- --></p>
<ul>
<li>These three are mathematically related, and if given one, we can calculate the others
<ul>
<li>These 3 functions each represent a different aspect of the survival time distribution.</li>
</ul></li>
<li>The fundamental problem in survival analysis is coming up with a way to estimate these functions.</li>
</ul>
<div id="defining-the-functions" class="section level3">
<h3>Defining the functions</h3>
<p>Let <em>T</em> denote the survival time, our goal is to characterize the distribution of <em>T</em> using these 3 functions.</p>
<p>Let <em>T</em> be a discrete(or continuous) <em>iid</em> random variable and let <span class="math inline">\(t_i\)</span>, be an occurrence of that variable, such that <span class="math inline">\(Pr(t_i)=Pr(T=t_i)\)</span></p>
</div>
<div id="the-distribution-function-or-pdf" class="section level3">
<h3>The distribution function, or <em>pdf</em></h3>
<p>Like any other random variates survival times have a simple distribution function that gives the probability of observing a particular survival time within a finite interval</p>
<p>The density function is defined as the limit of the probability that an individual fails (experiences the event) in a short interval <span class="math inline">\(t+\Delta t\)</span> (read delta t), per width of <span class="math inline">\(\Delta t\)</span>, or simply the probability of failure in a small interval per unit time, <span class="math inline">\(f(t_i) = Pr(T=t_i)\)</span>.</p>
<p>If <span class="math inline">\(F(t)\)</span> is the cumulative distribution function for <em>T</em>, given by:</p>
<p><span class="math display">\[ F(t) = \int_{0}^{t} f(u) du = Pr(T \leqslant t )\]</span> Which is the probability of observing a value of <em>T</em> prior to the current value, <em>t</em>.</p>
<p>The density function is then:</p>
<p><span class="math display">\[ f(t) = \frac{F(t)}{d(t)} = F&#39;(t)\]</span> or</p>
<p><span class="math display">\[ f(t) = \lim_{\delta t \rightarrow 0} \frac{F(t+\Delta t) - F(t)}{\Delta t}\]</span></p>
<p>The density function gives the unconditional instantaneous failure rate in the (very small) interval between <em>t</em> and <em>dt</em>, <span class="math inline">\(\Delta t\)</span></p>
</div>
<div id="survival-function" class="section level3">
<h3>Survival Function</h3>
<p>The survival function, <em>S(t)</em> is expressed:</p>
<p><span class="math display">\[ S(t) = 1 - F(t) = Pr (T \geqslant t)\]</span></p>
<p>Which is the probability that <em>T</em> takes a value larger than <em>t</em>. i.e. the event happens some time after the present time.</p>
<p>At <span class="math inline">\(t = 0, S(t) =1 \text { and at } t= \infty, \text { and } S(t) =0\)</span></p>
<p>As time passes, <em>S(t)</em> decreases, and is called a <em>strictly decreasing function of time</em>.</p>
<p>Empirically, <em>S(t)</em> takes the form of a step function:</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb8-1" title="1">St&lt;-<span class="st"> </span><span class="kw">c</span>(<span class="dv">1</span>, <span class="kw">cumprod</span>(<span class="dv">1</span><span class="op">-</span>(t1<span class="op">$</span>Failing<span class="op">/</span>t1<span class="op">$</span>At_Risk)))</a>
<a class="sourceLine" id="cb8-2" title="2"></a>
<a class="sourceLine" id="cb8-3" title="3"><span class="kw">plot</span>(St, <span class="dt">type=</span><span class="st">&quot;s&quot;</span>, <span class="dt">xlab =</span> <span class="st">&quot;Time&quot;</span>, <span class="dt">ylab=</span><span class="st">&quot;S(t)&quot;</span>, <span class="dt">ylim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">1</span>))</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-6-1.png" /><!-- --></p>
</div>
<div id="the-hazard-function" class="section level3">
<h3>The hazard function</h3>
<p>The hazard function relates death, <em>f(t)</em>, and survival, <em>S(t)</em>, to one another</p>
<p><span class="math display">\[h(t) = \frac{f(t)}{S(t)}\]</span> <span class="math display">\[h(t) = \lim_{\Delta t \rightarrow 0} \frac{Pr(t \leqslant T \leqslant t + \Delta t | T \geqslant t)}{\Delta t}\]</span></p>
<p>Which is the failure rate per unit time in the interval <em>t</em>, <span class="math inline">\(t+\Delta t\)</span>, the hazard may increase or decrease with time, or stay the same. This is really dependent on the distribution of failure times.</p>
</div>
</div>
<div id="relationships-among-the-three-functions" class="section level2">
<h2>Relationships among the three functions</h2>
<p>If <span class="math inline">\(ft = \frac{dF(t)}{dt}\)</span> and <span class="math inline">\(S(t) = 1- F(t)\)</span> and, <span class="math inline">\(h(t) = \frac{f(t)}{S(t)}\)</span>, then we can write:</p>
<p><span class="math display">\[f(t) = \frac{-dS(t)}{dt}\]</span></p>
<p>and the hazard function as:</p>
<p><span class="math display">\[h(t) = \frac{{-dS(t)}/{dt}{S(t)}\]</span></p>
<p>If we integrate this and let <span class="math inline">\(S(0)=1\)</span>, then</p>
<p><span class="math display">\[S(t) = exp^{-\int_{0}^t h(u) du} = e^{-H(t)}\]</span></p>
<p>where the quantity, <span class="math inline">\(H(t)\)</span> is called the <em>cumulative hazard function</em> and, <span class="math inline">\(H(t) = \int h(u) du\)</span>, then</p>
<p><span class="math display">\[H(t) = -\text{log }  S(t)\]</span></p>
<p>The density can be written as:</p>
<p><span class="math display">\[f(t) = h(t) e ^{-H(t)}\]</span> and</p>
<p><span class="math display">\[h(t) = \frac{h(t) e^{-H(t)}}{e^{-H(t)}} = \frac{f(t)}{S(t)}\]</span></p>
<div id="more-on-the-hazard-function" class="section level3">
<h3>More on the hazard function…</h3>
<p>Unlike the <em>f(t)</em> or <em>S(t)</em>, <em>h(t)</em> describes the risk an individual faces of experiencing the event, given they have survived up to that time.</p>
<p>This kind of conditional probability is of special interest to us.</p>
<p>We can extend this framework to include effects of <em>individual characteristics on one’s risk</em>, thus not only introducing dependence on time, but also on these characteristics (covariates).</p>
<p>We can re-express the hazard rate with both these conditions as:</p>
<p><span class="math display">\[h(t|x) = \lim_{\Delta t \rightarrow 0} \frac{Pr(t \leqslant T \leqslant t + \Delta t | T \geqslant t, x)}{\Delta t}\]</span></p>
</div>
</div>
<div id="quantiles-of-survival-time" class="section level2">
<h2>Quantiles of Survival time</h2>
<p>Since <em>S(t)</em> is a cumulative function <span class="math inline">\(S(t) = 1-F(t)\)</span></p>
<p>We can calculate quantiles of its distribution, or the time by which (for example) 10, 25, 50, 75 % of the sample have experienced the event.</p>
<div id="median-life-time" class="section level4">
<h4>Median life time</h4>
<p>This is the time by which 50% of the sample has experienced the event. To estimate median life time, if <span class="math inline">\(S(t)=.5\)</span> is not directly observed:</p>
<p><span class="math display">\[\text{Est. Median Life Time} = m + \left [ \frac{\hat{S(t_m)-.5}}{\hat{S(t_m)}-\hat{S(t_m)}}  \right ] ((m+1)-m)\]</span> And you can use this method of interpolation to find any percentile of the survival function, as long as it is bound by other values.</p>
<p>Another note, in data, often times 50% of the observations do not fail in the study period, so the median may not be observed. Also, don’t assume that the median survival time is a particularly high period of risk, medians are just a point in a distribution, nothing more, nothing less.</p>
</div>
</div>
<div id="example-from-data" class="section level2">
<h2>Example from data</h2>
<p>This example will illustrate how to construct a basic survival function from individual-level data. The example will use as its outcome variable, the event of a child dying before age 1. The data for this example come from the <a href="http://dhsprogram.com/data/Download-Model-Datasets.cfm?flag=1">Demographic and Health Survey Model Data Files</a> children’s recode file.</p>
<p>The DHS Program has created example datasets for users to practice with. These datasets have been created strictly for practice and do not represent any actual country’s data. See more <a href="http://dhsprogram.com/data/Download-Model-Datasets.cfm?flag=1#sthash.HRINGQ00.dpuf">here</a>.</p>
<p>This file contains information for all births to the sample of women between the ages of 15 and 49 in the last 5 years prior to the survey.</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb9-1" title="1"><span class="co">#Example 1</span></a>
<a class="sourceLine" id="cb9-2" title="2"><span class="kw">library</span>(haven)</a>
<a class="sourceLine" id="cb9-3" title="3"><span class="kw">library</span>(survival)</a>
<a class="sourceLine" id="cb9-4" title="4"></a>
<a class="sourceLine" id="cb9-5" title="5">model.dat&lt;-<span class="kw">read_dta</span>(<span class="st">&quot;https://github.com/coreysparks/data/blob/master/ZZKR62FL.DTA?raw=true&quot;</span>)</a></code></pre></div>
</div>
<div id="event---infant-mortality" class="section level2">
<h2>Event - Infant Mortality</h2>
<p>In the DHS, they record if a child is dead or alive and the age at death if the child is dead. This can be understood using a series of variables about each child.</p>
<p>If the child is alive at the time of interview, then the variable B5==1, and the age at death is censored.</p>
<p>If the age at death is censored, then the age at the date of interview (censored age at death) is the date of the interview - date of birth (in months).</p>
<p>If the child is dead at the time of interview,then the variable B5!=1, then the age at death in months is the variable B7. Here we code this:</p>
<div class="sourceCode" id="cb10"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb10-1" title="1">model.dat<span class="op">$</span>death.age&lt;-<span class="kw">ifelse</span>(model.dat<span class="op">$</span>b5<span class="op">==</span><span class="dv">1</span>,</a>
<a class="sourceLine" id="cb10-2" title="2">                          ((((model.dat<span class="op">$</span>v008))<span class="op">+</span><span class="dv">1900</span>)<span class="op">-</span>(((model.dat<span class="op">$</span>b3))<span class="op">+</span><span class="dv">1900</span>)) </a>
<a class="sourceLine" id="cb10-3" title="3">                          ,model.dat<span class="op">$</span>b7)</a>
<a class="sourceLine" id="cb10-4" title="4"></a>
<a class="sourceLine" id="cb10-5" title="5"><span class="co">#censoring indicator for death by age 1, in months (12 months)</span></a>
<a class="sourceLine" id="cb10-6" title="6">model.dat<span class="op">$</span>d.event&lt;-<span class="kw">ifelse</span>(<span class="kw">is.na</span>(model.dat<span class="op">$</span>b7)<span class="op">==</span>T<span class="op">|</span>model.dat<span class="op">$</span>b7<span class="op">&gt;</span><span class="dv">12</span>,<span class="dv">0</span>,<span class="dv">1</span>)</a>
<a class="sourceLine" id="cb10-7" title="7">model.dat<span class="op">$</span>d.eventfac&lt;-<span class="kw">factor</span>(model.dat<span class="op">$</span>d.event); <span class="kw">levels</span>(model.dat<span class="op">$</span>d.eventfac)&lt;-<span class="kw">c</span>(<span class="st">&quot;Alive at 1&quot;</span>, <span class="st">&quot;Dead by 1&quot;</span>)</a>
<a class="sourceLine" id="cb10-8" title="8"><span class="kw">table</span>(model.dat<span class="op">$</span>d.eventfac)</a></code></pre></div>
<pre><code>## 
## Alive at 1  Dead by 1 
##       5434        534</code></pre>
<p>We see 534 infant deaths among the 5968 births in the last 5 years.</p>
</div>
<div id="example-of-estimating-survival-time-functions-from-data" class="section level2">
<h2>Example of Estimating Survival Time Functions from data</h2>
<p>To generate a basic life table, we use the <code>survfit()</code> procedure in the <code>survival</code> library. The data for this is a <code>Surv()</code> object, which typically has 2 arguments, the duration, and the censoring indicator. This uses age at death (the <code>death.age</code> variable from above) for children dying before age 1 as the outcome, and the <code>d.event</code> variable from above as the censoring indicator.</p>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb12-1" title="1"><span class="co">#Here we see the data</span></a>
<a class="sourceLine" id="cb12-2" title="2"><span class="kw">head</span>(model.dat[,<span class="kw">c</span>(<span class="st">&quot;death.age&quot;</span>,<span class="st">&quot;d.event&quot;</span>)], <span class="dt">n=</span><span class="dv">20</span>)</a></code></pre></div>
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
<div class="sourceCode" id="cb14"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb14-1" title="1"><span class="co">#The Surv() object</span></a>
<a class="sourceLine" id="cb14-2" title="2"><span class="kw">head</span>(<span class="kw">Surv</span>(model.dat<span class="op">$</span>death.age, model.dat<span class="op">$</span>d.event), <span class="dt">n=</span><span class="dv">20</span>)</a></code></pre></div>
<pre><code>##  [1]  5+ 37+ 30+ 10+ 30+  0  34+  1  18+  3  27+ 24+ 12+  9+  5  54+ 16+ 37+ 30+
## [20]  0+</code></pre>
<p>In the first 20 cases from the data, several children died (no <code>+</code> after the time), while all the other children had not experienced the event (they were still alive at age 12 months), these have a <code>+</code> after their censored age at death.</p>
<div class="sourceCode" id="cb16"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb16-1" title="1">mort&lt;-<span class="kw">survfit</span>(<span class="kw">Surv</span>(death.age, d.event)<span class="op">~</span><span class="dv">1</span>, <span class="dt">data=</span>model.dat,<span class="dt">conf.type=</span><span class="st">&quot;none&quot;</span>)</a>
<a class="sourceLine" id="cb16-2" title="2"><span class="kw">plot</span>(mort, <span class="dt">ylim=</span><span class="kw">c</span>(.<span class="dv">9</span>,<span class="dv">1</span>), <span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">main=</span><span class="st">&quot;Survival Function for Infant Mortality&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-11-1.png" /><!-- --></p>
<div class="sourceCode" id="cb17"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb17-1" title="1"><span class="kw">summary</span>(mort)</a></code></pre></div>
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
<div class="sourceCode" id="cb19"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb19-1" title="1"><span class="kw">library</span>(muhaz)</a>
<a class="sourceLine" id="cb19-2" title="2">haz&lt;-<span class="kw">kphaz.fit</span>(<span class="dt">time=</span>model.dat<span class="op">$</span>death.age, <span class="dt">status=</span>model.dat<span class="op">$</span>d.event, <span class="dt">method =</span> <span class="st">&quot;product-limit&quot;</span>)</a>
<a class="sourceLine" id="cb19-3" title="3"><span class="kw">kphaz.plot</span>(haz, <span class="dt">main=</span><span class="st">&quot;Hazard function plot&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-12-1.png" /><!-- --></p>
<div class="sourceCode" id="cb20"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb20-1" title="1"><span class="kw">data.frame</span>(haz)</a></code></pre></div>
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
<div class="sourceCode" id="cb22"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb22-1" title="1"><span class="co">#cumulative hazard</span></a>
<a class="sourceLine" id="cb22-2" title="2"><span class="kw">plot</span>(<span class="kw">cumsum</span>(haz<span class="op">$</span>haz)<span class="op">~</span>haz<span class="op">$</span>time, </a>
<a class="sourceLine" id="cb22-3" title="3">     <span class="dt">main =</span> <span class="st">&quot;Cumulative Hazard function&quot;</span>,</a>
<a class="sourceLine" id="cb22-4" title="4">     <span class="dt">ylab=</span><span class="st">&quot;H(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>, </a>
<a class="sourceLine" id="cb22-5" title="5">     <span class="dt">type=</span><span class="st">&quot;l&quot;</span>,<span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">0</span>,<span class="dv">12</span>), <span class="dt">lwd=</span><span class="dv">2</span>,<span class="dt">col=</span><span class="dv">3</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-13-1.png" /><!-- --></p>
<div class="sourceCode" id="cb23"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb23-1" title="1"><span class="co">#Survival function, I just store this in an object so I can use it</span></a>
<a class="sourceLine" id="cb23-2" title="2">surv&lt;-mort</a>
<a class="sourceLine" id="cb23-3" title="3"></a>
<a class="sourceLine" id="cb23-4" title="4"><span class="co">#here is a cheap version of the pdf</span></a>
<a class="sourceLine" id="cb23-5" title="5">ft&lt;-<span class="st"> </span><span class="op">-</span><span class="kw">diff</span>(mort<span class="op">$</span>surv)</a>
<a class="sourceLine" id="cb23-6" title="6"><span class="kw">plot</span>(ft, <span class="dt">xlim=</span><span class="kw">c</span>(.<span class="dv">5</span>,<span class="fl">11.5</span>), </a>
<a class="sourceLine" id="cb23-7" title="7">     <span class="dt">type=</span><span class="st">&quot;s&quot;</span>,</a>
<a class="sourceLine" id="cb23-8" title="8">     <span class="dt">ylab=</span><span class="st">&quot;f(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>,</a>
<a class="sourceLine" id="cb23-9" title="9">     <span class="dt">main=</span><span class="st">&quot;Probability Density Function&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-13-2.png" /><!-- --></p>
<div class="sourceCode" id="cb24"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb24-1" title="1"><span class="co">#here is the cumulative distribution function</span></a>
<a class="sourceLine" id="cb24-2" title="2">Ft&lt;-<span class="kw">cumsum</span>(ft)</a>
<a class="sourceLine" id="cb24-3" title="3"><span class="kw">plot</span>(Ft, <span class="dt">xlim=</span><span class="kw">c</span>(<span class="fl">0.5</span>,<span class="dv">12</span>), <span class="dt">type=</span><span class="st">&quot;s&quot;</span>, <span class="dt">ylab=</span><span class="st">&quot;F(t)&quot;</span>,<span class="dt">xlab=</span><span class="st">&quot;Time in Months&quot;</span>, <span class="dt">main=</span><span class="st">&quot;Cumulative Distribution Function&quot;</span>)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/EX1_ModelData_files/figure-html/unnamed-chunk-13-3.png" /><!-- --></p>
<p>So in this example, we calculated the censored ages at death for children under age 1, we estimated the survival function, hazard and Cumulative hazard functions, and the associated pdf and cdf’s.</p>
</div>
</div>
</section>
