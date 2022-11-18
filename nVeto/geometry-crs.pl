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
my $X = 0.;
my $Y = 0.;
my $Z = 0.;

my $Crs_x =6./2; 
my $Crs_y =6./2; 
my $Crs_z =32./2;

my $Crs_mat= "CsI_Tl";

my $Veto_layers= 3;
my @Veto_thickness=(1./2, 5./2,5./2);
my $Veto_posx= $Crs_x +4./2 ;
my $Veto_posy= $Crs_y +4./2;
my $Veto_posz= $Crs_z +8./2;
my $Veto_mat= "ScintillatorB";

my $pass_in_layers=2;
my $pass_in_thickness=5./2.;
my $passive_in_mat="G4_Pb";



################################### NaI_Tl ##################################### 
  
sub make_crystal
{   
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}

       # lAr 
    $detector{"name"}        = "crystal";
    $detector{"description"} = "NaI_Tl";
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
    $detector{"material"}    = "$Crs_mat";          
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
 

# RIGHT
    for(my $i=0; $i<$Veto_layers; $i++){

        my $Veto_lx =$Veto_thickness[$i]; 
        my $Veto_ly =$Veto_posy- 2*$Veto_thickness[$i] ; 
        my $Veto_lz =$Veto_posz - 2*$Veto_thickness[$i];
        if ($i>0){
             $Veto_ly =$Veto_posy + ($i*2-2)*$Veto_thickness[$i] + $i*2*$pass_in_thickness;
             $Veto_lz =$Veto_posz + ($i*2-2)*$Veto_thickness[$i]+ $i*2*$pass_in_thickness;
        }
        $detector{"name"}        = "right $i";
        $detector{"description"} = "right side $i ";
        $detector{"color"}       = "ff0000"; #red + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $X = $Veto_posx - $Veto_thickness[$i];
        if ($i>0){
            $X = $Veto_posx +(2*$i-1)*$Veto_thickness[$i] +(2*$i)*$pass_in_thickness;
        }    
        $Y = 0.;
        $Z = 0.;
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx*cm $Veto_ly*cm $Veto_lz*cm";
        $detector{"material"} = "$Veto_mat";
        $detector{"sensitivity"} = "veto";
        $detector{"hit_type"}    = "veto";
        $detector{"identifiers"} = "sector manual 1 veto manual 100 channel manual $i";
         print_det(\%configuration, \%detector);

    }

    #LEFT    
    for(my $i=0; $i<$Veto_layers; $i++){ 

        my $Veto_lx =$Veto_thickness[$i]; 
        my $Veto_ly =$Veto_posy- 2*$Veto_thickness[$i] ; 
        my $Veto_lz =$Veto_posz - 2*$Veto_thickness[$i];
        if ($i>0){
             $Veto_ly =$Veto_posy + ($i*2-2)*$Veto_thickness[$i] + $i*2*$pass_in_thickness;
             $Veto_lz =$Veto_posz + ($i*2-2)*$Veto_thickness[$i]+ $i*2*$pass_in_thickness;
        }   
        $detector{"name"}        = "left $i";
        $detector{"description"} = "left side $i ";
        $detector{"color"}       = "ff0000"; #red + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $X = - $Veto_posx + $Veto_thickness[$i];
        if ($i>0){
            $X = - $Veto_posx - (2*$i-1)*$Veto_thickness[$i] -(2*$i)*$pass_in_thickness;
        }
        $Y = 0.;
        $Z = 0.;
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; #
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx*cm $Veto_ly*cm $Veto_lz*cm";
        $detector{"material"}    = "$Veto_mat";         #defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
        $detector{"sensitivity"} = "veto";
        $detector{"hit_type"}    = "veto";
        $detector{"identifiers"} = "sector manual 2 veto manual 100 channel manual $i";
         print_det(\%configuration, \%detector);
    }

  # DOWN
    for(my $i=0; $i<$Veto_layers; $i++){

        my $Veto_lx =$Veto_posx  + 2*$i*$Veto_thickness[$i]; 
        my $Veto_ly =$Veto_thickness[$i]; 
        my $Veto_lz =$Veto_posz - 2*$Veto_thickness[$i];

        if ($i>0){
             $Veto_lx =$Veto_posx  + 2*$i*$Veto_thickness[$i] + $i*2*$pass_in_thickness; 
             $Veto_lz =$Veto_posz + ($i*2-2)*$Veto_thickness [$i]+ $i*2*$pass_in_thickness;  
        }

        $detector{"name"}        = "down $i";
        $detector{"description"} = "down side $i";
        $detector{"color"}       = "0000ff"; #blue + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        my $X = 0.;
        my $Y = -$Veto_posy + $Veto_thickness[$i];
        if ($i>0){
            $Y = -$Veto_posy - (2*$i-1)*$Veto_thickness[$i] - 2*$i*$pass_in_thickness;
        }
        my $Z = 0.;
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx*cm $Veto_ly*cm $Veto_lz*cm";
        $detector{"material"}    = "$Veto_mat";	#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
        $detector{"sensitivity"} = "veto";
        $detector{"hit_type"}    = "veto";
        $detector{"identifiers"} = "sector manual 3 veto manual 100 channel manual $i";
         print_det(\%configuration, \%detector);

    }     
  
    # UP
    for(my $i=0; $i<$Veto_layers; $i++){

        my $Veto_lx =$Veto_posx  + 2*$i*$Veto_thickness[$i]; 
        my $Veto_ly =$Veto_thickness[$i]; 
        my $Veto_lz =$Veto_posz - 2*$Veto_thickness[$i];

        if ($i>0){
             $Veto_lx =$Veto_posx  + 2*$i*$Veto_thickness[$i] + $i*2*$pass_in_thickness; 
             $Veto_lz =$Veto_posz + ($i*2-2)*$Veto_thickness [$i]+ $i*2*$pass_in_thickness;  
        }  
        $detector{"name"}        = "up $i";
        $detector{"description"} = "up side  $i";
        $detector{"color"}       = "0000ff"; #blue + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        my $X = 0.;
        my $Y = +$Veto_posy - $Veto_thickness[$i];
        if ($i>0){
            $Y = +$Veto_posy + (2*$i-1)*$Veto_thickness[$i] + 2*$i*$pass_in_thickness;
        }
        my $Z = 0.;
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx*cm $Veto_ly*cm $Veto_lz*cm";
        $detector{"material"}    = "$Veto_mat";
        $detector{"sensitivity"} = "veto";
        $detector{"hit_type"}    = "veto";
        $detector{"identifiers"} = "sector manual 4 veto manual 100 channel manual $i";
        print_det(\%configuration, \%detector);

    }
 


     # FRONT
    for(my $i=0; $i<$Veto_layers; $i++){

        my $Veto_lx =$Veto_posx  ; 
        my $Veto_lz =$Veto_thickness[$i]; 
        my $Veto_ly =$Veto_posy ;
        if ($i>0){
             $Veto_lx =$Veto_posx  + 2*$i*$Veto_thickness[$i] + $i*2*$pass_in_thickness; 
             $Veto_ly =$Veto_posy + ($i*2)*$Veto_thickness[$i] + $i*2*$pass_in_thickness; 
        }  
        $detector{"name"}        = "front $i";
        $detector{"description"} = "front side$i";
        $detector{"color"}       = "ffd700"; #giallo + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $X = 0.;
        $Y = 0.;
        $Z = $Veto_posz -$Veto_thickness [$i] ;
        if ($i>0){
            $Z =$Veto_posz + ($i*2-1)*$Veto_thickness [$i]+ $i*2*$pass_in_thickness; 
        }
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx*cm $Veto_ly*cm $Veto_lz*cm";
        $detector{"material"}    = "$Veto_mat";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
        $detector{"sensitivity"} = "veto";
        $detector{"hit_type"}    = "veto";
        $detector{"identifiers"} = "sector manual 5 veto manual 100 channel manual $i";
         print_det(\%configuration, \%detector);

    } 


    # BACK
    for(my $i=0; $i<$Veto_layers; $i++){

         my $Veto_lx =$Veto_posx  ; 
        my $Veto_lz =$Veto_thickness[$i]; 
        my $Veto_ly =$Veto_posy ;
        if ($i>0){
             $Veto_lx =$Veto_posx  + 2*$i*$Veto_thickness[$i] + $i*2*$pass_in_thickness; 
             $Veto_ly =$Veto_posy + ($i*2)*$Veto_thickness[$i] + $i*2*$pass_in_thickness; 
        }  
        $detector{"name"}        = "back $i";
        $detector{"description"} = "back side $i";
        $detector{"color"}       = "ffd700"; #giallo + trasparency
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $X = 0.;
        $Y = 0.;
        $Z = -$Veto_posz +$Veto_thickness [$i] ;
        if ($i>0){
            $Z =-$Veto_posz - ($i*2-1)*$Veto_thickness [$i] - $i*2*$pass_in_thickness; 
        }
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$Veto_lx*cm $Veto_ly*cm $Veto_lz*cm";
        $detector{"material"}    = "$Veto_mat";			#defined in /GEMC/devel-2.6/sources/materials/cpp_materials.cc
        $detector{"sensitivity"} = "veto";
        $detector{"hit_type"}    = "veto";
        $detector{"identifiers"} = "sector manual 6 veto manual 100 channel manual $i";
        print_det(\%configuration, \%detector);

    }

} 
 

 ################################### Passive inside #####################################    

