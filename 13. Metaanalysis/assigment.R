
#install.packages("meta")
if (!require(readxl)) {
  install.packages("readxl")
}
library(readxl)
library(meta)
library(metagen)
library(metafor)
library(readxl)


# Install the magrittr package
#install.packages("magrittr")

# Load the magrittr package
library(magrittr)

file_path <- "/Users/eugeneolkhovik/Desktop/master/reproducible_research/copied/RRcourse2023-UW/13. Metaanalysis/data/metaanalysis_data.xlsx"
data <- read_excel(file_path)
#Here’s authors’ descriptions to the data:
  
#Neutral toys
#(1 = neutral toys included; 2 = neutral toys not included);
#Parent present (1 = absent; 2 = minimal interaction; 3 = moderate or full interaction);
# Setting = location of study (1 = home; 2 = laboratory; 3 = nursery);
#Country = gender inequality index, a measure of how gender egalitarian the country was at the time the study took place.

#Note.
#Quality is assessed using Newcastle–Ottawa Quality Assessment Scale criteria adapted for this study.
#A star indicates that the study fulfilled this criterion; an X indicates that the study did not fulfil this criterion. 
#Case definition adequate: clear justification for the gendered nature of a toy, for example, based on research. 
#Representativeness of cases: recruitment of consecutive participants. 
#Selection of controls: whether boys and girls were comparable in terms of social background. 
#Parental opinion: whether parents’ views on gender were measured. 
#Comparability of both groups: the toys were comparable (in size, shape, etc.) and if the boys and girls were comparable in age. 
#Ascertainment of behaviour: Play behaviour was clearly defined. 
#Same ascertainment method for both groups: The measurement of the outcome (time spent playing with toy) was clearly defined. 
#Nonresponse rate: whether either nonuptake or dropout rates reported.
data


## Our effect sizes are not calculated but we have the necessary data
## we have std and means for boys and girls 

#
load("/Users/eugeneolkhovik/Downloads/RRcourse2023-main/13. Metaanalysis/data/madata.RData")
Meta_Analysis_Data[1:5,]

meta_boys <- metacont(n.e = N_boys,
                      mean.e = Mean_boys_play_male,
                      sd.e = SD_boys_play_male,
                      n.c = N_boys,
                      mean.c = Mean_boys_play_female,
                      sd.c = SD_boys_play_female,
                      data = data,
                      comb.fixed = TRUE,
                      comb.random = TRUE)

meta_girls <- metacont(n.e = N_girls,
                       mean.e = Mean_girls_play_male,
                       sd.e = SD_girls_play_male,
                       n.c = N_girls,
                       mean.c = Mean_girls_play_female,
                       sd.c = SD_girls_play_female,
                       data = data)

meta_boys %>% forest(sortvar = TE)
meta_girls %>% forest(sortvar = TE)

meta_boys %>% funnel()

contour_levels <- c(0.90, 0.95, 0.99)

contour_colors <- c("#FF0000", "#00FF00", "#0000FF")

#The funnel plot for the meta-analysis is not symmetrical. 
#Most of the publications are concentrated on the right side of the plot. 
#However, it's worth noting that the funnel includes the majority of the publications, specifically 25 out of 27.


funnel(meta_boys, contour = contour_levels, col.contour = contour_colors)
legend("bottomright", c("p < 0.10", "p < 0.05", "p < 0.01"), bty = "n", fill = contour_colors)

funnel(meta_girls, contour = contour_levels, col.contour = contour_colors)
legend("bottomright", c("p < 0.10", "p < 0.05", "p < 0.01"), bty = "n", fill = contour_colors)


# Methods and Quality Effect on Results


reg_results <- metareg(meta_boys, ~ Parent.present + Country + Year + male_share)

