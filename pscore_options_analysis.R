# pscore_options_analysis.R

# Lines 10 - 11 here can be adjusted for the circumstance in which propensity score options are needed; the remaining lines can be copy-pasted-- they are the universal propensity score options

## Variables introduced on this page:
# Pscore options: *_pscore_mode ('basic','adv'), *_pscore_basic_more (T/F), *_pscore_para (T/F), *_pscore_sl (T/F)
# Parametric: *_pscore_link ('logit','probit','cloglog','log','cauchit'), *_pscore_covform ('mainterm','mainterm_inter','quintile'), *_pscore_formula (text)
# Semi-parametric: *_pscore_slfull (0/1), *_pscore_sldefault (0/1), *_pscore_sllibs (string vector)

name <- "analysis"
conditionalPanel(condition = "input.an_pweight == true || input.an_aiptw == true || input.an_tmle == true || input.an_bcm == true ",
   radioButtons(paste0(name,"_pscore_mode"),
                label="Select level of detail for model estimation:",
                choices = list("Basic: test several default methods" = "basic",
                     "Advanced: select custom methods" = "adv")),
   checkboxInput(paste0(name,"_pscore_basic_more"), "More information on basic mode"),
   conditionalPanel(condition = paste0("input.",name,"_pscore_basic_more == true "),
                    p("Basic mode will test the following 2 options:"),
                    p("(1) Parametric GLM with Binomial distribution and logit link, and covariates as main linear terms with first order interactions"),
                    p("(2) Full SuperLearner with default libraries")),
   
   conditionalPanel(condition = paste0("input.",name,"_pscore_mode == 'adv' "),
                    
       p("Do you want to estimate the propensity score using a parametric or semi-parametric model (SuperLearner)?"),
       checkboxInput(paste0(name,"_pscore_para"), "Parametric"),
       checkboxInput(paste0(name,"_pscore_sl"), "Semi-parametric (SuperLearner)"),
       
       conditionalPanel(condition = paste0("input.",name,"_pscore_para == true "),
                        h6("Parametric propensity score estimation options"),
                        radioButtons(paste0(name,"_pscore_link"),
                                     label = "Select link for binomial GLM:",
                                     choices = list("logit"="logit", "probit"="probit", "complementary log-log"="cloglog", "log"="log", "Cauchy CDF"="cauchit"),
                                     selected = "logistic"),
                        
                        radioButtons(paste0(name,"_pscore_covform"),
                                     label = "Which covariate forms would you like to test?",
                                     choices = list("Main linear terms (e.g. W1 + W2)"="mainterm","Main linear terms and first order interactions (e.g. W1 + W2 + W1^2 + W2^2 + W1*W2)"="mainterm_inter","Quintile dummies (e.g. quintile2(W1) + quintile3(W1) + quintile4(W1) + quintile5(W1))"="quintile"),
                                     selected = "mainterm"),
                        
                        textInput(paste0(name,"_pscore_formula"), label = "If you would like to test a particular parametric model form, please enter the formula here (this option not currently operational):", value = ""),
                        div("Notes about allowed operators, transformations and notations for equation box here.", style = "color:blue")
       ),
       conditionalPanel(condition = paste0("input.",name,"_pscore_sl == 1 "),
                        h6("Semi-parametric propensity score estimation options"),
                        radioButtons(paste0(name,"_pscore_slfull"),
                                     label = "Would you like to test full or discrete SuperLearner?",
                                     choices = list("Full" = 1, "Discrete" = 0),
                                     selected = 1),
                        radioButtons(paste0(name,"_pscore_sldefault"),
                                     label = "Would you like to use default or custom SuperLearner libraries?",
                                     choices = list("Default" = 1, "Custom" = 0)),
                        p("Default SuperLearner libraries: SL.glm, SL.step, SL.rpartprune, SL.earth, SL.nnet, SL.gam"),
                        p("Default SuperLearner covariate transformations: first order interactions, quintile dummies"),
                        conditionalPanel(condition = paste0("input.",name,"_pscore_sldefault == 0"),
                                         checkboxGroupInput(paste0(name, "_pscore_sllibs"),
                                                            label = "Select custom SuperLearner libraries:",
                                                            choices = list("bayesglm","caret","caret.rpart","cforest (continous outcome only)","earth","gam","gbm","glm","glm.interaction","glmnet","ipredbagg","knn (binary outcome only)","loess (continous outcome only)","mean","nnet","polymars","randomForest","ridge (continuous outcome only)","rpart","rpartPrune","step","step.forward","step.interaction","stepAIC","svm"))
                        )
       )
   )   
)

