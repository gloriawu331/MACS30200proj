# MACS 30200: Perspectives on Computational Research, Final Project
setwd("/Users/hsswyx/Desktop/files_macs30200proj")
# Import packages
library(tidyverse)
library(forcats)
library(broom)
library(modelr)
library(tree)
library(randomForest)
library(stringr)
library(ISLR)
library(gridExtra)
library(grid)
library(titanic)
library(rcfss)
library(pROC)
library(gbm)
library(ggdendro)

# Read-in data
edu_data <- read.csv('data2.csv')

# Settings
options(digits = 3)
set.seed(1234)
# theme_set(theme_minimal())

# Functions
err.rate.rf <- function(model, data) {
  data <- as_tibble(data)
  response <- as.character(model$terms[[2]])
  
  pred <- predict(model, newdata = data, type = "response")
  actual <- data[[response]]
  
  return(mean(pred != actual, na.rm = TRUE))
}

# add 95% confidence intervals to fitted values from augment()
add_ci <- function(df_augment) {
  df_augment%>%
    mutate(.fitted.low = .fitted - 1.96 * .se.fit,
           .fitted.high = .fitted + 1.96 * .se.fit)
}

# draw 95% confidence interval plot using results of add_ci()
plot_ci <- function(df_ci, x){
  ggplot(df_ci, aes_string(x, ".fitted")) +
    geom_line() +
    geom_line(aes(y = .fitted.low), linetype = 2) +
    geom_line(aes(y = .fitted.high), linetype = 2)
}

# Logistic Regression Model
major_mod <- glm(is_move ~ age + female + race + major, family=binomial, data = edu_data)
summary(major_mod)

# Data cleaning
edu_rf_data <- edu_data%>%
  select(is_move, major)%>%
  mutate(is_move = factor(is_move, levels = 0:1, labels = c("Not Moved", "Moved")),
         female = factor(female, levels = 0:1, labels = c("Male", "Female")),
         race = factor(race, levels = 0:2, labels = c("Others", "Asian", "Black", "Hispanic")),
         major = factor(major))
# , levels = 0:19, labels = c("cs", "math", "agri_sci", "bio_sci", "phy_sci", "psy", "soc_sci", "engn", "health", "tech", "agri_b&p", "bm&as", "edu", "theology", "foreign_lan&lit", "art", "commu", "nat_r&c", "pa", "other"))


##### Decision Tree
major_levels <- c('one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty')

edu_tree_data <- edu_data%>%
  select(is_move, major, age, female, race, lninc, match_type, match_num, matched, major0, major1, major2, major3, major4, major5, major6, major7, major8, major9, major10, major11, major12, major13, major14, major15, major16, major17, major18, major19)%>%
  mutate(is_move = as.factor(is_move),
         # is_move = factor(is_move, levels = 0:1, labels = c('Not-moved', "Moved")),
         # major = factor(major, levels = 0:19, labels = major_levels),
         # major = as.factor(major),
         female = as.factor(female),
         race = as.factor(race),
         matched = factor(matched, levels = 0:1, labels = c('Not-match', 'Match')),
         match_type = factor(match_type, labels=c('None', 'Sciences', 'Others', 'Social_sciences', 'Sci&oth', 'Sci&soc', 'Oth&soc', 'All')),
         match_num = factor(match_num, levels = 0:3, labels = c('No-match', '1_match', '2_matches', '3_matches')),
         major0 = factor(major0, levels=0:1, labels=c('false', 'true')),
         major1 = factor(major1, levels=0:1, labels=c('false', 'true')),
         major2 = factor(major2, levels=0:1, labels=c('false', 'true')),
         major3 = factor(major3, levels=0:1, labels=c('false', 'true')),
         major4 = factor(major4, levels=0:1, labels=c('false', 'true')),
         major5 = factor(major5, levels=0:1, labels=c('false', 'true')),
         major6 = factor(major6, levels=0:1, labels=c('false', 'true')),
         major7 = factor(major7, levels=0:1, labels=c('false', 'true')),
         major8 = factor(major8, levels=0:1, labels=c('false', 'true')),
         major9 = factor(major9, levels=0:1, labels=c('false', 'true')),
         major10 = factor(major10, levels=0:1, labels=c('false', 'true')),
         major11 = factor(major11, levels=0:1, labels=c('false', 'true')),
         major12 = factor(major12, levels=0:1, labels=c('false', 'true')),
         major13 = factor(major13, levels=0:1, labels=c('false', 'true')),
         major14 = factor(major14, levels=0:1, labels=c('false', 'true')),
         major15 = factor(major15, levels=0:1, labels=c('false', 'true')),
         major16 = factor(major16, levels=0:1, labels=c('false', 'true')),
         major17 = factor(major17, levels=0:1, labels=c('false', 'true')),
         major18 = factor(major18, levels=0:1, labels=c('false', 'true')),
         major19 = factor(major19, levels=0:1, labels=c('false', 'true'))
         )

