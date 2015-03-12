# Analysis options

## Variables introduced on this page:
# Analysis methods: an_gcomp (T/F), an_pweight (T/F), an_aiptw (T/F), an_tmle (T/F), an_bcm (T/F)
# Analysis covariates: an_covs (string vector)
# Additional pweight options: an_pweight_type ('pweight_ht', 'pweight_modht')


conditionalPanel(condition = "input.sample_size > 0 ",
  fluidRow(               
    column(4, 
           
      h4("Select desired analysis methods:"),
      p("(Note: Unadjusted analysis will be run by default)"),
      checkboxInput("an_gcomp", "G-computation"),
      checkboxInput("an_pweight", "Propensity score weighting"),
      checkboxInput("an_aiptw", "Augmented inverse probability of treatment weighted estimation (AIPTW)"),
      checkboxInput("an_tmle", "Targeted maximum likelihood estimation (TMLE)"),
      checkboxInput("an_bcm", "Bias corrected matching"),
      
      h5("Notes on covariates:"),
      div("We suggest that only covariates that influence simultaneously the exposure and the outcome be included. We also suggest that no covariates that are the consequence of the treatment be included in this set.", style = "color:blue"),
      div("Covariate sets that are sufficient to control confounding: ...", style = "color:blue"),
      div("Covariates that are highly correlated: ...", style = "color:blue"),
      
      h5("Which covariates would you like to control for in your analysis?"),
      checkboxGroupInput("an_covs", label = "", choices = list("W1", "W2","W3","Y0"))
    
      
    ),
    column(4, 
           
      # Options for treatment mechanism
      conditionalPanel(condition = "input.an_pweight == true || input.an_aiptw == true || input.an_tmle == true || input.an_bcm == true ",
                       h4("Specifications for estimation of treatment mechanism"),
                       source("pscore_options_analysis.R")
      ), 
      
      # Options for outcome model
      conditionalPanel(condition = "input.an_gcomp == true || input.an_aiptw == true || input.an_tmle == true || input.an_bcm == true ",
                       h4("Specifications for estimation of outcome model"),
                       source("analysis_q_options.R")
      )
           
         
    ),
    column(4, 
       # G computation options
       conditionalPanel(condition = "input.an_gcomp == true ",
                        h4("Additional specifications for G-computation"),
                        div("What about fitting models separately for treated and control groups?", style = "color:blue"),
                        div("What about regression models that are weighted with IPT weights?", style = "color:blue")
       ),
       
       # Propensity score weighting
       conditionalPanel(condition = "input.an_pweight == true ",
                        h4("Additional specifications for propensity weighting analysis"),
                        radioButtons("an_pweight_type",
                                     "Which propensity weighting methods would you like to test?",
                                     choices = list("Horvitz-Thompson inverse probability of treatment weighted estimator" = "pweight_ht",
                                                    "Modified Horvitz-Thompson inverse probability of treatment weighted estimator with stabilized weights (not currently operational)" = "pweight_modht"),
                                     selected = "pweight_ht")
       ),
           
       # AIPTW
       conditionalPanel(condition = "input.an_aiptw == true ",
                        h4("Additional specifications for augmented IPTW"),
                        p("None for now.")
       ),       
          
       # TMLE
       conditionalPanel(condition = "input.an_tmle == true ",
                        h4("Additional specifications for targeted maximum likelihood estimation (TMLE)"),
                        p("None for now.")
       ),
       
       # Bias-corrected matching
       conditionalPanel(condition = "input.an_bcm == true ",
                        h4("Additional specifications for bias-corrected matching (BCM)"),
                        source("bcm.R")
       )
    )     
  )
)