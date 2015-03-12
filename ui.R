library(shiny)

## Variables introduced on this page:
# Sampling: sample_size (numeric), all_exposed (0/1), all_controls (0/1)
# Target parameter: ate (T/F), att (T/F), effect metric (1/2/3)
# Timing and outcome: outcome_diff (0/1)
# Matching: match (0/1), match_mode ('basic','adv'), match_basic_more(T/F)

shinyUI(fluidPage(
  
titlePanel("Study design and analysis"),
  
tabsetPanel(
  tabPanel("Main options",
    fluidRow(
      
      column(3,
    
        # 1. Sampling ---------------------------------------------------------------------
        h4("Sampling"),

        numericInput("sample_size", label = "Desired sample size:", value = 500),
        br(),
        radioButtons("all_exposed",
                     label = "Do you want your sample to include all exposed subjects or a random sample?",
                     choices = list("All exposed subjects"=1,"Random sample of exposed subjects"=0),
                     selected = 1),
        br(),
        radioButtons("all_controls",
                     label="Do you want your sample to include all unexposed subjects or a random sample?",
                     choices=list("All unexposed subjects"=1,"Random sample of unexposed subjects"=0),
                     selected=1),
        div("Create flag here for inconsistencies between desired sample size and inclusion of treated units and controls (e.g. all exposed units desired, but sample size requested is less that the number of treated units", style = "color:blue")
      ),
      
      column(4,
      
        # 2. Target parameter and scale of effect metric -----------------------------------
        h4("Target parameter and scale of effect metric"),
        
        p("Which target parameters would you like to estimate?"),
        checkboxInput("ate", "Average treatment effect for whole population (ATE)", value = T),
        checkboxInput("att", "Effect of treatment among the treated units (ATT)"),
        br(),
        
        radioButtons("effect_metric",
                     label = "Would you like to compare risk differences, risk ratios, or odds ratios?",
                     choices = list("Risk difference (RD)" = 1, "Risk ratio (RR)" = 2, "Odds ratio (OR)" = 3),
                     selected = 1),
        br(),
        
        # 3. Timing and outcome considerations ----------------------------------------------
        h4("Timing and outcome considerations"),
        
        radioButtons("outcome_diff",
                     label = "How many times would you like the outcome to be differenced over time?", 
                     choices = list("None. Use Y at final time point as outcome" = 0, "Once. Use first-differenced outcome" = 1),
                     selected = 0)
      ),
      
      
      
      column(4, 
             
        # 4. Matching -------------------------------------------------------------------------
        h4("Matching"),
        
        radioButtons("match",
                    label = "In addition to the simple random sample specified above, would you like to consider analyses involving samples that have been pre-processed through matching (currently only for ATT)?",
                    choices = list("No" = 0, "Yes" = 1), 
                    selected = 0),
        conditionalPanel(condition = "input.match == 1",
                         br(),
                         radioButtons("match_mode",
                                      label="Select level of detail for matching options:",
                                      list("Basic: test several default matching methods" = "basic",
                                           "Advanced: select custom matching options" = "adv")),
                         checkboxInput("match_basic_more", "More information on basic matching mode"),
                         conditionalPanel(condition = "input.match_basic_more == true ",
                                          p("Basic matching mode will test the following 4 options:"),
                                          p("(1) 1:1 nearest neighbor propensity score matching with replacement and propensity score estimated using linear regression with main term covariates"),
                                          p("(2) 1:1 nearest neighbor propensity score matching with replacement and propensity score estimated using SuperLearner with main term covariates"),
                                          p("(3) Full propensity score matching with propensity score estimated using linear regression with main term covariates"),
                                          p("(4) Full propensity score matching with propensity score estimated using linear regression with main term covariates")
                         )
                         
        )           
      )
      
    ) # close fluid row
  ), # close tabPanel 1 (main options)
  
  tabPanel("Matching options",
    source("matching.R")
  ), 
  
  tabPanel("Analysis options",
    source("analysis.R")
  ), 
  
  tabPanel("Final settings",
    textOutput("text1"),
    h3("Designs"),
    tableOutput("designs"),
    h3("Matches"),
    tableOutput("matches"),
    h3("Analyses"),
    tableOutput("analyses")
  ) 

) 

))