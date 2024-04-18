# Climate data from ISIMIP is openly available from isimip.org
# There are a number of modelled output available, we are interested in creating a pipeline to gather the 
# forecast air temperature data (tas, tasmin, tasmax) relevant to our Environment Agency and Marine Directorate
# informed river systems to perform a similar function as they are used in Rinaldo et al 2023 DOI: 10.1111/jfb.15603

# ISIMIP3b holds the forecast data, whilst ISIMIP3a holds the historical data that Rinaldo et al trained their 
# water temperature model on.
# Rinaldo et al use forecasts GFDL-ESM4, IPSL-CM6A-LR, MPI-ESM1-2-HR, MRI-ESM2-0, and UKESM1-0-LL
# they use the forecast air temperatures in their trained model to derive water temperature, then they take
# an 'ensemble mean' from these to determine a single number of CGDD (growth degree day) for each cohort 
# from 2021 to 2098

# There is an API available to search the ISIMIP data, and possibly download subsets of the target datasets
# 
# Data used by Rinaldo et al is described in the supplementary information in detail
# jfb15603-sup-0001-supinfo1.zip.54f/S1a.pdf and jfb15603-sup-0001-supinfo1.zip.54f/S1b.pdf found via the above DOI
# 
# ISIMIP data is served as NETCDF4 (.nc) files which require the R netcdf package to open and explore
# ISIMIP files are large and so usually grouped in time steps
# The download process to select the appropriate time steps that overlap years of interest




# Prepare libraries
library(dplyr)
library(httr)
library(jsonlite)

# interogate ISIMIP API
data_url = "https://data.isimip.org/api/v1/datasets/"
file_url = "https://data.isimip.org/api/v1/files/"
# example
res <- httr::GET(url = data_url,
  query = list(simulation_round='ISIMIP3a',
    product='InputData',
    climate_forcing='gswp3-w5e5',
    climate_scenario='obsclim',
    climate_variable='pr'))
res_content <- jsonlite::fromJSON(base::rawToChar(res$content))
res_content

# From here it is not clear how to initiate a masking procedure via R, so I have moved on to using the python isimip-client
# to facilitate a reproducible download pathway. See download_script.py