sub make_passive_in
{ 
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}


#/////////// RIGHT /////////#
       

for(my $i=1; $i<=$pass_in_layers; $i++){
   
    my $pass_in_lx =$pass_in_thickness;   
    my $pass_in_ly =$Veto_posy  + ($i*2-2)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i];
    my $pass_in_lz =$Veto_posz +  ($i*2-2)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i]; 
    $detector{"name"}        = " pass_in_right $i";
    $detector{"description"} = "right side $i ";
    $detector{"color"}       = "0000004"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = $Veto_posx  + ($i*2-1)*$pass_in_thickness +  ($i*2-2)*$Veto_thickness[$i];
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass_in_lx*cm $pass_in_ly*cm $pass_in_lz*cm";
    $detector{"material"}    = "$passive_in_mat";			
     print_det(\%configuration, \%detector);
}
 
    

#/////////// LEFT /////////#

for(my $i=1; $i<=$pass_in_layers; $i++){    

    my $pass_in_lx =$pass_in_thickness; 
    my $pass_in_ly =$Veto_posy + ($i*2-2)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i];
    my $pass_in_lz =$Veto_posz +  ($i*2-2)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i];
    $detector{"name"}        = " pass_in_left $i";
    $detector{"description"} = "left side $i";
    $detector{"color"}       = "0000004"; #black + trasparency
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Box";
    $X = - $Veto_posy - ($i*2-1)*$pass_in_thickness -  ($i*2-2)*$Veto_thickness[$i];
    $Y = 0.;
    $Z = 0.;
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$pass_in_lx*cm $pass_in_ly*cm $pass_in_lz*cm";
    $detector{"material"}    = "$passive_in_mat";			
     print_det(\%configuration, \%detector);

}

