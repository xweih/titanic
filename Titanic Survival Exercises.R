options(digits = 3)    # report 3 significant digits
library(tidyverse)
library(titanic)

titanic <- titanic_train %>%
  select(Survived, Pclass, Sex, Age, SibSp, Parch, Fare) %>%
  mutate(Survived = factor(Survived),
         Pclass = factor(Pclass),
         Sex = factor(Sex))

# Q1
str(titanic)

# Q2

titanic %>% group_by(Sex) %>%
  ggplot(aes(Age, color = Sex)) +
  geom_density()
  
titanic %>% group_by(Sex) %>%
  filter(Age==40) %>%
  count()

titanic %>% group_by(Sex) %>%
  filter(Age>=18 & Age <=35) %>%
  count()

proportions_1835 <- c(133/314, 251/577)

titanic %>% group_by(Sex) %>%
  filter(Age<17) %>%
  count()

proportions_17 <- c(49/314, 51/577)

max(titanic$Age, na.rm=T)

# The oldest passengers were female?
titanic[which.max(titanic$Age),]

# Question 3: QQ-plot of Age Distribution

params <- titanic %>%
  filter(!is.na(Age)) %>%
  summarize(mean = mean(Age), sd = sd(Age))

titanic |> filter(!is.na(Age)) |>
  ggplot(aes(sample = Age)) +
  geom_qq(dparams = params) +
  geom_qq_line(dparams = params)

titanic |> filter(!is.na(Age)) |>
  ggplot(aes(sample = Age)) +
  geom_qq() +
  geom_qq_line()

# Question 4: Survival by Sex

titanic |> filter(Survived == 1) |>
  ggplot(aes(Survived, fill = Sex)) + geom_bar()

titanic |> group_by(Sex) |>
  ggplot(aes(Survived, fill = Sex)) + geom_bar()

# ggplot(aes(Survived, fill = Sex)) + geom_bar()


# Question 5: Survival by Age -- redo

# Make a density plot of age filled by survival status. Change the y-axis to count and set alpha = 0.2.

# Which age group is the only group more likely to survive than die?
# Which age group had the most deaths?
titanic |> filter(!is.na(Age) & !is.na(Survived)) |> 
  ggplot(aes(x=Age, y=after_stat(count), fill= Survived)) + 
  geom_density(alpha = 0.2) +
  labs(y="Count")

# Which age group had the highest proportion of deaths?                  
titanic |> filter(!is.na(Age) & !is.na(Survived)) |> 
  ggplot(aes(x=Age, y=after_stat(count / sum(n[!duplicated(group)])), color= Survived)) + 
  geom_density(alpha = 0.2)
                  

#Question 6: Survival by Fare

titanic %>% filter(Fare != 0) %>%
  ggplot(aes(Fare, Survived)) +
  geom_boxplot() +
  geom_jitter() + 
  scale_x_continuous(trans = "log2")


# Question 7: Survival by Passenger Class

titanic %>% ggplot(aes(x=Pclass, y=after_stat(count), fill= Survived)) + 
  geom_bar()

titanic %>% ggplot(aes(x=Pclass, y=after_stat(count), fill= Survived)) +
  geom_bar(position = "fill") +
  labs(y="Proportion")

titanic %>% ggplot(aes(x=Survived, y=after_stat(count), fill= Pclass)) +
  geom_bar(position = "fill") +
  labs(y="Proportion")


# Question 8: Survival by Age, Sex and Passenger Class

# Create a grid of density plots for age, filled by survival status, with count on the y-axis, faceted by sex and passenger class.

titanic %>% 
  ggplot(aes(x=Age, y=after_stat(count), fill=Survived)) +
  geom_density() +
  facet_grid(Sex ~ Pclass)
