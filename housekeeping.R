# ---------------------------------------------------------------------------------------------
#File: housekeeping.R
#By: "Zach Richards, Damien DiGiovine, Tong Ning, Jessie Ye, and Bravo Nie"
#Date: "`r format(Sys.time(), '%d %B, %Y')`"
# Description: This file installs and loads packages. It also defines the file paths. Run it 
# before running any other files. In fact, include it all files you run.
# ---------------------------------------------------------------------------------------------


if (!requireNamespace("pacman", quietly =TRUE)) install.packages("pacman")
pacman::p_load(tidyverse,janitor,tidygeocoder, readxl, tidycensus, sf, ggplot2, dplyr, ggmap, fixest, broom, gridExtra,png,grid)


# Include any other folders you may want
# Directory objects
# Create directories
data_dir <- file.path('data')
raw_dir <- file.path(data_dir,'raw')
work_dir <- file.path(data_dir,'work')
output_dir <- file.path('output')
code_dir <- file.path('code')
build_dir <- file.path(code_dir,'build')
analysis_dir <- file.path(code_dir,'analysis')
documentation_dir <- file.path('documentation')
literature_dir <- file.path('literature')

# Create directories
suppressWarnings({
  dir.create(data_dir)
  dir.create(raw_dir)
  dir.create(work_dir)
  dir.create(documentation_dir)
  dir.create(code_dir)
  dir.create(build_dir)
  dir.create(analysis_dir)
  dir.create(literature_dir)
  dir.create(output_dir)
})


# Create .placeholder's in each folder, these ensure that the folders are included in the git repository
# Git does not track empty folders, so we need to create a file in each folder to ensure that the folder
# is pushed

suppressWarnings({
  for (dir in c(raw_dir,work_dir,build_dir,analysis_dir,documentation_dir,literature_dir)){
    # If file created, it prints "TRUE"
    file.create(file.path(dir,'.placeholder'),
      showWarnings=FALSE)
  }
}
)
