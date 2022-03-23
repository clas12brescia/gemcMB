use strict;
use warnings;

our %configuration;


###########################################################################################
###########################################################################################
#
# all dimensions are in mm
#


my $degrad = 0.01745329252;
my $cic    = 2.54;


#################################################################################################
sub make_main_volume
    {
     my %detector = init_det();
        $detector{"name"}        = "bdx_real_main_volume";			# The position and rotation of a volume are relative to its mother volume. 
        $detector{"mother"}      = "root";					# The rotation will happen before the position. “root” is the root volume.
        $detector{"description"} = "World";
        $detector{"color"}       = "666666";					# The color entry is a 6 digit hexadecimal number that represents Red,Green and Blue weights from 0 to 255 (RRGGBB)
        $detector{"color"}       = "000000";
        $detector{"style"}       = 0;						# 1 is “solid”, 0 is “wireframe”
        $detector{"visible"}     = 1;						# 1 is “visible”, 0 is “invisible” 
        $detector{"type"}        = "Box";					# The type of geant4 solid is “box”
        my $X = 0.;
        my $Y = 0.;
        my $Z = 0.;
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
            my $wallthk=0.01; # now it's 15cm or 470cm
            
        my $par1 = 600.+$wallthk;
        my $par2 = 400.+$wallthk;
        my $par3 = 600.+$wallthk;
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm";
        $detector{"material"}    = "G4_CONCRETE";
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
        #$detector{"material"}    = "G4_AIR";
        $detector{"material"}    = "G4_Galactic";
        print_det(\%configuration, \%detector);
}


##########################################
# nVeto
##########################################
# nVeto
# starting from 0,0,0 define the different shifts
my $shX=0.;
my $shY=0.;
my $shZ=0.;

my $thickness=1./2;
my $dim=32./2;
my $Gd_thickness=0.5;


