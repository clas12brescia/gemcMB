# gemcMB

Clone the repository and download a copy of the ccdb sqlite file (for more info on local snapshots of the clas12 ccdb sqlite file, see the dedicated Jlab [wiki page](https://clasweb.jlab.org/wiki/index.php/CLAS12_Constants_Database):
```bash
git clone https://github.com/clas12brescia/gemcMB.git
wget https://fisbs.unibs.it/GEMC/clas12.sqlite -O gemcMB/clasdb/clas12.sqlite
```
Pull the docker image
```bash
docker pull maskass/gemcdimarco:v2
```
Run the container mounting the repo as shared volume between the host and the container (replace /YOUR/ABSOLUTE/PATH with your absolute path to the repo folder):
```bash
docker run -it --rm \
-e CCDB_CONNECTION="sqlite:////GEMC/clasdb/clas12.sqlite" \
-v /YOUR/ABSOLUTE/PATH/gemcMB:/GEMC \
--workdir /GEMC \
--rm maskass/gemcdimarco:v2 bash
```
Once in the container, compile the source code (~ few minutes):
```
cd devel-2.6/source/
scons -j4
```
Now the executable `gemc` is compiled and ready to be used. 

In the `misc` folder some useful scripts/macros are provided.

### Run the simulation

From the host machine, go into the container (see in the `misc` folder a template for defning aliases in your host `.bashrc` file) and then execute the perl script to create txt files for gemc:
```bash
cd nVeto
./bdx.pl config_CT.dat
```
Then run the `gemc` executable on the gcard file (10 events, no gui):
```bash
/GEMC/devel-2.6/source/gemc bdx_CT.gcard -USE_GUI=0 -N=10
```
Transform the created evio file into a root file:
```bash
evio2root -B=bdx -INPUTF=out.evio
```

### Analysis (on the host machine, NOT on the container!)

**Only once**: create the needed classes header files, shared libraries and ROOT dictionaries by running this macro on the `out.root` file (tested with ROOT Version: 6.24/06):
```bash
root -l -b -q ../misc/make_classes.C
```
After that, the analysis macro can be run (and a histo file is saved in the Output folder):
```bash
root -l nVeto_con_loop.C
```
