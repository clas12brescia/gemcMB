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
        $detector{"material"}    = "G4_Galactic";
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
my $X = 0.;
my $Y = 0.;
my $Z = 0.;


my $LAr_dim=35.6/2.;
my $Sci_thickness=10./2;
my $Sci_dim=$LAr_dim;
my $Gd_thickness=0.00025/2.;

my $passive_mat1= "G4_B";
my $pass1_thickness=25./2;
my $pass1_dim=150./2 + 2*$pass1_thickness;

my $passive_mat2= "Borotron";
my $pass2_thickness=60./2;
my $pass2_dim=$pass1_dim + 2*$pass1_thickness + 2*$pass2_thickness ;

my $passive_mat3= "G4_Pb";
my $pass3_thickness=50./2;
my $pass3_dim=$pass2_dim + 2*$pass2_thickness + 2*$pass3_thickness;




sub make_nVeto
{
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}
 
 ################################### Scintillator ##################################### 
   
 # down  1
    $detector{"name"}        = "down 1";
    $detector{"description"} = "down side 1";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $csi_pad_lx =$Sci_dim+8.*$Sci_thickness + 6*$Gd_thickness; 
    my $csi_pad_ly =$Sci_thickness; 
    my $csi_pad_lz =$Sci_dim; 
    my $X = 0.;
    my $Y = -$Sci_dim -$Sci_thickness;
    my $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";	#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 3 veto manual 100 channel manual 1";
     print_det(\%configuration, \%detector);


 # down 2 
    $detector{"name"}        = "down 2";
    $detector{"description"} = "down side 2";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = -$Sci_dim -3*$Sci_thickness - 2*$Gd_thickness;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB"; #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 3 veto manual 100 channel manual 2";
     print_det(\%configuration, \%detector);

 # down 3 
    $detector{"name"}        = "down 3";
    $detector{"description"} = "down side 3";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box"; 
    $X = 0.;
    $Y = -$Sci_dim -5*$Sci_thickness - 4*$Gd_thickness;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB"; #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 3 veto manual 100 channel manual 3";
     print_det(\%configuration, \%detector);

 # down  4
    $detector{"name"}        = "down 4";
    $detector{"description"} = "down side 4";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = -$Sci_dim -7*$Sci_thickness - 6*$Gd_thickness;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB"; #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 3 veto manual 100 channel manual 4";
     print_det(\%configuration, \%detector);           
      
      
    # up 1
    $detector{"name"}        = "up 1";
    $detector{"description"} = "up side  1";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$Sci_dim+ $Sci_thickness;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 4 veto manual 100 channel manual 1";
    print_det(\%configuration, \%detector);

    # up 2
    $detector{"name"}        = "up 2";
    $detector{"description"} = "up side 2 ";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$Sci_dim+ 3*$Sci_thickness + 2*$Gd_thickness;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 4 veto manual 100 channel manual 2";
    print_det(\%configuration, \%detector);

    # up 3 
    $detector{"name"}        = "up 3";
    $detector{"description"} = "up side 3 ";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$Sci_dim+ 5*$Sci_thickness + 4*$Gd_thickness;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 4 veto manual 100 channel manual 3";
    print_det(\%configuration, \%detector);

    # up 4
    $detector{"name"}        = "up 4";
    $detector{"description"} = "up side 4 ";
    $detector{"color"}       = "0000ff3"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$Sci_dim+ 7*$Sci_thickness + 6*$Gd_thickness;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 4 veto manual 100 channel manual 4";
    print_det(\%configuration, \%detector);
  
    # right  1
    $detector{"name"}        = "right 1";
    $detector{"description"} = "right side 1 ";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$Sci_thickness; 
    $csi_pad_ly =$Sci_dim;
    $csi_pad_lz =$Sci_dim; 
    $X = $Sci_dim+$Sci_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 1 veto manual 100 channel manual 1";
     print_det(\%configuration, \%detector);

    # right 2 
    $detector{"name"}        = "right 2";
    $detector{"description"} = "right side  2";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = $Sci_dim+3*$Sci_thickness + 2*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 1 veto manual 100 channel manual 2";
     print_det(\%configuration, \%detector);

     # right 3 
    $detector{"name"}        = "right 3";
    $detector{"description"} = "right side  3";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = $Sci_dim+5*$Sci_thickness + 4*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 1 veto manual 100 channel manual 3";
     print_det(\%configuration, \%detector);
     
     # right 4 
    $detector{"name"}        = "right 4";
    $detector{"description"} = "right side  4";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = $Sci_dim+7*$Sci_thickness + 6*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 1 veto manual 100 channel manual 4";
     print_det(\%configuration, \%detector);
     
     
       # left 1
    $detector{"name"}        = "left 1";
    $detector{"description"} = "left side 1 ";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $Sci_dim-$Sci_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 2 veto manual 100 channel manual 1";
     print_det(\%configuration, \%detector);

       # left 2
    $detector{"name"}        = "left 2";
    $detector{"description"} = "left side 2 ";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $Sci_dim-3*$Sci_thickness- 2*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 2 veto manual 100 channel manual 2";
     print_det(\%configuration, \%detector);

       # left 3
    $detector{"name"}        = "left 3";
    $detector{"description"} = "left side 3 ";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $Sci_dim-5*$Sci_thickness- 4*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 2 veto manual 100 channel manual 3";
     print_det(\%configuration, \%detector);

       # left 4
    $detector{"name"}        = "left 4";
    $detector{"description"} = "left side 4 ";
    $detector{"color"}       = "ff00003"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $Sci_dim-7*$Sci_thickness- 6*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 2 veto manual 100 channel manual 4";
     print_det(\%configuration, \%detector);


     # front 1 
    $detector{"name"}        = "front 1";
    $detector{"description"} = "front side 1";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $csi_pad_lx =$Sci_dim +8.*$Sci_thickness + 6*$Gd_thickness; 
    $csi_pad_ly =$Sci_dim +8.*$Sci_thickness + 6*$Gd_thickness; 
    $csi_pad_lz =$Sci_thickness; 
    $X = 0.;
    $Y = 0.;
    $Z = $Sci_dim+$Sci_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 5 veto manual 100 channel manual 1";
     print_det(\%configuration, \%detector);

     # front 2 
    $detector{"name"}        = "front 2";
    $detector{"description"} = "front side 2";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = $Sci_dim+3*$Sci_thickness + 2*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 5 veto manual 100 channel manual 2";
     print_det(\%configuration, \%detector);

      # front  3
    $detector{"name"}        = "front 3 ";
    $detector{"description"} = "front side 3";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = $Sci_dim +5*$Sci_thickness + 4*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 5 veto manual 100 channel manual 3";
     print_det(\%configuration, \%detector);

      # front 4
    $detector{"name"}        = "front 4";
    $detector{"description"} = "front side 4";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = $Sci_dim + 7*$Sci_thickness + 6*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 5 veto manual 100 channel manual 4";
     print_det(\%configuration, \%detector);
     
       # back 1
    $detector{"name"}        = "back 1";
    $detector{"description"} = "back side 1";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$Sci_dim-$Sci_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 6 veto manual 100 channel manual 1";
     print_det(\%configuration, \%detector);


     # back 2
    $detector{"name"}        = "back 2";
    $detector{"description"} = "back side 2";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$Sci_dim - 3*$Sci_thickness - 2*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 6 veto manual 100 channel manual 2";
     print_det(\%configuration, \%detector);

     # back 3
    $detector{"name"}        = "back 3";
    $detector{"description"} = "back side 3";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$Sci_dim - 5*$Sci_thickness - 4*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 6 veto manual 100 channel manual 3";
     print_det(\%configuration, \%detector);

    # back 4
    $detector{"name"}        = "back 4";
    $detector{"description"} = "back side 4";
    $detector{"color"}       = "ffd7003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$Sci_dim - 7*$Sci_thickness - 6*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$csi_pad_lx*cm $csi_pad_ly*cm $csi_pad_lz*cm";
    $detector{"material"}    = "ScintillatorB";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    $detector{"identifiers"} = "sector manual 6 veto manual 100 channel manual 4";
     print_det(\%configuration, \%detector);
    
} 
 ################################### Liquid argon ##################################### 
  
