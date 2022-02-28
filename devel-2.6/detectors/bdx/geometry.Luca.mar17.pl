use strict; 
use warnings; 
 
our %configuration; 
 
# to control Prototype into the cave 
# $flag_JlabCT=0; -> LNS/CT config 
# $flag_JlabCT=1; -> proto at JLab config 
my $flag_JlabCT = 0 ; 
if ($configuration{"variation"} eq "CT") 
{$flag_JlabCT = 0 ;} 
 
# Nov16: to control test in front of Hall-A beam dump 
# to measure muon flux 
# $flag_mutest = 0 -> standard Proposal 
# $flag_mutest = 1 -> Hall-A mu tests 
my $flag_mutest =0; 
 
########################################################################################### 
########################################################################################### 
# Define the relevant parameters of BDX geometry 
# 
# the BDX geometry will be defined starting from these parameters  
# 
# all dimensions are in mm 
# 
 
 
my $degrad = 0.01745329252; 
my $cic    = 2.54; 
 
# geom globals 
my $TunnDist=400.0; 
my $theta3=13.4; 
my $x0 = -130 - 227.401; 
my $y0 = 50 - 50; 
my $z0 = 900 + 1227; 
my $TunnISzX=140.0; 
my $TunnISzY=177.165; 
my $TunnISzZ=720.0; 
my $TunnWThS=36.0; 
my $TunnWThF=43.0; 
 
 
 
 
########################################################################################### 
# Build Crystal Volume and Assemble calorimeter 
########################################################################################### 
 
 
sub make_whole_old 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "bdx_main_volume"; 
	$detector{"mother"}      = "root"; 
	$detector{"description"} = "World"; 
	$detector{"color"}       = "666666"; 
	$detector{"style"}       = 0; 
	$detector{"visible"}     = 0; 
	$detector{"type"}        = "Box"; 
#      my $X = $x0-$TunnDist*sin($DEGRAD*$theta3); 
#      my $Y = $y0 + 50.; 
#      my $Z = $z0+$TunnDist*cos($DEGRAD*$theta3); 
# we don't have Tagger Hall volume - this is the mother 
	my $X = 0.; 
	my $Y = 0.; 
#      my $Z = $cic*($TunnISzZ+2.*$TunnWThF)/2.; 
	my $Z = 0.; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	my $par1 = 2*$cic*($TunnISzX+2.*$TunnWThS)/2.; 
	my $par2 = 2*$cic*($TunnISzY+2.*$TunnWThS)/2.; 
	my $par3 = 2*$cic*($TunnISzZ+2.*$TunnWThF)/2.+200.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$detector{"material"}    = "G4_Galactic"; 
	print_det(\%configuration, \%detector); 
} 
 
sub make_tunc 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "tunc"; 
	$detector{"mother"}      = "bdx_main_volume"; 
	$detector{"description"} = "Concrete Box in the Ground (TUNC) - Walls"; 
	$detector{"color"}       = "E6E6E6"; 
	$detector{"style"}       = 1; 
	$detector{"visible"}     = 1; 
	$detector{"type"}        = "Box"; 
#      my $X = $x0-$TunnDist*sin($DEGRAD*$theta3); 
#      my $Y = $y0 + 50.; 
#      my $Z = $z0+$TunnDist*cos($DEGRAD*$theta3); 
# we don't have Tagger Hall volume - this is the mother 
	my $X = 0.; 
	my $Y = 50.; 
#      my $Z = $cic*($TunnISzZ+2.*$TunnWThF)/2.; 
	my $Z = 0.; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	my $par1 = $cic*($TunnISzX+2.*$TunnWThS)/2.; 
	my $par2 = $cic*($TunnISzY+2.*$TunnWThS)/2.; 
	my $par3 = $cic*($TunnISzZ+2.*$TunnWThF)/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$detector{"material"}    = "G4_CONCRETE"; 
	print_det(\%configuration, \%detector); 
} 
 
 
sub make_tuna 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "tuna"; 
	$detector{"mother"}      = "tunc"; 
	$detector{"description"} = "Air Box in the TUNC (TUNA) - Air in the Tunnel"; 
	$detector{"color"}       = "CEF6F5"; 
	$detector{"type"}        = "Box"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = 0.; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	my $par1 = $cic*$TunnISzX/2.; 
	my $par2 = $cic*$TunnISzY/2.; 
	my $par3 = $cic*$TunnISzZ/2.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$detector{"material"}    = "G4_AIR"; 
	print_det(\%configuration, \%detector); 
 
	my $tunc_nflux=6; 
	my $tunc_flux_dz=20.; 
	my $tunc_flux_lz=0.01; 
	for(my $iz=0; $iz<$tunc_nflux; $iz++) 
	{ 
		my %detector = init_det(); 
		$detector{"name"}        = "tunc_flux_$iz"; 
		$detector{"mother"}      = "tunc"; 
		$detector{"description"} = "tunc flux detector $iz "; 
		$detector{"color"}       = "cc00ff"; 
		$detector{"style"}       = 1; 
		$detector{"visible"}     = 0; 
		$detector{"type"}        = "Box";	 
		$X = 0.; 
		$Y = 0.; 
		$Z=$iz*$tunc_flux_dz+$par3+$tunc_flux_lz+1.; 
		$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
		$detector{"dimensions"}  = "$par1*cm $par2*cm $tunc_flux_lz*cm"; 
		$detector{"material"}    = "G4_CONCRETE";  
		$detector{"sensitivity"} = "flux"; 
		$detector{"hit_type"}    = "flux"; 
		my $nflux=112+$iz; 
		$detector{"identifiers"} = "id manual $nflux"; 
		print_det(\%configuration, \%detector); 
	} 
 
} 
 
 
my $WL1Door=22.0; 
my $WLabHgt = $TunnISzY; 
my $WLabThk=24.0; 
my $WL1Dist=19.0; 
my $HousLen=182.0; 
my $CWBDDist=179.6; 
my $WL2Door=23.0; 
my $WL2Dist=56.0; 
my $WL3Door=22.0; 
my $WL3Dist=56.0; 
 
sub make_clab 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "clab1"; 
	$detector{"mother"}      = "tuna"; 
	$detector{"description"} = "Concrete Boxes in the TUNA (CLAB -1,2,3) - Labyrinth Walls"; 
	$detector{"color"}       = "666666"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Box"; 
	my $X = $cic*$WL1Door/2.; 
	my $Y = -$cic*($TunnISzY-$WLabHgt)/2.; 
	my $Z = -$cic*$WLabThk/2. - $cic*($WL1Dist + $HousLen - $CWBDDist); 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	my $par1 = $cic*($TunnISzX-$WL1Door)/2.; 
	my $par2 = $cic*$WLabHgt/2.; 
	my $par3 = $cic*$WLabThk/2.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$detector{"material"}    = "G4_CONCRETE"; 
	print_det(\%configuration, \%detector); 
 
#	my %detector = init_det(); 
	$detector{"name"}        = "clab2"; 
	$X = -$cic*$WL2Door/2.; 
	$Z = -$par3 - $cic*($WL1Dist + $HousLen - $CWBDDist) - $cic*($WL2Dist + $WLabThk); 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$par1 =  $cic*($TunnISzX-$WL2Door)/2.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "clab3"; 
	$X = -$cic*$WL3Door/2.; 
	$Z = -$par3 - $cic*($WL1Dist + $HousLen - $CWBDDist) + $cic*($WL3Dist + $WLabThk); 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$par1 = $cic*($TunnISzX-$WL3Door)/2.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "clab4"; 
	$detector{"ncopy"}       = 4; 
#      $X = $par1-280.; 
#      $Y = 0.; 
#      $Z = 135.5; 
# located in different mother volume - try to fit into TUNA 
	$X = -$par1 + $cic*$TunnISzX/2.; 
	$Y = -$par2+$cic*$TunnISzY/2.; 
	$Z = -$cic*$WLabThk/2. - $cic*($WL1Dist + $HousLen - $CWBDDist) - $cic*($WL2Dist + $WLabThk) - 3.*$par3; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$par1 = 100.; 
	$par2 = $cic*$WLabHgt/2.; 
	$par3 = 31.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	print_det(\%configuration, \%detector); 
} 
 
 
  
# Beam in the center 
my $BeamElev = $TunnISzY/2. - 50./$cic; 
my $HousHgt = $BeamElev*2.; 
 
sub make_iron 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "iron"; 
	$detector{"mother"}      = "tuna"; 
	$detector{"description"} = "iron shield blocks in the TUNA (IRON)"; 
	$detector{"color"}       = "FF8000"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Box"; 
	my $par1 = $cic*$TunnISzX/2.; 
	my $par2 = $cic*$HousHgt/2.; 
	my $par3 = $cic*$HousLen/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	my $X = 0.; 
	my $Y = -$cic*($TunnISzY-$HousHgt)/2.; 
	my $Z = -$par3 + $cic*$TunnISzZ/2.; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "BDX_Iron"; 
	print_det(\%configuration, \%detector); 
	 
	my $iron_nflux=12; 
	my $iron_flux_dz=20.; 
	my $iron_flux_lz=0.01; 
	for(my $iz=0; $iz<$iron_nflux; $iz++) 
	{ 
		my %detector = init_det(); 
		$detector{"name"}        = "iron_flux_$iz"; 
		$detector{"mother"}      = "iron"; 
		$detector{"description"} = "iron flux detector $iz "; 
		$detector{"color"}       = "cc00ff"; 
		$detector{"style"}       = 1; 
		$detector{"visible"}     = 0; 
		$detector{"type"}        = "Box";	 
		$X = 0.; 
		$Y = 0.; 
		$Z=$iz*$iron_flux_dz+$iron_flux_lz; 
		$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
		$detector{"dimensions"}  = "$par1*cm $par2*cm $iron_flux_lz*cm"; 
		$detector{"material"}    = "BDX_Iron";  
		$detector{"sensitivity"} = "flux"; 
		$detector{"hit_type"}    = "flux"; 
		my $nflux=100+$iz; 
		$detector{"identifiers"} = "id manual $nflux"; 
		print_det(\%configuration, \%detector); 
	} 
 
} 
 
 
my $BdholeX=26.0; 
my $BdholeY=26.0; 
my $BdholeZ=78.0; 
 
sub make_bsyv 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "bsyv"; 
	$detector{"mother"}      = "iron"; 
	$detector{"description"} = "BD-hole in the iron shield blocks (BSYV)"; 
	$detector{"color"}       = "33ffff"; 
	$detector{"type"}        = "Box"; 
	my $par1 = $cic*$BdholeX/2.; 
	my $par2 = $cic*$BdholeY/2.; 
	my $par3 = $cic*$BdholeZ/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	my $X = 0.; 
	#      my $Y = -$cic*$BeamElev - $cic*$HousHgt/2.; 
	#      my $Z = -$par3 - $cic*$HousLen/2.; 
	my $Y = 0.; 
	my $Z = $par3 - $cic*$HousLen/2.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	$detector{"material"}    = "G4_AIR"; 
	print_det(\%configuration, \%detector); 
} 
 
 
 
my $CWEnDist=2.00; 
my $CWExDist=3.00; 
my $CWinDia=1.95; 
my $CWoutDia=2.88; 
my $shftBSYV = $cic*($HousLen - $CWBDDist) - $cic*$BdholeZ/2.; 
 
sub make_wint 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "wint"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "Win Section Tube (WINT)"; 
	$detector{"color"}       = "999999"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV + $cic*($CWExDist-$CWEnDist)/2.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	my $par1 = $cic*$CWinDia/2.; 
	my $par2 = $cic*$CWoutDia/2.; 
	my $par3 = $cic*($CWEnDist+$CWExDist)/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	$detector{"material"}    = "G4_Al"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $CWFlDi=4.60; 
my $CWFlTh=0.625; 
 
sub make_winf 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "winf"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "Win Section Flange (WINF)"; 
	$detector{"color"}       = "999999"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube";	 
	my $par1 = $cic*$CWoutDia/2.; 
	my $par2 = $cic*$CWFlDi/2.; 
	my $par3 = $cic*$CWFlTh/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV - $par3 + $cic*$CWExDist;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "G4_Al"; 
	print_det(\%configuration, \%detector); 
} 
 
 
 
my $CWDiam=1.18; 
my $CWThick=0.118; 
my $CWWDist=1.25; 
my $CW2Th=0.354; 
 
sub make_wind 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "wind1"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "copper Windows (WIND)"; 
	$detector{"color"}       = "ff9933"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV - $cic*$CWWDist;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	my $par1 = 0.; 
	my $par2 = $cic*$CWDiam/2.; 
	my $par3 = $cic*$CWThick/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	$detector{"material"}    = "G4_Cu";	 
	print_det(\%configuration, \%detector); 
 
 
	$detector{"name"}        = "wind2"; 
	$Z = $shftBSYV + $cic*$CWWDist; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "wind3"; 
	$Z = $shftBSYV - $cic*$CWWDist; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$par1 = $cic*$CWDiam/2.; 
	$par2 = $cic*$CWinDia/2.; 
	$par3 = $cic*$CW2Th/2.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "wind4"; 
	$Z = $shftBSYV + $cic*$CWWDist; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $FSinDia=3.0; 
my $FSoutDia=6.625; 
my $FSLeng=12.188; 
 
sub make_fsst 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "fsst"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "Front Section Tube (FSST)"; 
	$detector{"color"}       = "999999"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube";	 
	my $par1 = $cic*$FSinDia/2.; 
	my $par2 = $cic*$FSoutDia/2.; 
	my $par3 = $cic*$FSLeng/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV + $par3 + $cic*$CWExDist;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "G4_Al"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $FSEFlDi=2.50; 
my $FSEFlTh=1.628; 
 
sub make_fsef 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "fsef"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "Front Section Tube entrance flange inside (FSEF)"; 
	$detector{"color"}       = "999999"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube"; 
	my $par1 = $cic*$FSEFlDi/2.; 
	my $par2 = $cic*$FSinDia/2.; 
	my $par3 = $cic*$FSEFlTh/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV + $par3 + $cic*$CWExDist;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "G4_Al"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $FSFlDi=9.50; 
my $FSFlTh=0.875; 
 
sub make_fssf 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "fssf"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "Front Section Flange (FSSF)"; 
	$detector{"color"}       = "999999"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube"; 
	my $par1 = $cic*$FSoutDia/2.; 
	my $par2 = $cic*$FSFlDi/2.; 
	my $par3 = $cic*$FSFlTh/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV - $par3 + $cic*$FSLeng + $cic*$CWExDist;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	$detector{"material"}    = "G4_Al"; 
	print_det(\%configuration, \%detector); 
} 
 
 
 
my $FSWCinD=5.50; 
my $FSWCThk=0.25; 
 
sub make_fstw 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "fstw"; 
	$detector{"mother"}      = "acst"; 
	$detector{"description"} = "Front Section Tube Water (FSTW)"; 
	$detector{"color"}       = "ffffff"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = 0.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	my $par1 = $cic*$FSWCinD/2.; 
	my $par2 = $cic*($FSWCinD/2. + $FSWCThk); 
	my $par3 = $cic*$FSLeng/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	$detector{"material"}    = "G4_WATER"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $ACSDiam=10.00; 
my $ACSLeng=41.50; 
 
sub make_acst 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "acst"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "Al Center Section Tube (ACST)"; 
	$detector{"color"}       = "999999"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube"; 
	my $par1 = 0.; 
	my $par2 = $cic*$ACSDiam/2.; 
	my $par3 = $cic*$ACSLeng/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV + $par3 + $cic*($CWExDist+$FSLeng);	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	$detector{"material"}    = "G4_Al"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $ACHDiam=2.25; 
my $ACHLeng=19.60; 
 
sub make_acht 
{ 
	my %detector = init_det(); 
	 $detector{"name"}        = "acht"; 
	$detector{"mother"}      = "acst"; 
	$detector{"description"} = "Al Center Section Tube (ACHT)"; 
	$detector{"color"}       = "33ffff"; 
	$detector{"style"}       = 0; 
	$detector{"type"}        = "Tube";	 
	my $par1 = 0.; 
	my $par2 = $cic*$ACHDiam/2.; 
	my $par3 = $cic*$ACHLeng/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $par3 - $cic*$ACSLeng/2.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "G4_AIR"; 
	print_det(\%configuration, \%detector); 
} 
 
 
sub make_acct 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "acct"; 
	$detector{"mother"}      = "acht"; 
	$detector{"description"} = "cone in the Hole in Al Center Section Tube (ACCT)"; 
	$detector{"color"}       = "999999"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Cons"; 
	#      my $par1 = $cic*$ACHDiam/4.; Dz/2 
	#      my $par2 = $cic*$ACHDiam/2.; R1_min 
	#      my $par3 = $cic*$ACHDiam/2.; R1_max 
	#      my $par4 = 0.;               R2_min 
	#      my $par5 = $cic*$ACHDiam/2.; R2_max 
	my $par1 = $cic*$ACHDiam/2.; 
	my $par2 = $cic*$ACHDiam/2.; 
	my $par3 = 0.; 
	my $par4 = $cic*$ACHDiam/2.; 
	my $par5 = $cic*$ACHDiam/4.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = - $par1 + $cic*$ACHLeng/2.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "G4_Al"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $ACWCinD=3.50; 
my $ACWCThk=0.25; 
 
sub make_actw 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "actw"; 
	$detector{"mother"}      = "acst";  
	$detector{"description"} = "Al Center Section Tube Water (ACTW)"; 
	$detector{"color"}       = "ffffff"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = 0.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	my $par1 = $cic*$ACWCinD/2.; 
	my $par2 = $cic*$ACWCinD/2. + $cic*$ACWCThk; 
	my $par3 = $cic*$ACSLeng/2.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	$detector{"material"}    = "G4_WATER"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $CESDiam=10.0; 
my $CESLeng=11.5; 
my $CESgap=0.25; 
 
sub make_cest 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "cest"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "Copper End Section Tube (CEST)"; 
	$detector{"color"}       = "ff9933"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube";	 
	my $par1 = 0.; 
	my $par2 = $cic*$CESDiam/2.; 
	my $par3 = $cic*$CESLeng/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV + $par3 + $cic*($CWExDist+$FSLeng+$ACSLeng+$CESgap);	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "G4_Cu"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $CEWCinD=9.00; 
my $CEWCThk=0.25; 
 
sub make_cetw 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "cetw"; 
	$detector{"mother"}      = "cest"; 
	$detector{"description"} = "Copper End Section Tube Water (CETW)"; 
	$detector{"color"}       = "ffffff"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube";	 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = 0.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	my $par1 = $cic*$CEWCinD/2.; 
	my $par2 = $cic*$CEWCinD/2. + $cic*$CEWCThk; 
	my $par3 = $cic*$CESLeng/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	$detector{"material"}    = "G4_WATER"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $SizeBD = 0; 
 
sub make_cmb 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "cmb0"; 
	$detector{"mother"}      = "bsyv"; 
	$detector{"description"} = "side cyl. outside BD"; 
	$detector{"color"}       = "0000ff"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Tube"; 
	my $par1 = $cic*$ACSDiam/2.; 
	my $par2 = $par1 + 0.5; 
	my $par3 = $cic*($CWEnDist+$CWExDist+$FSLeng+$ACSLeng+$CESgap+$CESLeng)/2.; 
	my $SizeBD = $par3;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $shftBSYV - $cic*$CWEnDist + $par3;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "G4_Galactic";	 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "cmb1"; 
	$par1 = 0.; 
	$par2 = $cic*$ACSDiam/2. + 0.5; 
	$par3 = 0.25; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm 0*deg 360*deg"; 
	$Z = $shftBSYV - $cic*$CWEnDist + 2.*$SizeBD + $par3; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "cmb2"; 
	$Z = $shftBSYV - $cic*$CWEnDist - $par3; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	print_det(\%configuration, \%detector); 
} 
 
 
my $CV_Zsize = $WL1Dist + $HousLen - $CWBDDist  - 300./$cic + $TunnISzZ/2.; 
 
