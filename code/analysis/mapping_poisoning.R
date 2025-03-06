source('housekeeping.R')
source(file.path(build_dir,'clean_data.R'))

# Filtering for years 2018-2022
poison_2018_2022 <- poisoning_screening_clean %>%
  filter(Year == "2018-2022") %>%
  mutate(GEOID = Location) %>%
  mutate(GEOID = substr(GEOID, 1, nchar(GEOID) - 1))

# census_api_key("your_census_api_key", install = TRUE, overwrite = TRUE) # Need to input your own census api key here

# Retrieve Lewiston, ME boundaries (tract-level data)

tract_outcomes <- get_decennial(geography = "tract", 
                                variables = ("H034002"),
                                year = 2000, 
                                sumfile = "sf3",
                                state = "ME", 
                                geometry = TRUE)

tract_outcomes <- get_acs(
  geography = "tract",
  state = "ME",
  county = "Androscoggin",  # Specify the county for Lewiston and Auburn
  variables = "B19013_001", # Median household income as an example
  geometry = TRUE
)

# Now merge, keeping geometry
merged_poison_2018_2022 <- merge(poison_2018_2022, tract_outcomes, by = "GEOID", all.x = TRUE)

merged_poison_2018_2022 <- merge(poison_2018_2022, tract_outcomes, by = "GEOID")

base_map <- readRDS("data/work/lewiston_auburn_map.rds")

merged_poison_2018_2022 <- st_as_sf(merged_poison_2018_2022)

# Proportion Map
poison_map_prop <- ggmap(base_map) +
  geom_sf(data = merged_poison_2018_2022, 
          aes(fill = Proportion_Poisoned), 
          color = "black", alpha = 0.5, inherit.aes = FALSE) + 
  scale_fill_gradient(low = "white", high = "red",
                      name = "Percent Positive Poison Test") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom"
  ) +
  labs(
    title = "Lead Poisoning in Lewiston/Auburn",
    subtitle = "By Percentage of Positive Tests"
  )

ggsave(
  filename = "output/Proportion_Map_Lead_Poisoning.png"  # Save the file
)

poison_map_prop

# Cases Map
poison_map_cases <- ggmap(base_map) +
  geom_sf(data = merged_poison_2018_2022, 
          aes(fill = Positive), 
          color = "black", alpha = 0.5, inherit.aes = FALSE) + 
  scale_fill_gradient(low = "white", high = "red",
                      name = "Number of Poisoned Cases") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom"
  ) +
  labs(
    title = "Lead Poisoning in Lewiston/Auburn",
    subtitle = "By Total Cases"
  )

# Display the map
poison_map_cases
ggsave("output/Case_Map_Lead_Poisoning.png")