sub make_lAr
{   
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}

       # lAr 
    $detector{"name"}        = "liquid argon";
    $detector{"description"} = "detector inside";
    $detector{"color"}       = "00ff00"; #verde
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    my $LAr_Rmin =0.; 
    my $LAr_Rmax =$LAr_dim; 
    my $LAr_d =$LAr_dim;
    my $LAr_phi_min =0.;
    my $LAr_phi_max =2*pi; 
    $X = 0.;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "90*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$LAr_Rmin*cm $LAr_Rmax*cm $LAr_d*cm $LAr_phi_min*rad $LAr_phi_max*rad";
    $detector{"material"}    = "LAr";			
    $detector{"sensitivity"} = "det";
    $detector{"hit_type"}    = "det";
    $detector{"identifiers"} = "sector manual 3 det manual 200 channel manual 0";
     print_det(\%configuration, \%detector); 
}   

 ################################### Gadolinium #####################################    

sub make_passive_Gd
{ 
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}

 #/////////// UP /////////#

      # Gd_up 1
    $detector{"name"}        = "Gd_up 1";
    $detector{"description"} = "up side 1 ";
    $detector{"color"}       = "0000003"; #nero
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $Gd_lx =$Sci_dim+8.*$Sci_thickness + 6*$Gd_thickness; ; 
    my $Gd_ly =$Gd_thickness; 
    my $Gd_lz =$Sci_dim; 
    $X = 0.;
    $Y = +$Sci_dim+ 2.*$Sci_thickness + $Gd_thickness ;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";
    print_det(\%configuration, \%detector);

     # Gd_up 2
    $detector{"name"}        = "Gd_up 2";
    $detector{"description"} = "up side  2";
    $detector{"color"}       = "0000003"; #nero
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$Sci_dim+ 4.*$Sci_thickness + 3*$Gd_thickness ;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";
    print_det(\%configuration, \%detector);

    # Gd_up 3
    $detector{"name"}        = "Gd_up 3 ";
    $detector{"description"} = "up side 3";
    $detector{"color"}       = "0000003"; #nero
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$Sci_dim+ 6.*$Sci_thickness + 5*$Gd_thickness ;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";
    print_det(\%configuration, \%detector);

