
while read -r line;
do
   root -l -b -q "Plots/do_plots.C($line)";
done < inputlist_eff.txt

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