# Matching options

## Variables introduced on this page:
# Basic matching: match_basic_covs (string vector)
# Advanced matching: match_exact (T/F), match_nonexact (T/F)
# Exact matching: match_exact_covs (string vector)
# Non-exact matching: match_nonexact_covs (string vector), match_distance_{pscore, mahal, class, nnet} (T/F), match_method_{nn, opt, gen, sub, full, kern} (T/F)
# NN matching:      match_nn_ratio (numeric),  match_nn_replace (T/F),  match_nn_exact_covs (string vector)
# Optimal matching: match_opt_ratio (numeric)
# Genetic matching: match_gen_ratio (numeric)
# Subclassification: match_sub_pscore_subclasses (numeric)
# Full: (none)
# Kernel: (none)
# Additional options: match_discard (0/1/2/3/4/5/6), match_discard_reest (T/F)

conditionalPanel(condition = "input.match == 0 || input.match ==1 ",   

  # No matching
  conditionalPanel(condition = "input.match == 0",
                   p("None. Matching not selected.")
  ),
  
  # Basic matching
  conditionalPanel(condition = "input.match == 1 && input.match_mode == 'basic' ",
                   fluidRow(
                     column(4,
                            h4("Basic matching options:"),
                            h5("Matching notes:"),
                            div("We suggest that only covariates that influence simultaneously the exposure and the outcome be included. We also suggest that no covariates that are the consequence of the treatment be included in this set.", style="color:blue"),
                            div("Covariate sets that are sufficient to control confounding: ...", style="color:blue"),
                            div("Covariates that are highly correlated: ...", style="color:blue")),
                     column(4,
                            br(), br(), br(), br(),
                            div("On which covariates would you like to match? (these options will need to be pulled from initial user input)", style="color:blue"),
                            checkboxGroupInput("match_basic_covs", label = "", choices = list("W1", "W2","W3","Y0"))
                     )
                   )
  ),
  
  # Advanced matching
  conditionalPanel(condition = "input.match == 1 && input.match_mode == 'adv' ",
                   fluidRow(
                     column(3,
                            h4("Advanced matching options:"),
                            h5("Matching notes:"),
                            div("We suggest that only covariates that influence simultaneously the exposure and the outcome be included. We also suggest that no covariates that are the consequence of the treatment be included in this set.", style="color:blue"),
                            div("Covariate sets that are sufficient to control confounding: ...", style="color:blue"),
                            div("Covariates that are highly correlated: ...", style="color:blue"),
                            
                            p("Which matching types would you like to consider?"),
                            checkboxInput("match_exact", label="Exact", value = F),
                            checkboxInput("match_nonexact", label="Non-exact (propensity score, Mahalanobis, etc)", value = F)    
                     ),
                     
                     column(4,
                        
                       # Exact matching      
                       conditionalPanel(condition = "input.match_exact == true ",
                                        h4("Exact matching"),
                                        checkboxGroupInput("match_exact_covs",
                                          label = "On which covariates would you like to exact match? (these options will need to be pulled from initial user input)",
                                          choices = list("W1", "W2","W3","Y0"))  
                       ),
                       
                       # Non-exact matching
                       conditionalPanel(condition = "input.match_nonexact == true ",
                                        h4("Non-exact matching"),
                                        checkboxGroupInput("match_nonexact_covs",
                                                           label = "On which covariates would you like to match? (options need to be pulled from initial user input)",
                                                           choices = list("W1", "W2","W3","Y0")),
                                        
                                        h5("Select distance metric:"),
                                        checkboxInput("match_distance_pscore", "Propensity score"),
                                        checkboxInput("match_distance_mahal" , "Mahalanobis"),
                                        checkboxInput("match_distance_class" , "Classification trees"),
                                        checkboxInput("match_distance_nnet"  , "Neural network"),
                                        
                                        h5("Select matching method:"),
                                        checkboxInput("match_method_nn",     "Nearest neighbor"),
                                        checkboxInput("match_method_opt",    "Optimal (currently only works if more controls than treated units)"),
                                        checkboxInput("match_method_gen",    "Genetic"),
                                        checkboxInput("match_method_sub",    "Subclassification"),
                                        checkboxInput("match_method_full",   "Full matching"),
                                        conditionalPanel(condition = "input.match_distance_pscore == true", 
                                                         checkboxInput("match_method_kern",   "Kernel regression (this method not currently operational; only offered with propensity score matching; will use default kernel and bandwidth)")),
                                        
                                        # sub-specifications for particular matching methods
                                        # Nearest neighbor 
                                        conditionalPanel(condition = "input.match_method_nn == true",
                                                         h6("Nearest neighbor matching specifications:"),
                                                         numericInput("match_nn_ratio", label = "Matching ratio of control to treated units (input as fraction):", value = 1),
                                                         checkboxInput("match_nn_replace", "With replacement"),
                                                         checkboxGroupInput("match_nn_exact_covs",
                                                                            label = "On which covariates (if any) would you like to exact match first? (not currently available for SuperLearner-estimated propensity score matching)",
                                                                            choices = list("W1", "W2","W3","Y0"))          
                                        ),
                                        # Genetic
                                        conditionalPanel(condition = "input.match_method_gen == true",
                                                         h6("Genetic matching specifications:"),
                                                         numericInput("match_gen_ratio", label = "Matching ratio of control to treated units (input as fraction):", value = 1)
                                        ),
                                        # Subclassfication
                                        conditionalPanel(condition = "input.match_method_sub == true",
                                                         h6("Subclassification specifications:"),
                                                         numericInput("match_sub_pscore_subclasses", label = "Number of subclasses:", value = 12)
                                        )
                       )
                     ),
                     
                     column(4,
                        conditionalPanel(condition = "input.match_nonexact == true  && (input.match_distance_pscore == true || input.match_method_sub == true) ", 
                                         h5("Propensity score options:"),
                                         source("pscore_options_match.R")
                        ),
                        conditionalPanel(condition = "input.match_nonexact == true",
                                         h5("Additional matching specifications (not required)"),
                                         radioButtons("match_discard",
                                                      "Discard units outside some measure of support (not required):",
                                                      choices = list("None" = 0,
                                                                     "All units not within convex hull" = 1,
                                                                     "All units outside support of distance metric" = 2,
                                                                     "Control units not within convex hull of treated units" = 3,
                                                                     "Control units outside the support of the distance measure of the treated units" = 4,
                                                                     "Treated units not within the convex hull of the control units" = 5,
                                                                     "Treated units outside the support of the distance measure of the control units" = 6),
                                                      selected = 0), 
                                         conditionalPanel(condition = "input.match_discard != 0 ",
                                                          checkboxInput("match_discard_reest", "Re-estimate distance metric after discarding"))
                        )
                     )
                     
                   ) # close fluid row                    
  ) 
)