sub make_cmc 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "cmc1"; 
	$detector{"mother"}      = "tunc"; 
	$detector{"description"} = "Air Plates in the TUNC (entrance from TUNA)"; 
	$detector{"color"}       = "0000ff"; 
	$detector{"type"}        = "Box";	 
	my $par1 = 0.25; 
	my $par2 = $cic*$TunnISzY/2.; 
	my $par3 = $cic*$CV_Zsize/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	my $X = $par1 + $cic*$TunnISzX/2.; 
	my $Y = 0.; 
	my $Z = $cic*$TunnISzZ/2. - $par3;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"material"}    = "G4_Galactic"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "cmc2"; 
	$X = - $par1 - $cic*$TunnISzX/2.; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "cmc3"; 
	$par1 = 0.5+$cic*$TunnISzX/2.; 
	$par2 = 0.25; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$X = 0.; 
	$Y = $par2 + $cic*$TunnISzY/2.; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "cmc4"; 
	$Y = - $par2 - $cic*$TunnISzY/2.; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "cmc5"; 
	$par2 = 0.5+$cic*$TunnISzY/2.; 
	$par3 = 0.25; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$X = 0.; 
	$Y = 0.; 
	$Z = $par3 + $cic*$TunnISzZ/2.; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	print_det(\%configuration, \%detector); 
 
	$detector{"name"}        = "cmc6"; 
	$detector{"mother"}      = "tuna"; 
	$par1 = $cic*$TunnISzX/2.; 
	$par2 = $cic*$TunnISzY/2.; 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$Z = $par3 - $cic*($WL1Dist + $HousLen - $CWBDDist - 300./$cic); 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	print_det(\%configuration, \%detector); 
 
} 
 
 
my $TEwidthX=104.0; 
my $TEwidthY=78.75; 
my $TElengthZ=259.010+53.0; 
my $TEth=13.21; 
 
sub make_tunce 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "tunce"; 
	$detector{"mother"}      = "bdx_main_volume"; 
	$detector{"description"} = "Extention of Concrete Box in the Ground (TUNCE) - Walls"; 
	$detector{"color"}       = "336666"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Box"; 
	my $X = 0.; 
#	my $Y = -$cic*($TunnISzY-$HousHgt)/2.; 
	my $Y = 0.; 
	my $Z = $cic*($TunnISzZ+2.*$TunnWThF+$TElengthZ+$TEth)/2.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	my $par1 = $cic*($TEwidthX+2.*$TEth)/2.; 
	my $par2 = $cic*($TEwidthY+2.*$TEth)/2.; 
	my $par3 = $cic*($TElengthZ+$TEth)/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$detector{"material"}    = "G4_CONCRETE"; 
	print_det(\%configuration, \%detector); 
} 
 
 
sub make_tunae 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "tunae"; 
	$detector{"mother"}      = "tunce"; 
	$detector{"description"} = "Iron Box in the TUNCE (TUNAE) - Air in the Tunnel"; 
	$detector{"color"}       = "33ee99"; 
	$detector{"type"}        = "Box";	 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = -$TEth/2.;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	my $par1 = $cic*$TEwidthX/2.; 
	my $par2 = $cic*$TEwidthY/2.; 
	my $par3 = $cic*$TElengthZ/2.;	 
	$detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
	$detector{"material"}    = "BDX_Iron"; 
	print_det(\%configuration, \%detector); 
	 
	my $tunce_nflux=15; 
	my $tunce_flux_dz=50.; 
	my $tunce_flux_lz=0.01; 
	for(my $iz=0; $iz<$tunce_nflux; $iz++) 
	{ 
		my %detector = init_det(); 
		$detector{"name"}        = "tunce_flux_$iz"; 
		$detector{"mother"}      = "tunae"; 
		$detector{"description"} = "tunae flux detector $iz "; 
		$detector{"color"}       = "cc00ff"; 
		$detector{"style"}       = 1; 
		$detector{"visible"}     = 0; 
		$detector{"type"}        = "Box";	 
		$X = 0.; 
		$Y = 0.; 
		$Z=-$par3+$iz*$tunce_flux_dz+$tunce_flux_lz; 
		$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
		$detector{"dimensions"}  = "$par1*cm $par2*cm $tunce_flux_lz*cm"; 
		$detector{"material"}    = "BDX_Iron";  
		$detector{"sensitivity"} = "flux"; 
		$detector{"hit_type"}    = "flux"; 
		my $nflux=200+$iz; 
		$detector{"identifiers"} = "id manual $nflux"; 
		print_det(\%configuration, \%detector); 
	} 
} 
 
 
 
 
 
# define cormorino detector geometry 
my $cormo_z=2020; 
#my $cormo_z=1920; 
# detector is a matrix of $cormo_nchannels in Y and $cormo_nchannels in Z 
my $cormo_nchannels=3; 
# small bar size is (cm): 
my $cormo_bar_dx=30./2.; 
my $cormo_bar_dy=5./2.; 
my $cormo_bar_dz=5./2.; 
# scintillator block size is (cm): 
my $cormo_block_nbary=2; 
my $cormo_block_nbarz=2; 
my $cormo_block_dx=5./2.; 
# mylar wrapping thickness is (cm): 
my $cormo_mylar_tn=0.0025; 
# airgap thickness is (cm): 
my $cormo_airgap_tn=0.05; 
# case thickness is (cm): 
my $cormo_box_tn=1.; 
# lead planes thicknes 
my $cormo_lead_tn=0.02; 
# pmt length 
my $cormo_pmt_lt=26.; 
 
# calculate all other infos from above parameters: 
# wrapped bars: 
my $cormo_wrapped_bar_dx=$cormo_bar_dx; 
my $cormo_wrapped_bar_dy=$cormo_bar_dy+$cormo_mylar_tn; 
my $cormo_wrapped_bar_dz=$cormo_bar_dz+$cormo_mylar_tn; 
# wrapped blocks: 
my $cormo_wrapped_block_dx=$cormo_block_dx; 
my $cormo_wrapped_block_dy=$cormo_wrapped_bar_dy*$cormo_block_nbary+$cormo_airgap_tn*($cormo_block_nbary-1); 
my $cormo_wrapped_block_dz=$cormo_wrapped_bar_dz*$cormo_block_nbarz+$cormo_airgap_tn*($cormo_block_nbarz-1); 
# blocks 
my $cormo_block_dy=$cormo_wrapped_block_dy-$cormo_mylar_tn; 
my $cormo_block_dz=$cormo_wrapped_block_dz-$cormo_mylar_tn; 
#channels 
my $cormo_channel_dx=2*$cormo_wrapped_block_dx+$cormo_wrapped_bar_dx; 
my $cormo_channel_dy=$cormo_wrapped_block_dy+$cormo_airgap_tn; 
my $cormo_channel_dz=$cormo_wrapped_block_dz+$cormo_airgap_tn; 
# box 
my $cormo_box_lx=$cormo_channel_dx+$cormo_box_tn; 
my $cormo_box_ly=$cormo_channel_dy*$cormo_nchannels+$cormo_box_tn; 
my $cormo_box_lz=($cormo_channel_dz+$cormo_lead_tn/2.)*$cormo_nchannels+$cormo_box_tn; 
# lead 
my $cormo_lead_lx=$cormo_channel_dx; 
my $cormo_lead_ly=$cormo_channel_dy*$cormo_nchannels; 
my $cormo_lead_lz=$cormo_lead_tn/2.; 
# flux 
my $cormo_flux_lz =0.02; 
 
 
# inner veto 
my $cormo_iveto_gap=1.; 
my $cormo_iveto_tn=1./2.; 
my $cormo_iveto_lx=$cormo_box_lx+$cormo_pmt_lt+$cormo_iveto_gap+2*$cormo_iveto_tn; 
my $cormo_iveto_ly=$cormo_box_ly+$cormo_iveto_gap; 
my $cormo_iveto_lz=$cormo_box_lz+$cormo_iveto_gap+2*$cormo_iveto_tn; 
 
# lead shield 
my $cormo_leadshield_tn=5./2.; 
my $cormo_leadshield_gap=1.; 
my $cormo_leadshield_lx=$cormo_iveto_lx+$cormo_leadshield_gap+2*$cormo_leadshield_tn; 
my $cormo_leadshield_ly=$cormo_iveto_ly+$cormo_leadshield_gap+2*$cormo_iveto_tn; 
my $cormo_leadshield_lz=$cormo_iveto_lz+$cormo_leadshield_gap+2*$cormo_leadshield_tn; 
 
# outer veto 
my $cormo_oveto_gap=1.; 
my $cormo_oveto_tn=1.; 
my $cormo_oveto_lx=$cormo_leadshield_lx+$cormo_oveto_gap+2*$cormo_oveto_tn; 
my $cormo_oveto_ly=$cormo_leadshield_ly+$cormo_oveto_gap+2*$cormo_leadshield_tn; 
my $cormo_oveto_lz=$cormo_leadshield_lz+$cormo_oveto_gap+2*$cormo_oveto_tn; 
my $cormo_oveto_dz=$cormo_oveto_lz/2.; 
 
#flux detector around cormorad 
#my $cormo_veto_r0=32.0; 
#my $cormo_veto_r1=30.0; 
#my $cormo_veto_h0=18.0; 
#my $cormo_veto_h1=20.0; 
my $cormo_veto_r0=49.9; 
my $cormo_veto_r1=47.9; 
my $cormo_veto_h0=30.0; 
my $cormo_veto_h1=32.0; 
my $cormo_veto_nplanes=6; 
 
my @cormo_veto_ir = (              0.,              0. , $cormo_veto_r1,   $cormo_veto_r1,              0.,              0.); 
my @cormo_veto_or = ( $cormo_veto_r0 , $cormo_veto_r0  , $cormo_veto_r0,   $cormo_veto_r0,   $cormo_veto_r0, $cormo_veto_r0); 
my @cormo_veto_z  = (-$cormo_veto_h1 , -$cormo_veto_h0 ,-$cormo_veto_h0,   $cormo_veto_h0,   $cormo_veto_h0, $cormo_veto_h1); 
 
 
sub make_cormo_flux 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "cormo_flux"; 
	$detector{"mother"}      = "bdx_main_volume"; 
	$detector{"description"} = "flux detector"; 
	$detector{"color"}       = "cc00ff"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Box";	 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $cormo_z-17.1;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	$detector{"dimensions"}  = "20*cm 15*cm 1*mm"; 
	$detector{"material"}    = "ScintillatorB"; #ScintillatorB 
	$detector{"sensitivity"} = "flux"; 
	$detector{"hit_type"}    = "flux"; 
	$detector{"identifiers"} = "id manual 0"; 
#	print_det(\%configuration, \%detector); 
 
	%detector = init_det(); 
	$detector{"name"}        = "cormo_veto"; 
	$detector{"mother"}      = "bdx_main_volume"; 
	$detector{"description"} = "veto detector"; 
	$detector{"color"}       = "A9D0F5"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Polycone";	 
	$X = 0.; 
	$Y = 0.; 
	$Z = $cormo_z;	 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "90*deg 0*deg 0*deg"; 
	my $dimen = "0.0*deg 360*deg $cormo_veto_nplanes*counts"; 
	for(my $i = 0; $i <$cormo_veto_nplanes ; $i++) 
	{ 
	$dimen = $dimen ." $cormo_veto_ir[$i]*cm"; 
	} 
	for(my $i = 0; $i <$cormo_veto_nplanes ; $i++) 
	{ 
	$dimen = $dimen ." $cormo_veto_or[$i]*cm"; 
	} 
	for(my $i = 0; $i <$cormo_veto_nplanes ; $i++) 
	{ 
	$dimen = $dimen ." $cormo_veto_z[$i]*cm"; 
	}	 
	$detector{"dimensions"}  = $dimen; 
	$detector{"material"}    = "ScintillatorB"; 
	$detector{"sensitivity"}  = "flux"; 
	$detector{"hit_type"}     = "flux"; 
	$detector{"identifiers"}  = "id manual 1"; 
#	print_det(\%configuration, \%detector); 
} 
 
 
 
sub make_cormo_det 
{ 
	my %detector = init_det(); 
	$detector{"name"}        = "cormo_det"; 
	$detector{"mother"}      = "bdx_main_volume"; 
	$detector{"description"} = "cormorad detector"; 
	$detector{"color"}       = "0000ff"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Box"; 
	my $X = 0.; 
	my $Y = 0.; 
	my $Z = $cormo_z; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	$detector{"dimensions"}  = "$cormo_box_lx*cm $cormo_box_ly*cm $cormo_box_lz*cm"; 
	$detector{"material"}    = "G4_Al"; 
	print_det(\%configuration, \%detector); 
 
	%detector = init_det(); 
	$detector{"name"}        = "cormo_flux"; 
	$detector{"mother"}      = "cormo_det"; 
	$detector{"description"} = "cormorad flux detector"; 
	$detector{"color"}       = "cc00ff"; 
	$detector{"style"}       = 1; 
	$detector{"type"}        = "Box";	 
	$X = 0.; 
	$Y = 0.; 
	$Z=-($cormo_box_lz-$cormo_box_tn)-$cormo_flux_lz; 
	$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";	 
	$detector{"dimensions"}  = "$cormo_lead_lx*cm $cormo_lead_ly*cm $cormo_flux_lz*cm"; 
	$detector{"material"}    = "G4_AIR";  
	$detector{"sensitivity"} = "flux"; 
	$detector{"hit_type"}    = "flux"; 
	$detector{"identifiers"} = "id manual 301"; 
	print_det(\%configuration, \%detector); 
	 
	for(my $iz=0; $iz<$cormo_nchannels; $iz++) 
	{ 
		my %detector = init_det(); 
		$detector{"name"}        = "cormo_lead_$iz"; 
		$detector{"mother"}      = "cormo_det"; 
		$detector{"description"} = "cormorad lead plane $iz"; 
		$X=0; 
		$Y=0; 
		$Z=-($cormo_box_lz-$cormo_box_tn)+$cormo_lead_lz+2*$iz*($cormo_channel_dz+$cormo_lead_lz); 
		$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "000000"; 
		$detector{"type"}        = "Box"; 
		$detector{"dimensions"}  = "$cormo_lead_lx*cm $cormo_lead_ly*cm $cormo_lead_lz*cm"; 
		$detector{"material"}    = "G4_Pb"; 
		print_det(\%configuration, \%detector); 
		for(my $iy=0; $iy<$cormo_nchannels; $iy++) 
		{ 
			my $channel_id=$iz*10+$iy; 
			my %detector = init_det(); 
			$detector{"name"}        = "cormo_channel_$channel_id"; 
			$detector{"mother"}      = "cormo_det"; 
			$detector{"description"} = "cormorad channel $channel_id"; 
			$detector{"color"}       = "00ffff"; 
			$detector{"style"}       = 1; 
			$detector{"type"}        = "Box"; 
			$X=0; 
			$Y=($iy*2-$cormo_nchannels+1)*$cormo_channel_dy; 
#			$Z=($iz*2-$cormo_nchannels+1)*$cormo_channel_dz+($iz+1)*$cormo_lead_tn; 
			$Z=-($cormo_box_lz-$cormo_box_tn)+($iz+1)*$cormo_lead_tn+(2*$iz+1)*$cormo_channel_dz; 
			$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
			$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
			$detector{"dimensions"}  = "$cormo_channel_dx*cm $cormo_channel_dy*cm $cormo_channel_dz*cm"; 
			$detector{"material"}    = "G4_AIR"; 
			print_det(\%configuration, \%detector); 
		 
			for(my $iblock=0; $iblock<2; $iblock++) 
			{ 
				my $block_name="left"; 
				if($iblock==1) { 
					$block_name="right"; 
				} 
				my %detector = init_det(); 
				$detector{"name"}        = "cormo_wrapped_block_$block_name"."_$channel_id"; 
				$detector{"mother"}      = "cormo_channel_$channel_id"; 
				$detector{"description"} = "cormorad wrapped $block_name block $channel_id"; 
				$detector{"color"}       = "A4A4A4"; 
				$detector{"style"}       = 1; 
				$detector{"type"}        = "Box"; 
				$X=($iblock*2-1)*($cormo_wrapped_bar_dx+$cormo_wrapped_block_dx); 
				$Y=0; 
				$Z=0; 
				$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
				$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
				$detector{"dimensions"}  = "$cormo_wrapped_block_dx*cm $cormo_wrapped_block_dy*cm $cormo_wrapped_block_dz*cm"; 
				$detector{"material"}    = "bdx_mylar"; 
				print_det(\%configuration, \%detector); 
 
				%detector = init_det(); 
				$detector{"name"}        = "cormo_block_$block_name"."_$channel_id"; 
				$detector{"mother"}      = "cormo_wrapped_block_$block_name"."_$channel_id"; 
				$detector{"description"} = "cormorad $block_name block $channel_id"; 
				$detector{"color"}       = "9F81F7"; 
				$detector{"style"}       = 1; 
				$detector{"type"}        = "Box"; 
				$X=0; 
				$Y=0; 
				$Z=0; 
				$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
				$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
				$detector{"dimensions"}  = "$cormo_block_dx*cm $cormo_block_dy*cm $cormo_block_dz*cm"; 
				$detector{"material"}    = "ScintillatorB"; 
				$detector{"sensitivity"} = "cormo"; 
				$detector{"hit_type"}    = "cormo"; 
				$detector{"identifiers"} = "sector manual 0 layer manual $iz paddle manual $iy"; 
#				$detector{"identifiers"} = "paddle manual $channel_id"; 
				print_det(\%configuration, \%detector); 
			} 
 
			for(my $ibary=0; $ibary<$cormo_block_nbary; $ibary++) 
			{ 
				for(my $ibarz=0; $ibarz<$cormo_block_nbarz; $ibarz++) 
				{ 
					my %detector = init_det(); 
					$detector{"name"}        = "cormo_wrapped_bar_$ibary"."_$ibarz"."_$channel_id"; 
					$detector{"mother"}      = "cormo_channel_$channel_id"; 
					$detector{"description"} = "cormorad wrapped bar $ibary $ibarz $channel_id"; 
					$detector{"color"}       = "A4A4A4"; 
					$detector{"style"}       = 1; 
					$detector{"type"}        = "Box"; 
					$X=0; 
					$Y=(2*$ibary-$cormo_block_nbary+1)*$cormo_wrapped_bar_dy+(2*$ibary-$cormo_block_nbary+1)*$cormo_airgap_tn; 
					$Z=(2*$ibarz-$cormo_block_nbarz+1)*$cormo_wrapped_bar_dz+(2*$ibarz-$cormo_block_nbarz+1)*$cormo_airgap_tn; 
					$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
					$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
					$detector{"dimensions"}  = "$cormo_wrapped_bar_dx*cm $cormo_wrapped_bar_dy*cm $cormo_wrapped_bar_dz*cm"; 
					$detector{"material"}    = "bdx_mylar"; 
					print_det(\%configuration, \%detector); 
 
					%detector = init_det(); 
					$detector{"name"}        = "cormo_bar_$ibary"."_$ibarz"."_$channel_id"; 
					$detector{"mother"}      = "cormo_wrapped_bar_$ibary"."_$ibarz"."_$channel_id"; 
					$detector{"description"} = "cormorad bar $ibary $ibarz $channel_id"; 
					$detector{"color"}       = "9F81F7"; 
					$detector{"style"}       = 1; 
					$detector{"type"}        = "Box"; 
					$X=0; 
					$Y=0; 
					$Z=0; 
					$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
					$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
					$detector{"dimensions"}  = "$cormo_bar_dx*cm $cormo_bar_dy*cm $cormo_bar_dz*cm"; 
					$detector{"material"}    = "ScintillatorB"; 
					$detector{"sensitivity"} = "cormo"; 
					$detector{"hit_type"}    = "cormo"; 
					$detector{"identifiers"} = "sector manual 0 layer manual $iz paddle manual $iy"; 
#					$detector{"identifiers"} = "paddle manual $channel_id"; 
					print_det(\%configuration, \%detector); 
				} 
			} 
		} 
	} 
} 
 
