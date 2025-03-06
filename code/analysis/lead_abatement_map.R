source('housekeeping.R')
source(file.path(build_dir,'acs_get.R'))

abatement_data <- read.csv("data/work/abatement_addresses_geocoded.csv")
acs_data <- lewiston_auburn
base_map <- readRDS("data/work/lewiston_auburn_map.rds")

# Filter data for completed projects
completed_projects <- abatement_data %>%
  filter(!is.na(lat) & !is.na(long)) # Ensure geocoded coordinates exist

acs_sf <- st_as_sf(acs_data, wkt = "geometry", crs = 4326)

# Step 2: Convert completed projects data to spatial format
completed_sf <- st_as_sf(completed_projects, coords = c("long", "lat"), crs = 4326)
# Ensure CRS consistency
completed_sf <- st_transform(completed_sf, crs = st_crs(acs_sf))

# Step 3: Join ACS boundaries with completed projects
area_with_projects <- st_join(acs_sf, completed_sf, left = TRUE)
#uncompleted_area
uncompleted_sf <- area_with_projects %>% 
  filter(is.na(GEOID)) 

# Step 4: Plot the data
lead_abatement_map <- ggmap(base_map) +
  geom_sf(data = acs_sf, fill = "grey90", color = "black", alpha = 0.5, inherit.aes = FALSE) + # ACS boundaries
  geom_sf(data = completed_sf, aes(color = "Completed"), size = 0.1, inherit.aes = FALSE) + # Completed projects
  geom_sf(data = uncompleted_sf, size = 2, shape = 21, fill = "red", stroke = 0.5, inherit.aes = FALSE) + # Uncompleted areas
  scale_color_manual(
    values = c("Completed" = "blue"),
    name = "Project Status"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom"
  ) +
  labs(
    title = "Lead Abatement Projects",
    subtitle = "Blue Dot: Completed Projects",
    color = "Project Status"
  ) +
  coord_sf() # Align coordinate systems

#save
ggsave(
  filename = "output/lead_abatement_map.png", # File name with desired format
  plot = lead_abatement_map,                  # Use the last plotted ggplot object
  width = 8,                           # Width in inches
  height = 6,                          # Height in inches
  dpi = 300                            # Resolution (dots per inch)
)
