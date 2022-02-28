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
        $detector{"name"}        = "bdx_real_main_volume";
        $detector{"mother"}      = "root";
        $detector{"description"} = "World";
        $detector{"color"}       = "666666";
        $detector{"color"}       = "f00000";
        $detector{"style"}       = 0;
        $detector{"visible"}     = 1;
        $detector{"type"}        = "Box";
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
        # $detector{"material"}    = "G4_AIR";
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


##########################################
# NaI Compton scattering detector
##########################################
# starting from 0,0,0 define the different shifts
my $shX=0.;
my $shY=0.;
my $shZ=0.;


sub make_NaI
{
    my $X = 0.;
    my $Y = 0.;
    my $Z = 0.;
    my $cry_IRd=0.;
    my $cry_Rd=7.6/2.; #Diam/2
    my $cry_Lt=7.6/2.; #Semi-lenght
    
    my $refl_thkS = 0.2/2; #Thikness of reflective material on the side
    my $refl_thkF = 0.3/2; #Thikness of reflective material on the front
    my $refl_LtS = $cry_Lt + $refl_thkF;
    my $refl_IRd = $cry_Rd;
    my $refl_Rd =  $cry_Rd + $refl_thkS*2.;
    my $refl_zS= $refl_thkF;
    my $refl_zF= $cry_Lt+$refl_thkF;

    my $silpad_thk = 0.2/2; #Thikness of Silicon Pad
    my $silpad_z= $refl_zF + $refl_thkF + $silpad_thk;
    my $silpad_Rd = $cry_Rd+$refl_thkS*2.;

    my $al_thkS = 0.15/2; #Thikness of Al cup  on the side
    my $al_thkF = 0.15/2; #Thikness of Al cup on the front
    my $al_LtS =  $cry_Lt + $refl_thkF + $silpad_thk + $al_thkF ;
    my $al_IRd = $silpad_Rd;
    my $al_Rd =  $silpad_Rd + $al_thkS*2.;
    my $al_zS= $refl_thkF + $silpad_thk + $al_thkF;
    my $al_zF= $cry_Lt + 2*$refl_thkF + 2*$silpad_thk + $al_thkF;

    my $pmt_Lt = 3.0/2;# PMT lenght treated as a Al cylinder
    my $pmt_Rd = 8.2/2;# PMT diam/2 treated as a Al cylinder
    my $pmt_z=-($cry_Lt+$pmt_Lt);
    
    my %detector = init_det();
    if ($configuration{"variation"} eq "CT")
    {$detector{"mother"}      = "bdx_main_volume";}
    else
    {$detector{"mother"}      = "Det_house_inner";}
    
    # PMT treated as a solid Al cylinder
    $detector{"name"}        = "PMT";
    $detector{"description"} = "PMT volume";
    $detector{"color"}       = "c0c0c0";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $pmt_z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$0.*cm $pmt_Rd*cm $pmt_Lt*cm 0.*deg 360.*deg";
    $detector{"material"}    = "G4_Al";
    print_det(\%configuration, \%detector);

    
    # Al2O3 Reflector side
    $detector{"name"}        = "reflectorSide";
    $detector{"description"} = "Al2O3 reflector side";
    $detector{"color"}       = "e4e3e4";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $refl_zS*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$refl_IRd*cm $refl_Rd*cm $refl_LtS*cm 0.*deg 360.*deg";
    $detector{"material"}    = "Al2O3";
    print_det(\%configuration, \%detector);
    # Al2O3 Reflector front
    $detector{"name"}        = "reflectorFront";
    $detector{"description"} = "Al2O3 reflector front";
    $detector{"color"}       = "e4e3e4";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $refl_zF*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "0.*cm $refl_IRd*cm $refl_thkF*cm 0.*deg 360.*deg";
    $detector{"material"}    = "Al2O3";
    print_det(\%configuration, \%detector);
    # Silicon pad
    $detector{"name"}        = "siliconpad";
    $detector{"description"} = "Silicon pad";
    $detector{"color"}       = "d1e7f4";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $silpad_z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "0.*cm $silpad_Rd*cm $silpad_thk*cm 0.*deg 360.*deg";
    $detector{"material"}    = "Silicone";
    print_det(\%configuration, \%detector);
    # Al cup
    $detector{"name"}        = "alcup";
    $detector{"description"} = "Al cup";
    $detector{"color"}       = "c0c0c0";
    $detector{"style"}       = 0;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $al_zS*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$al_IRd*cm $al_Rd*cm $al_LtS*cm 0.*deg 360.*deg";
    $detector{"material"}    = "G4_Al";
    print_det(\%configuration, \%detector);
    # Al cup front
    $detector{"name"}        = "alcupFront";
    $detector{"description"} = "Alcup front";
    $detector{"color"}       = "c0c0c0";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $al_zF*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "0.*cm $al_IRd*cm $al_thkF*cm 0.*deg 360.*deg";
    $detector{"material"}    = "G4_Al";
    print_det(\%configuration, \%detector);
    # Crystals
    %detector = init_det();
    {$detector{"mother"}      ="bdx_main_volume";}
    $detector{"name"}        = "crystal";
    $detector{"description"} = "Crystal";
    $detector{"color"}       = "00ffff";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    my $par1 =$cry_IRd ;#IRadius
    my $par2 =$cry_Rd; #Radius
    my $par3 =$cry_Lt ; #lenght
    my $par4 =0.  ;
    my $par5 =360. ;
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg";
    $detector{"material"}    = "NaI_Tl";
    $detector{"sensitivity"} = "crs";
    $detector{"hit_type"}    = "crs";
    $detector{"identifiers"} = "sector manual 600 xch manual 0 ych manual 0";
    print_det(\%configuration, \%detector);
    
}




sub make_bdx_CT
{
    make_main_volume();
    #make_EEE_MRPC;
    #make_EEE_MRPC_flux;
    make_NaI;
    #make_EEE_ASTRO;
    #make_flux_cosmic_sph;
}








1;

