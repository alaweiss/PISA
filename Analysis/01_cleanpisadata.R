##################################################################
########              PISA data analysis                  ########
##################################################################
# 01 Clean data
#   - selects key columns / observations and combines years
##################################################################
##################################################################

rm(list = ls())

######################
# Setup

## Libraries
library(tidyverse)
library(tidylog)
library(magrittr)
library(here)

## PISA years
pisa_years = seq(2000,2018,by = 3)

## Variable selection
analysis_vars = list("country","schoolid","subnatio","gender" = "st03q01",
                     "mother_at_home" = "st04q01","female_at_home" = "st04q02",
                     "father_at_home" = "st04q03","male_at_home" = "st04q04",
                     "mother_lfs" = "st05q01","father_lfs" = "st06q01")

## Country selection
analysis_countries = c("036",  #Australia
                       "040",  #Austria
                       "056",  #Belgium
                       "124",  #Canada
                       "156",  #Shanghai
                       "158",  #Taiwan
                       "203",  #Czech Republic
                       "208",  #Denmark
                       "246",  #Finland
                       "250",  #France
                       "276",  #Germany
                       "344",  #Hong Kong
                       "352",  #Iceland
                       "372",  #Ireland
                       "376",  #Israel
                       "380",  #Italy
                       "392",  #Japan
                       "410",  #South Korea
                       "442",  #Luxembourg
                       "446",  #Macao
                       "528",  #Netherlands
                       "554",  #New Zealand
                       "578",  #Norway
                       "616",  #Poland
                       "620",  #Portugal
                       "643",  #Russia
                       "702",  #Singapore
                       "724",  #Spain
                       "752",  #Sweden
                       "756",  #Switzerland
                       "826",  #UK
                       "840"   #USA
                       )

######################
# Load and clean original data

## 2000
pisa_2000 = readRDS(here("InData","PISA_raw","PISA_2000.RDS")) %>%
  # Year of data
  mutate(year = 2000) %>%
  # Filter key countries for analysis
  filter(country %in% analysis_countries) %>%
  # Select key variables
  select(country,cnt,schoolid,subnatio,gender = st03q01,
         mother_at_home = st04q01,female_at_home = st04q02,
         father_at_home = st04q03,male_at_home = st04q04,
         mother_lfs = st06q01,father_lfs = st07q01,
         # mother_scheduc = st12q01,father_scheduc = st13q01,
         # mother_tereduc = st14q01,father_tereduc = st15q01,
         own_room = st21q02,study_place = st21q06,desk = st21q07,
         computers = st22q04,
         private_tutoring = st24q07,
         age,nsib,socioeconomic = hisei,home_educ_resources = hedres,
         father_educ = fisced,mother_educ = misced,
         wealth,
         matches("pv\\d{1}(math|read)$",perl = TRUE),
         w_fstuwt,
         sch_female = pcgirls,sch_type = schltype,sch_hrs = tothrs,
         sch_size = schlsize,sch_ratio = stratio) %>%
  # Variable transformations
  mutate(female = factor(2 - gender,levels = c(0,1),labels = c("Male","Female")),
         woman_at_home = case_when(mother_at_home == 1 | female_at_home == 1 ~ 1,
                                   mother_at_home == 2 & (female_at_home == 2 | is.na(female_at_home)) ~ 0,
                                   is.na(mother_at_home) & female_at_home == 2 ~ 0),
         male_at_home = case_when(father_at_home == 1 | male_at_home == 1 ~ 1,
                                  father_at_home == 2 & (male_at_home == 2 | is.na(male_at_home)) ~ 0,
                                  is.na(father_at_home) & male_at_home == 2 ~ 0),
         lfs_mother = factor(mother_lfs,levels = 1:4,labels = c("FT","PT","Unemployed","NILF")),
         lfs_father = factor(father_lfs,levels = 1:4,labels = c("FT","PT","Unemployed","NILF")),
         across(.cols = c(own_room,study_place,desk),
                .f = ~ 2 - .x),
         computer = case_when(computers == 1 ~ 0,
                              computers > 1  ~ 1),
         private_tutoring = factor(private_tutoring,levels = 1:3,labels = c("Never","Sometimes","Regularly")),
         sch_type = factor(
           case_when(sch_type == 1 | sch_type == 2 ~ 1,
                     sch_type == 3 ~ 2),
           levels = c(1,2),
           labels = c("Private","Government")
         ),
         parental_educ = pmax(father_educ,mother_educ,na.rm = TRUE)) %>%
  # Further column selection
  select(-c(gender,mother_lfs,father_lfs,
            mother_at_home,female_at_home,father_at_home,male_at_home,
            computers,
            father_educ,mother_educ))

