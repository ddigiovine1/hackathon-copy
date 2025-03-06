source('housekeeping.R')
source(file.path(build_dir, 'geocode_lead_addresses.R'))

#import 2002-2024 Lewiston lead abatement summary with geocodes
abatement_addresses_geocoded <- read_csv("data/work/abatement_addresses_geocoded.csv")

abatement_addresses_geocoded_clean <- abatement_addresses_geocoded %>%
                      mutate(l_a_grant = replace(l_a_grant, is.na(l_a_grant), 0)) %>%
                      mutate(housing_units = replace(housing_units, is.na(housing_units), 0))



#import pre-1978 housing data
pre_1978_housing <- read_excel("data/raw/LeadAbatementSummaryLewiston2002-2024.xlsx", 
                                                    sheet = "Pre-1978 Housing-Assessor Rec",
                                                    range = "A1:Q7139")


#import and clean 10/25/2034 LA block group risk factors
risk_factors <- read_excel("data/raw/Auburn-Lewiston - block group Risk Factors - export 10-25-2024.xlsx",
                           range = "A3:Q61")

risk_factors_clean <- risk_factors %>%
                        rename(c('Total_Families_PA' = 'Total Families...3', 'Number_PA' = 'Number...4', 'Percent_PA' = 'Percent...5'), 'Total_Families_PC' = 'Total Families...6', 'Number_PC' = 'Number...7', 'Percent_PC' = 'Percent...8', 'Total_Occupied_All' = 'Total Occupied Units...9', 'Number_All' = 'Number...10', 'Percent_All' = 'Percent...11', 'Total_Occupied_Own' = 'Total Occupied Units...12', 'Number_Own' = 'Number...13', 'Percent_Own' = 'Percent...14','Total_Occupied_Rent' = 'Total Occupied Units...15', 'Number_Rent' = 'Number...16', 'Percent_Rent' = 'Percent...17')


#import and clean 10/25/2034 LA block group poisoning screening
poisoning_screening <- read_excel("data/raw/Auburn-Lewiston - block group Poisoning-Screening - export 10-25-2024.xlsx",
                                  range = "A3:D174")

#changes column names and changes all values of 1-5 to 3 in order to allow analysis with numeric variables
poisoning_screening_clean <- poisoning_screening %>%
                              rename(c('Positive' = '0-<36...3', 'Tested' = '0-<36...4')) %>%
                              mutate(across(everything(), ~ ifelse(. == "1-5", "3", .))) %>%
                              mutate(Positive = as.numeric(Positive), Tested = as.numeric(Tested)) %>%
                              mutate(Proportion_Poisoned = Positive/Tested)