#/////////// UP /////////#

    for(my $i=1; $i<=$pass_in_layers; $i++){

        my $pass_in_lx =$Veto_posx + ($i*2-2)*$Veto_thickness[$i] + $i*2*$pass_in_thickness;  
        my $pass_in_ly =$pass_in_thickness; 
        my $pass_in_lz =$Veto_posz +  ($i*2-2)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i]; 
        $detector{"name"}        = "pass_in_up $i";
        $detector{"description"} = "up side $i ";
        $detector{"color"}       = "0000004"; #nero
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $X = 0.;
        $Y = +$Veto_posy+ (2*$i-2)*$Veto_thickness[$i] + (2*$i -1)*$pass_in_thickness ;
        $Z = 0.;
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$pass_in_lx*cm $pass_in_ly*cm $pass_in_lz*cm";
        $detector{"material"}    = "$passive_in_mat";
        print_det(\%configuration, \%detector);

    }
      

#/////////// DOWN /////////#
 
    for(my $i=1; $i<=$pass_in_layers; $i++){   

        my $pass_in_lx =$Veto_posx + ($i*2-2)*$Veto_thickness[$i] + $i*2*$pass_in_thickness;  
        my $pass_in_ly =$pass_in_thickness; 
        my $pass_in_lz =$Veto_posz +  ($i*2-2)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i];   
        $detector{"name"}        = "pass_in_down $i";
        $detector{"description"} = "down side $i";
        $detector{"color"}       = "0000004"; #nero
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $X = 0.;
        $Y = -$Veto_posy- (2*$i-2)*$Veto_thickness[$i] - (2*$i -1)*$pass_in_thickness ;
        $Z = 0.;
       $detector{"pos"}         = "$X*cm $Y*cm $Z*cm"; 
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$pass_in_lx*cm $pass_in_ly*cm $pass_in_lz*cm";
        $detector{"material"}    = "$passive_in_mat";
        print_det(\%configuration, \%detector);
    }


#/////////// FRONT /////////#

 
    for(my $i=1; $i<=$pass_in_layers; $i++){  

        my $pass_in_lx =$Veto_posx + ($i*2-2)*$Veto_thickness[$i] + $i*2*$pass_in_thickness; 
        my $pass_in_ly =$Veto_posy + ($i*2)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i];
        my $pass_in_lz =$pass_in_thickness;    
        $detector{"name"}        = "pass_in_front $i";
        $detector{"description"} = "front side $i ";
        $detector{"color"}       = "0000003"; 
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box"; 
        $X = 0.;
        $Y = 0.;
        $Z = $Veto_posz + ($i*2 -1)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i];
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$pass_in_lx*cm $pass_in_ly*cm $pass_in_lz*cm";
        $detector{"material"}    = "$passive_in_mat";	
        print_det(\%configuration, \%detector);
    }


    for(my $i=1; $i<=$pass_in_layers; $i++){ 

        my $pass_in_lx =$Veto_posx + ($i*2-2)*$Veto_thickness[$i] + $i*2*$pass_in_thickness; 
        my $pass_in_ly =$Veto_posy + ($i*2)*$pass_in_thickness + ($i*2-2)*$Veto_thickness[$i];
        my $pass_in_lz =$pass_in_thickness;    
        $detector{"name"}        = "pass_in_back $i";
        $detector{"description"} = "back side $i";
        $detector{"color"}       = "0000003"; 
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
        $X = 0.;
        $Y = 0.;
        $Z = -$Veto_posz -($i*2 -1)*$pass_in_thickness - ($i*2-2)*$Veto_thickness[$i];
        $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";	#
        $detector{"rotation"}    = "0*deg 0*deg 0*deg";
        $detector{"dimensions"}  = "$pass_in_lx*cm $pass_in_ly*cm $pass_in_lz*cm";
        $detector{"material"}    = "$passive_in_mat";
         print_det(\%configuration, \%detector); 

    }
   
   
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
    make_crystal;
    make_passive_in;
  # make_flux_cosmic_sph;		#Crea la routine flux_cosmic che disegna la sfera
}


1;