mod_tree <- tree(match_type ~ major0+major1+major2+major3+major4+major5+major6+major7+major8+major9+major10+major11+major12+major13+major14+major15+major16+major17+major18+major19, data = edu_tree_data,
                  control = tree.control(nobs = nrow(edu_tree_data),
                                         mindev = 0))
# mod <- prune.tree(mod_tree, best = 9)
mod <- mod_tree

# plot tree
tree_data <- dendro_data(mod)
ggplot(segment(tree_data)) +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend), 
               alpha = 0.5) +
  geom_text(data = label(tree_data), 
            aes(x = x, y = y, label = label_full), vjust = -0.5, size = 3) +
  geom_text(data = leaf_label(tree_data), 
            aes(x = x, y = y, label = label), vjust = 0.5, size = 3) +
  theme_dendro() +
  labs(title = "College Major Classification Tree: Unpruned",
       subtitle = "By Major-Job Match Type")


### Find the optimal number of nodes
# generate 10-fold CV trees
edu_cv <- crossv_kfold(edu_tree_data, k = 20) %>%
  mutate(tree = map(train, ~ tree(match_type ~ major0+major1+major2+major3+major4+major5+major6+major7+major8+major9+major10+major11+major12+major13+major14+major15+major16+major17+major18+major19, data = .,
                                  control = tree.control(nobs = nrow(edu_tree_data),
                                                         mindev = 0))))

# calculate each possible prune result for each fold
edu_cv <- expand.grid(edu_cv$.id, 2:20) %>%
  as_tibble() %>%
  mutate(Var2 = as.numeric(Var2)) %>%
  rename(.id = Var1,
         k = Var2) %>%
  left_join(edu_cv) %>%
  mutate(prune = map2(tree, k, ~ prune.tree(.x, best = .y)),
         mse = map2_dbl(prune, test, err.rate.tree))

edu_cv %>%
  select(k, mse) %>%
  group_by(k) %>%
  summarize(test_mse = mean(mse),
            sd = sd(mse, na.rm = TRUE)) %>%
  ggplot(aes(k, test_mse)) +
  geom_point() +
  geom_line() +
  labs(title = "College Major Classification",
       subtitle = "20-fold Cross-Validation for Optimal Number of Nodes",
       x = "Number of terminal nodes",
       y = "Test Error Rate")
### End

mod2 <- prune.tree(mod_tree, best = 9)

tree_data2 <- dendro_data(mod2)
ggplot(segment(tree_data2)) +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend), 
               alpha = 0.5) +
  geom_text(data = label(tree_data2), 
            aes(x = x, y = y, label = label_full), vjust = -0.5, size = 3) +
  geom_text(data = leaf_label(tree_data2), 
            aes(x = x, y = y, label = label), vjust = 0.5, size = 3) +
  theme_dendro() +
  labs(title = "College Major Classification Tree: 9 Terminal Nodes",
       subtitle = "By Major-Job Match Type")

#####

##### Regression Tree #####
edu_data2 <- read.csv("data2.csv")
edu_tree_data2 <- edu_data2%>%
  select(is_move, age, race, female, married, major, lninc, major_ctgy, major_sci, major_oth, major_soc, asian_1, black_1, hispanic_1, fedu, medu)%>%
  na.omit()%>%
  mutate(is_move = factor(is_move, levels=0:1, labels=c('Not-moved', 'Moved')),
         female = factor(female, levels=0:1, labels=c('Male', 'Female')),
         Asian = factor(asian_1, levels=0:1, labels=c('false', 'true')),
         black = factor(black_1, levels=0:1, labels=c('false', 'true')),
         Hispanic = factor(hispanic_1, levels=0:1, labels=c('false', 'true')),
         major_sci = factor(major_sci, levels=0:1, labels=c('false', 'true')),
         major_oth = factor(major_oth, levels=0:1, labels=c('false', 'true')),
         major_soc = factor(major_soc, levels=0:1, labels=c('false', 'true')),
         relationship = factor(married, levels=0:1, labels=c('false', 'true')))
         # race = factor(race, levels=0:3, labels=c('Other', 'Asian', 'Black', 'Hispanic')),
         # race = as.character(race),
         # major_ctgy = factor(major_ctgy, levels=0:2, labels=c('Soc', 'Sci', 'Oth')))

