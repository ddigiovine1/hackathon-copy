source('housekeeping.R')
source(file.path(build_dir, 'clean_data.R'))


# Ensure both Year columns are character
poisoning_screening_clean <- poisoning_screening_clean %>%
  mutate(Year = as.character(Year))

risk_factors_clean <- risk_factors_clean %>%
  mutate(Year = as.character(Year))

poisoning_screening_clean$Year <- rep(c(2010, 2015, 2020), length.out = 171)

filtered_poisoning_clean <- poisoning_screening_clean %>%
  filter(Year == "2020")


# Perform the join
merged_data_regression <- filtered_poisoning_clean %>%
  left_join(risk_factors_clean, by = c("Location"))

# View the merged dataset
head(merged_data_regression)

# Run regressions
poverty_model_all <- feols(Proportion_Poisoned ~ Percent_PA, data = merged_data_regression)
poverty_model_child <- feols(Proportion_Poisoned ~ Percent_PC, data = merged_data_regression)
pre1950_housing_model <- feols(Proportion_Poisoned ~ Percent_All, data = merged_data_regression)
poverty_housing_model <- feols(Proportion_Poisoned ~ Percent_PA + Percent_All, data = merged_data_regression)


poverty_model_all_n <- feols(Positive ~ Percent_PA, data = merged_data_regression)
poverty_model_child_n <- feols(Positive ~ Percent_PC, data = merged_data_regression)
pre1950_housing_model_n <- feols(Positive ~ Percent_All, data = merged_data_regression)
poverty_housing_model_n <- feols(Positive ~ Percent_PA + Percent_All, data = merged_data_regression)

# Summary of the regression
summary(poverty_model_all)
summary(poverty_model_child)
summary(pre1950_housing_model)
summary(poverty_housing_model)


summary(poverty_model_all_n)
summary(poverty_model_child_n)
summary(pre1950_housing_model_n)
summary(poverty_housing_model_n)


#1. housing vs. Lead Poisoning w/ poverty color
housing_poisoning_with_poverty_plot <- ggplot(merged_data_regression, aes(x = Percent_All, y = Proportion_Poisoned, colour = Percent_PA)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, col = "red") +
  labs(title = "Pre-1950 Housing vs. Lead Poisoning (Color = Poverty Rates)", x = "Pre-1950 Housing Stock (%)", y = "Lead Poisoning Proportion") +
  theme_minimal()

ggsave(
  filename = "output/Pre-1950_Housing_vs_Lead_Poisoning_Color_Poverty_Rates.png",
  plot = housing_poisoning_with_poverty_plot,
  width = 8,
  height = 6,
  dpi = 300
)


#2. Poverty All vs. Lead Poisoning
poverty_poisoning_plot <- ggplot(merged_data_regression, aes(x = Percent_PA, y = Proportion_Poisoned)) +
  geom_point() +
  geom_smooth(method = "lm", col = "green") +
  labs(title = "All Poverty vs. Lead Poisoning", x = "Poverty (%)", y = "Lead Poisoning Proportion") +
  theme_minimal()

ggsave(
  filename = "output/All_Poverty_vs._Lead_Poisoning.png",
  plot = poverty_poisoning_plot,
  width = 8,
  height = 6,
  dpi = 300
)


#3. Poverty Children vs. Lead Poisoning
poverty_children_poisoning_plot <- ggplot(merged_data_regression, aes(x = Percent_PC, y = Proportion_Poisoned)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, col = "purple") +
  labs(title = "Child Poverty vs. Lead Poisoning", x = "Child Poverty (%)", y = "Lead Poisoning Proportion") +
  theme_minimal()

ggsave(
  filename = "output/Child_Poverty_vs._Lead_Poisoning.png",
  plot = poverty_children_poisoning_plot,
  width = 8,
  height = 6,
  dpi = 300
)


#4. Pre-1950 Housing vs. Lead Poisoning
pre1950housing_poisoning_plot <- ggplot(merged_data_regression, aes(x = Percent_All, y = Proportion_Poisoned)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, col = "orange") +
  labs(title = "Pre-1950 Housing Model vs. Lead Poisoning", x = "Pre-1950 Housing Stock (%)", y = "Lead Poisoning Proportion") +
  theme_minimal()

