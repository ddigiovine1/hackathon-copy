# Lewiston Hack-a-thon of Group 2 by Damien, Zach, Tong, Jessie and Bravo

About the project

In this read-me, you can read through and find out what you will need for this project to replicate our work.

This project was done by Damien Digiovine, Zach Richards, Tong Ning, Jessie Ye and Bravo Nie. We are all from Bates College and this project belongs to our team, the Economics Department of Bates College and Professor Kyle Coombs.

In this project, we evaluated the effectiveness of lead abatement in the Lewiston/Auburn area by analysing data from the Maine Tracking Network and Central Maine Tracking. We also used maps to visualise some key data to reflect the overall lead poisoning situation. Finally, we provide a presentation with our advice including benefit cost analysis.

By replicating our work, you would have a general idea of how lead poisoning affects the entire Lewiston/Auburn area and whether Lewiston has targeted its lead reduction efforts appropriately.

# Requirements

Before starting the project, you need to make sure your Rstudio version is RStudio 2024.04.2+764 "Chocolate Cosmos". Also for this project, we are using packages including tidyverse,janitor,tidygeocoder, readxl, tidycensus, tidyverse, sf, ggplot2, dplyr, ggmap, fixest, broom, gridExtra, png and grid. You can run this line

```         
  if (!requireNamespace("pacman", quietly =TRUE)) install.packages("pacman")
pacman::p_load(tidyverse,janitor,tidygeocoder, readxl, tidycensus, tidyverse, sf, ggplot2, dplyr, ggmap, fixest, broom, gridExtra,png,grid)
```

to ensure you install the enough packages and then there will be no issues running this whole project.

To match the lead abatement addresses to the census block group data, you will need to geocode the addresses to blocks. I have provided a script to do this in the `code` folder called `geocode_lead_addresses.R`. This script uses the `tidygeocoder` package to geocode the addresses and requires a Census API key. You can get a Census API key [here](https://api.census.gov/data/key_signup.html) if you have not already!

*Note: Census block groups are smaller than Census tracts, but larger than census blocks.*

# Getting started Now, we can start the whole project!

In the main folder, we have a Rmarkdown file name: 'Hackathon'. In the file and below, you can step by step run the each code file and get full outcome of our work.

1.  Housekeeping

Housekeeping file to set up directories and load packages

```{r housekeeping}
source('housekeeping.R')
```

-   Part 1

Code to clean datasets and merge them for use

```{r cleaning}
source(file.path(build_dir, 'clean_data.R'))
```

2.  Get acs

```{r acs data}
source(file.path(build_dir, 'acs_get.R'))
```

3.  Geocoding pre-1978 housing

```{r geocoding data}
source(file.path(build_dir, 'geocode_lead_addresses.R'))
```

```{r geocoding housing}
source(file.path(build_dir, 'geocode_pre_1978_housing.R'))
```

4.  Fetching map

```{r map fetch}
source(file.path(build_dir, 'map_fetch.R'))
```

5.  Making Map

```{r map making-pre 1950}
source(file.path(analysis_dir, 'pre_1950housing_map.R'))
```

```{r map lead abatement}
source(file.path(analysis_dir, 'lead_abatement_map.R'))
```

6.  Regression

```{r map regression_poisoning}
source(file.path(analysis_dir, 'poisoning_regressions.R'))
```

7.  Poisoning and its plot

```{r map lead poisoning over time}
source(file.path(analysis_dir, 'lead_poisoning_over_time.R'))
```

```{r map lead poisoning over time2}
source(file.path(analysis_dir, 'mapping_poisioning.R'))
```

## Notice

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star! Thanks again!

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

### Contributors contact:

Bravo Nie: [ynie\@bates.edu](mailto:ynie@bates.edu){.email} \\ Damien Digiovine: [ddigiovine\@bates.edu](mailto:ddigiovine@bates.edu){.email} \\ Zach Richards: [zrichards\@bates.edu](mailto:zrichards@bates.edu){.email} \\ Tong Ning: [tning\@bates.edu](mailto:tning@bates.edu){.email} \\ Liujun Ye: [lye\@bates.edu](mailto:lye@bates.edu){.email}

# Codespace

This repository contains a Docker codespace that can be used to run R from your browser with a pre-configured environment. This is useful if you have trouble setting up your local environment or if you want to work on a Chromebook or other device that does not have R installed. See instructions [here](https://github.com/big-data-and-economics/big-data-class-materials?tab=readme-ov-file#github-codespaces).
