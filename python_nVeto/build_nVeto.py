#!/usr/bin/env python3

import sys, os
import argparse # Used to parse the command line arguments

import gemc_api_utils as gemc


from geometry import make_geometry
from materials import define_materials

# This section handles checking for the required configuration filename argument and also provides help and usage messages
desc_str = "   Will create the geometry, materials, bank and hit definitions.\n"
parser = argparse.ArgumentParser(description=desc_str)
parser.add_argument("config_filename", help="The name of the experiment configuration file")
if len(sys.argv)==1:
    parser.print_help()
    sys.exit(1)
args = parser.parse_args()
cfg_file = args.config_filename

print("Using config file:",cfg_file)



# Loading configuration file and parameters
configuration = gemc.load_configuration("config.dat")


#materials
define_materials(configuration)

# geometry
make_geometry(configuration)



