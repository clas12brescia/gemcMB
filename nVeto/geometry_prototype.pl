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
        $detector{"name"}        = "bdx_real_main_volume";	# The position and rotation of a volume are relative to its mother volume. 
        $detector{"mother"}      = "root";					# The rotation will happen before the position. “root” is the root volume.
        $detector{"description"} = "World";
        $detector{"color"}       = "666666";				# The color entry is a 6 digit hexadecimal number that represents Red,Green and Blue weights from 0 to 255 (RRGGBB)
        $detector{"color"}       = "000000";
        $detector{"style"}       = 0;						# 1 is “solid”, 0 is “wireframe”
        $detector{"visible"}     = 1;						# 1 is “visible”, 0 is “invisible” 
        $detector{"type"}        = "Box";					# The type of geant4 solid is “box”
        my $X = 0.;
        my $Y = 0.;
        my $Z = 0.;
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        my $wallthk=30./2; # now it's 15cm or 470cm
            
        my $par1 = 600.+$wallthk;
        my $par2 = 400.+$wallthk;
        my $par3 = 600.+$wallthk;
        $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm";
        $detector{"material"}    = "G4_AIR";
       # $detector{"material"}    = "G4_CONCRETE";
        print_det(\%configuration, \%detector);
 

        my $p1= $par1-$wallthk ;
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
        $detector{"material"}    = "G4_AIR";
        #$detector{"material"}    = "G4_Galactic";
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
my @X=(0,0,0);
my @Y=(0,0,0);
my @Z=(0,0,0);
my $X = 0.;
my $Y = 0.;
my $Z = 0.;

my $nlayers=4;

my $Crs_x =6./2; 
my $Crs_y =6./2; 
my $Crs_z =32./2;

my @Veto_thickness=(0.1/2,0.1/2,6./2,0.1/2);
my @Veto_lx;
my @Veto_ly;
my @Veto_lz;

my $Veto_posx= $Crs_x ;
my $Veto_posy= $Crs_y ;
my $Veto_posz= $Crs_z ;
my @mat= ("G4_Galactic","G4_Pb","ScintillatorB","G4_Galactic");

################################### CsI_Tl ##################################### 
  
sub make_crystal
{   
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}
 
    $detector{"name"}        = "crystal";
    $detector{"description"} = "CsI_Tl";
    $detector{"color"}       = "00ff00"; #verde
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = 0.;
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$Crs_x*cm $Crs_y*cm $Crs_z*cm";
    $detector{"material"}    = "CsI_Tl";          
    $detector{"sensitivity"} = "crs";
    $detector{"hit_type"}    = "crs";
    $detector{"identifiers"} = "sector manual 3 det manual 200 channel manual 0";
     print_det(\%configuration, \%detector); 
} 


sub make_nVeto
{
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}
 
 ################################### Scintillator ##################################### 
# RIGHT-LeFt

    for(my $i=0; $i<$nlayers; $i++){
        if ($i==0){
            $Veto_lx[$i] =$Veto_thickness[$i]; 
            $Veto_ly[$i] =$Veto_posy ; 
            $Veto_lz[$i] =$Veto_posz ;
            $X[$i] =$Veto_posx+ $Veto_thickness[$i]; 
            $Y[$i] =0; 
            $Z[$i] =0;
        }
        else{
             $Veto_lx[$i] =$Veto_thickness[$i];
             $Veto_ly[$i]  =$Veto_ly[$i-1] + 2*$Veto_thickness[$i-1];
             $Veto_lz[$i]  = $Veto_lz[$i-1] + 2*$Veto_thickness[$i-1];
             $X[$i]  =$X[$i-1] + $Veto_thickness[$i-1] + $Veto_thickness[$i];
             $Y[$i]  =0.;
             $Z[$i] = 0.;
        }
        $detector{"name"}        = "right_$i";
        $detector{"description"} = "right side $i, $mat[$i]  ";
        $detector{"color"}       = "0000003"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X[$i]*cm $Y[$i]*cm $Z[$i]*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx[$i]*cm $Veto_ly[$i]*cm $Veto_lz[$i]*cm";
        $detector{"material"}    = "$mat[$i]";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"} = "id manual 1$i";
        if ($mat[$i]eq "G4_Pb"  || $mat[$i]eq "G4_Gd"){
            $detector{"color"}       = "0000003"; #red + trasparency
            $detector{"sensitivity"} = "no";
            $detector{"hit_type"}    = "no";
            $detector{"identifiers"} = "no";
        }
        if ($mat[$i]eq "ScintillatorB"){
            $detector{"color"}       = "ff00003"; #red + trasparency
            $detector{"sensitivity"} = "veto";
            $detector{"hit_type"}    = "veto";
            $detector{"identifiers"} = "sector manual 1 veto manual 100 channel manual $i";
        }
         print_det(\%configuration, \%detector);

        $detector{"name"}        = "left_$i";
        $detector{"description"} = "left side $i, $mat[$i]  ";
        $detector{"color"}       = "0000003"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "-$X[$i]*cm -$Y[$i]*cm -$Z[$i]*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx[$i]*cm $Veto_ly[$i]*cm $Veto_lz[$i]*cm";
        $detector{"material"}    = "$mat[$i]";
        if ($mat[$i]eq "G4_Pb" || $mat[$i]eq "G4_Gd" ){
            $detector{"color"}       = "0000003"; #red + trasparency
            $detector{"sensitivity"} = "no";
            $detector{"hit_type"}    = "no";
            $detector{"identifiers"} = "no";
        }
        if ($mat[$i]eq "ScintillatorB"){
            $detector{"color"}       = "ff00003"; #red + trasparency
            $detector{"sensitivity"} = "veto";
            $detector{"hit_type"}    = "veto";
            $detector{"identifiers"} = "sector manual 2 veto manual 100 channel manual $i";
        }
         print_det(\%configuration, \%detector); 

    }

