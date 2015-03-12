# bcm.R

## Variables introduced on this page:
# none

conditionalPanel(condition = "input.an_bcm == true",
   conditionalPanel(condition = "input.match == 1",
                    p("Matching methods selected in 'Main options' and 'Matching options' tabs will be implemented.")),
   conditionalPanel(condition = "input.match == 0",
                    p("This analysis method requires match. Please return to 'Main options' and 'Matching options' tabs and select desired matching options.")),
   div("Requires to match treated units to controls and vice versa, so take matching specifications from matching tab, and match both directions??", style = "color:blue"),
   div("OR require re-estimation of pscore here and allow only certain types of pscore matching", style = "color:blue"),
   div("OR require in matching tab that certain pscore matching methods be used", style = "color:blue")
   
)