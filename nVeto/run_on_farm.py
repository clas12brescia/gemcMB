#!/usr/bin/env python3

import os
import sys
import argparse

user = os.getlogin()
output_dir  = f"/project/gruppo3/fiber7/{user}"
gemc_exe    = f"/mnt/project_mnt/home_fs/{user}/gemcMB/devel-2.6/source/gemc"

# Arguments parsing
parser = argparse.ArgumentParser()
parser.add_argument("-o", "--outdir", help=f"Output directory (default is {output_dir})", default=output_dir)
parser.add_argument("-nj","--number-of-jobs", help="number of jobs to launch (default is 3)", default=3)
parser.add_argument("-ne","--number-of-events", help="number of events per job (default is 10)", default=10)
parser.add_argument("-q","--queue", help="queue (default is aiace)", default='aiace')
parser.add_argument("--debug", help="debug to print the bsub commands instead of running them (default is False)", default=False, action='store_true')
parser.add_argument("--gemc-exe", help=f"gemc exe file (default is {gemc_exe})", default=gemc_exe)
args = parser.parse_args()

# Make sure you're running the C-shell
current_real_shell = os.path.realpath(f'/proc/{os.getppid()}/exe')
if current_real_shell != "/usr/bin/tcsh":
    print("Stop! You are probably still in the bash shell.")
    print("      This script has to be run inside the C-shell")
    print("      where all the enviroment variables are properly set.")
    sys.exit()

########################
# GEMC for nuBDX checks

# Make sure the output dir exists:
if not os.path.isdir(output_dir):
    print(f"The output dir {output_dir} does not exist.\nExit.")
    sys.exit()

# Make sure the Geant4 neutron library is the one that we want to use
if os.environ['G4NEUTRONHPDATA'] != '/mnt/project_mnt/jlab12/fiber7_fs/ENDF-VIII.0':
    print("Check the value of the G4NEUTRONHPDATA env variable, which now is")
    print(os.environ['G4NEUTRONHPDATA'])
    print("Exit.")
    sys.exit()

# Make sure the GEMC executable is the customized one (MB version)
if not os.path.isfile(gemc_exe):
    print(f"The GEMC executable {gemc_exe} does not exist.\nExit.")
    sys.exit()

# Make sure the gcard exists in the workinf directory
if not os.path.isfile("bdx_CT.gcard"):
    print(f"The gcard bdx_CT.gcard does not exist.\nExit.")
    sys.exit()

########################
# LSF parameters

lsf_host    = "farmuisl7"
lsf_queue   = args.queue 
lsf_project = "sl7_64"
lsf_res     = '-R "select[mem > 4000] rusage[mem=4000]" -M 4000'
lsf_exe     = "bsub"


for i in range(int(args.number_of_jobs)):
    file_index = str(i)
    file_name = f"{output_dir}/out{file_index}.evio"
    
    # redirect stdout and stderr to a file. 
    # Do not do it for the first job (-> 1 email will be sent)
    out_and_err = f"-oo {output_dir}/log/lsf_out{file_index}.log -eo {output_dir}/log/lsf_err{file_index}.log"
    if i==0:
        out_and_err = ""

    command = f"{lsf_exe} -q {lsf_queue} -P {lsf_project} {lsf_res} {out_and_err} {gemc_exe} bdx_CT.gcard -USE_GUI=0 -N={args.number_of_events} -OUTPUT=\"evio, {file_name}\" "
    
    # Launch the command (or print it for debug)
    #os.system("pwd")
    if args.debug:
        print(command)
    else:
        os.system(command)
        