# DOWN -Up
   for(my $i=0; $i<$nlayers; $i++){
        if ($i==0){
            $Veto_lx[$i] =$Veto_posx + 2*$Veto_thickness[$i] ; 
            $Veto_ly[$i] =$Veto_thickness[$i] ; 
            $Veto_lz[$i] =$Veto_posz ;
            $X[$i] =0; 
            $Y[$i] =+$Veto_posy+ $Veto_thickness[$i]; 
            $Z[$i] =0;
        }
        else{
            $Veto_lx[$i] = $Veto_lx[$i-1] + 2*$Veto_thickness[$i];
            $Veto_ly[$i] = $Veto_thickness[$i] ;
            $Veto_lz[$i] = $Veto_lz[$i-1] + 2*$Veto_thickness[$i-1];
            $X[$i] = 0.;
            $Y[$i] = $Y[$i-1] + $Veto_thickness[$i-1] + $Veto_thickness[$i];
            $Z[$i] = 0.;
        }
        $detector{"name"}        = "down_$i";
        $detector{"description"} = "down side $i, $mat[$i]  ";
        $detector{"color"}       = "0000003"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "-$X[$i]*cm -$Y[$i]*cm -$Z[$i]*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx[$i]*cm $Veto_ly[$i]*cm $Veto_lz[$i]*cm";
        $detector{"material"}    = "$mat[$i]"; 
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"} = "id manual 2$i";
        if ($mat[$i]eq "G4_Pb" || $mat[$i]eq "G4_Gd"){
            $detector{"color"}       = "0000003"; 
            $detector{"sensitivity"} = "no";
            $detector{"hit_type"}    = "no";
            $detector{"identifiers"} = "no";
        }
        if ($mat[$i]eq "ScintillatorB"){
            $detector{"color"}       = "0000ff3"; #blue + trasparency
            $detector{"sensitivity"} = "veto";
            $detector{"hit_type"}    = "veto";
            $detector{"identifiers"} = "sector manual 4 veto manual 100 channel manual $i";
        }
         print_det(\%configuration, \%detector);    
    }
    
    for(my $i=0; $i<$nlayers; $i++){
        if ($i==0){
            $Veto_lx[$i] =$Veto_posx + 2*$Veto_thickness[$i] ; 
            $Veto_ly[$i] =$Veto_thickness[$i] ; 
            $Veto_lz[$i] =$Veto_posz ;
            $X[$i] =0; 
            $Y[$i] =+$Veto_posy+ $Veto_thickness[$i]; 
            $Z[$i] =0;
        }
        else{
            $Veto_lx[$i] = $Veto_lx[$i-1] + 2*$Veto_thickness[$i];
            $Veto_ly[$i] = $Veto_thickness[$i] ;
            $Veto_lz[$i] = $Veto_lz[$i-1] + 2*$Veto_thickness[$i-1];
            $X[$i] = 0.;
            $Y[$i] = $Y[$i-1] + $Veto_thickness[$i-1] + $Veto_thickness[$i];
            $Z[$i] = 0.;
        }
        $detector{"name"}        = "up_$i";
        $detector{"description"} = "up side $i, $mat[$i]  ";
        $detector{"color"}       = "0000005"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X[$i]*cm $Y[$i]*cm $Z[$i]*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx[$i]*cm $Veto_ly[$i]*cm $Veto_lz[$i]*cm";
        $detector{"material"}    = "$mat[$i]";
                $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 3$i";
        if ($mat[$i]eq "G4_Pb" || $mat[$i]eq "G4_Gd"){
            $detector{"color"}       = "0000003"; #red + trasparency
            $detector{"sensitivity"} = "no";
            $detector{"hit_type"}    = "no";
            $detector{"identifiers"} = "no";
        }
         if ($mat[$i] eq "ScintillatorB"){
            $detector{"color"}       = "0000ff3"; #blue + trasparency
            $detector{"sensitivity"} = "veto";
            $detector{"hit_type"}    = "veto";
            $detector{"identifiers"} = "sector manual 3 veto manual 100 channel manual $i";
        }
         print_det(\%configuration, \%detector);   
    }

 
     # FRONT
    for(my $i=0; $i<$nlayers; $i++){
        if ($i==0){
            $Veto_lx[$i] =$Veto_posx + 2*$Veto_thickness[$i] ; 
            $Veto_ly[$i] =$Veto_posy + 2*$Veto_thickness[$i]  ; 
            $Veto_lz[$i] =$Veto_thickness[$i] ;
            $X[$i] =0; 
            $Y[$i] =0.; 
            $Z[$i] =$Veto_posz+ $Veto_thickness[$i];
        }
        else{
            $Veto_lx[$i] =$Veto_lx[$i-1] + 2*$Veto_thickness[$i] ; 
            $Veto_ly[$i] =$Veto_ly[$i-1] + 2*$Veto_thickness[$i]  ; 
            $Veto_lz[$i] =$Veto_thickness[$i] ;
            $X[$i] = 0.;
            $Y[$i] = 0.;
            $Z[$i] = $Z[$i-1] + $Veto_thickness[$i-1] + $Veto_thickness[$i] ;
        }
        $detector{"name"}        = "front_$i";
        $detector{"description"} = "front side $i ,$mat[$i]";
        $detector{"color"}       = "0000003"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X[$i]*cm $Y[$i]*cm $Z[$i]*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx[$i]*cm $Veto_ly[$i]*cm $Veto_lz[$i]*cm";
        $detector{"material"}    = "$mat[$i]";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"} = "id manual 4$i";
        if ($mat[$i]eq "G4_Pb" || $mat[$i]eq "G4_Gd"){
            $detector{"color"}       = "0000003"; #red + trasparency
            $detector{"sensitivity"} = "no";
            $detector{"hit_type"}    = "no";
            $detector{"identifiers"} = "no";
        }
        if ($mat[$i] eq "ScintillatorB"){
            $detector{"color"}       = "ffd7003"; #yellow + trasparency
            $detector{"sensitivity"} = "veto";
            $detector{"hit_type"}    = "veto";
            $detector{"identifiers"} = "sector manual 5 veto manual 100 channel manual $i";
        }
         print_det(\%configuration, \%detector);

        $detector{"name"}        = "back_$i";
        $detector{"description"} = "back side $i, $mat[$i] ";
        $detector{"color"}       = "0000003"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "-$X[$i]*cm -$Y[$i]*cm -$Z[$i]*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx[$i]*cm $Veto_ly[$i]*cm $Veto_lz[$i]*cm";
        $detector{"material"}    = "$mat[$i]";
        if ($mat[$i]eq "G4_Pb" || $mat[$i]eq "G4_Gd"){
            $detector{"color"}       = "0000003"; #red + trasparency
            $detector{"sensitivity"} = "no";
            $detector{"hit_type"}    = "no";
            $detector{"identifiers"} = "no";
        }
        if ($mat[$i] eq "ScintillatorB"){
            $detector{"color"}       = "ffd7003"; #yellow + trasparency
            $detector{"sensitivity"} = "veto";
            $detector{"hit_type"}    = "veto";
            $detector{"identifiers"} = "sector manual 6 veto manual 100 channel manual $i";
        }
         
         print_det(\%configuration, \%detector);
    }    
} 