#/////////// DOWN /////////#
 
     # Gd_down 1S
    $detector{"name"}        = "Gd_down 1";
    $detector{"description"} = "down side 1";
    $detector{"color"}       = "0000003"; #nero
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = -$Sci_dim- 2.*$Sci_thickness - $Gd_thickness ;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";
    print_det(\%configuration, \%detector);

         # Gd_down 2
    $detector{"name"}        = "Gd_down 2";
    $detector{"description"} = "down side 2 ";
    $detector{"color"}       = "0000003"; #nero
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = -$Sci_dim- 4.*$Sci_thickness - 3*$Gd_thickness ;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";
    print_det(\%configuration, \%detector);

         # Gd_down 3
    $detector{"name"}        = "Gd_down 3";
    $detector{"description"} = "down side  3";
    $detector{"color"}       = "0000003"; #nero
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = -$Sci_dim- 6.*$Sci_thickness - 5*$Gd_thickness ;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";
    print_det(\%configuration, \%detector);

#/////////// RIGHT /////////#

   #  Gd_right 1 
    $detector{"name"}        = " Gd_right 1";
    $detector{"description"} = "right side 1 ";
    $detector{"color"}       = "0000003"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $Gd_lx =$Gd_thickness; 
    $Gd_ly =$Sci_dim ;
    $Gd_lz =$Sci_dim; 
    $X = $Sci_dim+2.*$Sci_thickness + $Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";			
     print_det(\%configuration, \%detector);

      #  Gd_right 2 
    $detector{"name"}        = " Gd_right 2";
    $detector{"description"} = "right side  2";
    $detector{"color"}       = "0000003"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = $Sci_dim+4.*$Sci_thickness + 3*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";            
     print_det(\%configuration, \%detector);

      #  Gd_right 3 
    $detector{"name"}        = " Gd_right 3";
    $detector{"description"} = "right side 3 ";
    $detector{"color"}       = "0000003"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = $Sci_dim+6.*$Sci_thickness + 5*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";            
     print_det(\%configuration, \%detector);

