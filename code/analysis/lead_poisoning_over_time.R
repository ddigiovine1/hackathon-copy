source('housekeeping.R')
source(file.path(build_dir, 'clean_data.R'))

average_over_time <- poisoning_screening_clean %>%
  group_by(Year) %>%
  summarize(average_variable = mean(Proportion_Poisoned, na.rm = TRUE))
# Convert Year ranges to midpoints
average_over_time$Year <- c(2010, 2015, 2020)  # Midpoints of the ranges


average_poisoning_graph <- ggplot(average_over_time, aes(x = Year, y = average_variable)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = c(2010, 2015, 2020), labels = c("2008-2012", "2013-2017", "2018-2022")) +
  labs(title = "Trend of Proportion Poisoned Over Time",
       x = "Time Period", y = "Average Proportion")

ggsave(
  filename = "output/average_poisoning_graph.png",
  plot = average_poisoning_graph,
  width = 8,
  height = 6,
  dpi = 300
)
