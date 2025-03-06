source('housekeeping.R')

# This file reads in the lead abatement addresses and geocodes them to various levels of granularity including census block groups, tracts, and counties.
# This could also be applied to other addresses in the future.

abatement_addresses <-readxl::read_excel('data/raw/LeadAbatementSummaryLewiston2002-2024.xlsx',skip=3,n_max=270,sheet='ABATEMENT SUMMARY') %>%
    janitor::clean_names() 

# Read more about the geocder used below here: https://jessecambon.github.io/tidygeocoder/articles/geocoder_services.html
# It works with a census API here: https://www.census.gov/programs-surveys/geography/technical-documentation/complete-technical-documentation/census-geocoder.html 
# Geocoding works well -- only 2 NAs. One is at Bates. The other is an ambiguous address. 

geocoding <- abatement_addresses %>%
    select(lewiston_address) %>%
    distinct() %>%
    mutate(city='Lewiston',state='ME',state='ME',postalcode='04240') %>%
    tidygeocoder::geocode(street=lewiston_address,city=city,state=state,postalcode=postalcode,
        method='census',
        api_options=list(census_return_type='geographies'),
        full_results=TRUE,flatten=TRUE) %>%
    janitor::clean_names() 

# The geocoder returns census tracts and blocks, but not block groups, so I use the explanation of 15-digit census GEOIDs (https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html) to create block groups from the block data. 
# Here's the breakdown:
# 2-digit state code + 3-digit county fips + 6-digit census tract + 1-digit block group + 3-digit block = 15-digit GEOID
# I just need to keep the first digit of the census block and combine the rest to create a 12-digit GEOID for the block group
geocoding_with_block_group <- geocoding %>%
    mutate(block_group=substr(census_block,1,1)) %>%
    mutate(geoid=paste0(state_fips,county_fips,census_tract,block_group)) 

# combine
abatement_addresses_geocoded <- abatement_addresses %>%
    left_join(geocoding_with_block_group)

write_csv(abatement_addresses_geocoded, file = file.path(work_dir, 'abatement_addresses_geocoded.csv'))