## 2003
pisa_2003 = readRDS(here("InData","PISA_raw","PISA_2003.RDS")) %>%
  # Year of data
  mutate(year = 2003) %>%
  # Filter key countries for analysis
  filter(country %in% analysis_countries) %>%
  # Select key variables
  select(country,cnt,schoolid,subnatio,oecd,
         gender = st03q01,
         mother_at_home = st04q01,female_at_home = st04q02,
         father_at_home = st04q03,male_at_home = st04q04,
         mother_lfs = st05q01,father_lfs = st06q01,
         own_room = st17q02,study_place = st17q03,desk = st17q01,
         computer = st17q04,
         age,socioeconomic = hisei,
         father_educ = fisced,mother_educ = misced,parental_educ = hisced,
         escs,immig,
         matches("pv\\d{1}(math|read)$",perl = TRUE),
         w_fstuwt,
         sch_female = pcgirls,sch_type = schltype,
         sch_size = schlsize,sch_ratio = stratio) %>%
  # Variable transformations
  mutate(female = factor(2 - gender,levels = c(0,1),labels = c("Male","Female")),
         woman_at_home = case_when(mother_at_home == 1 | female_at_home == 1 ~ 1,
                                   mother_at_home == 2 & (female_at_home == 2 | is.na(female_at_home)) ~ 0,
                                   is.na(mother_at_home) & female_at_home == 2 ~ 0),
         male_at_home = case_when(father_at_home == 1 | male_at_home == 1 ~ 1,
                                  father_at_home == 2 & (male_at_home == 2 | is.na(male_at_home)) ~ 0,
                                  is.na(father_at_home) & male_at_home == 2 ~ 0),
         lfs_mother = factor(mother_lfs,levels = 1:4,labels = c("FT","PT","Unemployed","NILF")),
         lfs_father = factor(father_lfs,levels = 1:4,labels = c("FT","PT","Unemployed","NILF")),
         across(.cols = c(own_room,study_place,desk,computer),
                .f = ~ 2 - .x),
         immig = factor(immig,levels = 1:3,labels = c("Native","First-gen","Non-native")),
         sch_type = factor(
           case_when(sch_type == 1 | sch_type == 2 ~ 1,
                     sch_type == 3 ~ 2),
           levels = c(1,2),
           labels = c("Private","Government")
         )) %>%
  # Further column selection
  select(-c(gender,mother_lfs,father_lfs,
            mother_at_home,female_at_home,father_at_home,male_at_home,
            father_educ,mother_educ))

## 2006
pisa_2006 = readRDS(here("InData","PISA_raw","PISA_2006.RDS")) %>%
  # Year of data
  mutate(year = 2006) %>%
  # Filter key countries for analysis
  filter(country %in% analysis_countries) %>%
  # Select key variables
  select(country,cnt,schoolid,subnatio,oecd,
         gender = st04q01,
         own_room = st13q02,study_place = st13q03,desk = st13q01,
         computer = st13q04,
         age,socioeconomic = hisei,
         father_educ = fisced,mother_educ = misced,parental_educ = hisced,
         escs,immig,
         matches("pv\\d{1}(math|read)$",perl = TRUE),
         w_fstuwt,
         sch_female = pcgirls,sch_type = schltype,
         sch_size = schsize,sch_ratio = stratio,
         sch_clsize = clsize) %>%
  # Variable transformations
  mutate(female = factor(2 - gender,levels = c(0,1),labels = c("Male","Female")),
         across(.cols = c(own_room,study_place,desk,computer),
                .f = ~ 2 - .x),
         sch_type = factor(
           case_when(sch_type == 1 | sch_type == 2 ~ 1,
                     sch_type == 3 ~ 2),
           levels = c(1,2),
           labels = c("Private","Government")
         )) %>%
  # Further column selection
  select(-c(gender,father_educ,mother_educ))

