
my $NchOV = 8;
my $DeltaAng = 360./$NchOV;
###
for(my $ib=1; $ib<($NchOV+1); $ib++)
{
    $par4=$ib*$DeltaAng+0.1; # +0.1deg tolerance
    $par5=($ib+1)*$DeltaAng-0.1;# -0.1deg tolerance
    $detector{"name"}        = "mutest_OV";
    
    $detector{"description"} = "OV in the pipe";
    $detector{"color"}       = "ff8000";
    $detector{"style"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "$X*cm $Y*cm $Z*cm";
    $detector{"rotation"}    = "$rotX*deg 0*deg 0*deg";
    $detector{"dimensions"}  = "$par1*cm $par2*cm $par3*cm $par4*deg $par5*deg";
    $detector{"material"}    = "ScintillatorB";
    $detector{"sensitivity"} = "veto";
    $detector{"hit_type"}    = "veto";
    #$detector{"identifiers"} = "sector manual 0 veto manual 7 channel manual $ib";
    print_det(\%configuration, \%detector);
    print  " OV segments = ",$par4,"-",$par5,"\n";
}
print  " OV INNER radius = ",$par1,"\n";
print  " OV OUTER radius = ",$par2,"\n";
print  " OV segmentations Nch = ",$NchOV,"\n";
