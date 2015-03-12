#analysis_q_options.R

## Variables introduced on this page:
# Main options: analysis_q_mode('basic','adv'), analysis_q_basic_more (T/F), analysis_q_para (T/F), analysis_q_sl (T/F)
# Parametric model distribution: analysis_q_dist_gaus (T/F), analysis_q_dist_bin (T/F), analysis_q_dist_gam (T/F), analysis_q_dist_pois (T/F)
# Parametric links: analysis_q_gaus_link (string vector), analysis_q_bin_link (string vector), analysis_q_gam_link (string vector), analysis_q_pois_link (string vector)
# Parametric covariate forms: analysis_q_covform ('mainterm','mainterm_inter','quintile'), analysis_q_formula (text)
# Semi parametric: analysis_q_slfull (0/1), analysis_q_sldefault (0/1), analysis_q_sllibs (string vector)

conditionalPanel(condition = "input.an_gcomp == true || input.an_aiptw == true || input.an_tmle == true || input.an_bcm == true ",
    radioButtons("analysis_q_mode",
                 label="Select level of detail for outcome model estimation:",
                 list("Basic: test several default methods" = "basic",
                      "Advanced: select custom methods" = "adv"),
                 selected = "basic"),
    checkboxInput("analysis_q_basic_more", "More information on basic mode"),
    conditionalPanel(condition = "input.analysis_q_basic_more == true ",
                     p("Basic mode will test the following 2 options:"),
                     p("(1) Parametric GLM with Gaussian distribution and identity link for continuous outcomes and Binomial distribution with logit link for binomial outcomes, and covariates as main linear terms with first order interactions"),
                     p("(2) Full SuperLearner outcome model with default libraries")),
                     div("Need to pipe in here whether outcome is continuous or binary so we know which option for basic mode 1. For now will just use gaussian", style = "color:blue"),
    
    conditionalPanel(condition = "input.analysis_q_mode == 'adv' ",
                     p("Would you like to test parametric or semi-parametric (SuperLearner) outcome models?"),
                     checkboxInput("analysis_q_para", "Parametric"),
                     checkboxInput("analysis_q_sl", "Semi-parametric (SuperLearner)"),
                     
                     conditionalPanel(condition = "input.analysis_q_para == true ",
                                      
                                      h6("Parametric outcome model estimation options"),
                                      
                                      p("Select distribution and link for GLM model: "),
                                      checkboxInput("analysis_q_dist_gaus", "Gaussian"),
                                      conditionalPanel(condition = "input.analysis_q_dist_gaus == true",
                                                       radioButtons("analysis_q_gaus_link",
                                                       label = "Select link for gaussian GLM:",
                                                       choices = list("identity"="identity","log"="log","inverse"="inverse"),
                                                       selected = "identity")),
                                      checkboxInput("analysis_q_dist_bin", "Binomial"),
                                      conditionalPanel(condition = "input.analysis_q_dist_bin == true",
                                                       radioButtons("analysis_q_bin_link",
                                                       label = "Select link for binomial GLM:",
                                                       choices = list("logit"="logit","probit"="probit","Cauchy CDF"="cauchit","log"="log","Complementary log-log"="cloglog"),
                                                       selected = "logit")),
                                      checkboxInput("analysis_q_dist_gam", "Gamma"),
                                      conditionalPanel(condition = "input.analysis_q_dist_gam == true",
                                                       radioButtons("analysis_q_gam_link",
                                                       label = "Select link for gamma GLM:",
                                                       choices = list("inverse"="inverse","identity"="identity","log"="log"),
                                                       selected = "inverse")),
                                      checkboxInput("analysis_q_dist_pois", "Poisson"),
                                      conditionalPanel(condition = "input.analysis_q_dist_pois == true",
                                                       radioButtons("analysis_q_pois_link",
                                                       label = "Select link for poisson GLM:",
                                                       choices = list("log"="log","identity"="identity","Square root"="sqrt"),
                                                       selected = "log")),
                                      
                                      div("Conditional warnings based on selected distribution vs. distribution of outcome variable here", style="color:blue"),
                                      
                                      radioButtons("analysis_q_covform",
                                                   label = "Which covariate forms would you like to test?",
                                                   choices = list("Main linear terms (e.g. W1 + W2)"="mainterm","Main linear terms and first order interactions (e.g. W1 + W2 + W1^2 + W2^2 + W1*W2)"="mainterm_inter","Quintile dummies (e.g. quintile2(W1) + quintile3(W1) + quintile4(W1) + quintile5(W1))"="quintile"),
                                                   selected = "mainterm"),
                                      
                                      textInput("analysis_q_formula", label = "If you would like to test a particular parametric model form, please enter the formula here (this option not currently operational):", value = ""),
                                      div("Notes about allowed operators, transformations and notations for equation box here.", style = "color:blue")
                     ),
                     
                     conditionalPanel(condition = "input.analysis_q_sl == 1 ",
                                      h6("Semi-parametric propensity score estimation options"),
                                      radioButtons("analysis_q_slfull",
                                                   label = "Would you like to test full or discrete SuperLearner?",
                                                   choices = list("Full" = 1, "Discrete" = 0),
                                                   selected = 1),
                                      radioButtons("analysis_q_sldefault",
                                                   label = "Would you like to use default or custom SuperLearner libraries?",
                                                   choices = list("Default" = 1, "Custom" = 0)),
                                      p("Default SuperLearner libraries: SL.glm, SL.step, SL.rpartprune, SL.earth, SL.nnet, SL.gam"),
                                      p("Default SuperLearner covariate transformations: first order interactions, quintile dummies"),
                                      conditionalPanel(condition = "input.analysis_q_sldefault == 0",
                                                       checkboxGroupInput("analysis_q_sllibs",
                                                                          "Select custom SuperLearner libraries:",
                                                                          choices = list("bayesglm","caret","caret.rpart","cforest (continous outcome only)","earth","gam","gbm","glm","glm.interaction","glmnet","ipredbagg","knn (binary outcome only)","loess (continous outcome only)","mean","nnet","polymars","randomForest","ridge (continuous outcome only)","rpart","rpartPrune","step","step.forward","step.interaction","stepAIC","svm"))
                                      )
                     )
    )
)