## 2009
pisa_2009 = readRDS(here("InData","PISA_raw","PISA_2009.RDS")) %>%
  # Year of data
  mutate(year = 2009) %>%
  # Filter key countries for analysis
  filter(country %in% analysis_countries) %>%
  # Select key variables
  select(country,cnt,schoolid,subnatio,gender = st04q01,
         own_room = st20q02,study_place = st20q03,desk = st20q01,
         computer = st20q04,
         age,socioeconomic = hisei,
         father_educ = fisced,mother_educ = misced,parental_educ = hisced,
         escs,immig,
         matches("pv\\d{1}(math|read)$",perl = TRUE),
         w_fstuwt,
         sch_female = pcgirls,sch_type = schtype,
         sch_size = schsize,sch_ratio = stratio) %>%
  # Variable transformations
  mutate(female = factor(2 - gender,levels = c(0,1),labels = c("Male","Female")),
         across(.cols = c(own_room,study_place,desk,computer),
                .f = ~ 2 - .x),
         sch_type = factor(
           case_when(sch_type == 1 | sch_type == 2 ~ 1,
                     sch_type == 3 ~ 2),
           levels = c(1,2),
           labels = c("Private","Government")
         )) %>%
  # Further column selection
  select(-c(gender,father_educ,mother_educ))

## 2012
pisa_2012 = readRDS(here("InData","PISA_raw","PISA_2012.RDS")) %>%
  # Year of data
  mutate(year = 2012) %>%
  # Filter key countries for analysis
  mutate(country_og = floor((country %>% unclass %>% as.numeric)/100) %>% as.character) %>%
  filter(country_og %in% analysis_countries) %>%
  # Select key variables
  select(country,cnt,schoolid,subnatio,gender = st04q01,
         own_room = st26q02,study_place = st26q03,desk = st26q01,
         computer = st26q04,
         age,socioeconomic = hisei,
         father_educ = fisced,mother_educ = misced,parental_educ = hisced,
         escs,immig,
         matches("pv\\d{1}(math|read)$",perl = TRUE),
         w_fstuwt,
         sch_female = pcgirls,sch_type = schltype,
         sch_size = schsize,sch_ratio = stratio) %>%
  # Variable transformations
  mutate(female = factor(2 - gender,levels = c(0,1),labels = c("Male","Female")),
         across(.cols = c(own_room,study_place,desk,computer),
                .f = ~ 2 - .x),
         sch_type = factor(
           case_when(sch_type == 1 | sch_type == 2 ~ 1,
                     sch_type == 3 ~ 2),
           levels = c(1,2),
           labels = c("Private","Government")
         )) %>%
  # Further column selection
  select(-c(gender,father_educ,mother_educ))

## 2015
pisa_2015 = readRDS(here("InData","PISA_raw","PISA_2015.RDS")) %>%
  # Year of data
  mutate(year = 2012) %>%
  # Filter key countries for analysis
  filter(country %in% analysis_countries) %>%
  # Select key variables
  select(country,cnt,schoolid,subnatio,gender = st04q01,
         own_room = st26q02,study_place = st26q03,desk = st26q01,
         computer = st26q04,
         age,socioeconomic = hisei,
         father_educ = fisced,mother_educ = misced,parental_educ = hisced,
         escs,immig,
         matches("pv\\d{1}(math|read)$",perl = TRUE),
         w_fstuwt,
         sch_female = pcgirls,sch_type = schtype,
         sch_size = schsize,sch_ratio = stratio) %>%
  # Variable transformations
  mutate(female = factor(2 - gender,levels = c(0,1),labels = c("Male","Female")),
         across(.cols = c(own_room,study_place,desk,computer),
                .f = ~ 2 - .x),
         sch_type = factor(
           case_when(sch_type == 1 | sch_type == 2 ~ 1,
                     sch_type == 3 ~ 2),
           levels = c(1,2),
           labels = c("Private","Government")
         )) %>%
  # Further column selection
  select(-c(gender,father_educ,mother_educ))

######################
# Combine years

######################
# Saved clean data