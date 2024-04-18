# Once data has been dowloaded the .nc files can be accessed in R and synthesised into a project specific data package
# 
library(ncdf4) # package for netcdf manipulation
library(processNC)
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting

# Example - Load and view data
tas_data_2001 <- ncdf4::nc_open('./downloads/gswp3-w5e5_obsclim_tas_lat49.0to61.3lon-12.0to9.0_daily_2001_2010.nc')
print(tas_data_2001)

# Example - Load a second source and compare dimensions
tasmin_data_2001 <- ncdf4::nc_open('./downloads/gswp3-w5e5_obsclim_tasmax_lat49.0to61.3lon-12.0to9.0_daily_2001_2010.nc')
# use the base::identical function to compare lon, lat and time to confirm that these two files have the same geo-temporal size and shape
base::identical(ncdf4::ncvar_get(tas_data_2001,'lon'),ncdf4::ncvar_get(tasmin_data_2001,'lon'))
base::identical(ncdf4::ncvar_get(tas_data_2001,'lat'),ncdf4::ncvar_get(tasmin_data_2001,'lat'))
base::identical(ncdf4::ncvar_get(tas_data_2001,'time'),ncdf4::ncvar_get(tasmin_data_2001,'time'))

# Example - Load more data and combine tas, tasmin and tasmax, 2001 through to 2019 into a single source
tasmax_data_2001 <- ncdf4::nc_open('./downloads/gswp3-w5e5_obsclim_tasmin_lat49.0to61.3lon-12.0to9.0_daily_2001_2010.nc')
tas_data_2011 <- ncdf4::nc_open('./downloads/gswp3-w5e5_obsclim_tas_lat49.0to61.3lon-12.0to9.0_daily_2011_2019.nc')
tasmin_data_2011 <- ncdf4::nc_open('./downloads/gswp3-w5e5_obsclim_tasmax_lat49.0to61.3lon-12.0to9.0_daily_2011_2019.nc')
tasmax_data_2011 <- ncdf4::nc_open('./downloads/gswp3-w5e5_obsclim_tasmin_lat49.0to61.3lon-12.0to9.0_daily_2011_2019.nc')