sub make_babar_crystal 
{ 
    my %detector = init_det(); 
    $detector{"name"}        = "babar_crystal"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "preshower"; 
    $detector{"color"}       = "00ffff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "G4Trap"; 
    my $X = 0.; 
    my $Y = 0.; 
    my $Z = 0.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    my $par1 = 20.; 
    my $par2 = 0.; 
    my $par3 = 0. ; 
    my $par4 = 4.0 ; 
    my $par5 = 3. ; 
     
    my $par6 = 4.; 
    my $par7 = 0.; 
    my $par8 = 1.6 ; 
    my $par9 = 1. ; 
    my $par10 = 1.4 ; 
    my $par11 = 0. ; 
     
    $detector{"dimensions"}  = "$par1*cm $par2*deg $par3*deg $par4*cm $par5*cm $par6*cm $par7*deg $par8*cm $par9*cm $par10*cm $par11*deg"; 
    $detector{"material"}    = "CsI_Tl"; 
    $detector{"sensitivity"} = "crs"; 
    $detector{"hit_type"}    = "crs"; 
    $detector{"identifiers"} = "sector manual 0 layer manual 0 paddle manual 0"; 
    #    print_det(\%configuration, \%detector); 
} 
 
 
sub make_crystal 
{ 
    my %detector = init_det(); 
    $detector{"name"}        = "boxscint"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "preshower"; 
    $detector{"color"}       = "00ffff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    my $X = 0.; 
    my $Y = 0.; 
    my $Z = 0.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    my $par1 = 2.5; 
    my $par2 = 2.5; 
    my $par3 = 15. ; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "CsI_Tl"; 
    $detector{"material"}    = "BDX_Iron"; 
    $detector{"sensitivity"} = "crs"; 
    $detector{"hit_type"}    = "crs"; 
    $detector{"identifiers"} = "sector manual 0 layer manual 0 paddle manual 0"; 
    print_det(\%configuration, \%detector); 
} 
 
 
sub make_crystal_trap 
{ 
    my %detector = init_det(); 
    $detector{"name"}        = "boxscint"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "preshower"; 
    $detector{"color"}       = "00ffff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Trd"; 
    my $X = 0.; 
    my $Y = 0.; 
    my $Z = 0.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    my $par1 = 2.; 
    my $par2 = 3; 
    my $par3 = 2. ; 
    my $par4 = 3. ; 
    my $par5 = 15. ; 
 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm"; 
    $detector{"material"}    = "CsI_Tl"; 
    #	$detector{"material"}    = "BDX_Iron"; 
    $detector{"sensitivity"} = "crs"; 
    $detector{"hit_type"}    = "crs"; 
    $detector{"identifiers"} = "sector manual 0 layer manual 0 paddle manual 0"; 
    print_det(\%configuration, \%detector); 
} 
 
################################################################################################# 
# 
# Begin: Hall A Beam Dump 
# 
################################################################################################# 
# 
# Note: These numbers assume that the origin is at the upstream side of the BEAM DUMP. 
# 
# Generate particles at (0,0,-200) 
 
 
 
sub make_bdx_main_volume 
    { 
     my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
        { 
 
        $detector{"name"}        = "bdx_real_main_volume"; 
        $detector{"mother"}      = "root"; 
        $detector{"description"} = "World"; 
        $detector{"color"}       = "666666"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        my $X = 0.; 
        my $Y = 0.; 
        my $Z = 0.; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
            my $wallthk=470.; # now it's 15cm or 470cm 
             
        my $par1 = 600.+$wallthk; 
        my $par2 = 400.+$wallthk; 
        my $par3 = 600.+$wallthk; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
            $detector{"material"}    = "G4_CONCRETE"; 
            # $detector{"material"}    = "Air"; 
        print_det(\%configuration, \%detector); 
  
 
        my $p1= $par1-$wallthk  ; 
        my $p2 =$par2-$wallthk ; 
        my $p3 =$par3-$wallthk ; 
        $detector{"name"}        = "bdx_main_volume"; 
        $detector{"mother"}      = "bdx_real_main_volume"; 
        $detector{"description"} = "concrete walls"; 
        $detector{"color"}       = "f00000"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$p1*cm $p2*cm $p3*cm"; 
        $detector{"material"}    = "G4_Galactic"; 
        print_det(\%configuration, \%detector); 
    } 
    else 
    { 
    $detector{"name"}        = "bdx_main_volume"; 
    $detector{"mother"}      = "root"; 
    $detector{"description"} = "World"; 
    $detector{"color"}       = "666666"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
     
    my $X = 0.; 
    my $Y = 0.; 
    my $Z = 0.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    my $par1 = 1000.; 
    my $par2 = 2000.; 
    my $par3 = 4000.; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "G4_Galactic"; 
    print_det(\%configuration, \%detector); 
    } 
} 
 
 
 
my $Dirt_xmin = -800 ; 
my $Dirt_xmax = +800. ; 
my $Dirt_ymin = -762. ; 
my $Dirt_ymax = +762. ;  # This is "xgrade" the depth of the beamline underground. 
my $Dirt_zmin =-1000. ; 
my $Dirt_zmax = 3200. ; 
 
 
 
# To keep the beamdump at (0,0,0) we have symmetric x,y. For z we use two joined volumes. 
 
sub make_dirt_u 
{ 
    my %detector = init_det(); 
     
    my $X = ($Dirt_xmax+$Dirt_xmin) ; 
    my $Y = ($Dirt_ymax+$Dirt_ymin) ; 
    my $Z = 0; 
    my $par1 = ($Dirt_xmax-$Dirt_xmin)/2.; 
    my $par2 = ($Dirt_ymax-$Dirt_ymin)/2.; 
    my $par3 = -($Dirt_zmin) ; 
 
    $detector{"name"}        = "dirt_u"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "Upstream side of Mother volume of Earth/dirt, below grade level"; 
    $detector{"color"}       = "f00000"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 0; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Component"; 
    print_det(\%configuration, \%detector); 
} 
sub make_dirt_d 
{ 
    my %detector = init_det(); 
     
    my $X = ($Dirt_xmax+$Dirt_xmin) ; 
    my $Y = ($Dirt_ymax+$Dirt_ymin) ; 
    my $Z = -$Dirt_zmin + ($Dirt_zmax+$Dirt_zmin)/2.; 
    my $par1 = ($Dirt_xmax-$Dirt_xmin)/2.; 
    my $par2 = ($Dirt_ymax-$Dirt_ymin)/2.; 
    my $par3 = ($Dirt_zmax+$Dirt_zmin)/2. ; 
     
    $detector{"name"}        = "dirt_d"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "Downpstream side of Mother volume of Earth/dirt, below grade level"; 
    $detector{"color"}       = "d00000"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 0; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Component"; 
    print_det(\%configuration, \%detector); 
} 
sub make_dirt 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = 0.; 
     
    $detector{"name"}        = "dirt"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "Mother volume of Earth/dirt, below grade level"; 
    $detector{"color"}       = "D0A080"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Operation: dirt_u+dirt_d"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"material"}    = "BDX_Dirt"; # if not defined use G4_SiO2 
    print_det(\%configuration, \%detector); 
} 
 
sub make_dirt_top 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y =$Dirt_ymax+300./2.; 
    my $Z = 400. ; 
    my $par1 = 800./2; 
    my $par2 = 300./2.; 
    my $par3 = -$Dirt_zmin+800/2 ; 
     
    $detector{"name"}        = "dirt_top"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "Hill protecting dump area"; 
    $detector{"color"}       = "D0A080"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Dirt"; 
    print_det(\%configuration, \%detector); 
} 
 
 
 
my $Bunker_L_inner = 914. ; 
my $Bunker_DZ_end = 548. ; 
my $Bunker_Z_upstream = -600. ; 
my $Bunker_zmin = $Bunker_Z_upstream; 
my $Bunker_zmax = $Bunker_Z_upstream + $Bunker_L_inner + $Bunker_DZ_end ; #-600+914+548 = 862
my $Bunker_dx = 564. ; 
my $Bunker_dy = 564. ; 
 
my $Bunker_cutout_l = 914 ; 
my $Bunker_cutout_r = 213./2. ; 
my $Bunker_cutout_shim = 1. ; 
 
 
 
my $Bunker_end_dc = 91. ; 
my $Bunker_end_dx = $Bunker_cutout_r + $Bunker_end_dc; 
my $Bunker_end_dz = ($Bunker_dx - ($Bunker_cutout_r + $Bunker_end_dc))/2. ;  
 
my $Bunker_dz = ($Bunker_L_inner + $Bunker_DZ_end)/2. - $Bunker_end_dz*2.+100 ;  
 
my $Bunker_main_rel_z = $Bunker_Z_upstream + ($Bunker_zmax-$Bunker_zmin)/2.-100;
 
sub make_bunker_main 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = $Bunker_main_rel_z; 
    my $par1 = $Bunker_dx; 
    my $par2 = $Bunker_dy; 
    my $par3 = $Bunker_dz; 
     
    $detector{"name"}        = "Bunker_main"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "Main block volume of concrete bunker"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
sub make_bunker_tunnel 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = -90.; 
    my $par1 = $Bunker_cutout_r; 
    my $par2 = $Bunker_cutout_r; 
    my $par3 = $Bunker_dz-90.; 
     
    $detector{"name"}        = "Bunker_tunnel"; 
    $detector{"mother"}      = "Bunker_main"; 
    $detector{"description"} = "Cutout of bunker for tunnel"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
sub make_bunker 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = $Bunker_main_rel_z; 
     
    $detector{"name"}        = "Bunker"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "Cutout of bunker for tunnell"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Operation: Bunker_main-Bunker_tunnel"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"material"}    = "BDX_Concrete"; 
    #    print_det(\%configuration, \%detector); 
} 
sub make_bunker_end 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = $Bunker_main_rel_z + $Bunker_dz + $Bunker_end_dz; 
     
    $detector{"name"}        = "Bunker_end"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "End cone of bunker"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Trd"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$Bunker_dx*cm $Bunker_end_dx*cm $Bunker_dy*cm $Bunker_end_dx*cm $Bunker_end_dz*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
     
    # add flux detectors 
    my $bunker_nflux=10; 
    my $bunker_flux_dz=40.; 
    my $bunker_flux_lx=130.; 
    my $bunker_flux_ly=130.; 
    my $bunker_flux_lz=0.01; 
    for(my $iz=0; $iz<$bunker_nflux; $iz++) 
    { 
        my %detector = init_det(); 
        $detector{"name"}        = "bunker_flux_$iz"; 
        $detector{"mother"}      = "Bunker_end"; 
        $detector{"description"} = "bunker flux detector $iz "; 
        $detector{"color"}       = "cc00ff"; 
        $detector{"style"}       = 1; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        $X = 0.; 
        $Y = 0.; 
        $Z=($iz-4.5)*$bunker_flux_dz+$bunker_flux_lz+1.; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$bunker_flux_lx*cm $bunker_flux_ly*cm $bunker_flux_lz*cm"; 
        $detector{"material"}    = "BDX_Concrete"; 
        $detector{"sensitivity"} = "flux"; 
        $detector{"hit_type"}    = "flux"; 
        my $nflux=101+$iz; 
        $detector{"identifiers"} = "id manual $nflux"; 
        # print_det(\%configuration, \%detector); 
    } 
 
} 
 
    my $beamdump_zdelta = 320; 
    my $beamdump_zmin   = 0.; 
    my $beamdump_zmax   = $beamdump_zmin + $beamdump_zdelta; 
    my $beamdump_radius = 54.5;

my $water_at_the_end=29;
my $Al_at_the_end=76.2;

my $beamdump_start;
#my $beamdump_z = -($Bunker_dz+$beamdump_zdelta/2.)+2*$Bunker_dz-$beamdump_zdelta+145-91; 

my $beamdump_z = -229.5;

 
sub make_hallaBD 
{ 
  

    my %detector = init_det(); 
   
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = $beamdump_z; 
    my $par1 = 0.; 
    my $par2 = $beamdump_radius; 
    my $par3 = $beamdump_zdelta/2.; 
    my $par4 = 0.; 
    my $par5 = 360.; 

    $detector{"name"}  = "hallaBDextvessel";
    $detector{"mother"} = "Bunker_tunnel";
    $detector{"description"} = "BD ext vessel";
    $detector{"color"} = "A05070";
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Polycone";	
    
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    my $dimen = "0.0*deg 360*deg 6*counts";
    $dimen = $dimen . " 0*cm 0*cm 0*cm 0*cm 0*cm 0*cm";
    $dimen = $dimen . " 29*cm 29*cm 53*cm 53*cm 2.28*inch 2.28*inch";
    $dimen = $dimen . " -8*cm 27*cm 47*cm 351*cm 380*cm 402*cm";
    
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = $dimen;
    $detector{"material"}    = "G4_WATER";
    print_det(\%configuration, \%detector); 

    $X=0;
    $Y=0;
    $Z=402+$beamdump_z+0.2;

    $par2=2.28;
    $par3=0.1;
    my %detector = init_det(); 
    $detector{"name"}        = "mutest_flux_bdvessel"; 
    $detector{"mother"}      = "Bunker_tunnel"; 
    $detector{"description"} = "Mu Test flux detector to sample the muon flux just out of the bd vessel"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*inch $par3*cm $par4*deg $par5*deg"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "G4_WATER"; 
    $detector{"identifiers"} = "id manual 4000"; 
    print_det(\%configuration, \%detector); 









    my %detector = init_det(); 

    $par3=$beamdump_zdelta/2.; 
    $Z=$par3;
    $par2=25.2;
    $detector{"name"}        = "hallaBD"; 
    $detector{"mother"}      = "hallaBDextvessel"; 
    $detector{"description"} = "BD vessel"; 
    $detector{"color"}       = "A05070"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "G4_WATER"; 
    print_det(\%configuration, \%detector); 
    $X = 0. ; 
    $Y = 0. ; 
    $Z = ($beamdump_zdelta/2.-$water_at_the_end-$Al_at_the_end)+$Al_at_the_end/2;

    my %detector = init_det(); 
     $par1 = 0.; 
     $par2 = 25.1; 
     $par3 = $Al_at_the_end/2.; 
     $par4 = 0.; 
     $par5 = 360.; 
    $detector{"name"}        = "hallaBD-Al-solid"; 
    $detector{"mother"}      = "hallaBD"; 
    $detector{"description"} = "Al solid dump"; 
    $detector{"color"}       = "0000FF"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "G4_Al"; 
    print_det(\%configuration, \%detector); 
    
    my $totAlPlates=0;
    my $first_plate_Z_center=-154.18;
    my $thisZ=$first_plate_Z_center;
    my $iz=0;
    my $plateID=0;
    #first 3 plates are .5inch
    my $thick=0.5;
    for ($iz=0;$iz<3;$iz++){
	my %detector = init_det();
	$par3=$thick/2;
        $detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+2*$thick*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }
    #next 3 plates are .375inch. The spacer before the first is .375inch
    $thisZ=$thisZ+(-0.5*2+0.5/2+0.375+0.375/2)*2.54;
    $thick=0.375;
    for ($iz=0;$iz<3;$iz++){
	my %detector = init_det(); 
	$par3=$thick/2;
        $detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+$thick*2*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }
    #next 8 plates are .25 inch. The spacer before the first is .25 inch
    $thisZ=$thisZ+(-.375*2+.375/2+.25+.25/2)*2.54;
    $thick=0.25;
    for ($iz=0;$iz<8;$iz++){
	my %detector = init_det(); 
	$par3=$thick/2;
        $detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+$thick*2*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }
    #next 50 plates are .188 inch. The spacer before the first is .188 inch
    $thisZ=$thisZ+(-.25*2+.25/2+.188+.188/2)*2.54;
    $thick=0.188;
    for ($iz=0;$iz<50;$iz++){
	my %detector = init_det(); 
	$par3=$thick/2;
        $detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+$thick*2*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }
    #next 16 plates are .25 inch. The spacer before the first is .25 inch
    $thisZ=$thisZ+(-.188*2+.188/2+.25+.25/2)*2.54;
    $thick=0.25;
    for ($iz=0;$iz<16;$iz++){
	my %detector = init_det(); 
	$par3=$thick/2;
        $detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+$thick*2*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }
    
    #next 9 plates are .375 inch. The spacer before the first is .375 inch
    $thisZ=$thisZ+(-.25*2+.25/2+.375+.375/2)*2.54;
    $thick=0.375;
    for ($iz=0;$iz<9;$iz++){
	my %detector = init_det(); 
        $par3=$thick/2;
	$detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+$thick*2*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }
    #next 12 plates are .5 inch. The spacer before the first is .5 inch
    $thisZ=$thisZ+(-.375*2+.375/2+.5+.5/2)*2.54;
    $thick=0.5;
    for ($iz=0;$iz<12;$iz++){
	my %detector = init_det(); 
	$par3=$thick/2;
        $detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+$thick*2*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }
    #next 12 plates are .75 inch. The spacer before the first is .5 inch, as well as the spacers in the middle
    $thisZ=$thisZ+(-0.5*2+0.5/2+0.5+0.75/2)*2.54;
    $thick=0.75;
    for ($iz=0;$iz<12;$iz++){
	my %detector = init_det(); 
	$par3=$thick/2;
        $detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+$thick*2.54+0.5*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }
    #next 6 plates are .1 inch. The spacer before the first is .5 inch, as well as the spacers in the middle
    $thisZ=$thisZ+(-.75/2+1/2)*2.54;
    $thick=1.;
    for ($iz=0;$iz<6;$iz++){
	my %detector = init_det(); 
	$par3=$thick/2;
        $detector{"name"}        = "hallaBD-Al-plates_$plateID";$plateID++; 
        $detector{"mother"}      = "hallaBD"; 
        $detector{"description"} = "Al plates $iz "; 
        $detector{"color"}       = "0000ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
        $detector{"pos"}         = "$X*cm $Y*cm $thisZ*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*inch $par4*deg $par5*deg"; 
        $detector{"material"}    = "G4_Al"; 
        print_det(\%configuration, \%detector); 
	$thisZ=$thisZ+$thick*2.54+0.5*2.54;
	$totAlPlates=$totAlPlates+$thick;
    }


    print "Total Al plates: $plateID. Tot Al (inches): $totAlPlates","\n";
     
 
} 
 
 
 
 
 
sub make_hallaBD_flux_barrel 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = 0.; 
    my $par1 = $beamdump_radius*1.1; 
    my $par2 = $beamdump_radius*1.1+0.1; 
    my $par3 = $beamdump_zdelta/2.+2.5; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "hallaBD_flux_barrel"; 
    $detector{"mother"}      = "Bunker_tunnel"; 
    $detector{"description"} = "Beamdump flux detector"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 0; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Component"; 
    print_det(\%configuration, \%detector); 
} 
sub make_hallaBD_flux_endcup 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z =    $beamdump_zdelta/2.+2.5; 
    # my $Z = $beamdump_z+$beamdump_zdelta/2.+2.5+0.05; 
 
    my $par1 = 0.; 
    my $par2 = $beamdump_radius*1.1+0.1; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "hallaBD_flux_endcup"; 
    $detector{"mother"}      = "Bunker_tunnel"; 
    $detector{"description"} = "Beamdump flux detector"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Component"; 
    print_det(\%configuration, \%detector); 
} 
sub make_hallaBD_flux 
{ 
    my %detector = init_det(); 
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = $beamdump_z; 
     
    $detector{"name"}        = "hallaBD_flux"; 
    $detector{"mother"}      = "Bunker_tunnel"; 
    $detector{"description"} = "Beamdump flux detector"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Operation: hallaBD_flux_barrel + hallaBD_flux_endcup"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 0"; 
    #print_det(\%configuration, \%detector); 
} 
 
sub make_hallaBD_flux_sample 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z =    $beamdump_zdelta/2.+2.5; 
    $Z = -$beamdump_zdelta/2.+4.; 
     
    my $par1 = 0.; 
    my $par2 = $beamdump_radius*0.95; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "hallaBD_flux_sample"; 
    $detector{"mother"}      = "hallaBD"; 
    $detector{"description"} = "Beamdump flux detector to sample em shower in BD"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 5000"; 
    #   print_det(\%configuration, \%detector); 
} 
 
#############################MUTEST PIPES#################################### 
my $mutest_pipe_x = 0.; 
my $mutest_pipe_y = 0.;
my $mutest_pipe_z = 960. + 128.; 

