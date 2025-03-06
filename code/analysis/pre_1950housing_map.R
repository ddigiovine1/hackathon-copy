source('housekeeping.R')

# Load the Lewiston-Auburn map
base_map <- readRDS("data/work/lewiston_auburn_map.rds")

# Load the geocoded data
pre_1978_geocoded <- read.csv("data/work/pre_1978_geocoded.csv")

pre_1950 <- pre_1978_geocoded[pre_1978_geocoded$year_built < 1950, ]

# Filter out rows with missing lat/long and houses built before 1978
pre_1950_filtered <- pre_1950 %>%
  filter(!is.na(lat) & !is.na(long) & year_built < 1978)

pre_1950_filtered <- pre_1950_filtered %>%
  filter(city.x == 'LEWISTON') %>%
  mutate(long = long + 0.027) %>% # Accounts for mismatched base map coordinates from different sources
  mutate(lat = lat - 0.019) %>% # Accounts for mismatched base map coordinates from different sources
  filter(lat <= 44.126 & lat >= 44.037) %>%
  filter(long >= -70.21 & long <= -70.128) #%>%
  #filter(grepl("SABATTUS ST|MAIN ST|COLLEGE ST|ASH ST|HOLLAND ST|RUSSELL ST" , matched_address, ignore.case = TRUE)) # Used the housing on these streets as reference points to line up longitude and latitude with the base map

  

# Convert the filtered data to an sf object
pre_1950_sf <- st_as_sf(
  pre_1950_filtered,
  coords = c("long", "lat"),
  crs = 4326 # WGS84 CRS
)

# Transform to match Web Mercator CRS used by the map
pre_1950_sf <- st_transform(pre_1950_sf, crs = st_crs(3857))

# Convert base_map to a raster
base_map_raster <- as.raster(base_map)

# Plot using annotation_custom() to overlay base_map as a raster
housing_map <- ggplot() +
  annotation_custom(
    rasterGrob(base_map_raster, interpolate = TRUE),
    xmin = -7817062, xmax = -7806281, ymin = 5467033, ymax = 5488942
  ) +
  geom_sf(data = pre_1950_sf, color = "red", size = 0.5, inherit.aes = FALSE) +
  scale_x_continuous(breaks = seq(-70.20, -70.13, by = 0.02)) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", color = "black"),
    plot.subtitle = element_text(size = 12, color = "black"),
    panel.background = element_rect(fill = "white", color = NA), # White panel background
    plot.background = element_rect(fill = "white", color = NA),  # White plot background
    panel.grid = element_line(color = "grey80"),                 # Light grey grid lines
    legend.position = "none"
  ) +
  labs(
    title = "Pre-1950 Housing Units",
    subtitle = "Dots are houses built before 1950"
  )

# Save the map
ggsave(
  filename = "output/pre_1950_housing_red_dots_map.png",
  plot = housing_map,
  width = 8,
  height = 6,
  dpi = 300
)

housing_map
