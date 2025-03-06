source('housekeeping.R')

register_stadiamaps(key = "558cd471-358f-4c34-a1dd-a8aec7f05040", write = TRUE)

map <- get_stadiamap(
  bbox = c(left = -70.25, bottom = 44.05, right = -70.15, top = 44.15),
  zoom = 12,
  maptype = "stamen_toner_lite" # Updated maptype
)

# Plot the map
ggmap(map)

# Save map data as an RDS file for reuse
saveRDS(map, "data/work/lewiston_auburn_map.rds")