my $mutest_pipe_InRad = 24./2; 
my $mutest_pipe_thick = 1./2; 
my $mutest_pipe_length = 1500./2; 
 
 
sub make_mutest_pipes 
{

 for(my $iz=2; $iz<3; $iz++){ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = $Bunker_zmax+$mutest_pipe_z + $iz*280 ; 
    my $par1 = $mutest_pipe_InRad; 
    my $par2 = $mutest_pipe_InRad+$mutest_pipe_thick; 
    my $par3  =$mutest_pipe_length; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_pipe$iz"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "pipe to host muon flux detector $iz"; 
    $detector{"color"}       = "A05070"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "90*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$0*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "G4_Al"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "mutest_pipe_air$iz"; 
    $detector{"mother"}      = "mutest_pipe$iz"; 
    $detector{"description"} = "air in pipe $iz"; 
    $detector{"color"}       = "A05070"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "0*cm 0*cm 0*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "0*cm $par1*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air";
    print_det(\%configuration, \%detector); 
    
    } 
}


 
sub make_mutest_flux 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = 0. ; 
 
     
    my $par1 = 0.; 
    my $par2 = 23./2; 
    my $par3 = 0.5/2; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux"; 
    $detector{"mother"}      = "mutest_pipe_air"; 
    $detector{"description"} = "Mu Test flux detector to sample the muon flux in the pipe"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "-90*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 6000"; 
    #print_det(\%configuration, \%detector); 
} 

############################MUTEST FLUX DETECTORS############################## 

#DETECTORS INSIDE PIPES
sub make_mutest_flux_sample_pipes 
{
 
    for(my $iz=0; $iz<3; $iz++){ 
    my %detector = init_det();
 
    my $parz = 0.1; 
    my $parx = $mutest_pipe_InRad-0.01;   
    my $pary = $mutest_pipe_length; 

    my $X =  0. ; 
    my $Y =  0.;
    my $Z = 0.; 
   # my $Z = $Bunker_zmax+$mutest_pipe_z + $iz*344 ;
 
    $detector{"name"}        = "mutest_flux_sample_pipe$iz"; 
    $detector{"mother"}      = "mutest_pipe_air$iz"; 
    $detector{"description"} = "mutest flux detector inside pipe $iz"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "90*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$parx*cm $pary*cm $parz*cm"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air";
    my $flux_id = 6000 + $iz; 
    $detector{"identifiers"} = "id manual $flux_id"; 
    print_det(\%configuration, \%detector);

 } 
} 
 
#BIG ROUND DETECTORS IN FRONT OF EACH PIPE
my $fluxdet_radius = 100.0;


sub make_mutest_flux_sample_frontpipes
{ 
    
    
    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.;
    my $Zstart = $Bunker_zmax+$mutest_pipe_z - $mutest_pipe_InRad - $mutest_pipe_thick -$par3;
    for(my $iz=0; $iz<3; $iz++) 
    { 
        my %detector = init_det();

        my $X = 0.; 
        my $Y = 0.; 
        my $Z=($iz)*280. + $Zstart;
 
        $detector{"name"}        = "mutest_flux_sample_frontpipe_$iz"; 
        $detector{"mother"}      = "dirt"; 
        $detector{"description"} = "mu flux detector in front of pipe $iz "; 
        $detector{"color"}       = "cc00ff"; 
        $detector{"style"}       = 1; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Tube"; 
    	 $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
        $detector{"material"}    = "Air"; 
        $detector{"sensitivity"} = "flux"; 
        $detector{"hit_type"}    = "flux"; 
        my $nflux=7000+$iz; 
        $detector{"identifiers"} = "id manual $nflux"; 
        print_det(\%configuration, \%detector); 
    }
}


#SMALL FLUX DETECTORS ON TOP OF PIPES

sub make_mutest_flux_sample_toppipes 
{
for(my $iz=0; $iz<3; $iz++)
    { 
    my %detector = init_det(); 
    
    my $parz = 0.1; 
    my $parx = 200/2;   
    my $pary = 100/2; 
 
    my $X = 0. ;
    my $Y = 770 + $pary ;
    my $Z = $Bunker_zmax+$mutest_pipe_z + $iz*280 ;

    my $l = $Z + 290;
    my $theta = atan2 ($Y,$l);

 
     
    $detector{"name"}        = "mutest_flux_toppipe$iz"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "mutest flux detector on top of pipe $iz"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "$theta*rad 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$parx*cm $pary*cm $parz*cm"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    my $flux_id = 8000 + $iz; 
    $detector{"identifiers"} = "id manual $flux_id"; 
    print_det(\%configuration, \%detector); 
    }
}

#VARIOUS FLUXES ON BEAM AXIS
sub make_mutest_flux_sample0 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z =    $beamdump_zdelta/2.+2.5; 
 
    $Z =  300; 
    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_sample0"; 
    $detector{"mother"}      = "Bunker_tunnel"; 
    $detector{"description"} = "mutest flux detector n0"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 5000"; 
    print_det(\%configuration, \%detector); 
} 
 



 
 
sub make_mutest_flux_sample1 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z =  0;
    $Z = 316.-31.; 
  
    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_sample1"; 
    $detector{"mother"}      = "Bunker_main"; 
    $detector{"description"} = "mutest flux detector n1"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 5001"; 
    print_det(\%configuration, \%detector); 
} 
 
sub make_mutest_flux_sample2 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
  
    my $Z = 0 -90; 
    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_sample2"; 
    $detector{"mother"}      = "Bunker_end"; 
    $detector{"description"} = "mutest flux detector n2"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 5002"; 
    print_det(\%configuration, \%detector); 
} 
 
 
 
sub make_mutest_flux_sample3 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    
    my $Z =  863; 
    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_sample3"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "mutest flux detector n3"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 5003"; 
    print_det(\%configuration, \%detector); 
} 
 
sub make_mutest_flux_sample4 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    
    my $Z =  1138; 
    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_sample4"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "mutest flux detector n4"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 5004"; 
    print_det(\%configuration, \%detector); 
}


sub make_mutest_flux_sample5 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    
    my $Z =  1413; 
    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_sample5"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "mutest flux detector n5"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 5005"; 
    print_det(\%configuration, \%detector); 
}




#FLUX DETECTORS ON TOP HILL
sub make_mutest_flux_top_hill1 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ;
    my $Y = 1100. ;
    my $Z = -103 +290 -290; 
    #my $Z =  -290. + $beamdump_radius;

   # my $l = $Z + 290;
   # my $theta = atan2 ($Y,$l);

    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_top_hill1"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "mutest flux detector on top hill 1"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "90*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 9001"; 
    print_det(\%configuration, \%detector); 
}



sub make_mutest_flux_top_hill2 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ;
    my $Y = 1200. ;
    my $Z = 1000. -290; 
   # my $Z =  900.;

    my $l = $Z + 290;
    my $theta = atan2 ($Y,$l);

    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_top_hill2"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "mutest flux detector on top hill 2"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "$theta*rad 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 9002"; 
    print_det(\%configuration, \%detector); 
} 
   




sub make_mutest_flux_top_hill3 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 1250. ; 
    my $Z =  1800 - 290.;

    my $l = $Z + 290;
    my $theta = atan2 ($Y,$l);
 
    my $par1 = 0.; 
    my $par2 = 2*$fluxdet_radius; 
    my $par3 = 0.1; 
    my $par4 = 0.; 
    my $par5 = 360.; 
     
    $detector{"name"}        = "mutest_flux_top_hill3"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "mutest flux detector on top hill 3"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "$theta*rad 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"material"}    = "Air"; 
    $detector{"identifiers"} = "id manual 9003"; 
    print_det(\%configuration, \%detector); 
}

 
 
 
 
 
 
 
 
 
 
 
my  $Muon_absorber_dz = 810./2.; # Half length on muon iron 
my  $Muon_absorber_dx = 132.;    # Half width of muon absorber iron 
my  $Muon_absorber_zmax = $Bunker_zmax + $Muon_absorber_dz*2.; 
my  $Muon_absorber_c1_dz = 40./2.; # half length of upstream concrete block 
my  $Muon_absorber_iron_dz = 660./2.; # half length of iron 
my  $Muon_absorber_c2_dz = $Muon_absorber_dz-$Muon_absorber_c1_dz-$Muon_absorber_iron_dz; # half length of upstream concrete block 
 
sub make_muon_absorber 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = $Bunker_zmax+$Muon_absorber_dz; 
    my $par1 = $Muon_absorber_dx; 
    my $par2 = $Muon_absorber_dx; 
    my $par3 = $Muon_absorber_dz; 
     
    $detector{"name"}        = "muon_absorber"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "Muon absorber"; 
    $detector{"color"}       = "a0a0a0"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Dirt"; 
    print_det(\%configuration, \%detector); 
 
    $par3 = $Muon_absorber_c1_dz; 
    $Z    =-$Muon_absorber_dz + $Muon_absorber_c1_dz; 
    $detector{"name"}        = "muon_absorber_concrete1"; 
    $detector{"mother"}      = "muon_absorber"; 
    $detector{"description"} = "Muon absorber upstream concrete"; 
    $detector{"color"}       = "cccccc"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
    print "#####################################","\n"; 
     
    print $par3,"\n"; 
    print "#####################################","\n"; 
 
    $par3 = $Muon_absorber_iron_dz; 
    $Z    =-$Muon_absorber_dz + $Muon_absorber_c1_dz*2. + $Muon_absorber_iron_dz; 
    $detector{"name"}        = "muon_absorber_iron"; 
    $detector{"mother"}      = "muon_absorber"; 
    $detector{"description"} = "Muon absorber iron"; 
    $detector{"color"}       = "A05030"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Iron"; 
    print_det(\%configuration, \%detector); 
    print "#####################################","\n"; 
 
    print $par3,"\n"; 
    print "#####################################","\n"; 
  
     
    $par3 = $Muon_absorber_c2_dz; 
    $Z    = $Muon_absorber_dz - $Muon_absorber_c2_dz; 
    $detector{"name"}        = "muon_absorber_concrete2"; 
    $detector{"mother"}      = "muon_absorber"; 
    $detector{"description"} = "Muon absorber upstream concrete"; 
    $detector{"color"}       = "cccccc"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
    print "#####################################","\n"; 
     
    print $par3,"\n"; 
    print "#####################################","\n"; 
    
    # add flux detectors 
    my $absorber_nflux=20; 
    my $absorber_flux_dz=40.; 
    my $absorber_flux_lx=130.; 
    my $absorber_flux_ly=130.; 
    my $absorber_flux_lz=0.01; 
    for(my $iz=0; $iz<$absorber_nflux; $iz++) 
    { 
	$X = 0.; 
        $Y = 0.; 
        $Z=$iz*$absorber_flux_dz-$Muon_absorber_dz+$absorber_flux_lz+1.; 
        my %detector = init_det(); 
        $detector{"name"}        = "absorber_flux_$iz"; 
	if($Z>=-$Muon_absorber_dz && $Z<=-$Muon_absorber_dz+$Muon_absorber_c1_dz*2.) { # flux detector is in upstream concrete block 
	  $Z = $Z-(-$Muon_absorber_dz+$Muon_absorber_c1_dz); 
	  $detector{"mother"}      = "muon_absorber_concrete1"; 
	  $detector{"material"}    = "BDX_Concrete"; 
        } 
	elsif($Z>-$Muon_absorber_dz+$Muon_absorber_c1_dz*2. && $Z<$Muon_absorber_dz-$Muon_absorber_c2_dz*2.) { # flux detector is in iron block 
	  $Z = $Z-(-$Muon_absorber_dz+$Muon_absorber_c1_dz*2+$Muon_absorber_iron_dz); 
	  $detector{"mother"}      = "muon_absorber_iron"; 
	  $detector{"material"}    = "BDX_Iron"; 
        } 
	else { 
	  $Z = $Z-($Muon_absorber_dz-$Muon_absorber_c2_dz); 
	  $detector{"mother"}      = "muon_absorber_concrete2"; 
	  $detector{"material"}    = "BDX_Concrete"; 
	} 
        $detector{"description"} = "absorber flux detector $iz "; 
        $detector{"color"}       = "cc00ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$absorber_flux_lx*cm $absorber_flux_ly*cm $absorber_flux_lz*cm"; 
        $detector{"sensitivity"} = "flux"; 
        $detector{"hit_type"}    = "flux"; 
        my $nflux=201+$iz; 
        $detector{"identifiers"} = "id manual $nflux"; 
        # print_det(\%configuration, \%detector); 
    } 
 
} 
    my $Building_dx = 900/2. ; 
    my $Building_dy = 300/2. ;     # Headroom in detector building is 3m? 
    my $Building_dz = 900/2. ; 
 
    my $Building_cc_thick = 30 ; # Concrete walls are 30cm thick? 
 
    my $Building_x_offset = $Building_dx - 200 ; 
 
    my $Building_shaft_dx = 300/2. ; # 3x4.5 m shaft 
    my $Building_shaft_dz = 450/2. ; 
    my $Building_shaft_dy = ($Dirt_ymax/2.  - $Building_dy/2.) ; 
 
    my $Building_shaft_offset_x = $Building_dx - $Building_shaft_dx ; 
    my $Building_shaft_offset_y = $Building_dy + $Building_shaft_dy ; 
    my $Building_shaft_offset_z = -$Building_dz + $Building_shaft_dz ; 
 
sub make_det_house_outer 
{ 
    my %detector = init_det(); 
     
    my $X = $Building_x_offset ; 
    my $Y = 0. ; 
    my $Z = $Muon_absorber_zmax + ($Building_dz + $Building_cc_thick); 
    my $par1 = $Building_dx+$Building_cc_thick; 
    my $par2 = $Building_dy+$Building_cc_thick; 
    my $par3 = $Building_dz+$Building_cc_thick; 
     
    $detector{"name"}        = "Det_house_outer"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "Outer envelope of detector house"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
my $roomx = $Building_dx; 
my $roomy = $Building_dy+$Building_cc_thick/2.; 
my $roomz = $Building_dz; 
 
sub make_det_house_inner 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0.+$Building_cc_thick/2. ; 
    my $Z = 0.; 
     
    $detector{"name"}        = "Det_house_inner"; 
    $detector{"mother"}      = "Det_house_outer"; 
    $detector{"description"} = "Inner envelope of detector house"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$roomx*cm $roomy*cm $roomz*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
     
} 
 
 
 
 
sub make_det_shaft_outer 
{ 
    my %detector = init_det(); 
 
     
    my $X = $Building_x_offset+ $Building_shaft_offset_x; 
    my $Y = 0. +$Building_shaft_offset_y+$Building_cc_thick/2.; 
    my $Z = $Muon_absorber_zmax + ($Building_dz + $Building_cc_thick)+$Building_shaft_offset_z; 
 
 
    my $par1 = $Building_shaft_dx+$Building_cc_thick; 
    my $par2 = $Building_shaft_dy-$Building_cc_thick/2.; 
    my $par3 = $Building_shaft_dz+$Building_cc_thick; 
     
    $detector{"name"}        = "Det_shaft_outer"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "Outer envelope of shaft"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
     print_det(\%configuration, \%detector); 
} 
sub make_det_shaft_inner 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = 0.; 
     
    my $par1 = $Building_shaft_dx; 
    my $par2 = $Building_shaft_dy-$Building_cc_thick/2.; 
    my $par3 = $Building_shaft_dz; 
     
    $detector{"name"}        = "Det_shaft_inner"; 
    $detector{"mother"}      = "Det_shaft_outer"; 
    $detector{"description"} = "Inner envelope of shaft"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
 
 
 
 
 
my  $Building_stair_dz=$Building_dz-$Building_shaft_dz ; 
my $Building_stair_dx =$Building_dz; 
my $Building_stair_dy = ($Dirt_ymax/2.  - $Building_dy/2.) ; 
 
my $Building_stair_offset_x = $Building_dx - $Building_stair_dx ; 
my $Building_stair_offset_y = $Building_dy + $Building_stair_dy ; 
my $Building_stair_offset_z = -$Building_dz + $Building_stair_dz+2*$Building_shaft_dz ; 
 
 
 