#/////////// LEFT /////////#

       #  Gd_left 1
    $detector{"name"}        = " Gd_left 1";
    $detector{"description"} = "left side 1";
    $detector{"color"}       = "0000003"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $Sci_dim-2.*$Sci_thickness - $Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";			
     print_det(\%configuration, \%detector);

       #  Gd_left 2
    $detector{"name"}        = " Gd_left 2";
    $detector{"description"} = "left side 2";
    $detector{"color"}       = "0000003"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $Sci_dim-4.*$Sci_thickness - 3*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";            
     print_det(\%configuration, \%detector);

       #  Gd_left 3
    $detector{"name"}        = " Gd_left 3";
    $detector{"description"} = "left side 3";
    $detector{"color"}       = "0000003"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $Sci_dim-6.*$Sci_thickness - 5*$Gd_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";            
     print_det(\%configuration, \%detector);          

#/////////// FRONT /////////#

     # Gd_front 1 
    $detector{"name"}        = "Gd_front 1";
    $detector{"description"} = "front side 1 ";
    $detector{"color"}       = "0000003"; 
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $Gd_lx =$Sci_dim +8.*$Sci_thickness + 6.*$Gd_thickness; 
    $Gd_ly =$Sci_dim + 8.*$Sci_thickness+ 6.*$Gd_thickness; 
    $Gd_lz =$Gd_thickness; 
    $X = 0.;
    $Y = 0.;
    $Z = $Sci_dim+2.*$Sci_thickness +$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";	
     print_det(\%configuration, \%detector);

       # Gd_front  2
    $detector{"name"}        = "Gd_front 2";
    $detector{"description"} = "front side 2";
    $detector{"color"}       = "0000003"; 
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = $Sci_dim+4.*$Sci_thickness +3*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd"; 
     print_det(\%configuration, \%detector);


# Gd_front  3
    $detector{"name"}        = "Gd_front 3";
    $detector{"description"} = "front side 3";
    $detector{"color"}       = "0000003"; 
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = $Sci_dim+6.*$Sci_thickness +5*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd"; 
     print_det(\%configuration, \%detector);

#/////////// BACK /////////#

    # Gd_back 1
    $detector{"name"}        = "Gd_back 1";
    $detector{"description"} = "back side 1";
    $detector{"color"}       = "0000003"; 
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$Sci_dim -2.*$Sci_thickness - $Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";
     print_det(\%configuration, \%detector); 
 
    # Gd_back 2
    $detector{"name"}        = "Gd_back 2";
    $detector{"description"} = "back side 2";
    $detector{"color"}       = "0000003"; 
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$Sci_dim-4.*$Sci_thickness - 3*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";            
     print_det(\%configuration, \%detector); 
  
     # Gd_back 3
    $detector{"name"}        = "Gd_back 3";
    $detector{"description"} = "back side 3";
    $detector{"color"}       = "0000003"; 
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$Sci_dim-6.*$Sci_thickness - 5*$Gd_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Gd_lx*cm $Gd_ly*cm $Gd_lz*cm";
    $detector{"material"}    = "Gd";            
     print_det(\%configuration, \%detector); 
}