ggsave(
  filename = "output/Pre-1950_Housing_Model_vs._Lead_Poisoning.png",
  plot = pre1950housing_poisoning_plot,
  width = 8,
  height = 6,
  dpi = 300
)

# Creates coefficient graph with proportions
# Extract coefficients and confidence intervals
model_list <- list(
  Poverty_vs_Lead = poverty_model_all,
  Pre1950_Housing_vs_Lead = pre1950_housing_model,
  Poverty_and_Housing = poverty_housing_model
)

# Create tidy_models with associated degrees of freedom
tidy_models <- lapply(names(model_list), function(model_name) {
  tidy(model_list[[model_name]]) %>%
    mutate(
      Model = model_name,
      df_residual = df.residual(model_list[[model_name]]) # Add degrees of freedom for each model
    )
}) %>%
  bind_rows() %>%
  filter(term != '(Intercept)') %>%
  mutate(
    conf.low = estimate - qt(0.975, df = df_residual) * std.error,
    conf.high = estimate + qt(0.975, df = df_residual) * std.error)

tidy_models <- tidy_models %>%
  mutate(term = recode(term,
                "Percent_PA" = "Poverty (All Ages)",
                "Percent_All" = "Pre-1950 Housing"))


# Plotting the regression coefficients
coefficients_proportion_plot <- ggplot(tidy_models, aes(x = term, y = estimate, color = Model)) +
  geom_point(position = position_dodge(width = 0.5), size = 3) + # Points for coefficients
  geom_errorbar(
    aes(ymin = conf.low, ymax = conf.high),
    width = 0.2,
    position = position_dodge(width = 0.5) # Dodge to avoid overlap
  ) +
  labs(
    title = "Comparison of Regression Coefficients Across Models in Proportion",
    x = "Predictor Variables",
    y = "Proportion Poisoned Coefficient Estimate",
    color = "Model"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels for readability
    legend.position = "bottom"
  )

ggsave(
  filename = "output/Comparison_of_Regression_Coefficients_Across_Models_in_Proportion.png",
  plot = coefficients_proportion_plot,
  width = 8,
  height = 6,
  dpi = 300
)


# Creates coefficient graph with total number
# Extract coefficients and confidence intervals
model_list2 <- list(
  Poverty_vs_Lead = poverty_model_all_n,
  Pre1950_Housing_vs_Lead = pre1950_housing_model_n,
  Poverty_and_Housing = poverty_housing_model_n
)

# Create tidy_models with associated degrees of freedom
tidy_models2 <- lapply(names(model_list2), function(model_name) {
  tidy(model_list2[[model_name]]) %>%
    mutate(
      Model = model_name,
      df_residual = df.residual(model_list2[[model_name]]) # Add degrees of freedom for each model
    )
}) %>%
  bind_rows() %>%
  filter(term != '(Intercept)') %>%
  mutate(
    conf.low = estimate - qt(0.975, df = df_residual) * std.error,
    conf.high = estimate + qt(0.975, df = df_residual) * std.error
  )

tidy_models2 <- tidy_models2 %>%
  mutate(term = recode(term,
                       "Percent_PA" = "Poverty (All Ages)",
                       "Percent_All" = "Pre-1950 Housing"))


# Plotting the regression coefficients
coefficients_number_plot <- ggplot(tidy_models2, aes(x = term, y = estimate, color = Model)) +
  geom_point(position = position_dodge(width = 0.5), size = 3) + # Points for coefficients
  geom_errorbar(
    aes(ymin = conf.low, ymax = conf.high),
    width = 0.2,
    position = position_dodge(width = 0.5) # Dodge to avoid overlap
  ) +
  labs(
    title = "Comparison of Regression Coefficients Across Models in Number",
    x = "Predictor Variables",
    y = "Coefficient Estimate",
    color = "Model"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels for readability
    legend.position = "bottom"
  )

ggsave(
  filename = "output/Comparison_of_Regression_Coefficients_Across_Models_in_Number.png",
  plot = coefficients_number_plot,
  width = 8,
  height = 6,
  dpi = 300
)