sub make_stair_outer 
{ 
    my %detector = init_det(); 
     
     
    my $X = $Building_x_offset+ $Building_stair_offset_x; 
    my $Y = 0. +$Building_stair_offset_y +$Building_cc_thick/2.; 
    my $Z = $Muon_absorber_zmax + ($Building_dz + 2*$Building_cc_thick)+$Building_stair_offset_z; 
    
     
    my $par1 = $Building_stair_dx+$Building_cc_thick; 
    my $par2 = $Building_stair_dy-$Building_cc_thick/2.; 
    my $par3 = $Building_stair_dz; 
     
    $detector{"name"}        = "Stair_outer"; 
    $detector{"mother"}      = "dirt"; 
    $detector{"description"} = "Outer stair"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
sub make_stair_inner 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = 0.; 
     
    my $par1 = $Building_stair_dx; 
    my $par2 = $Building_stair_dy-$Building_cc_thick/2.; 
    my $par3 = $Building_stair_dz-$Building_cc_thick; 
    
    $detector{"name"}        = "Stair_inner"; 
    $detector{"mother"}      = "Stair_outer"; 
    $detector{"description"} = "Inner stair"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
 
my $strwallposz=(-$Building_dz/2+$Building_stair_dz+3/2.*$Building_cc_thick); 
 
print $strwallposz; 
 
sub make_stair_wall 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = $strwallposz; 
     
    my $par1 = $Building_stair_dx; 
    my $par2 = $Building_dy+$Building_cc_thick/2.; 
    my $par3 = $Building_cc_thick/2; 
     
    $detector{"name"}        = "Stair_wall"; 
    $detector{"mother"}      = "Det_house_inner"; 
    $detector{"description"} = "Stair wall "; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
sub make_stair_wall_door 
{ 
    my %detector = init_det(); 
     
    my $door_l = 80. ; 
    my $door_h = 250. ; 
    my $door_p = -50. ; 
    my $X =  $door_p; 
    my $Y = -(2*($Building_dy+$Building_cc_thick/2.)-$door_h)/2; 
    my $Z = 0.; 
     
    my $par1 = $door_l/2.; 
    my $par2 = $door_h/2; 
    my $par3 = $Building_cc_thick/2; 
     
    $detector{"name"}        = "Stair_wall_door"; 
    $detector{"mother"}      = "Stair_wall"; 
    $detector{"description"} = "Stair gate"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
sub make_shaft_wall 
{ 
    my %detector = init_det(); 
     
    my $X = +$Building_shaft_offset_x-$Building_shaft_dx-$Building_cc_thick/2.; 
    my $Y = 0. ; 
    my $Z = 0.-$Building_dz/2.+$Building_cc_thick/2.; 
     
    my $par1 = $Building_cc_thick/2; 
    my $par2 = $Building_dy+$Building_cc_thick/2.; 
    my $par3 = $Building_shaft_dz+$Building_cc_thick/2.; 
     
    $detector{"name"}        = "Shaft_wall"; 
    $detector{"mother"}      = "Det_house_inner"; 
    $detector{"description"} = "Shaft wall"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
sub make_shaft_wall_door 
{ 
    my %detector = init_det(); 
     
    my $door_l = 300. ; 
    my $door_h = 150. ; 
    my $door_p = -50. ; 
    my $X = 0.; 
    my $Y =  -(2*($Building_dy+$Building_cc_thick/2.)-$door_h)/2; 
    my $Z = $door_p; 
     
    my $par1 = $Building_cc_thick/2; 
    my $par2 = $door_h/2; 
    my $par3 = $door_l/2.; 
     
    $detector{"name"}        = "Shaft_wall_door"; 
    $detector{"mother"}      = "Shaft_wall"; 
    $detector{"description"} = "Shaft gate"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
 
 
my $ext_house_shift_dz=$Muon_absorber_zmax + ($Building_dz + $Building_cc_thick)-$Dirt_zmin - ($Dirt_zmax+$Dirt_zmin)/2.+100; 
my $ext_house_dy=300./2.; 
sub make_ext_house_outer 
{ 
    my %detector = init_det(); 
     
    my $X = $Building_x_offset ; 
    my $Y = ($Dirt_ymax-$Dirt_ymin)/2.+ $ext_house_dy+$Building_cc_thick; 
    my $Z = $ext_house_shift_dz; 
    my $par1 = $Building_dx+$Building_cc_thick; 
    my $par2 = $ext_house_dy+$Building_cc_thick; 
    my $par3 = $Building_dz+$Building_cc_thick; 
     
    $detector{"name"}        = "ext_house_outer"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "Outer envelope of externalr building"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
sub make_ext_house_inner 
{ 
    my %detector = init_det(); 
     
    my $X = 0. ; 
    my $Y = 0. ; 
    my $Z = 0.; 
    my $par1 = $Building_dx; 
    my $par2 = $ext_house_dy; 
    my $par3 = $Building_dz; 
     
    $detector{"name"}        = "ext_house_inner"; 
    $detector{"mother"}      = "ext_house_outer"; 
    $detector{"description"} = "Inner envelope of external building"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
sub make_ext_house_shaft_hole 
{ 
    my %detector = init_det(); 
     
    my $X = $Building_dx-$Building_shaft_dx ; 
    my $Y = -$ext_house_dy-$Building_cc_thick/2.; 
    my $Z = -($Building_stair_dz-$Building_cc_thick); 
    my $par1 = $Building_shaft_dx; 
    my $par2 = $Building_cc_thick/2.; 
    my $par3 = $Building_dz-($Building_stair_dz-$Building_cc_thick); 
     
    $detector{"name"}        = "ext_house_shaft_hole"; 
    $detector{"mother"}      = "ext_house_outer"; 
    $detector{"description"} = "Shaft hall in the ext building floor"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
sub make_ext_house_stair_hole 
{ 
    my %detector = init_det(); 
     
    my $X =  $Building_stair_offset_x; 
    my $Y = -$ext_house_dy-$Building_cc_thick/2.; 
    my $Z =  $Building_dz-$Building_stair_dz+$Building_cc_thick; 
    my $par1 = $Building_stair_dx; 
    my $par2 = $Building_cc_thick/2.; 
    my $par3 = $Building_stair_dz-$Building_cc_thick; 
     
    $detector{"name"}        = "ext_house_stair_hole"; 
    $detector{"mother"}      = "ext_house_outer"; 
    $detector{"description"} = "Shaft hall in the ext building floor"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
sub make_stair_steps_1 
{ 
    my %detector = init_det(); 
     
    my $X =  0.; 
    my $Y = 50.; 
    my $Z =  -($Building_stair_dz-$Building_cc_thick)/2.; 
    my $par1 = $Building_stair_dx; 
    my $par2 = $Building_cc_thick/2.; 
    my $par3 = ($Building_stair_dz-$Building_cc_thick)/2.; 
    my $par4 = 0. ; 
    my $par5 = 0. ; 
    my $par6 = 0. ; 
     
    $detector{"name"}        = "stair_steps_1"; 
    $detector{"mother"}      = "Stair_inner"; 
    $detector{"description"} = "Shaft hall in the ext building floor"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Parallelepiped"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0.*deg 0.*deg 30*deg"; 
    
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg $par6*deg"; 
 
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
sub make_stair_steps_2 
{ 
    my %detector = init_det(); 
     
    my $X =  300.; 
    my $Y = -220.; 
    my $Z =  ($Building_stair_dz-$Building_cc_thick)/2.; 
    my $par1 = 0.25*$Building_stair_dx; 
    my $par2 = $Building_cc_thick/2.; 
    my $par3 = ($Building_stair_dz-$Building_cc_thick)/2.; 
    my $par4 = 0. ; 
    my $par5 = 0. ; 
    my $par6 = 0. ; 
     
    $detector{"name"}        = "stair_steps_2"; 
    $detector{"mother"}      = "Stair_inner "; 
    $detector{"description"} = "Shaft hall in the ext building floor"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Parallelepiped"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0.*deg 0.*deg -30*deg"; 
     
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg $par6*deg"; 
     
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
sub make_stair_steps_3 
{ 
    my %detector = init_det(); 
     
    my $X =  -80.; 
    my $Y =  0.; 
    my $Z =  2.*($Building_stair_dz-$Building_cc_thick)-38.; 
    my $par1 = 0.67*$Building_stair_dx; 
    my $par2 = $Building_cc_thick/2.; 
    my $par3 = ($Building_stair_dz-$Building_cc_thick)/2.; 
    my $par4 = 0. ; 
    my $par5 = 0. ; 
    my $par6 = 0. ; 
     
    $detector{"name"}        = "stair_steps_3"; 
    $detector{"mother"}      = "Det_house_inner "; 
    $detector{"description"} = "Shaft hall in the ext building floor"; 
    $detector{"color"}       = "A0A0A0"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Parallelepiped"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0.*deg 0.*deg -30*deg"; 
     
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg $par6*deg"; 
     
    $detector{"material"}    = "BDX_Concrete"; 
    print_det(\%configuration, \%detector); 
} 
 
################################################################################################# 
# 
# End: Hall-A beam dump 
# 
################################################################################################# 
 
################################################################################################# 
# 
# Start: BDX-p veto 
# 
################################################################################################# 
 
# inner veto 
$cormo_iveto_gap=1.; 
$cormo_iveto_tn=1./2.; 
$cormo_iveto_lx=20.; 
$cormo_iveto_ly=20.; 
$cormo_iveto_lz=52.9; 
 
# lead shield 
$cormo_leadshield_tn=5./2.; 
$cormo_leadshield_gap=1.; 
$cormo_leadshield_lx=$cormo_iveto_lx+$cormo_leadshield_gap+2*$cormo_leadshield_tn; 
$cormo_leadshield_ly=$cormo_iveto_ly+$cormo_leadshield_gap+2*$cormo_iveto_tn; 
$cormo_leadshield_lz=$cormo_iveto_lz+$cormo_leadshield_gap+2*$cormo_leadshield_tn; 
 
# outer veto 
$cormo_oveto_gap=1.; 
$cormo_oveto_tn=1.; 
$cormo_oveto_lx=$cormo_leadshield_lx+$cormo_oveto_gap+2*$cormo_oveto_tn; 
$cormo_oveto_ly=$cormo_leadshield_ly+$cormo_oveto_gap+2*$cormo_leadshield_tn; 
$cormo_oveto_lz=$cormo_leadshield_lz+$cormo_oveto_gap+2*$cormo_oveto_tn; 
$cormo_oveto_dz=$cormo_oveto_lz/2.; 
 
$cormo_z=0.; 
$cormo_box_lx=$cormo_iveto_lx-$cormo_iveto_tn; 
$cormo_box_ly=$cormo_iveto_ly-$cormo_iveto_tn; 
$cormo_box_lz=$cormo_iveto_lz-$cormo_iveto_tn; 
 
 
 
 
# Start inner veto 
# UP=1 
# Bottom=3 
# Downstream (Z bigger)=0 
# Upstream (Z smaller or negative)=2 
# Right (looking at the beam from the front - from Z positive)=5 
# Left (looking at the beam from the front - from Z positive)=4 
 
# shift for jlab location (wrt the hall) 
my $jshiftx=-$Building_x_offset; 
my $jshifty=0; 
my $jshiftz=-$Building_cc_thick/2.-($Muon_absorber_zmax + ($Building_dz + $Building_cc_thick)); 
 
 
 
# starting from 0,0,0 define the different shifts 
 my $shX=0.; 
 my $shY=0.; 
 my $shZ=0.; 
if (($flag_JlabCT) eq ("1")) 
{   $shX=-$Building_x_offset; 
    $shY=0.; 
    $shZ=-($Building_dz-$Building_cc_thick/2)+240;} 
 
 
sub make_cormo_iveto 
{ 
    my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
     
    $detector{"name"}        = "cormo_iveto_top"; 
    $detector{"description"} = "inner veto top"; 
    $detector{"color"}       = "0000FF"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    my $cormo_iveto_lx=40.1/2; 
    my $cormo_iveto_ly=1.0/2.; 
    my $cormo_iveto_lz=105.8/2.; 
    my $X = $shX + 0.; 
    my $Y = $shY + (35.1+1.0)/2.+0.5; 
    my $Z = $shZ + 0.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$cormo_iveto_lx*cm $cormo_iveto_ly*cm $cormo_iveto_lz*cm"; 
    $detector{"material"}    = "ScintillatorB"; 
    $detector{"sensitivity"} = "veto"; 
    $detector{"hit_type"}    = "veto"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 1 channel manual 1"; 
    print_det(\%configuration, \%detector); 
 
    $detector{"name"}        = "cormo_iveto_bottom"; 
    $detector{"description"} = "inner veto bottom"; 
    $cormo_iveto_lx=42.8/2; 
    $cormo_iveto_ly=1.0/2.; 
    $cormo_iveto_lz=98.5/2.; 
    $X = $shX + 0.; 
    $Y = $shY -((35.1+1.0)/2+0.2); 
    $Z = $shZ -(105.8-98.5)/2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_iveto_lx*cm $cormo_iveto_ly*cm $cormo_iveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 1 channel manual 2"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "cormo_iveto_upstream"; 
    $detector{"description"} = "inner veto upstream"; 
    $cormo_iveto_lx=40.8/2; 
    $cormo_iveto_ly=34.6/2.; 
    $cormo_iveto_lz=1.0/2.; 
    $X = $shX +0.; 
    $Y = $shY -(35.1-34.6)/2; 
    $Z = $shZ -(105.8-1.0)/2.+0.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_iveto_lx*cm $cormo_iveto_ly*cm $cormo_iveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 1 channel manual 3"; 
    print_det(\%configuration, \%detector); 
 
    #$detector{"name"}        = "cormo_iveto_downstream-full"; 
    #$detector{"description"} = "inner veto downstream"; 
    #my $cormo_iveto_lx=40.8/2; 
    #my $cormo_iveto_ly=34.6/2.; 
    #my $cormo_iveto_lz=1.0/2.; 
    #my $X = 0.; 
    #my $Y = -(35.1-34.6)/2; 
    #my $Z = +(105.8-1.0-(105.8-103.2))/2.-15.; 
    #$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    #$detector{"dimensions"}  = "$cormo_iveto_lx*cm $cormo_iveto_ly*cm $cormo_iveto_lz*cm"; 
    #$detector{"identifiers"} = "sector manual 0 veto manual 1 channel manual 2"; 
    #print_det(\%configuration, \%detector); 
    $detector{"name"}        = "cormo_iveto_downstream1"; 
    $detector{"description"} = "inner veto downstream"; 
    $cormo_iveto_lx=40.8/2; 
    $cormo_iveto_ly=(34.6-2.00)/2; 
    $cormo_iveto_lz=1.0/2.; 
    $X = $shX + 0.; 
    $Y = $shY -(35.1-34.6)/2+2.00/2.; 
    $Z =  $shZ -(105.8-103.2)/2.+103.2/2.+0.5-4.5; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_iveto_lx*cm $cormo_iveto_ly*cm $cormo_iveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 1 channel manual 4"; 
    print_det(\%configuration, \%detector); 
    #$detector{"name"}        = "cormo_iveto_downstream2"; 
    #$detector{"description"} = "inner veto downstream"; 
    #my $cormo_iveto_lx=(40.8-12.)/2; 
    #my $cormo_iveto_ly=34.6/2.-(34.6-2.00)/2.; 
    #my $cormo_iveto_lz=1.0/2.; 
    #my $X = 0.+12./2.; 
    #my $Y = -(35.1-34.6)/2-(34.6-2.00)/2.; 
    #my $Z = +(105.8-1.0-(105.8-103.2))/2.-15.; 
    #$detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    #$detector{"dimensions"}  = "$cormo_iveto_lx*cm $cormo_iveto_ly*cm $cormo_iveto_lz*cm"; 
    #$detector{"identifiers"} = "sector manual 0 veto manual 1 channel manual 2"; 
    #print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "cormo_iveto_right"; 
    $detector{"description"} = "inner veto right"; 
    $cormo_iveto_lx=1.0/2; 
    $cormo_iveto_ly=35.1/2.; 
    $cormo_iveto_lz=103.2/2.; 
    $X = $shX -(42.8-1.0)/2.; 
    $Y = $shY + 0.; 
    $Z = $shZ -(105.8-103.2)/2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_iveto_lx*cm $cormo_iveto_ly*cm $cormo_iveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 1 channel manual 5"; 
    print_det(\%configuration, \%detector); 
 
    $detector{"name"}        = "cormo_iveto_left"; 
    $detector{"description"} = "inner veto left"; 
    $X = $shX +(42.8-1.0)/2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_iveto_tn*cm $cormo_iveto_ly*cm $cormo_iveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 1 channel manual 6"; 
    print_det(\%configuration, \%detector); 
} 
# END inner veto 
# Lead shield 
sub make_cormo_lead 
{ 
    my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
 
    $detector{"name"}        = "cormo_lead_upstream"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    my $cormo_leadshield_lx=50./2; 
    my $cormo_leadshield_ly=50./2.; 
    my $cormo_leadshield_lz=5.0/2.; 
    my $X = $shX + 0.; 
    my $Y = $shY - ((35.1+1.0+5.0+1.0)/2+0.2)-5/2+50/2.; 
    my $Z = $shZ -(105.8+5.0)/2.-2.5; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$cormo_leadshield_lx*cm $cormo_leadshield_ly*cm $cormo_leadshield_lz*cm"; 
    $detector{"material"}    = "G4_Pb"; 
    #$detector{"material"}    = "Air"; 
    #$detector{"material"}    = "G4_WATER"; 
    print_det(\%configuration, \%detector); 
    $detector{"name"}        = "cormo_lead_downstream"; 
    $X = $shX + 0.; 
    $Z = $shZ +120+5.-(105.8+5.0)/2.+2.5; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_leadshield_lx*cm $cormo_leadshield_ly*cm $cormo_leadshield_lz*cm"; 
    print_det(\%configuration, \%detector); 
 
     
    $detector{"name"}        = "cormo_lead_bottom"; 
    $detector{"style"}       = 0; 
    $cormo_leadshield_lx=40./2; 
    $cormo_leadshield_ly=5.0/2.; 
    $cormo_leadshield_lz=120/2.; 
    $X = $shX + 0.; 
    $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2); 
    $Z = $shZ -(105.8-120)/2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_leadshield_lx*cm $cormo_leadshield_ly*cm $cormo_leadshield_lz*cm"; 
    print_det(\%configuration, \%detector); 
    $detector{"name"}        = "cormo_lead_top"; 
    $cormo_leadshield_lx=50./2; 
    $cormo_leadshield_ly=5.0/2.; 
    $cormo_leadshield_lz=130/2.; 
    $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2)+50.0+1.3; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_leadshield_lx*cm $cormo_leadshield_ly*cm $cormo_leadshield_lz*cm"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "cormo_lead_right"; 
    $detector{"style"}       = 0; 
    $cormo_leadshield_lx=5.0/2.; 
    $cormo_leadshield_ly=50./2.; 
    $cormo_leadshield_lz=120/2.; 
    $X = $shX  -(40+5.0)/2.-2.2; 
    $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2)-5/2+50/2.; 
    $Z = $shZ -(105.8-120)/2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_leadshield_lx*cm $cormo_leadshield_ly*cm $cormo_leadshield_lz*cm"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "cormo_lead_left"; 
    $X = $shX  +(40+5.0)/2.+2.2; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_leadshield_lx*cm $cormo_leadshield_ly*cm $cormo_leadshield_lz*cm"; 
     print_det(\%configuration, \%detector); 
} 
# END lead shield 
 
sub make_sarc_lead 
{ 
    my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
  
     
    $detector{"name"}        = "sarc_lead_top"; 
    $detector{"description"} = "sarc lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    my $cormo_leadshield_lx=40./2; 
    my $cormo_leadshield_ly=50./2.; 
    my $cormo_leadshield_lz=120.0/2.; 
    my $X = $shX + 0.; 
    my $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2)+75.+30; 
    my $Z = $shZ -(105.8-120)/2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$cormo_leadshield_lx*cm $cormo_leadshield_ly*cm $cormo_leadshield_lz*cm"; 
    #$detector{"material"}    = "Borotron"; 
    $detector{"material"}    = "Air"; 
    #$detector{"material"}    = "G4_GRAPHITE"; 
    print_det(\%configuration, \%detector); 
 
    my $sarc_x=0.; 
    my $sarc_y=0.; 
    my $sarc_z=0.; 
    my $sarc_dx=5.5; 
    my $sarc_dy=5; 
    my $sarc_dz=20; 
    my $sarc_th=5; 
 
    $detector{"name"}        = "sarc_lead_out"; 
    $detector{"description"} = "sarc lead shield out"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 0; 
    $detector{"type"}        = "Box"; 
    my $sarc_leadshield_lx=($sarc_dx+$sarc_th); 
    my $sarc_leadshield_ly=($sarc_dy+$sarc_th); 
    my $sarc_leadshield_lz=($sarc_dz+$sarc_th); 
    $detector{"pos"}         = "$sarc_x*cm $sarc_y*cm $sarc_z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$sarc_leadshield_lx*cm $sarc_leadshield_ly*cm $sarc_leadshield_lz*cm"; 
    $detector{"material"}    = "Component"; 
    print_det(\%configuration, \%detector); 
 
     
    $detector{"name"}        = "sarc_lead_in"; 
    $detector{"description"} = "sarc lead shield in"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 0; 
    $detector{"type"}        = "Box"; 
    my $sarc_leadshield_lx=$sarc_dx; 
    my $sarc_leadshield_ly=$sarc_dy; 
    my $sarc_leadshield_lz=$sarc_dz; 
    $detector{"pos"}         = "$sarc_x*cm $sarc_y*cm $sarc_z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$sarc_leadshield_lx*cm $sarc_leadshield_ly*cm $sarc_leadshield_lz*cm"; 
    $detector{"material"}    = "Component"; 
    print_det(\%configuration, \%detector); 
    my $sarc_x=0.; 
    my $sarc_y=-3.8; 
    my $sarc_z=3.; 
 
    $detector{"name"}        = "sarc_lead"; 
    $detector{"description"} = "sarc lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Operation:sarc_lead_out-sarc_lead_in"; 
    $detector{"pos"}         = "$sarc_x*cm $sarc_y*cm $sarc_z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"material"}    = "G4_Pb"; 
    #$detector{"material"}    = "Borotron"; 
    print_det(\%configuration, \%detector); 
 
 
} 
# END lead shield 
 
 
sub make_cormo_oveto 
{ 
    my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
 
    $detector{"name"}        = "cormo_oveto_top_upstream"; 
    $detector{"description"} = "outer veto top upstream"; 
    $detector{"color"}       = "ff8000"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    my $cormo_oveto_lx = 40./2; 
    my $cormo_oveto_ly =2.0/2 ; 
    my $cormo_oveto_lz =80./2 ;# MB May16 should be 80 
    my $X = $shX + 0; 
    my $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2)+50.0+1.3+5./2.+2/2; 
    my $Z = $shZ -(105.8-120)/2.-80./2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"material"}    = "ScintillatorB"; 
    $detector{"sensitivity"} = "veto"; 
    $detector{"hit_type"}    = "veto"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 1"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "cormo_oveto_top_downstream"; 
    $detector{"description"} = "outer veto top downstream"; 
    $detector{"color"}       = "ff8000"; 
    $Z = $shZ -(105.8-120)/2.+80./2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 2"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "cormo_oveto_bottom_upstream"; 
    $detector{"color"}       = "ff8000"; 
    $detector{"description"} = "outer veto bottom upstream"; 
    $X = $shX + 0; 
    $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2)-5/2-7-2/2.; 
    $Z = $shZ -(105.8-120)/2.-80./2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 3"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "cormo_oveto_bottom_downstream"; 
    $detector{"color"}       = "ff8000"; 
    $detector{"description"} = "outer veto bottom downstream"; 
    $Z = $shZ -(105.8-120)/2.+80./2.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 4"; 
    print_det(\%configuration, \%detector); 
 
     
 
    $detector{"style"}       = 0; 
    $detector{"name"}        = "cormo_oveto_upstream"; 
    $detector{"color"}       = "ff8000"; 
    $detector{"description"} = "outer veto upstream"; 
    $cormo_oveto_lx = 50./2; 
    $cormo_oveto_ly =56./2 ; 
    $cormo_oveto_lz =2./2 ; 
    $X = $shX + 0.; 
    $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2)-5/2+56/2; 
    $Z = $shZ -(105.8+5.0)/2.-2.5-2.5-2/2; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 5"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "cormo_oveto_downstream"; 
    $detector{"color"}       = "ff8000"; 
    $detector{"description"} = "outer veto downstream"; 
    $Z = $shZ + 120+5.-(105.8+5.0)/2.+2.5+2.5+2/2; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 6"; 
    print_det(\%configuration, \%detector); 
    $detector{"style"}       = 0; 
     
    $detector{"name"}        = "cormo_oveto_right1"; 
    $detector{"color"}       = "ff8000"; 
    $detector{"description"} = "outer veto left"; 
    $cormo_oveto_lx = 2./2; 
    $cormo_oveto_ly =80./2 ; 
    $cormo_oveto_lz =40./2 ; 
    $X = $shX  -(40+5.0)/2.-2.2-2.5-2/2-3.6; 
    $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2)-5/2-11+80/2.; 
    $Z = $shZ -(105.8+5.0)/2.-2.5-2.5+40/2+7.5;# 7.5 (and not 8.5) to make it suymmetric) 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 7"; 
    print_det(\%configuration, \%detector); 
        $detector{"style"}       = 0; 
    $detector{"name"}        = "cormo_oveto_right2"; 
    $detector{"description"} = "outer veto left"; 
    $Z = $shZ + 40.-(105.8+5.0)/2.-2.5-2.5+40/2+7.5; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 8"; 
    print_det(\%configuration, \%detector); 
    $detector{"name"}        = "cormo_oveto_right3"; 
    $Z = $shZ + 80.-(105.8+5.0)/2.-2.5-2.5+40/2+7.5; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 9"; 
    print_det(\%configuration, \%detector); 
 
    $detector{"name"}        = "cormo_oveto_left1"; 
    $detector{"color"}       = "ff8000"; 
    $detector{"description"} = "outer veto left"; 
    $cormo_oveto_lx = 2./2; 
    $cormo_oveto_ly =80./2 ; 
    $cormo_oveto_lz =40./2 ; 
    $X = $shX + -(-(40+5.0)/2.-2.2-2.5-2/2-3.6); 
    $Y = $shY -((35.1+1.0+5.0+1.0)/2+0.2)-5/2-11+80/2.; 
    $Z = $shZ -(105.8+5.0)/2.-2.5-2.5+40/2+7.5; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 10"; 
    print_det(\%configuration, \%detector); 
    $detector{"name"}        = "cormo_oveto_left2"; 
    $detector{"description"} = "outer veto left"; 
    $Z = $shZ +40.-(105.8+5.0)/2.-2.5-2.5+40/2+7.5; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 11"; 
    print_det(\%configuration, \%detector); 
    $detector{"name"}        = "cormo_oveto_left3"; 
    $Z = $shZ +80.-(105.8+5.0)/2.-2.5-2.5+40/2+7.5; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"dimensions"}  = "$cormo_oveto_lx*cm $cormo_oveto_ly*cm $cormo_oveto_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 2 channel manual 12"; 
    print_det(\%configuration, \%detector); 
 
} 
 
 
 
