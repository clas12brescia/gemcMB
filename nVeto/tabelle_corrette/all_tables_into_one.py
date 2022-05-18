import sys

# for all files in the argument list

all_bin_dict = dict()

for file in sys.argv[1:]:
 #   print(file)

    # open the file
    with open(file) as f:
        for i,line in enumerate(f.readlines()):
            if "Bin width" in line:
                bin_width = float(line.split()[2])
            if i>5:
                bin_center = float(line.split()[1])
                bin_content = float(line.split()[2])
                all_bin_dict[bin_center-bin_width/2] = bin_content 
#                print(f"{bin_center-bin_width/2:.3E} {bin_content:.3E}")


# sort the bins

sorted_bins = sorted(all_bin_dict.items(), key=lambda x: x[0])

for bin in sorted_bins:
    print(f"{bin[0]:.3E} {bin[1]:.3E}")