sub make_passive
{
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";} 

# Up

        my $lx_1_up =$Crs_x + 12.8/2 ;
        my $ly_1_up = 30./2 ; #thickness 
        my $lz_1_up = $Crs_z + 12.8/2 ;
        my $X_1_up = 0.;
        my $Y_1_up = $Crs_y + 12.8/2 + $ly_1_up ;
        my $Z_1_up = 0.;
        $detector{"name"}        = "first pass up ";
        $detector{"description"} = "first pass up";
        $detector{"color"}       = "08e8de4"; 
        #$detector{"color"}       = "0000004";#black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_1_up*cm $Y_1_up*cm $Z_1_up*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_1_up*cm $ly_1_up*cm $lz_1_up*cm";
        $detector{"material"}    = "G4_WATER";
        $detector{"sensitivity"} = "no";
        $detector{"hit_type"}    = "no";
         $detector{"identifiers"}= "no";
         print_det(\%configuration, \%detector); 
                 
        my $lx_f5_up =$Crs_x + 12.8/2;
        my $ly_f5_up =0.1/2 ;      #thickness flux
        my $lz_f5_up = $Crs_z + 12.8/2;
        my $X_f5_up = 0.;
        my $Y_f5_up = $Y_1_up + $ly_1_up+ $ly_f5_up;
        my $Z_f5_up = 0.;
        $detector{"name"}        = "flux5 up";
        $detector{"description"} = "flux5 , 1 up ";
        $detector{"color"}       = "ffd7003"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_f5_up*cm $Y_f5_up*cm $Z_f5_up*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f5_up*cm $ly_f5_up*cm $lz_f5_up*cm";
        $detector{"material"}    = "G4_Galactic";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 55";
         print_det(\%configuration, \%detector); 
         
        my $lx_2_up =$Crs_x + 12.8/2;
        my $ly_2_up = 20./2 ; #thickness
        my $lz_2_up = $Crs_z + 12.8/2 ;
        my $X_2_up = 0.;
        my $Y_2_up = $Y_f5_up + $ly_f5_up +$ly_2_up;
        my $Z_2_up= 0.;
        $detector{"name"}        = "second pass up ";
        $detector{"description"} = "second pass up ";
         #$detector{"color"}       = "08e8de4";
        $detector{"color"}       = "0000004"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_2_up*cm $Y_2_up*cm $Z_2_up*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_2_up*cm $ly_2_up*cm $lz_2_up*cm";
        $detector{"material"}    = "G4_Pb";
        $detector{"sensitivity"} = "no";
        $detector{"hit_type"}    = "no";
        $detector{"identifiers"} = "no";
         print_det(\%configuration, \%detector); 
                 
        my $lx_f6_up =$Crs_x + 12.6/2 ;
        my $ly_f6_up =0.1/2 ;  #thickness flux on water
        my $lz_f6_up = $Crs_z +  12.6/2;
        my $X_f6_up = 0.;
        my $Y_f6_up = $Y_2_up +  $ly_2_up+  $ly_f6_up;
        my $Z_f6_up = 0.;
        $detector{"name"}        = "flux6";
        $detector{"description"} = "flux6   ";
        $detector{"color"}       = "ffd7003"; 
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_f6_up*cm $Y_f6_up*cm $Z_f6_up*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f6_up*cm $ly_f6_up*cm $lz_f6_up*cm";
        $detector{"material"}    = "G4_Galactic";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 65";
        print_det(\%configuration, \%detector);  
        
        my $lx_f7_up =600.;
        my $ly_f7_up =0.1/2 ;  #thickness flux after concrete
        my $lz_f7_up = 600.;
        my $X_f7_up = 0.;
        my $Y_f7_up = 370.;
        my $Z_f7_up = 0.;
        $detector{"name"}        = "flux7 _up";
        $detector{"description"} = "flux7 , _up";
        $detector{"color"}       = "ffd7003"; 
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_f7_up*cm $Y_f7_up*cm $Z_f7_up*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f7_up*cm $ly_f7_up*cm $lz_f7_up*cm";
        $detector{"material"}    = "G4_Galactic";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 75";
         print_det(\%configuration, \%detector); 
        
 
#down         
        my $lx_1_down =$Crs_x + 12.8/2+ 81.2/2 ;
        my $ly_1_down = 1./2 ; #thickness 
        my $lz_1_down = $Crs_z + 12.8/2 +55.2/2 ;
        my $X_1_down = 0.;
        my $Y_1_down = $Crs_y + 12.8/2 + $ly_1_down ;
        my $Z_1_down = 0.;
        $detector{"name"}        = "first pass ";
        $detector{"description"} = "first pass ";
        #$detector{"color"}       = "08e8de4"; 
        $detector{"color"}       = "0000001";#black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_1_down*cm -$Y_1_down*cm $Z_1_down*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_1_down*cm $ly_1_down*cm $lz_1_down*cm";
        $detector{"material"}    = "G4_Cd";
        $detector{"sensitivity"} = "no";
        $detector{"hit_type"}    = "no";
         $detector{"identifiers"}= "no";
         print_det(\%configuration, \%detector); 
                 
        my $lx_f5_down =$Crs_x + 12.8/2+ 81.2/2;
        my $ly_f5_down =0.1/2 ;      #thickness flux
        my $lz_f5_down = $Crs_z + 12.8/2 +55.2/2;
        my $X_f5_down = 0.;
        my $Y_f5_down = $Y_1_down + $ly_1_down+ $ly_f5_down;
        my $Z_f5_down = 0.;
        $detector{"name"}        = "flux5 down";
        $detector{"description"} = "flux5 , 1 down ";
        $detector{"color"}       = "ffd7003"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_f5_down*cm -$Y_f5_down*cm $Z_f5_down*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f5_down*cm $ly_f5_down*cm $lz_f5_down*cm";
        $detector{"material"}    = "G4_Galactic";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 50";
         print_det(\%configuration, \%detector);    
         
        my $lx_2_down =$Crs_x + 12.8/2 + 81.2/2;
        my $ly_2_down = 300./2 ; #thickness
        my $lz_2_down = $Crs_z + 12.8/2  +55.2/2 ;
        my $X_2_down = 0.;
        my $Y_2_down = $Y_f5_down + $ly_f5_down +$ly_2_down;
        my $Z_2_down= 0.;
        $detector{"name"}        = "second pass down ";
        $detector{"description"} = "second pass down ";
         #$detector{"color"}       = "08e8de4";
        $detector{"color"}       = "0000004"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_2_down*cm -$Y_2_down*cm $Z_2_down*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_2_down*cm $ly_2_down*cm $lz_2_down*cm";
        $detector{"material"}    = "G4_Pb";
        $detector{"sensitivity"} = "no";
        $detector{"hit_type"}    = "no";
        $detector{"identifiers"} = "no";
         print_det(\%configuration, \%detector); 
                 
        my $lx_f6_down =$Crs_x + 12.6/2 + 81.2/2;
        my $ly_f6_down =0.1/2 ;  #thickness flux on water
        my $lz_f6_down = $Crs_z +  12.6/2 +55.2/2;
        my $X_f6_down = 0.;
        my $Y_f6_down = $Y_2_down +  $ly_2_down+  $ly_f6_down;
        my $Z_f6_down = 0.;
        $detector{"name"}        = "flux6 down";
        $detector{"description"} = "flux6 down   ";
        $detector{"color"}       = "ffd7003"; 
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_f6_down*cm -$Y_f6_down*cm $Z_f6_down*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f6_down*cm $ly_f6_down*cm $lz_f6_down*cm";
        $detector{"material"}    = "G4_Galactic";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 60";
        print_det(\%configuration, \%detector);  

        
        my $lx_f7 =600.;
        my $ly_f7 =0.1/2 ;  #thickness flux after concrete
        my $lz_f7 = 600.;
        my $X_f7 = 0.;
        my $Y_f7 = 370.;
        my $Z_f7 = 0.;
        $detector{"name"}        = "flux7";
        $detector{"description"} = "flux7 , air ";
        $detector{"color"}       = "ffd7003"; 
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_f7*cm -$Y_f7*cm $Z_f7*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f7*cm $ly_f7*cm $lz_f7*cm";
        $detector{"material"}    = "G4_Galactic";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 70";
         print_det(\%configuration, \%detector); 
        
}  

sub make_flux_cosmic_sph
{
    my %detector = init_det();
    my $cosmicradius=240.;
    
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
    $detector{"rotation"}    = "90*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$par1*cm $par2*cm $parz3*cm $par4*deg $par5*deg $par6*deg";
    $detector{"material"}    = "G4_AIR";
    $detector{"sensitivity"} = "flux";
    $detector{"hit_type"}    = "flux";
    $detector{"identifiers"} = "id manual 1001";
    print_det(\%configuration, \%detector);
    
}

sub make_bdx_CT
{
    make_main_volume();
    make_nVeto;
    make_crystal;
    make_passive;
  # make_flux_cosmic_sph;		#Crea la routine flux_cosmic che disegna la sfera 
}

1;