# define cormorino shield geometry 
# all sizes are in cm 
my $cormo_hole_r=50.; 
my $cormo_hole_h=50.; 
 
my $cormo_shield_tn_r=100.; 
my $cormo_shield_tn_h=100.; 
 
my $cormo_shield_r=$cormo_hole_r+$cormo_shield_tn_r; 
my $cormo_shield_h=$cormo_hole_h+$cormo_shield_tn_h; 
 
my $cormo_shield_nplanes=6; 
my @cormo_shield_ir = (              0.,              0.,   $cormo_hole_r,   $cormo_hole_r,              0.,              0.); 
my @cormo_shield_or = ( $cormo_shield_r, $cormo_shield_r, $cormo_shield_r, $cormo_shield_r, $cormo_shield_r, $cormo_shield_r); 
my @cormo_shield_z  = (-$cormo_shield_h,  -$cormo_hole_h,  -$cormo_hole_h,   $cormo_hole_h,   $cormo_hole_h, $cormo_shield_h); 
 
sub make_cormo_shield 
{ 
    my %detector = init_det(); 
    $detector{"name"}        = "cormo_shield"; 
    $detector{"mother"}      = "bdx_main_volume"; 
    $detector{"description"} = "cormorad shield"; 
    $detector{"color"}       = "BDBDBD"; 
    $detector{"style"}       = 0; 
    $detector{"type"}        = "Polycone"; 
    my $X = 0.; 
    my $Y = 0.; 
    my $Z = $cormo_z; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "90*deg 0*deg 0*deg"; 
    my $dimen = "0.0*deg 360*deg $cormo_shield_nplanes*counts"; 
    for(my $i = 0; $i <$cormo_shield_nplanes ; $i++) 
    { 
        $dimen = $dimen ." $cormo_shield_ir[$i]*cm"; 
    } 
    for(my $i = 0; $i <$cormo_shield_nplanes ; $i++) 
    { 
        $dimen = $dimen ." $cormo_shield_or[$i]*cm"; 
    } 
    for(my $i = 0; $i <$cormo_shield_nplanes ; $i++) 
    { 
        $dimen = $dimen ." $cormo_shield_z[$i]*cm"; 
    } 
    $detector{"dimensions"} = $dimen; 
    $detector{"material"}    = "BDX_Iron"; 
    print_det(\%configuration, \%detector); 
} 
 
 
############# 
# COSMIC cylinder (CT) 
# CT fulldet     cosmicradius=100. 
# CT cryst only  cosmicradius=50. 
# Proposal       cosmicradius=180. Z = +1950 
# Proposal       single crystal = +1830 
sub make_flux_cosmic_cyl 
{ 
    my %detector = init_det(); 
    my $cosmicradius=100.1; 
    if (($configuration{"variation"}) eq ("CT")) 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
    if ((($configuration{"variation"}) eq ("CT")) || (($configuration{"variation"} eq "Proposal") and ($flag_JlabCT eq "1"))) 
    {$cosmicradius=100.1;} #fixed cosmic radius for proto conf both jlab/ct 
 
    my $X = $shX + 0. ; 
    my $Y = $shY + 0. ; 
    my $Z = $shZ +  0;#130. 
    my $par1 = $cosmicradius; 
    my $par2 = $cosmicradius+0.01; 
    my $parz3 = ($cosmicradius/2); 
    my $par4 = 0.; 
    my $par5 = 360.; 
 
 
    $detector{"name"}        = "flux_cosmic_cyl"; 
    $detector{"description"} = "Beamdump flux detector"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "90*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $parz3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"identifiers"} = "id manual 1001"; 
    print_det(\%configuration, \%detector); 
 
    $X = $shX + 0. ; 
    $Y = $shY + $parz3 ; 
 
    $par1 =0; 
    $par2 = $cosmicradius; 
    my $par3 = 0.01; 
    $par4 = 0.; 
    $par5 = 360.; 
 
    $detector{"name"}        = "flux_cosmic_cyl_top"; 
    $detector{"description"} = "Beamdump flux detector"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "90*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"identifiers"} = "id manual 1002"; 
    print_det(\%configuration, \%detector); 
     
    $X = $shX +  0. ; 
    $Y = $shY -$parz3; 
 
    $detector{"name"}        = "flux_cosmic_cyl_bot"; 
    $detector{"description"} = "Beamdump flux detector"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Tube"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "90*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"identifiers"} = "id manual 1003"; 
    print_det(\%configuration, \%detector); 
 
} 
 
 
############# 
# COSMIC rec 
# CT fulldet     cosmicradius=50. 
# CT cryst only  cosmicradius=20. 
# Proposal       cosmicradius=65. Z = +240; Z = +1950 from the hall 
# Proposal       single crystal = +1830 
sub make_flux_cosmic_rec 
{ 
 
    my %detector = init_det(); 
    my $cosmicradius=65.; 
     
    
     
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
    if ((($configuration{"variation"}) eq ("CT")) || (($configuration{"variation"} eq "Proposal") and ($flag_JlabCT eq "1"))) 
    {$cosmicradius=49.9;} #fixed cosmic radius for proto conf both jlab/ct 
    my $cosmicradius=14.; 
 
 
    my $X = $shX +  0. ; 
    my $Y = $shY + $cosmicradius; 
    my $Z = $shZ + 0;#130. 
     
    if (($configuration{"variation"} eq "Proposal") and ($flag_JlabCT eq "0")) 
    {$X=-$Building_x_offset; 
    $Z=-($Building_dz-$Building_cc_thick/2)+240;} 
 
    my $par1 = $cosmicradius; 
    my $par2 = 0.01; 
    my $par3 = 3*$cosmicradius; 
     
     
    $detector{"name"}        = "flux_cosmic_rec_top"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "cc00aa"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"identifiers"} = "id manual 2001"; 
    print_det(\%configuration, \%detector); 
    my $Y = $shY +  -$cosmicradius; 
    $detector{"name"}        = "flux_cosmic_rec_bottom"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "cc00ff"; 
    $detector{"style"}       = 1; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm"; 
    $detector{"material"}    = "Air"; 
    $detector{"sensitivity"} = "flux"; 
    $detector{"hit_type"}    = "flux"; 
    $detector{"identifiers"} = "id manual 2002"; 
    print_det(\%configuration, \%detector); 
 
 
} 
 
######## 
## 
##  BaBar Crystals 
# ALL in cm 
# Averaging the crystal size 
# Endcap: short side X (4.3+3.9)/2=4.1cm 
my $cr_ssx=4.1/2 ; 
# Endcap: short side Y 4.7 
my $cr_ssy=4.7/2 ; 
# Endcap: long side X (5+4.6)/2=4.8cm 
my $cr_lsx=4.8/2 ; 
# Endcap: long side Y 5.4 
my $cr_lsy=5.4/2 ; 
# Endcap: lenght side Y 32.5 
my $cr_lgt=32.5/2.; 
# Mylar wrapping thikness 
my $cr_mylar=0.005/2; 
# Wrapping thikness 
my $cr_airgap=0.1/2; 
# Alveolus thikness (0.03cm if Cfiber, 0.2 cm if Al) 
my $cr_alv=0.03/2; 
 
# Wrapped crystals 
my $wr_cr_ssx=$cr_ssx+$cr_mylar; 
my $wr_cr_ssy=$cr_ssy+$cr_mylar; 
my $wr_cr_lsx=$cr_lsx+$cr_mylar; 
my $wr_cr_lsy=$cr_lsy+$cr_mylar; 
my $wr_cr_lgt=$cr_lgt+$cr_mylar; 
# Air around crystals 
my $ar_wr_cr_ssx=$wr_cr_ssx+$cr_airgap; 
my $ar_wr_cr_ssy=$wr_cr_ssy+$cr_airgap; 
my $ar_wr_cr_lsx=$wr_cr_lsx+$cr_airgap; 
my $ar_wr_cr_lsy=$wr_cr_lsy+$cr_airgap; 
my $ar_wr_cr_lgt=$wr_cr_lgt+$cr_airgap; 
# Crystal alveolus 
my $al_ar_wr_cr_ssx=$ar_wr_cr_ssx+$cr_alv; 
my $al_ar_wr_cr_ssy=$ar_wr_cr_ssy+$cr_alv; 
my $al_ar_wr_cr_lsx=$ar_wr_cr_lsx+$cr_alv; 
my $al_ar_wr_cr_lsy=$ar_wr_cr_lsy+$cr_alv; 
my $al_ar_wr_cr_lgt=$ar_wr_cr_lgt+$cr_alv; 
#distance betweens modules (arbitraty fixed at XXcm) 
my $blocks_distance=$cr_lgt*2.+5.; 
 
 
# $fg=1 Flipped crystal positioning 
# $fg=0 Unflipped crystal positioning 
my $fg=0; 
# Number of modules (blocks or sectors) 
my $nblock=8; 
# Nuumber of columns (vert or X) 
my $ncol=10; 
# Number of rows (horiz or Y) 
my $nrow=10; 
#  <----- X Y || 
#             || 
#             || 
#             \/ 
 
# makes the alveoles parallelepipedal in shape (assuming that short sides are both < long sides) 
my $irectalv=1 ; 
 
if($irectalv==1) { 
  $al_ar_wr_cr_ssy=$al_ar_wr_cr_lsy; 
    #$al_ar_wr_cr_lsx=$al_ar_wr_cr_lsy; 
  $al_ar_wr_cr_ssx=$al_ar_wr_cr_lsx; 
  $ar_wr_cr_ssy=$ar_wr_cr_lsy; 
    #$ar_wr_cr_lsx=$ar_wr_cr_lsy; 
  $ar_wr_cr_ssx=$ar_wr_cr_lsx; 
} 
 
 
# to place it in in Hall-A detector house 
my $det_dist_from_wall=110.; 
my $shiftx=-$Building_x_offset; 
my $shifty=-$Building_cc_thick/2.; 
my $shiftz=-($Building_dz-$Building_cc_thick/2)+$det_dist_from_wall; 
# CT configuration or # Prototype at JLab 
if ((($configuration{"variation"}) eq ("CT")) || (($configuration{"variation"} eq "Proposal") and ($flag_JlabCT eq "1"))) 
{   $fg=1; 
    $nblock=1; 
    $ncol=1; 
    $nrow=1; 
    $shiftx=$shX + 0.; 
    $shifty=$shY -((35.1+1.0)/2+0.2)+0.5+17.-$cr_lsx; 
    $shiftz=$shZ -(105.8-1.0)/2.+1./2+54; 
} 
#print $shiftx; 
#print $configuration{"variation"}; 
 
my $tocntx=($ncol-1)/2.*($al_ar_wr_cr_lsx+$al_ar_wr_cr_lsx); 
my $tocnty=($nrow-1)/2.*($al_ar_wr_cr_lsy+$al_ar_wr_cr_ssy); 
#print $tocnty; 
 
 
# Size of the whole calorimeter 
my $cal_sz_x=2*$al_ar_wr_cr_lsx*$ncol; 
my $cal_sz_y=2*$al_ar_wr_cr_lsy*$nrow; 
my $cal_sz_z=($nblock-1)*$blocks_distance+2*$al_ar_wr_cr_lgt; 
 
## IV 
my $iv_thk=1.0/2.; 
my $iv_lgt=100./2.; 
my $n_iv=int($cal_sz_z/($iv_lgt*2)+1); 
my $iv_wdtx=int($cal_sz_x/10.+1.)*10/2.; 
my $iv_wdty=int($cal_sz_y/10.+1.)*10/2.; 
# IV top and bottom width is increased by the thikness to have an hermetic arrangment 
my $iv_wdtxH=$iv_wdtx+2*$iv_thk; 
my $iv_nsipmx=2*int($iv_wdtxH/10.+1); 
my $iv_nsipmy=2*int($iv_wdty/10.+1); 
my $iv_nsipmu=2.; 
 
# Cal center in X, Y, Z 
my $cal_centx=($tocntx+$shiftx+$tocntx-($ncol-1)*2.*($al_ar_wr_cr_lsx+$al_ar_wr_cr_lsx)/2.+$shiftx)/2; 
my $cal_centy=($tocnty+$shifty+$tocnty-($nrow-1)*2.*($al_ar_wr_cr_ssy+$al_ar_wr_cr_lsy)/2+$shifty)/2.; 
my $cal_centz=$cal_sz_z/2.-$al_ar_wr_cr_lgt+$shiftz; 
 
## Lead 
my $ld_tol=5.0; 
my $ld_thk=5./2.; 
my $ld_lgt=$n_iv*$iv_lgt+$ld_tol/2.; 
my $ld_wdx=$iv_wdtxH+$ld_thk+$ld_tol/2.; 
my $ld_wdy=$iv_wdty+2*$iv_thk+$ld_tol/2.; 
my $ld_lgtH=$ld_lgt+2*$ld_thk; 
 
## OV 
 
my $ov_thk=2.0/2.; 
my $ov_lgt=160./2.; 
my $n_ov=int($ld_lgt*2./($ov_lgt*2)+1); 
my $ov_wdtx=int($ld_wdx/5.+1.)*5.; 
my $ov_wdty=int($ld_wdy/5.+1.)*5.; 
# OV top and bottom width is increased by the thikness to have an hermetic arrangment 
my $ov_wdtxH=$ov_wdtx; 
# OV laterals 
my $ov_wdtL=30./2.; 
my $ov_szL=$ov_wdty+10.; 
my $n_ovL=int($n_ov*$ov_lgt/$ov_wdtL+1); 
$n_ovL=int($ld_lgtH/$ov_wdtL+1); 
my $ov_lgtL=$n_ovL*$ov_wdtL; 
# OV Upstream/Downstream 
my $ov_wdxU=$ov_wdtx; 
my $ov_wdyU=$ld_wdy+2*$ld_thk; 
my $ov_zU=($ld_lgtH+$ov_thk); 
 
#print " ",$iv_posz," ",$blocks_distance+$shiftz,"\n"; 
#print " ",$iv_posx," ",$tocntx+$shiftx," ",($tocntx+$shiftx)-$ncol*($al_ar_wr_cr_lsx+$al_ar_wr_cr_lsx)/2.,"\n"; 
#print " ",$iv_posy," ",$tocnty+$shifty," ",$tocnty-($nrow-1)*2.*($al_ar_wr_cr_ssy+$al_ar_wr_cr_lsy)/2+$shifty,"\n"; 
print "#####################################","\n"; 
print "###  Room size ############","\n"; 
print "###  ","\n"; 
print "###  Room size (m) (lg X Y): ",($roomz+$strwallposz)/100.," x ",2*$roomx/100.," x ",2*$roomy/100.,"\n"; 
print "#####################################","\n"; 
print "###  DETECTOR parameters ############","\n"; 
print "###  ","\n"; 
print "###       CALORIMETER","\n"; 
print "###  Module size and number (X,Y,Z): ",$ncol," ",$nrow," ",$nblock,"\n"; 
print "###  Total crystals: ",$ncol*$nrow*$nblock,"\n"; 
print "###  Distance between modules: ",$blocks_distance-$cr_lgt*2.,"\n"; 
print "###  Cal size (cm) (lgt X Y)= ",$cal_sz_z," x ",$cal_sz_x," x ",$cal_sz_y,"\n"; 
print "###  Cal center (cm) (X Y Z)= ",$cal_centx," ",$cal_centy," ",$cal_centz,"\n"; 
print "###       IV","\n"; 
print "###  IV overall lgt=",$n_iv*$iv_lgt*2.," in ",$n_iv," pieces","\n"; 
print "###  IV TOP/BOTTOM (cm) : ",2*$iv_lgt," x ",2*$iv_wdtxH," x ",2*$iv_thk,," , ",$n_iv," pieces","\n"; 
print "###  IV sides (cm) : ",2*$iv_lgt," x ",2*$iv_wdty," x ",2*$iv_thk,," , ",$n_iv," pieces","\n"; 
print "###  IV U/D (cm) : ",2*$iv_wdtx," x ",2*$iv_wdty," x ",2*$iv_thk,," , 2 pieces","\n"; 
print "###       LEAD","\n"; 
print "###  Lead TOP/BOTTOM (cm) : ",2*$ld_lgtH," x ",2*$ld_wdx," x ",2*$ld_thk,"\n"; 
print "###  Lead sides (cm) : ",2*$ld_lgt," x ",2*$ld_wdy," x ",2*$ld_thk,"\n"; 
print "###  Lead U/D (cm) : ",2*$ld_wdx," x ",2*$ld_wdy," x ",2*$ld_thk,"\n"; 
print "###  Lead tolerance (cm): ",$ld_tol,"\n"; 
print "###  Lead weight (ton): ",2*$ld_thk*(8*($ld_wdx*$ld_lgtH)+8*$ld_wdy*($ld_wdx+$ld_lgt))*11.3/1e6,"\n"; 
print "###       OV","\n"; 
print "###  OV overall lgt=",$n_ov*$ov_lgt*2.," in ",$n_ov," pieces","\n"; 
print "###  OV TOP/BOTTOM (cm) : ",2*$ov_lgt,"x",2*$ov_wdtx,"x",2*$ov_thk," , ",$n_ov,"x2 pieces","\n"; 
print "###  OV sides (cm) : ",2*$ov_szL,"x",2*$ov_wdtL,"x",2*$ov_thk," , ",$n_ovL,"x2 pieces","\n"; 
print "###  OV U/D (cm) : ",2*$ov_wdxU,"x",2*$ov_wdyU,"x",2*$ov_thk," , 2 pieces","\n"; 
print "###      Sizes","\n"; 
print "###  Cal x= ",$cal_sz_x," IV x=",2*$iv_wdtx*2.," Lead x=",2*$ld_wdx*2.," OV x=",2*$ov_wdtx*2.,"\n"; 
print "###  Cal y= ",$cal_sz_y," IV y=",2*$iv_wdty*2, " Lead y=",2*$ld_wdy*2.," OV y=",2*$ov_wdty*2.,"\n"; 
print "###  Cal z= ",$cal_sz_z," IV z=",$n_iv*2*$iv_lgt,  " Lead z=",2*$ld_lgtH, " OV z=",$n_ov*2*$ov_lgt,"\n"; 
print "###      Electronics","\n"; 
print "###  SiPM Cal (single readout 6x6 mm): ",$ncol*$nrow*$nblock,"\n"; 
print "###  SiPM IV (2 sides readout 3x3 mm): ",2*($n_iv*($iv_nsipmx+$iv_nsipmy)+$iv_nsipmu),"\n"; 
print "###  PMTs OV (1 side readout):",2*($n_ov+$n_ovL+$ov_thk),"\n"; 
print "###  ","\n"; 
print "###  END DETECTOR parameters ############","\n"; 
print "#########################################","\n"; 
 
