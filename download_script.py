# run reticulate::repl_python() from R prompt to enter Python environment
# attach the required python tools
from isimip_client.client import ISIMIPClient
import requests
# initialise client
client = ISIMIPClient()

# define file list from the API
# requires use of some loops because I don't see how to interogate the API in a slicker way
# list of variables we want (see README.md)
variables = ['tas','tasmax','tasmin','pr','prsn','huss','hurs','sfcwind','rsds','rlds']
# initialise list for file names to pass to mask and download operations later on
file_list = []
# loop through vars and get all file names that have these variables in the appropriate product (see README.md)
for var in variables:
  # get first page of results
  response = client.files(simulation_round='ISIMIP3a',
                           product='InputData',
                           climate_forcing='gswp3-w5e5',
                           climate_scenario='obsclim',
                           climate_variable=var)
  # pass results paths into list
  for dataset in response['results']:
    file_list.append(dataset['path'])
  # get results from following pages if they exist
  while response['next'] != None:
    # get next page of results
    response = client.parse_response(requests.get(response['next']))
    # pass results paths into the list
    for dataset in response['results']:
      file_list.append(dataset['path'])

# isolate the file names that cover our time scale
# for general use, have a look at the file_list and see what unique years appear in the path names that you can isolate on  
paths = [k for k in file_list if '2001' in k or '2011' in k]

# set bounding box (UK and Ireland)
north = 61.3
south = 49
east = 9
west = -12

# start a masking job on the ISIMIP servers to reduce file sizes
response = client.mask(paths[0], bbox=[south, north, west, east])
# check the response manually
response['status']
# when the job is complete this will show 'finished'
# It is possible to set up an automatic poll, however this ties up the prompt and so it is better to make a note of the response URL
response['file_url']
# or add this URL to your bookmarks to keep an eye on it via a browser window
"https://data.isimip.org/download/"+response['id']
# when masking job completes it is possible to trigger a download programmatically if the python session is still open.
client.download(response['file_url'], path='./downloads', validate=False, extract=True)
