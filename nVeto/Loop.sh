#!/bin/bash

if [ $# -lt 1 ]; then
   thr=100
else  
   thr=$1
fi

while read -r line;
do
   # root -l -b -q "Sort_flux.C($line, $thr)";
    root -l -b -q "Sort_cosmics_crs.C($line, $thr)";
    #root -l -b -q "Sort_cosmics_lAr.C($line, $thr)";
   # root -l -b -q "nVeto_con_loop.C($line)";
    #root -l -b -q "lAr_n_eff_cosmics.C($line, $thr)";
    #rot -l -b -q "Plots/do_plots.C($line)";
done < inputlist.txt

# for name in {"Sci1cm_p43MeV",
# 			 "Sci1cm_p9,7MeV",
# 			 "Sci1cm_p36,3MeV"}; do
# 	 root -l -b -q 'nVeto_con_loop.C('\"$name\"')'
# done

# for name in {"Sci1cm_p43MeV",
# 			 "Sci1cm_p9,7MeV",
# 			 "Sci1cm_p36,3MeV"}; do
# 	 root -l -b -q 'nVeto_con_loop.C('\"$name\"')'
# done