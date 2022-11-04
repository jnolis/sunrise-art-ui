library(shiny)
library(bslib)
library(httr)
library(glue)
library(brochure)
library(stringr)
library(purrr)


source("ui/make-chart.R")
source("ui/index.R")



brochureApp(
 make_chart_page,
 index_page,
 wrapped = identity
)