sub make_passive_1
{
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}
 
 ################################### Lead ##################################### 
   
    # pass1_down  
    $detector{"name"}        = "pass1_down ";
    $detector{"description"} = "pass1_down side ";
    $detector{"color"}       = "08e8de4"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $pass1_lx =$pass1_dim; 
    my $pass1_ly =$pass1_thickness; 
    my $pass1_lz =$pass1_dim; 
    my $X = 0.;
    my $Y = -$pass1_dim;
    my $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass1_lx*cm $pass1_ly*cm $pass1_lz*cm";
    $detector{"material"}    = "$passive_mat1"; 
     print_det(\%configuration, \%detector);


    # pass1_up 
    $detector{"name"}        = "pass1_up ";
    $detector{"description"} = "pass1_up side";
    $detector{"color"}       = "08e8de4"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$pass1_dim;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass1_lx*cm $pass1_ly*cm $pass1_lz*cm";
    $detector{"material"}    = "$passive_mat1"; 
    print_det(\%configuration, \%detector);
  
    # pass1_right  
    $detector{"name"}        = "pass1_right ";
    $detector{"description"} = "pass1_right side  ";
    $detector{"color"}       = "08e8de4"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $pass1_lx =$pass1_thickness; 
    $pass1_ly =$pass1_dim-$pass1_thickness;
    $pass1_lz =$pass1_dim;
    $X = $pass1_dim-$pass1_thickness; 
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass1_lx*cm $pass1_ly*cm $pass1_lz*cm";
    $detector{"material"}    = "$passive_mat1"; 
     print_det(\%configuration, \%detector);

       # pass1_left 
    $detector{"name"}        = "pass1_left ";
    $detector{"description"} = "pass1_left side  ";
    $detector{"color"}       = "08e8de4"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $pass1_dim +$pass1_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass1_lx*cm $pass1_ly*cm $pass1_lz*cm";
    $detector{"material"}    = "$passive_mat1"; 
     print_det(\%configuration, \%detector);

   
     # pass1_front  
    $detector{"name"}        = "pass1_front ";
    $detector{"description"} = "pass1_front side ";
    $detector{"color"}       = "08e8de4"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $pass1_lx =$pass1_dim ; 
    $pass1_ly =$pass1_dim + $pass1_thickness; 
    $pass1_lz =$pass1_thickness; 
    $X = 0.;
    $Y = 0.;
    $Z = $pass1_dim + $pass1_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass1_lx*cm $pass1_ly*cm $pass1_lz*cm";
    $detector{"material"}    = "$passive_mat1"; 
     print_det(\%configuration, \%detector);


       # pass1_back 
    $detector{"name"}        = "pass1_back ";
    $detector{"description"} = "pass1_back side ";
    $detector{"color"}       = "08e8de4"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$pass1_dim - $pass1_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass1_lx*cm $pass1_ly*cm $pass1_lz*cm";
    $detector{"material"}    = "$passive_mat1"; 
     print_det(\%configuration, \%detector);

} 

sub make_passive_2
{
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}
 
 ################################### Lead ##################################### 
   
    # pass2_down  
    $detector{"name"}        = "pass2_down ";
    $detector{"description"} = "pass2_down side ";
    $detector{"color"}       = "0000004"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $pass2_lx =$pass2_dim; 
    my $pass2_ly =$pass2_thickness; 
    my $pass2_lz =$pass2_dim; 
    my $X = 0.;
    my $Y = -$pass2_dim;
    my $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass2_lx*cm $pass2_ly*cm $pass2_lz*cm";
    $detector{"material"}    = "$passive_mat2"; 
     print_det(\%configuration, \%detector);


    # pass2_up 
    $detector{"name"}        = "pass2_up ";
    $detector{"description"} = "pass2_up side";
    $detector{"color"}       = "0000004"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$pass2_dim;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass2_lx*cm $pass2_ly*cm $pass2_lz*cm";
    $detector{"material"}    = "$passive_mat2";
    print_det(\%configuration, \%detector);
  
    # pass2_right  
    $detector{"name"}        = "pass2_right ";
    $detector{"description"} = "pass2_right side  ";
    $detector{"color"}       = "0000004"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $pass2_lx =$pass2_thickness; 
    $pass2_ly =$pass2_dim-$pass2_thickness;
    $pass2_lz =$pass2_dim;
    $X = $pass2_dim-$pass2_thickness; 
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass2_lx*cm $pass2_ly*cm $pass2_lz*cm";
    $detector{"material"}    = "$passive_mat2"; 
     print_det(\%configuration, \%detector);

       # pass2_left 
    $detector{"name"}        = "pass2_left ";
    $detector{"description"} = "pass2_left side  ";
    $detector{"color"}       = "0000004"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $pass2_dim +$pass2_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass2_lx*cm $pass2_ly*cm $pass2_lz*cm";
    $detector{"material"}    = "$passive_mat2"; 
     print_det(\%configuration, \%detector);

   
     # pass2_front  
    $detector{"name"}        = "pass2_front ";
    $detector{"description"} = "pass2_front side ";
    $detector{"color"}       = "0000004"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $pass2_lx =$pass2_dim ; 
    $pass2_ly =$pass2_dim + $pass2_thickness; 
    $pass2_lz =$pass2_thickness; 
    $X = 0.;
    $Y = 0.;
    $Z = $pass2_dim + $pass2_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass2_lx*cm $pass2_ly*cm $pass2_lz*cm";
    $detector{"material"}    = "$passive_mat2"; 
     print_det(\%configuration, \%detector);


       # pass2_back 
    $detector{"name"}        = "pass2_back ";
    $detector{"description"} = "pass2_back side ";
    $detector{"color"}       = "0000003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$pass2_dim - $pass2_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass2_lx*cm $pass2_ly*cm $pass2_lz*cm";
    $detector{"material"}    = "$passive_mat2"; 
     print_det(\%configuration, \%detector);

} 