sub make_nVeto
{
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}
 
 ################################### Scintillator ##################################### 
    
 # down  
    $detector{"name"}        = "down";
    $detector{"description"} = "down side";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =$dim+2.*$thickness; 
    my $csi_pad_ly =$thickness; 
    my $csi_pad_lz =$dim; 
    my $X = 0.;
    my $Y = -$dim -$thickness;
    my $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";	#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 500 channel manual 0";
     print_det(\%configuration, \%detector);
     
      
    # up
    $detector{"name"}        = "up";
    $detector{"description"} = "up side ";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$dim+ $thickness;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 500 channel manual 1";
    print_det(\%configuration, \%detector);
    
    # right  
    $detector{"name"}        = "right";
    $detector{"description"} = "right side  ";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$thickness; 
    $csi_pad_ly =$dim;
    $csi_pad_lz =$dim; 
    $X = $dim+$thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 1 veto manual 500 channel manual 1";
     print_det(\%configuration, \%detector);
     
       # left 
    $detector{"name"}        = "left";
    $detector{"description"} = "left side ";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$thickness; 
    $csi_pad_ly =$dim; 
    $csi_pad_lz =$dim; 
    $X = - $dim-$thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 1 veto manual 500 channel manual 0";
     print_det(\%configuration, \%detector);
     
     # front  
    $detector{"name"}        = "front";
    $detector{"description"} = "front side ";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$dim +2.*$thickness; 
    $csi_pad_ly =$dim + 2.*$thickness; 
    $csi_pad_lz =$thickness; 
    $X = 0.;
    $Y = 0.;
    $Z = $dim+$thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 2 veto manual 500 channel manual 0";
     print_det(\%configuration, \%detector);
     
       # back 
    $detector{"name"}        = "back";
    $detector{"description"} = "back side ";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$dim+2.*$thickness; 
    $csi_pad_ly =$dim + 2.*$thickness; 
    $csi_pad_lz =$thickness; 
    $X = 0.;
    $Y = 0.;
    $Z = -$dim-$thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 2 veto manual 500 channel manual 1";
     print_det(\%configuration, \%detector);
 
 ################################### Liquid argon ##################################### 
  
   
       # lAr 
    $detector{"name"}        = "liquid argon";
    $detector{"description"} = "detector inside";
    $detector{"color"}       = "00ff00"; #verde
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$dim;  
    $csi_pad_ly =$dim; 
    $csi_pad_lz =$dim; 
    $X = 0.;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 90*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lz*cm $csi_pad_ly*cm $csi_pad_lx*cm";
    $detector{"material"}    = "LAr";			
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 3 veto manual 550 channel manual 0";
     print_det(\%configuration, \%detector);
  
  #q{  
 ################################### Gadolinium #####################################    
      # Gd_up
    $detector{"name"}        = "Gd_up";
    $detector{"description"} = "up side ";
    $detector{"color"}       = "0000003"; #nero
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $Gd_lx =$dim+2.*$thickness; 
    my $Gd_ly =$Gd_thickness; 
    my $Gd_lz =$dim+2.*$thickness; 
    $X = 0.;
    $Y = +$dim+ 2.*$thickness + $Gd_thickness ;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "G4_Galactic";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 580 channel manual 0";
    print_det(\%configuration, \%detector);
    
     # Gd_down
    $detector{"name"}        = "Gd_down";
    $detector{"description"} = "down side ";
    $detector{"color"}       = "0000003"; #nero
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = -$dim- 2.*$thickness - $Gd_thickness ;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 0 veto manual 580 channel manual 1";
    print_det(\%configuration, \%detector);
  
   #  Gd_right  
    $detector{"name"}        = " Gd_right";
    $detector{"description"} = "right side  ";
    $detector{"color"}       = "0000003"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$Gd_thickness; 
    $csi_pad_ly =$dim +2.*$thickness + 2.*$Gd_thickness;
    $csi_pad_lz =$dim+2.*$thickness ; 
    $X = $dim+2.*$thickness + $Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "Gd";			
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 1 veto manual 580 channel manual 1";
     print_det(\%configuration, \%detector);
     
       #  Gd_left 
    $detector{"name"}        = " Gd_left";
    $detector{"description"} = "left side ";
    $detector{"color"}       = "0000003"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $dim-2.*$thickness - $Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "Gd";			
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 1 veto manual 580 channel manual 0";
     print_det(\%configuration, \%detector);
     
     # Gd_front  
    $detector{"name"}        = "Gd_front";
    $detector{"description"} = "front side ";
    $detector{"color"}       = "0000003"; 
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$dim +2.*$thickness + 2.*$Gd_thickness; 
    $csi_pad_ly =$dim + 2.*$thickness+ 2.*$Gd_thickness; 
    $csi_pad_lz =$Gd_thickness; 
    $X = 0.;
    $Y = 0.;
    $Z = $dim+2.*$thickness +$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "Gd";			
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 2 veto manual 580 channel manual 0";
     print_det(\%configuration, \%detector);
     
       # Gd_back 
    $detector{"name"}        = "Gd_back";
    $detector{"description"} = "back side ";
    $detector{"color"}       = "0000003"; 
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$dim-2.*$thickness - $Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "Gd";			
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 2 veto manual 580 channel manual 1";
     print_det(\%configuration, \%detector); 
 # };   
  
}



sub make_flux_cosmic_sph
{
    my %detector = init_det();
    my $cosmicradius=70.;
    
    my $X = $shX + 0. ;
    my $Y = $shY  +30. ;
    my $Z = $shZ +  0.;
    
    my $par1 = $cosmicradius;
    my $par2 = $cosmicradius+0.01;
    my $parz3 = 0.;
    my $par4 = 360.;
    my $par5 = 0.;
    my $par6 = 90.;
    
    $detector{"name"}        = "flux_cosmic_sph";
    $detector{"mother"}      = "bdx_main_volume";
    $detector{"description"} = "Beamdump flux detector";
    $detector{"color"}       = "cc00ff";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Sphere";
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "90*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$par1*cm $par2*cm $parz3*cm $par4*deg $par5*deg $par6*deg";
    $detector{"material"}    = "G4_AIR";
    $detector{"sensitivity"} = "flux";
    $detector{"hit_type"}    = "flux";
    $detector{"identifiers"} = "id manual 1001";
    print_det(\%configuration, \%detector);
    
}




# END EEE chambers
################################


sub make_bdx_CT
{
    make_main_volume();
    make_nVeto;
   # make_flux_cosmic_sph;		#Crea la routine flux_cosmic che disegna la sfera
}


1;

