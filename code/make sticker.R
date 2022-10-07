library(tidyverse)
library(haven)
library(survival)
library(car)
library(survey)
library(muhaz)
library(eha)

#load the data
dat<-read_dta("../data/ZAIR71FL.DTA")
dat<-zap_labels(dat)

table(is.na(dat$bidx_01))
#now we extract those women

#Here I keep only a few of the variables for the dates, and some characteristics of the women, and details of the survey

sub<-dat %>%
  filter(bidx_01==1&b0_01==0)%>%
  transmute(CASEID=caseid, 
            int.cmc=v008,
            fbir.cmc=b3_01,
            sbir.cmc=b3_02,
            marr.cmc=v509,
            rural=v025,
            educ=v106,
            age = v012,
            agec=cut(v012, breaks = seq(15,50,5), include.lowest=T),
            partneredu=v701,
            partnerage=v730,
            weight=v005/1000000,
            psu=v021,
            strata=v022)%>%
  select(CASEID, int.cmc, fbir.cmc, sbir.cmc, marr.cmc, rural, educ, age, agec, partneredu, partnerage, weight, psu, strata)%>%
  mutate(agefb = (age - (int.cmc - fbir.cmc)/12))

sub2<-sub%>%
  mutate(secbi = ifelse(is.na(sbir.cmc)==T,
                        int.cmc - fbir.cmc, 
                        fbir.cmc - sbir.cmc),
         b2event = ifelse(is.na(sbir.cmc)==T,0,1))
`
library(ggsurvfit)
fit<-survfit2(Surv(secbi, b2event)~1, sub2)

p<-fit %>%
  ggsurvfit()+theme_classic()


hexSticker::sticker(p, package="DEM 7223",        h_fill="#0c2340",         # Hex background color
                    h_size = 2,               # Hex border size
                    h_color = "#f15a22", filename = "DEM7223.png",p_size=20, s_x=1, s_y=.75, s_width=1.1, s_height=.7, dpi=300)

ggsave(filename = "DEM7223.png",
       width = 800, height = 800, units = "px",
       bg = "transparent",
       dpi = 300)