sub make_passive_3
{
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}
 
 ################################### passive materiale 3 ##################### 
   
    # pass3_down  
    $detector{"name"}        = "pass3_down ";
    $detector{"description"} = "pass3_down side ";
    $detector{"color"}       = "0000004"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    my $pass3_lx =$pass3_dim; 
    my $pass3_ly =$pass3_thickness; 
    my $pass3_lz =$pass3_dim; 
    my $X = 0.;
    my $Y = -$pass3_dim;
    my $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass3_lx*cm $pass3_ly*cm $pass3_lz*cm";
    $detector{"material"}    = "$passive_mat3"; 
     print_det(\%configuration, \%detector);


    # pass3_up 
    $detector{"name"}        = "pass3_up ";
    $detector{"description"} = "pass3_up side";
    $detector{"color"}       = "0000004"; #blue + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = +$pass3_dim;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass3_lx*cm $pass3_ly*cm $pass3_lz*cm";
    $detector{"material"}    = "$passive_mat3";
    print_det(\%configuration, \%detector);
  
    # pass3_right  
    $detector{"name"}        = "pass3_right ";
    $detector{"description"} = "pass3_right side  ";
    $detector{"color"}       = "0000004"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $pass3_lx =$pass3_thickness; 
    $pass3_ly =$pass3_dim-$pass3_thickness;
    $pass3_lz =$pass3_dim;
    $X = $pass3_dim-$pass3_thickness; 
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass3_lx*cm $pass3_ly*cm $pass3_lz*cm";
    $detector{"material"}    = "$passive_mat3"; 
     print_det(\%configuration, \%detector);

       # pass3_left 
    $detector{"name"}        = "pass3_left ";
    $detector{"description"} = "pass3_left side  ";
    $detector{"color"}       = "0000004"; #red + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $pass3_dim +$pass3_thickness;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass3_lx*cm $pass3_ly*cm $pass3_lz*cm";
    $detector{"material"}    = "$passive_mat3"; 
     print_det(\%configuration, \%detector);

   
     # pass3_front  
    $detector{"name"}        = "pass3_front ";
    $detector{"description"} = "pass3_front side ";
    $detector{"color"}       = "0000004"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $pass3_lx =$pass3_dim ; 
    $pass3_ly =$pass3_dim + $pass3_thickness; 
    $pass3_lz =$pass3_thickness; 
    $X = 0.;
    $Y = 0.;
    $Z = $pass3_dim + $pass3_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass3_lx*cm $pass3_ly*cm $pass3_lz*cm";
    $detector{"material"}    = "$passive_mat3"; 
     print_det(\%configuration, \%detector);


       # pass3_back 
    $detector{"name"}        = "pass3_back ";
    $detector{"description"} = "pass3_back side ";
    $detector{"color"}       = "0000003"; #giallo + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = -$pass3_dim - $pass3_thickness;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass3_lx*cm $pass3_ly*cm $pass3_lz*cm";
    $detector{"material"}    = "$passive_mat3"; 
     print_det(\%configuration, \%detector);

} 

sub make_flux_cosmic_sph
{
    my %detector = init_det();
    my $cosmicradius=50.;
    
    my $X = $shX + 0. ;
    my $Y = $shY + 0. ;
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
    $detector{"color"}       = "cc00ff3";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Sphere";
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "90*deg 180*deg 0*deg";
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
    make_lAr;
    make_passive_Gd;
    make_passive_1;
  # make_passive_2;
  #  make_passive_3;
  # make_flux_cosmic_sph;		#Crea la routine flux_cosmic che disegna la sfera
}


1;

