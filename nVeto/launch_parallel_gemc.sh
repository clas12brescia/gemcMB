#!/bin/bash


initial_time=$(date)
initial_seconds=$(date +%s)


# do not run if no number is provided
if [ $# -ne 2 ] ; then
	echo "ERROR: please privde the number of parallel sessions and number of events"
	echo "Example:"
	echo "    ./launch_parallel_gemc.sh 3 100"
	echo " "
	exit 1
fi

n=$1
Nevents=$2

# create custom gcard files
for i in $(seq 1 $n); do
	sed 's/\(value="evio, \)out.evio/ \1out'$i'.evio /g' bdx_CT.gcard > bdx_CT_$i.gcard
done

# launch gemc in parallel...
for i in $(seq 1 $n); do
	../devel-2.6/source/gemc bdx_CT_$i.gcard -USE_GUI=0 -N=$Nevents & 
done

wait 

# ... once finished, convert evio files to root in series
# (we noticed that evio2root in parallel creates partial root files)
for i in $(seq 1 $n); do
	evio2root -B=bdx -INPUTF=out$i.evio
done

wait 

# Cleanup at the end

rm -v out*.evio 2> /dev/null
rm -v bdx_CT_*.gcard 2> /dev/null


echo "... done."
echo "Number of parallel runs: "$n
echo "Number of events per run: "$Nevents
echo "Runs started at: "$initial_time
echo "    finished at: "$(date)
echo "    total elapsed time: "$(( $(date +%s) - $initial_seconds ))" seconds"
