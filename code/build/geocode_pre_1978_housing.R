source('housekeeping.R')

# This file reads in the lead abatement addresses and geocodes them to various levels of granularity including census block groups, tracts, and counties.
# This could also be applied to other addresses in the future.

# Step 1: Load the "Pre-1978 Housing-Assessor Rec" data
pre_1978_data <- readxl::read_excel(
  'data/raw/LeadAbatementSummaryLewiston2002-2024.xlsx',
  sheet = 'Pre-1978 Housing-Assessor Rec'
) %>%
  janitor::clean_names()

# Step 2: Extract unique addresses for geocoding
pre_1978_addresses <- pre_1978_data %>%
  select(mailing_address_1) %>% 
  distinct() %>%
  mutate(
    city = "Lewiston",
    state = "ME",
    postalcode = "04240"
  )

# Step 3: Geocode the addresses using the Census API
pre_1978_geocoded <- pre_1978_addresses %>%
  tidygeocoder::geocode(
    street = mailing_address_1,
    city = city,
    state = state,
    postalcode = postalcode,
    method = 'census', # Switch to OpenStreetMap
    full_results = TRUE,
    flatten = TRUE
  ) %>%
  janitor::clean_names()

# Step 5: Join geocoded results back to the "Pre-1978 Housing-Assessor Rec" data
pre_1978_mapped <- pre_1978_data %>%
  left_join(pre_1978_geocoded, by = c("mailing_address_1" = "mailing_address_1"))

pre_1978_mapped <- pre_1978_mapped %>%
  mutate(boundingbox = sapply(boundingbox, function(x) paste(x, collapse = ", ")))

# Step 6: Save the combined dataset for mapping
write.csv(pre_1978_mapped, file = file.path(work_dir,"pre_1978_geocoded.csv"))