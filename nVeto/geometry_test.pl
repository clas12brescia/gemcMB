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
        $detector{"material"}    = "G4_CONCRETE";
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

my $nlayers=2;

my $Crs_x =6./2; 
my $Crs_y =6./2; 
my $Crs_z =32./2;

my @Veto_thickness=(6./2,0.1/2);
my @Veto_lx;
my @Veto_ly;
my @Veto_lz;

my $Veto_posx= $Crs_x ;
my $Veto_posy= $Crs_y ;
my $Veto_posz= $Crs_z ;
my @mat= ("ScintillatorB","G4_Galactic");

################################### CsI_Tl ##################################### 
  
sub make_crystal
{   
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}

       # lAr 
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
        $detector{"identifiers"}  = "id manual 1";
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
        $detector{"color"}       = "0000005"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "-$X[$i]*cm -$Y[$i]*cm -$Z[$i]*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx[$i]*cm $Veto_ly[$i]*cm $Veto_lz[$i]*cm";
        $detector{"material"}    = "$mat[$i]"; 
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 2";
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
        $detector{"identifiers"}  = "id manual 3";
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
        $detector{"identifiers"}  = "id manual 4";
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
        my $lx_Pb =$Crs_x + 12./2;
        my $ly_Pb = 5./2 ; #thickness lead
        my $lz_Pb = $Crs_z + 12./2;
        my $X_Pb = 0.;
        my $Y_Pb = $Crs_y + 12.2/2 + $ly_Pb;
        my $Z_Pb = 0.;
        $detector{"name"}        = "up Pb";
        $detector{"description"} = "up side , Pb  ";
        $detector{"color"}       = "0000004"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_Pb*cm $Y_Pb*cm $Z_Pb*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_Pb*cm $ly_Pb*cm $lz_Pb*cm";
        $detector{"material"}    = "G4_Pb";
         print_det(\%configuration, \%detector); 
                 
        my $lx_f5 =$Crs_x + 12./2;
        my $ly_f5 =0.1/2 ;
        my $lz_f5 = $Crs_z + 12./2;
        my $X_f5 = 0.;
        my $Y_f5 = $Y_Pb + $ly_Pb+ $ly_f5;
        my $Z_f5 = 0.;
        $detector{"name"}        = "flux5";
        $detector{"description"} = "flux5 , Pb  ";
        $detector{"color"}       = "ffd7003"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_f5*cm $Y_f5*cm $Z_f5*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f5*cm $ly_f5*cm $lz_f5*cm";
        $detector{"material"}    = "G4_Pb";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 5";
         print_det(\%configuration, \%detector); 
         
        my $lx_w =$Crs_x + 12./2;
        my $ly_w = 50./2 ; #thickness lead
        my $lz_w = $Crs_z + 12./2;
        my $X_w = 0.;
        my $Y_w = $Y_f5 + $ly_f5 +$ly_w;
        my $Z_w = 0.;
        $detector{"name"}        = "up water";
        $detector{"description"} = "up side , water  ";
        $detector{"color"}       = "08e8de4"; #black + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_w*cm $Y_w*cm $Z_w*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_w*cm $ly_w*cm $lz_w*cm";
        $detector{"material"}    = "G4_WATER";
         print_det(\%configuration, \%detector); 
                 
        my $lx_f6 =$Crs_x + 12./2;
        my $ly_f6 =0.1/2 ;
        my $lz_f6 = $Crs_z +  12./2;
        my $X_f6 = 0.;
        my $Y_f6 = $Y_w +  $ly_w+  $ly_f6;
        my $Z_f6 = 0.;
        $detector{"name"}        = "flux6";
        $detector{"description"} = "flux6 , water  ";
        $detector{"color"}       = "ffd7003"; 
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $detector{"pos"}         = "$X_f6*cm $Y_f6*cm $Z_f6*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f6*cm $ly_f6*cm $lz_f6*cm";
        $detector{"material"}    = "G4_WATER";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 6";
         print_det(\%configuration, \%detector); 
         
        my $lx_f7 =600.;
        my $ly_f7 =0.1/2 ;
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
        $detector{"pos"}         = "$X_f7*cm $Y_f7*cm $Z_f7*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$lx_f7*cm $ly_f7*cm $lz_f7*cm";
        $detector{"material"}    = "G4_AIR";
        $detector{"sensitivity"} = "flux";
        $detector{"hit_type"}    = "flux";
        $detector{"identifiers"}  = "id manual 7";
         print_det(\%configuration, \%detector); 
        
} 

sub make_flux_cosmic_sph
{
    my %detector = init_det();
    my $cosmicradius=55.;
    
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

