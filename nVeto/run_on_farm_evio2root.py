#!/usr/bin/env python3

import os
import sys
import glob

# Make sure you're running the C-shell
current_real_shell = os.path.realpath(f'/proc/{os.getppid()}/exe')
if current_real_shell != "/usr/bin/tcsh":
    print("Stop! You are probably still in the bash shell.")
    print("      This script has to be run inside the C-shell")
    print("      where all the enviroment variables are properly set.")
    sys.exit()


lsf_host    = "farmuisl7"
lsf_queue   = "short"
lsf_project = "sl7_64"
lsf_res     = '-R "select[mem > 16000] rusage[mem=16000]" -M 16000'
lsf_exe     = "bsub"

output_dir  = f"/project/gruppo3/fiber7/{os.getlogin()}"

# Get all the .evio file in the "output_dir" which has not been
# converted to ROOT and use evio2root on them

all_evio = glob.glob(f"{output_dir}/*.evio")
evio_to_convert = [f for f in all_evio if not os.path.isfile(f[:-5]+".root")]

if len(evio_to_convert)==0:
    print("No evio files to convert (or all already converted to ROOT)")
    sys.exit()

for i,file_name in enumerate(evio_to_convert):
    file_index = str(i)
    
    # redirect stdout and stderr to a file.
    # Do not do it for the first job
    out_and_err = f"-o {output_dir}/log/lsf_out{file_index}.log -e {output_dir}/log/lsf_err{file_index}.log"
    if i==0:
        out_and_err = ""

    command = f"{lsf_exe} -q {lsf_queue} -P {lsf_project} {lsf_res} {out_and_err} evio2root -B=bdx -INPUTF={file_name}"

    # Launch the command (or print it for debug)
    #print(command)
    os.system(command)