# estimate model: single predictor
edu_tree <- tree(is_move ~ major_sci + major_oth + major_soc, data = edu_tree_data2,
                  control = tree.control(nobs = nrow(edu_tree_data2),
                                         mindev = 0))

# mod3 <- prune.tree(edu_tree, best = 5)
mod3 <- edu_tree

# plot tree
tree_data3 <- dendro_data(mod3)
ptree <- ggplot(segment(tree_data3)) +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend), 
               alpha = 0.5) +
  geom_text(data = label(tree_data3), 
            aes(x = x, y = y, label = label_full), vjust = -0.5, size = 3) +
  geom_text(data = leaf_label(tree_data3), 
            aes(x = x, y = y, label = label), vjust = 0.5, size = 3) +
  theme_dendro()+
  labs(title = "Geographical Mobility Tree: Single Predictor (All Nodes)",
       subtitle = "By Major Types")
ptree

# Tree model: 4 (Multiple predictors)
edu_tree2 <- tree(is_move ~ age + female + relationship + Asian + black + Hispanic + major_sci + major_oth + major_soc, data = edu_tree_data2,
                 control = tree.control(nobs = nrow(edu_tree_data2),
                                        mindev = 0))

# Regression Tree 3:
mod5 <- edu_tree2
# plot tree
tree_data5 <- dendro_data(mod5)
ptree3 <- ggplot(segment(tree_data5)) +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend), 
               alpha = 0.5) +
  geom_text(data = label(tree_data5), 
            aes(x = x, y = y, label = label_full), vjust = -0.5, size = 3) +
  geom_text(data = leaf_label(tree_data5), 
            aes(x = x, y = y, label = label), vjust = 0.5, size = 3) +
  theme_dendro()+
  labs(title = "Geographical Mobility Tree: Multiple Predictors (All Nodes)",
       subtitle = "By Age + Gender + Relationship + Race + Major")
ptree3

### Find the optimal number of nodes ###
# generate 10-fold CV trees
edu_cv2 <- crossv_kfold(edu_tree_data2, k = 10) %>%
  mutate(tree = map(train, ~ tree(is_move ~ age + female + relationship + Asian + black + Hispanic + major_sci + major_oth + major_soc, data = .,
                                  control = tree.control(nobs = nrow(edu_tree_data2),
                                                         mindev = 0))))

# calculate each possible prune result for each fold
edu_cv2 <- expand.grid(edu_cv2$.id, 2:10) %>%
  as_tibble() %>%
  mutate(Var2 = as.numeric(Var2)) %>%
  rename(.id = Var1,
         k = Var2) %>%
  left_join(edu_cv2) %>%
  mutate(prune = map2(tree, k, ~ prune.tree(.x, best = .y)),
         mse = map2_dbl(prune, test, err.rate.tree))

edu_cv2 %>%
  select(k, mse) %>%
  group_by(k) %>%
  summarize(test_mse = mean(mse),
            sd = sd(mse, na.rm = TRUE)) %>%
  ggplot(aes(k, test_mse)) +
  geom_line(color='blue', size=1.2) +
  geom_point(size=1.2) +
  labs(title="Regression Tree with Multiple Predictors",
       subtitle="10-fold Cross-Validation for Optimal Number of Nodes",
       x = "Number of terminal nodes",
       y = "Test Error Rate")
### End ###

mod4 <- prune.tree(edu_tree2, best = 9)

# plot tree
tree_data4 <- dendro_data(mod4)
ptree2 <- ggplot(segment(tree_data4)) +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend), 
               alpha = 0.5) +
  geom_text(data = label(tree_data4), 
            aes(x = x, y = y, label = label_full), vjust = -0.5, size = 3) +
  geom_text(data = leaf_label(tree_data4), 
            aes(x = x, y = y, label = label), vjust = 0.5, size = 3) +
  theme_dendro()+
  labs(title = "Geographical Mobility Tree: Multiple Predictors (Optimal: 9 Nodes)",
       subtitle = "By Age + Gender + Relationship + Race + Major_Types")
ptree2

ptree3