#print "Lead x= ",$cal_sz_x," OVeto x=",$iv_wdtx*2.,"\n"; 
#print "Lead y= ",$cal_sz_y," OVeto y=",$iv_wdty*2,"\n"; 
 
 
#print "Shiftz ",$cal_sz_z,"\n"; 
 
 sub make_cry_module 
{ 
 
    if ($configuration{"variation"} eq "Proposal") 
    { 
    # add flux detectors 
    my $det_nflux=1; 
    my $det_flux_dz=40.; 
    my $det_flux_lx=130.; 
    my $det_flux_ly=130.; 
    my $det_flux_lz=0.01; 
    for(my $iz=0; $iz<$det_nflux; $iz++) 
    { 
        my %detector = init_det(); 
        $detector{"name"}        = "det_flux_$iz"; 
        $detector{"mother"}      = "Det_house_inner"; 
        $detector{"description"} = "det flux detector $iz "; 
        $detector{"color"}       = "cc00ff"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        my $X = $cal_centx; 
        my $Y = $cal_centy; 
        my $Z=($iz+1)*$det_flux_dz+$det_flux_lz+1.-$Building_dz; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$det_flux_lx*cm $det_flux_ly*cm $det_flux_lz*cm"; 
        $detector{"material"}    = "Air"; 
        $detector{"sensitivity"} = "flux"; 
        $detector{"hit_type"}    = "flux"; 
        my $nflux=301+$iz; 
        $detector{"identifiers"} = "id manual $nflux"; 
        print_det(\%configuration, \%detector); 
        } 
    } 
     
     
     
    #    print $tocntx; 
 
    for(my $im=0; $im<($nblock); $im++) 
    { 
    for(my $ib=0; $ib<($ncol); $ib++) 
    { 
         for(my $ir=0; $ir<($nrow); $ir++) 
        { 
            my $rot=$fg*180.*((int(($ib+1.)/2.)-int(($ib)/2.))-(int(($ir+1.)/2.)-int(($ir)/2.)))+180.; 
            # Carbon/Aluminum alveols 
            my %detector = init_det(); 
            $detector{"name"}        = "cry_alveol_$ib"."_"."$ir"."_"."$im"; 
            if ($configuration{"variation"} eq "CT") 
            {$detector{"mother"}      = "bdx_main_volume";} 
            else 
            {$detector{"mother"}      = "Det_house_inner";} 
             
 
            $detector{"description"} = "Carbon/Al container_$ib"."_"."$ir"."_"."$im"; 
            $detector{"color"}       = "00ffff"; 
            $detector{"style"}       = 0; 
            $detector{"visible"}     = 1; 
            $detector{"type"}        = "Trd"; 
            my $X = $tocntx-$ib*2.*($al_ar_wr_cr_lsx+$al_ar_wr_cr_lsx)/2.+$shiftx; 
            my $Y = $tocnty-$ir*2.*($al_ar_wr_cr_ssy+$al_ar_wr_cr_lsy)/2+$shifty ; 
            my $Z = $im*$blocks_distance+$shiftz; 
            $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
            $detector{"rotation"}    = "0*deg $rot*deg 0*deg"; 
            my $par1 =$al_ar_wr_cr_ssx ; 
            my $par2 =$al_ar_wr_cr_lsx; 
            my $par3 =$al_ar_wr_cr_ssy  ; 
            my $par4 =$al_ar_wr_cr_lsy  ; 
            my $par5 =$al_ar_wr_cr_lgt ; 
            $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm"; 
            $detector{"material"}    = "CarbonFiber"; 
             print_det(\%configuration, \%detector); 
            #print  " cryst",$Z," ","\n"; 
             
            # Air layer 
            %detector = init_det(); 
            $detector{"name"}        = "cry_air_$ib"."_"."$ir"."_"."$im"; 
            $detector{"mother"}      = "cry_alveol_$ib"."_"."$ir"."_"."$im"; 
            #$detector{"mother"}      = "Det_house_inner"; 
            $detector{"description"} = "Air $ib"."_"."$ir"."_"."$im"; 
            $detector{"color"}       = "00ffff"; 
            $detector{"style"}       = 0; 
            $detector{"visible"}     = 1; 
            $detector{"type"}        = "Trd"; 
            $X = 0.; 
            $Y = 0.; 
            $Z = 0.; 
            $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
            $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
            $par1 =$ar_wr_cr_ssx ; 
            $par2 =$ar_wr_cr_lsx; 
            $par3 =$ar_wr_cr_ssy  ; 
            $par4 =$ar_wr_cr_lsy  ; 
            $par5 =$ar_wr_cr_lgt ; 
            $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm"; 
            $detector{"material"}    = "Air"; 
            print_det(\%configuration, \%detector); 
             
            # Mylar wrapping 
            %detector = init_det(); 
            $detector{"name"}        = "cry_mylar_$ib"."_"."$ir"."_"."$im"; 
            $detector{"mother"}      = "cry_air_$ib"."_"."$ir"."_"."$im"; 
            #$detector{"mother"}      = "Det_house_inner"; 
            $detector{"description"} = "Mylar wrapping_$ib"."_"."$ir"."_"."$im"; 
            $detector{"color"}       = "00ffff"; 
            $detector{"style"}       = 0; 
            $detector{"visible"}     = 1; 
            $detector{"type"}        = "Trd"; 
            $X = 0.; 
            $Y = 0.; 
            $Z = 0.; 
            $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
            $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
            $par1 =$wr_cr_ssx ; 
            $par2 =$wr_cr_lsx; 
            $par3 =$wr_cr_ssy  ; 
            $par4 =$wr_cr_lsy  ; 
            $par5 =$wr_cr_lgt ; 
            $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm"; 
            $detector{"material"}    = "bdx_mylar"; 
            print_det(\%configuration, \%detector); 
             
             
            # Crystals 
            %detector = init_det(); 
            $detector{"name"}        = "crystal_$ib"."_"."$ir"."_"."$im"; 
            $detector{"mother"}      = "cry_mylar_$ib"."_"."$ir"."_"."$im"; 
            #$detector{"mother"}      = "Det_house_inner"; 
            $detector{"description"} = "Crystal_$ib"."_"."$ir"."_"."$im"; 
            $detector{"color"}       = "00ffff"; 
            $detector{"style"}       = 1; 
            $detector{"visible"}     = 1; 
            $detector{"type"}        = "Trd"; 
            $X = 0.; 
            $Y = 0.; 
            $Z = 0.; 
            $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
            $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
            $par1 =$cr_ssx ; 
            $par2 =$cr_lsx; 
            $par3 =$cr_ssy  ; 
            $par4 =$cr_lsy  ; 
            $par5 =$cr_lgt ; 
            $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm"; 
            $detector{"material"}    = "CsI_Tl"; 
            #$detector{"material"}    = "Air"; 
            $detector{"sensitivity"} = "crs"; 
            $detector{"hit_type"}    = "crs"; 
            my $i_im=$im+1; 
            my $i_ir=$ir+1; 
            my $i_ib=$ib+1; 
            $detector{"identifiers"} = "sector manual $i_im xch manual $i_ir ych manual $i_ib"; 
            print_det(\%configuration, \%detector); 
             
 
         
        } 
         } 
    } 
} 
sub make_iveto 
{ 
    my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
     
    for(my $ir=0; $ir<($n_iv); $ir++) 
    { 
 
    $detector{"name"}        = "iveto_top_$ir"; 
    $detector{"description"} = "inner veto top"; 
    $detector{"color"}       = "0000FF"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    my $X = $cal_centx;; 
    my $Y = $cal_centy+$iv_wdty/2.+$iv_wdty/2.+$iv_thk; 
    my $Z = $cal_centz-$n_iv*$iv_lgt+(2*$ir+1)*$iv_lgt; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$iv_wdtxH*cm $iv_thk*cm $iv_lgt*cm "; 
    $detector{"material"}    = "ScintillatorB"; 
    $detector{"sensitivity"} = "veto"; 
    $detector{"hit_type"}    = "veto"; 
    $detector{"identifiers"} = "sector manual $ir veto manual 4 channel manual 1"; 
    print_det(\%configuration, \%detector); 
 
        $detector{"name"}        = "iveto_bottom_$ir"; 
        #$detector{"mother"}      = "Det_house_inner"; 
        $detector{"description"} = "inner veto bottom"; 
        $detector{"color"}       = "0000FF"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        $X = $cal_centx;; 
        $Y = $cal_centy-$iv_wdty/2.-$iv_wdty/2.-$iv_thk; 
        $Z = $cal_centz-$n_iv*$iv_lgt+(2*$ir+1)*$iv_lgt; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$iv_wdtxH*cm $iv_thk*cm $iv_lgt*cm "; 
        $detector{"material"}    = "ScintillatorB"; 
        $detector{"sensitivity"} = "veto"; 
        $detector{"hit_type"}    = "veto"; 
        $detector{"identifiers"} = "sector manual $ir veto manual 4 channel manual 2"; 
        print_det(\%configuration, \%detector); 
 
        $detector{"name"}        = "iveto_right_$ir"; 
        #$detector{"mother"}      = "Det_house_inner"; 
        $detector{"description"} = "inner veto right"; 
        $detector{"color"}       = "0000FF"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        $X = $cal_centx-$iv_wdtx/2.-$iv_wdtx/2.-$iv_thk; 
        $Y = $cal_centy; 
        $Z = $cal_centz-$n_iv*$iv_lgt+(2*$ir+1)*$iv_lgt; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$iv_thk*cm $iv_wdty*cm $iv_lgt*cm "; 
        $detector{"material"}    = "ScintillatorB"; 
        $detector{"sensitivity"} = "veto"; 
        $detector{"hit_type"}    = "veto"; 
        $detector{"identifiers"} = "sector manual $ir veto manual 4 channel manual 5"; 
        print_det(\%configuration, \%detector); 
 
        $detector{"name"}        = "iveto_left_$ir"; 
        #$detector{"mother"}      = "Det_house_inner"; 
        $detector{"description"} = "inner veto left"; 
        $detector{"color"}       = "0000FF"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        $X =$cal_centx+$iv_wdtx/2.+$iv_wdtx/2.+$iv_thk; 
        $Y =$cal_centy; 
        $Z = $cal_centz-$n_iv*$iv_lgt+(2*$ir+1)*$iv_lgt; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$iv_thk*cm $iv_wdty*cm $iv_lgt*cm "; 
        $detector{"material"}    = "ScintillatorB"; 
        $detector{"sensitivity"} = "veto"; 
        $detector{"hit_type"}    = "veto"; 
        $detector{"identifiers"} = "sector manual $ir veto manual 4 channel manual 6"; 
        print_det(\%configuration, \%detector); 
     
    } 
     
        $detector{"name"}        = "iveto_downstream"; 
        $detector{"description"} = "inner veto downstream"; 
        $detector{"color"}       = "0000FF"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        my $X = $cal_centx;; 
        my $Y = $cal_centy; 
        my $Z = $cal_centz+$n_iv*$iv_lgt-$iv_thk; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$iv_wdtx*cm $iv_wdty*cm $iv_thk*cm "; 
        $detector{"material"}    = "ScintillatorB"; 
        $detector{"sensitivity"} = "veto"; 
        $detector{"hit_type"}    = "veto"; 
        $detector{"identifiers"} = "sector manual 0 veto manual 4 channel manual 4"; 
        print_det(\%configuration, \%detector); 
 
    $detector{"name"}        = "iveto_upstream"; 
    $detector{"description"} = "inner veto upstream"; 
    $detector{"color"}       = "0000FF"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $X = $cal_centx;; 
    $Y = $cal_centy; 
    $Z = $cal_centz-$n_iv*$iv_lgt+$iv_thk; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$iv_wdtx*cm $iv_wdty*cm $iv_thk*cm "; 
    $detector{"material"}    = "ScintillatorB"; 
    $detector{"sensitivity"} = "veto"; 
    $detector{"hit_type"}    = "veto"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 4 channel manual 3"; 
    print_det(\%configuration, \%detector); 
 
} 
# END Proposal inner veto 
# BEGIN Porposal LEAD 
sub make_lead 
{ 
    my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
     
    my $X = $cal_centx; 
    my $Y = ($cal_centy+$iv_wdty/2.+$iv_wdty/2.+$iv_thk)+$iv_thk + $ld_thk+$ld_tol/2.; 
    my $Z = $cal_centz; 
    $detector{"name"}        = "lead_top"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$ld_wdx*cm $ld_thk*cm $ld_lgtH*cm"; 
    $detector{"material"}    = "G4_Pb"; 
    #$detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
    $Y = ($cal_centy-$iv_wdty/2.-$iv_wdty/2.-$iv_thk-$iv_thk) - $ld_thk-$ld_tol/2.; 
    $detector{"name"}        = "lead_bottom"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$ld_wdx*cm $ld_thk*cm $ld_lgtH*cm"; 
    #$detector{"material"}    = "G4_Pb"; 
    #$detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
    $X = $cal_centx; 
    $Y = $cal_centy; 
    $Z = $cal_centz-$ld_lgtH+$ld_thk; 
    $detector{"name"}        = "lead_upstream"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$ld_wdx*cm  $ld_wdy*cm $ld_thk*cm"; 
    #$detector{"material"}    = "G4_Pb"; 
    #$detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
    $Z = $cal_centz+$ld_lgtH-$ld_thk; 
    $detector{"name"}        = "lead_downstream"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$ld_wdx*cm  $ld_wdy*cm $ld_thk*cm"; 
    #$detector{"material"}    = "G4_Pb"; 
    #$detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
    $X = $cal_centx-$ld_wdx+$ld_thk; 
    $Y = $cal_centy; 
    $Z = $cal_centz; 
    $detector{"name"}        = "lead_right"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$ld_thk*cm  $ld_wdy*cm $ld_lgt*cm"; 
    #$detector{"material"}    = "G4_Pb"; 
    #$detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
    $X = $cal_centx+$ld_wdx-$ld_thk; 
    $Y = $cal_centy; 
    $Z = $cal_centz; 
    $detector{"name"}        = "lead_left"; 
    $detector{"description"} = "lead shield"; 
    $detector{"color"}       = "A9D0F5"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$ld_thk*cm  $ld_wdy*cm $ld_lgt*cm"; 
    #$detector{"material"}    = "G4_Pb"; 
    #$detector{"material"}    = "Air"; 
    print_det(\%configuration, \%detector); 
} 
 
# END Proposal LEAD 
 
 
 
 
# BEGIN Porposal OV 
sub make_oveto 
{ 
    my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
     
    for(my $ir=0; $ir<($n_ov); $ir++) 
    { 
         
        $detector{"name"}        = "oveto_top_$ir"; 
        $detector{"description"} = "Outer veto top"; 
        $detector{"color"}       = "088A4B"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        my $X = $cal_centx;; 
        my $Y = ($cal_centy+$iv_wdty/2.+$iv_wdty/2.+$iv_thk)+$iv_thk + $ld_thk+$ld_tol/2.+$ld_thk+$ov_thk; 
        my $Z = $cal_centz-$n_ov*$ov_lgt+(2*$ir+1)*$ov_lgt; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$ov_wdtx*cm $ov_thk*cm $ov_lgt*cm "; 
        $detector{"material"}    = "ScintillatorB"; 
        $detector{"sensitivity"} = "veto"; 
        $detector{"hit_type"}    = "veto"; 
        $detector{"identifiers"} = "sector manual $ir veto manual 5 channel manual 1"; 
        print_det(\%configuration, \%detector); 
         
        $detector{"name"}        = "oveto_bottom_$ir"; 
        $detector{"description"} = "Outer veto bottom"; 
        $detector{"color"}       = "088A4B"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        $X = $cal_centx;; 
        $Y = ($cal_centy-$iv_wdty/2.-$iv_wdty/2.-$iv_thk)-$iv_thk - $ld_thk-$ld_tol/2.-$ld_thk-$ov_thk; 
        $Z = $cal_centz-$n_ov*$ov_lgt+(2*$ir+1)*$ov_lgt; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$ov_wdtx*cm $ov_thk*cm $ov_lgt*cm ";   
        $detector{"material"}    = "ScintillatorB"; 
        $detector{"sensitivity"} = "veto"; 
        $detector{"hit_type"}    = "veto"; 
        $detector{"identifiers"} = "sector manual $ir veto manual 5 channel manual 2"; 
        print_det(\%configuration, \%detector); 
         
         
    } 
       for(my $ir=0; $ir<($n_ovL); $ir++) 
    { 
        my $ir_rev=$n_ovL-$ir-1; 
        $detector{"name"}        = "oveto_left_$ir_rev"; 
        $detector{"description"} = "Outer veto Right"; 
        $detector{"color"}       = "088A4B"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        my $X = $cal_centx+$ov_wdtx+$ov_thk; 
        my $Y = $cal_centy; 
        my $Z = $cal_centz+($n_ovL-1)*$ov_wdtL-2*$ov_wdtL*$ir; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$ov_thk*cm $ov_szL*cm $ov_wdtL*cm"; 
        $detector{"material"}    = "ScintillatorB"; 
        $detector{"sensitivity"} = "veto"; 
        $detector{"hit_type"}    = "veto"; 
        $detector{"identifiers"} = "sector manual $ir_rev veto manual 5 channel manual 4"; 
        print_det(\%configuration, \%detector); 
         
        print  "OV  SECTOR L=",$ir_rev," Position in Z = ",$Z,"\n"; 
 
         
        $detector{"name"}        = "oveto_right_$ir_rev"; 
        $detector{"description"} = "Outer veto Left"; 
        $detector{"color"}       = "088A4B"; 
        $detector{"style"}       = 0; 
        $detector{"visible"}     = 1; 
        $detector{"type"}        = "Box"; 
        $X = $cal_centx-$ov_wdtx-$ov_thk; 
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
        $detector{"dimensions"}  = "$ov_thk*cm $ov_szL*cm $ov_wdtL*cm"; 
        $detector{"material"}    = "ScintillatorB"; 
        $detector{"sensitivity"} = "veto"; 
        $detector{"hit_type"}    = "veto"; 
        $detector{"identifiers"} = "sector manual $ir_rev veto manual 5 channel manual 3"; 
        print_det(\%configuration, \%detector); 
        print  "OV  SECTOR R=",$ir_rev," Position in Z = ",$Z,"\n"; 
         
         
    } 
    $detector{"name"}        = "oveto_downstream"; 
    $detector{"description"} = "Outer veto Downstream"; 
    $detector{"color"}       = "088A4B"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    my $X = $cal_centx; 
    my $Y = $cal_centy; 
    my $Z = $cal_centz+$ov_zU; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = " $ov_wdxU*cm $ov_wdyU*cm $ov_thk*cm"; 
    $detector{"material"}    = "ScintillatorB"; 
    $detector{"sensitivity"} = "veto"; 
    $detector{"hit_type"}    = "veto"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 5 channel manual 5"; 
    print_det(\%configuration, \%detector); 
     
    $detector{"name"}        = "oveto_upstream"; 
    $detector{"description"} = "Outer veto Upstream"; 
    $detector{"color"}       = "088A4B"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    $Z = $cal_centz-$ov_zU; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = " $ov_wdxU*cm $ov_wdyU*cm $ov_thk*cm"; 
    $detector{"material"}    = "ScintillatorB"; 
    $detector{"sensitivity"} = "veto"; 
    $detector{"hit_type"}    = "veto"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 5 channel manual 6"; 
    print_det(\%configuration, \%detector); 
     
 
} 
# END Proposal OV 
sub make_csi_pad 
{ 
    my %detector = init_det(); 
    if ($configuration{"variation"} eq "CT") 
    {$detector{"mother"}      = "bdx_main_volume";} 
    else 
    {$detector{"mother"}      = "Det_house_inner";} 
     
    $detector{"name"}        = "csi_pad_up"; 
    $detector{"description"} = "paddle over the crystal"; 
    $detector{"color"}       = "ff8000"; 
    $detector{"style"}       = 0; 
    $detector{"visible"}     = 1; 
    $detector{"type"}        = "Box"; 
    my $csi_pad_lx =12./2.; 
    my $csi_pad_ly =1.0/2 ; 
    my $csi_pad_lz =12./2 ; 
    my $X = $shiftx+ 0; 
    my $Y = $shifty-$cr_lsy-1.5-0.5+0.5+20.; 
    my $Z = $shiftz+$cr_lgt-$csi_pad_lz-8.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm"; 
    $detector{"material"}    = "ScintillatorB"; 
    $detector{"sensitivity"} = "veto"; 
    $detector{"hit_type"}    = "veto"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 3 channel manual 1"; 
    print_det(\%configuration, \%detector); 
    $detector{"name"}        = "csi_pad_down"; 
    $detector{"description"} = "baddle below the crystal"; 
    $detector{"type"}        = "Box"; 
    $csi_pad_lx =12./2.; 
    $csi_pad_ly =1.0/2 ; 
    $csi_pad_lz =12./2 ; 
    $X = $shiftx + 0; 
    $Y = $shifty-$cr_lsy-1.5-0.5; 
    $Z = $shiftz+$cr_lgt-$csi_pad_lz-8.; 
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm"; 
    $detector{"identifiers"} = "sector manual 0 veto manual 3 channel manual 2"; 
    print_det(\%configuration, \%detector); 
} 


