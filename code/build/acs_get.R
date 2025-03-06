source('housekeeping.R')

#census_api_key("your_census_api_key", install = TRUE, overwrite = TRUE) #Need to insert your census api key in this line

# Retrieve Lewiston, ME boundaries (tract-level data)
lewiston_auburn <- get_acs(
  geography = "place",
  state = "ME",
  variables = "B19013_001", # Median household income as an example
  geometry = TRUE
) %>%
  filter(NAME %in% c("Lewiston city, Maine", "Auburn city, Maine"))



write.csv(lewiston_auburn, "data/work/lewiston_acs_data.csv", row.names = FALSE)
#!!! you can choose to read this csv while u need to clean the data for me, or you can call the 'lewiston' object in environment.