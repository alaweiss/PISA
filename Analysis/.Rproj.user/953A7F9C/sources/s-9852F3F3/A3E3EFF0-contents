##################################################################
########              PISA data analysis                  ########
##################################################################
# 00 Import data
#   - imports and does basic filtering on all PISA data sets
##################################################################
##################################################################

rm(list = ls())

######################
# Setup

## Libraries
library(tidyverse)
library(tidylog)
library(magrittr)
library(janitor)
library(here)
library(haven)

######################
# Import data

## 2000
pisa_2000_sch = read_spss(here("Original Data","2000","intscho.sav"))
pisa_2000_math = read_spss(here("Original Data","2000","intstud_math.sav"))
pisa_2000_read = read_spss(here("Original Data","2000","intstud_read.sav"))
# pisa_2000_scie = read_spss(here("Original Data","2000","intstud_scie.sav")) # Don't use

### Combine to single data frame
pisa_2000 = pisa_2000_read %>%
  mutate(indata_read = 1) %>%
  full_join(pisa_2000_math %>%
              select(COUNTRY,SCHOOLID,STIDSTD,matches("pv.math")) %>%
              mutate(indata_math = 1), 
            by = c("COUNTRY","SCHOOLID","STIDSTD")) %>%
  mutate(indata_read = case_when(is.na(indata_read) ~ 0,
                                 TRUE ~ indata_read),
         indata_math = case_when(is.na(indata_math) ~ 0,
                                 TRUE ~ indata_math)) %>% 
  left_join(pisa_2000_sch %>% 
              rename(COUNTRY = country,
                     SCHOOLID = schoolid) %>%
              select(-c(subnatio,cnt)),
            by = c("COUNTRY","SCHOOLID")) %>%
  clean_names
rm(pisa_2000_sch,pisa_2000_math,pisa_2000_read)

## 2003
pisa_2003_sch = read_spss(here("Original Data","2003","INT_schi_2003.sav"))
pisa_2003_std = read_spss(here("Original Data","2003","INT_stui_2003.sav"))

pisa_2003 = pisa_2003_std %>%
  left_join(pisa_2003_sch %>%
              select(-c(SUBNATIO,CNT,STRATUM)),
            by = c("COUNTRY","SCHOOLID")) %>%
  clean_names
rm(pisa_2003_sch,pisa_2003_std)

## 2006
pisa_2006_sch = read_spss(here("Original Data","2006","INT_Sch06_Dec07.sav"))
pisa_2006_std = read_spss(here("Original Data","2006","INT_Stu06_Dec07.sav"))

pisa_2006 = pisa_2006_std %>%
  left_join(pisa_2006_sch %>%
              select(-c(SUBNATIO,CNT,OECD,STRATUM)),
            by = c("COUNTRY","SCHOOLID")) %>%
  clean_names
rm(pisa_2006_sch,pisa_2006_std)

## 2009
pisa_2009_sch = read_spss(here("Original Data","2009","INT_SCQ09.sav"))
pisa_2009_std = read_spss(here("Original Data","2009","INT_STQ09.sav"))

pisa_2009 = pisa_2009_std %>%
  left_join(pisa_2009_sch %>%
              select(-c(SUBNATIO,CNT,OECD,STRATUM)),
            by = c("COUNTRY","SCHOOLID")) %>%
  clean_names
rm(pisa_2009_sch,pisa_2009_std)

## 2012
pisa_2012_sch = read_spss(here("Original Data","2012","INT_SCQ12.sav"))
pisa_2012_std = read_spss(here("Original Data","2012","INT_STU12.sav"))

pisa_2012 = pisa_2012_std %>%
  rename(COUNTRY = NC) %>%
  left_join(pisa_2012_sch %>%
              rename(COUNTRY = NC) %>%
              select(-c(SUBNATIO,OECD,STRATUM,CNT)),
            by = c("COUNTRY","SCHOOLID")) %>%
  clean_names
rm(pisa_2012_sch,pisa_2012_std)

## 2015
pisa_2015_sch = read_spss(here("Original Data","2015","CY6_MS_CMB_SCH_QQQ.sav"))
pisa_2015_std = read_spss(here("Original Data","2015","CY6_MS_CMB_STU_QQQ.sav"))

pisa_2015 = pisa_2015_std %>%
  rename(SCHOOLID = CNTSCHID) %>%
  left_join(pisa_2015_sch %>%
              rename(SCHOOLID = CNTSCHID) %>%
              select(-c(CNTRYID,CNT,CYC,NatCen,Region,STRATUM,SUBNATIO,OECD,ADMINMODE,SENWT,VER_DAT)),
            by = c("SCHOOLID")) %>%
  clean_names
rm(pisa_2015_sch,pisa_2015_std)

## 2018
pisa_2018_sch = read_spss(here("Original Data","2018","SCH","CY07_MSU_SCH_QQQ.sav"))
pisa_2018_std = read_spss(here("Original Data","2018","STU","CY07_MSU_STU_QQQ.sav"))

pisa_2018 = pisa_2018_std %>%
  rename(SCHOOLID = CNTSCHID) %>%
  left_join(pisa_2018_sch %>%
              rename(SCHOOLID = CNTSCHID) %>%
              select(-c(CNTRYID,CNT,CYC,NatCen,STRATUM,SUBNATIO,OECD,ADMINMODE,BOOKID,SENWT,VER_DAT)),
            by = c("SCHOOLID")) %>%
  clean_names
rm(pisa_2018_sch,pisa_2018_std)

######################
# Save raw data

## 2000
saveRDS(pisa_2000,
        here("Indata","PISA_raw","PISA_2000.RDS"))
## 2003
saveRDS(pisa_2003,
        here("Indata","PISA_raw","PISA_2003.RDS"))
## 2006
saveRDS(pisa_2006,
        here("Indata","PISA_raw","PISA_2006.RDS"))
## 2009
saveRDS(pisa_2009,
        here("Indata","PISA_raw","PISA_2009.RDS"))
## 2012
saveRDS(pisa_2012,
        here("Indata","PISA_raw","PISA_2012.RDS"))
## 2015
saveRDS(pisa_2015,
        here("Indata","PISA_raw","PISA_2015.RDS"))
## 2018
saveRDS(pisa_2018,
        here("Indata","PISA_raw","PISA_2018.RDS"))