sub make_mutest_detector
{
    
    
        my %detector = init_det();
         my $vs_top_tk=0.5;
         my $vs_side_tk=1.0;
         my $vs_lg=26.0*2.;
         my $vs_ir=20.;
        my $X = 0. ;
        my $Y = 0. ;
        my $Z = 0.;
	my $Z_det = 0.;	

        my $par1 = $vs_ir/2; #InRad
        my $par2 = ($vs_ir+$vs_side_tk)/2; #InRad+thick
    
        my $par3  =$vs_lg/2.;#length
        my $par4 = 0.;
        my $par5 = 360.;
        
        $detector{"name"}        = "mutest_vessel";
        $detector{"mother"}      = "mutest_pipe_air2";
        $detector{"description"} = "Vessel of BDX-Hodo";
        $detector{"color"}       = "A05070";
        $detector{"style"}       = 0;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Tube";
        $detector{"pos"}         = "$X*cm $Y*cm $Z_det*cm";
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "0*cm $par2*cm $par3*cm $par4*deg $par5*deg";
        $detector{"material"}    = "G4_Fe";
        print_det(\%configuration, \%detector);
 
    
    
        $detector{"name"}        = "mutest_vessel_air";
        $detector{"mother"}      = "mutest_vessel";
        $detector{"description"} = "air in BDX-Hodo vessel ";
        $detector{"color"}       = "A05070";
        $detector{"style"}       = 0;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Tube";
        $detector{"pos"}         = "0*cm 0*cm 0*cm";
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "0*cm $par1*cm $par3*cm $par4*deg $par5*deg";
        $detector{"material"}    = "Air";
        print_det(\%configuration, \%detector);
   

    my $Z = $vs_lg/2-$vs_top_tk/2 ;
    my $par2 = $vs_ir/2; #InRad
    my $par3  =$vs_top_tk/2;#length
    my $par4 = 0.;
    my $par5 = 360.;

    
    $detector{"name"}        = "mutest_vessel_top";
    $detector{"mother"}      = "mutest_vessel_air";
    $detector{"description"} = "top vessel ";
    $detector{"color"}       = "A05070";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "0*cm $par2*cm $par3*cm $par4*deg $par5*deg";
    $detector{"material"}    = "G4_Fe";
    print_det(\%configuration, \%detector);
    my $Z = -($vs_lg/2-$vs_top_tk/2) ;

    $detector{"name"}        = "mutest_vessel_bottom";
    $detector{"mother"}      = "mutest_vessel_air";
    $detector{"description"} = "top vessel ";
    $detector{"color"}       = "A05070";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "0*cm $par2*cm $par3*cm $par4*deg $par5*deg";
    $detector{"material"}    = "G4_Fe";
    print_det(\%configuration, \%detector);
    
    
    my %detector = init_det();
    # cystal
    $fg=0;
    $nblock=1;
    $ncol=1;
    $nrow=1;
    $al_ar_wr_cr_lgt=(29.5+5)/2.;
    
    
    my $rot=0;                # Carbon/Aluminum alveols
    my %detector = init_det();
    $detector{"name"}        = "cry_alveol";
    $detector{"mother"}      = "mutest_vessel_air";
    $detector{"description"} = "Carbon/Al container";
    $detector{"color"}       = "00ffff";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Trd";
    my $X = 0;
    my $Y = 0;
    my $Z = 0;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg $rot*deg 90*deg";
    my $par1 =$al_ar_wr_cr_ssx ;
    my $par2 =$al_ar_wr_cr_lsx;
    my $par3 =$al_ar_wr_cr_ssy  ;
    my $par4 =$al_ar_wr_cr_lsy  ;
    my $par5 =$al_ar_wr_cr_lgt ;
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm";
    $detector{"material"}    = "Air";
    #print_det(\%configuration, \%detector);# decomment if you want external box
    #print  " cryst",$Z," ","\n";
    
    # Air layer
    %detector = init_det();
    $detector{"name"}        = "cry_air";
    $detector{"mother"}      = "mutest_vessel_air";
    # $detector{"mother"}      = "cry_alveol"; # decomment if you want external box
    $detector{"description"} = "Air ";
    $detector{"color"}       = "00fff1";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Trd";
    $X = 0.;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $par1 =$ar_wr_cr_ssx ;
    $par2 =$ar_wr_cr_lsx;
    $par3 =$ar_wr_cr_ssy  ;
    $par4 =$ar_wr_cr_lsy  ;
    $par5 =$ar_wr_cr_lgt ;
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm";
    $detector{"material"}    = "Air";
    print_det(\%configuration, \%detector);
    
    # Mylar wrapping
    %detector = init_det();
    $detector{"name"}        = "cry_mylar";
    $detector{"mother"}      = "cry_air";
    #$detector{"mother"}      = "Det_house_inner";
    $detector{"description"} = "Mylar wrapping";
    $detector{"color"}       = "00fff2";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Trd";
    $X = 0.;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $par1 =$wr_cr_ssx ;
    $par2 =$wr_cr_lsx;
    $par3 =$wr_cr_ssy  ;
    $par4 =$wr_cr_lsy  ;
    $par5 =$wr_cr_lgt ;
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm";
    $detector{"material"}    = "bdx_mylar";
    print_det(\%configuration, \%detector);
    
    # Crystals
    %detector = init_det();
    $detector{"name"}        = "crystal in BDX-Hodo";
    $detector{"mother"}      = "cry_mylar";
    #$detector{"mother"}      = "Det_house_inner";
    $detector{"description"} = "Crystal";
    $detector{"color"}       = "00ffff";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Trd";
    $X = 0.;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $par1 =$cr_ssx ;
    $par2 =$cr_lsx;
    $par3 =$cr_ssy  ;
    $par4 =$cr_lsy  ;
    $par5 =$cr_lgt ;
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*cm $par5*cm";
    $detector{"material"}    = "CsI_Tl";
    #$detector{"material"}    = "Air";
    $detector{"sensitivity"} = "crs";
    $detector{"hit_type"}    = "crs";
    $detector{"identifiers"} = "sector manual 200 xch manual 0 ych manual 0";
    print_det(\%configuration, \%detector);
    
    # Scintillators
    # Ref system has x == Z, y == X z ==Y
    my $hodo_sc_thk = 1.2;
    $detector{"name"}        = "bdx-hodo-top";# top
    $detector{"mother"}      = "mutest_vessel_air";
    $detector{"description"} = "bdx-hodo paddle on top";
    $detector{"color"}       = "ff8000";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =10.4/2.;#short side (readout)
    my $csi_pad_ly = $hodo_sc_thk/2.; #Thikness
    my $csi_pad_lz =10.4/2 ;#long side (readout)
    my $X = 0.;
    my $Y = 0;
    my $Z = 31.6/2+7.+$hodo_sc_thk/2.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "90*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 1";
    print_det(\%configuration, \%detector);
    my $Z = -(31.6/2+1.6+$hodo_sc_thk/2.);
    $detector{"name"}        = "bdx-hodo-bot";# bottom
    $detector{"description"} = "bdx-hodo paddle on bottom";
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 2";
    print_det(\%configuration, \%detector);
    
    $detector{"name"}        = "bdx-hodo-left";# sideL
    $detector{"description"} = "bdx-hodo paddle on left side";
    $detector{"color"}       = "ff8000";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =4.0*2/2.;#short side (readout)
    my $csi_pad_ly = $hodo_sc_thk/2.; #Thikness
    my $csi_pad_lz =31.6/2 ;#long side (readout)
    my $X = 5.2-$hodo_sc_thk/2.;
    my $Y = 0;
    my $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 90*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 3";
    print_det(\%configuration, \%detector);
    my $X = -(5.2-$hodo_sc_thk/2.);
    $detector{"name"}        = "bdx-hodo-right";# Side R
    $detector{"description"} = "bdx-hodo paddle on right side";
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 4";
    print_det(\%configuration, \%detector);
    
    $detector{"name"}        = "bdx-hodo-front-ffl";# front-front-large (ffl)
    $detector{"description"} = "bdx-hodo paddle on front front large";
    $detector{"color"}       = "ff8000";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =8.0/2.;#short side (readout)
    my $csi_pad_ly = $hodo_sc_thk/2.; #Thikness
    my $csi_pad_lz =20.0/2 ;#long side (readout)
    my $X = $csi_pad_lx-0.8;
    my $Y = 5.2+$hodo_sc_thk/2.;
    my $Z = 0;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 5";
    print_det(\%configuration, \%detector);
    $detector{"name"}        = "bdx-hodo-front-fbl";# front-back-large (fbl)
    $detector{"description"} = "bdx-hodo paddle on front back large";
    my $X = -($csi_pad_lx-0.8);
    my $Y = 5.2-$hodo_sc_thk/2.;
    my $Z = 0;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 6";
    print_det(\%configuration, \%detector);
    
    $detector{"name"}        = "bdx-hodo-front-ffs";#  front-front-small (ffs)
    $detector{"description"} = "bdx-hodo paddle on front front small";
    $detector{"color"}       = "ff8000";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =2.5/2.;#short side (readout)
    my $csi_pad_ly = $hodo_sc_thk/2.; #Thikness
    my $csi_pad_lz =20.0/2 ;#long side (readout)
    my $X = -($csi_pad_lx+1.);
    my $Y = 5.2+$hodo_sc_thk/2.;
    my $Z = 0;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 7";
    print_det(\%configuration, \%detector);
    $detector{"name"}        = "bdx-hodo-front-fbs";# front-back-small (fbs)
    $detector{"description"} = "bdx-hodo paddle on front back small";
    my $X =($csi_pad_lx+1.);
    my $Y = 5.2-$hodo_sc_thk/2.;
    my $Z = 0;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 8";
    print_det(\%configuration, \%detector);

    $detector{"name"}        = "bdx-hodo-back-large";# back large (bl)
    $detector{"description"} = "bdx-hodo paddle on back large";
    $detector{"color"}       = "ff8000";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =14.4/2;#short side (readout)
    my $csi_pad_ly = $hodo_sc_thk/2.; #Thikness
    my $csi_pad_lz =20.0/2 ;#long side (readout)
    my $X = 0.;
    my $Y = -(4.0+$hodo_sc_thk/2.);
    my $Z = 0;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 9";
    print_det(\%configuration, \%detector);
    
    $detector{"name"}        = "bdx-hodo-back-bfl";# back-front-large (bfl)
    $detector{"description"} = "bdx-hodo paddle on back front large";
    $detector{"color"}       = "ff8000";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =5.0/2.;#short side (readout)
    my $csi_pad_ly = $hodo_sc_thk/2.; #Thikness
    my $csi_pad_lz =12.0/2 ;#long side (readout)
    my $X = 0.;
    my $Y = -(4.0+1.5*$hodo_sc_thk);
    my $Z = -($csi_pad_lx-0.8);
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 90*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 10";
    print_det(\%configuration, \%detector);
    $detector{"name"}        = "bdx-hodo-back-bbl";#  back-back-large bbl)
    $detector{"description"} = "bdx-hodo paddle on back back large";
    my $X = 0;
    my $Y = -(4.0+2.5*$hodo_sc_thk);
    my $Z = ($csi_pad_lx-0.8);
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 11";
    print_det(\%configuration, \%detector);
    
    $detector{"name"}        = "bdx-hodo-front-bfs";# back-front-small (bfs)
    $detector{"description"} = "bdx-hodo paddle on back front small";
    $detector{"color"}       = "ff8000";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =2.5/2.;#short side (readout)
    my $csi_pad_ly = $hodo_sc_thk/2.; #Thikness
    my $csi_pad_lz =12.0/2 ;#long side (readout)
    my $X = 0.;
    my $Y = -(4.0+1.5*$hodo_sc_thk);
    my $Z = ($csi_pad_lx+1.0);
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 12";
    print_det(\%configuration, \%detector);
    $detector{"name"}        = "bdx-hodo-front-bbs";# back-back-small (bbs)
    $detector{"description"} = "bdx-hodo paddle on back back small";
    my $X = 0.;
    my $Y = -(4.0+2.5*$hodo_sc_thk);
    my $Z = -($csi_pad_lx+1.0);
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"identifiers"} = "sector manual 0 veto manual 6 channel manual 13";
    print_det(\%configuration, \%detector);


}


 
################################################################################################# 
# 
# End: BDX-p veto 
# 
################################################################################################# 
sub make_hallA_bdx 
{ if($flag_mutest==0) 
  { 
     make_bdx_main_volume(); 
    make_dirt_u(); 
    make_dirt_d(); 
    make_dirt(); 
    make_bunker_main(); 
    make_bunker_tunnel(); 
    make_bunker(); 
    make_bunker_end(); 
    make_hallaBD(); 
    make_hallaBD_flux_barrel(); 
    make_hallaBD_flux_endcup(); 
    make_hallaBD_flux(); 
    make_hallaBD_flux_sample(); 
    make_muon_absorber(); 
    make_det_house_outer(); 
    make_det_house_inner(); 
    make_det_shaft_outer(); 
    make_det_shaft_inner(); 
    make_stair_outer(); 
    make_stair_inner(); 
    make_stair_wall(); 
    make_stair_wall_door(); 
    make_shaft_wall(); 
    make_shaft_wall_door(); 
    make_ext_house_outer(); 
    make_ext_house_inner(); 
    make_ext_house_shaft_hole(); 
    make_ext_house_stair_hole(); 
    make_stair_steps_1(); 
    make_stair_steps_2(); 
    make_stair_steps_3(); 
    #make_cry_module(); 
  } 
    else 
    { 
        make_bdx_main_volume(); 
        make_dirt_u(); 
        make_dirt_d(); 
        make_dirt(); 
        make_bunker_main(); 
        make_bunker_tunnel(); 
        make_bunker(); 
        make_bunker_end(); 
        make_hallaBD(); 
        make_hallaBD_flux_barrel(); 
        make_hallaBD_flux_endcup(); 
        make_hallaBD_flux(); 
        make_hallaBD_flux_sample(); 
        make_dirt_top(); 
 
    } 
} 
 
sub make_beamdump 
{ 
    #	make_whole(); 
    make_tunc(); 
    make_tuna(); 
    make_clab(); 
    make_iron(); 
    make_bsyv(); 
    make_wint(); 
    make_winf(); 
    make_wind(); 
    make_fsst(); 
    make_fsef(); 
    make_fssf(); 
    make_fstw(); 
    make_acst(); 
    make_acht(); 
    make_acct(); 
    make_actw(); 
    make_cest(); 
    make_cetw(); 
    make_cmb(); 
    make_cmc(); 
    make_tunce(); 
    make_tunae(); 
} 
 
# Prototype in CT 
sub make_bdx_CT 
{ 
    make_bdx_main_volume(); 
       #make_cormo_flux(); 
	   #make_cormo_det(); 
    make_cormo_iveto; 
    make_cormo_oveto; 
    make_cormo_lead(); 
    make_csi_pad(); 
    # make_flux_cosmic_cyl; 
    # make_flux_cosmic_rec; 
       #make_cormo_shield(); 
       #  make_babar_crystal(); 
       #make_cry_module_up(); 
       #make_cry_module_down(); 
    make_cry_module(); 
    #make_sarc_lead(); 
         #  make_cry_module_II(); 
} 
 
# Full detector in the center of the hall 
sub make_bdx_CT_o 
{ 
    make_bdx_main_volume(); 
    make_iveto(); 
    make_cry_module(); 
    make_lead(); 
    make_oveto(); 
    make_flux_cosmic_cyl; 
    make_flux_cosmic_rec; 
 
} 
 
 
 
 
sub make_detector_bdx 
 { 
     if (($configuration{"variation"} eq "Proposal") and ($flag_JlabCT eq "1")){ 
    #Prototype in the hall === DOS NOT WORK === 
    #make_cormo_flux(); 
    #make_cormo_det(); 
    #make_cormo_iveto; 
    #make_cormo_oveto; 
    #make_cormo_lead(); 
    #make_csi_pad(); 
    #make_cormo_shield(); 
    #make_babar_crystal(); 
    #make_cry_module_up(); 
    #make_cry_module_down(); 
     
    make_cormo_iveto; 
    make_cormo_oveto; 
    make_cormo_lead(); 
    make_csi_pad(); 
    make_flux_cosmic_cyl; 
    make_flux_cosmic_rec; 
    #make_cormo_shield(); 
    #  make_babar_crystal(); 
    #make_cry_module_up(); 
    #make_cry_module_down(); 
    make_cry_module(); 
     
    # make_flux_cosmic_cyl; 
    # make_flux_cosmic_rec; 
     
    #  make_cry_module_II(); 
     } 
     else 
     { 
         if($flag_mutest == 0) 
         { 
         #make_cormo_flux(); 
         #make_cormo_det(); 
         #make_cormo_iveto; 
         #make_cormo_oveto; 
         #make_cormo_lead(); 
         #make_csi_pad(); 
         #make_cormo_shield(); 
         #  make_babar_crystal(); 
         #make_cry_module_up(); 
         #make_cry_module_down(); 
         make_cry_module(); 
         make_iveto 
         make_lead 
         make_oveto 
         # make_flux_cosmic_cyl; 
         make_flux_cosmic_rec; 
          
         #  make_cry_module_II(); 
        } 
      
        if($flag_mutest == 1) 
        { 
            make_mutest_pipes(); 
	    make_mutest_flux_sample1(); 
	    make_mutest_flux_sample2(); 
	    make_mutest_flux_sample3(); 
	    make_mutest_flux_sample4();  
            make_mutest_flux_sample5(); 
            #make_mutest_flux_sample_pipes();
            make_mutest_flux_sample_frontpipes();
            make_mutest_flux_sample_toppipes(); 
	    make_mutest_detector();
	    make_mutest_flux_top_hill1();
	    make_mutest_flux_top_hill2();
            make_mutest_flux_top_hill3(); 
         } 
     } 
 } 
 
 
 
 
 
 
 
 
 
1; 
 
