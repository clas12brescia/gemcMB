
use strict;
use warnings;

our %configuration;
our %parameters;


sub define_cormo_hit
{
	# uploading the hit definition
	my %hit = init_hit();
	$hit{"name"}            = "cormo";
	$hit{"description"}     = "BDX cormorino detector";
	$hit{"identifiers"}     = "sector layer paddle";
	$hit{"signalThreshold"} = "200.0*KeV";
	$hit{"timeWindow"}      = "4*ns";
	$hit{"prodThreshold"}   = "100*um";
	$hit{"maxStep"}         = "1*mm";
	$hit{"delay"}           = "10*ns";
	$hit{"riseTime"}        = "1*ns";
	$hit{"fallTime"}        = "1*ns";
	$hit{"mvToMeV"}         = 100;
	$hit{"pedestal"}        = -20;
	print_hit(\%configuration, \%hit);
	
	%hit = init_hit();
	$hit{"name"}            = "veto";
	$hit{"description"}     = "BDX cormorino veto";
	$hit{"identifiers"}     = "sector veto channel";
	$hit{"signalThreshold"} = "200.0*KeV";
	$hit{"timeWindow"}      = "1000*ns";
	$hit{"prodThreshold"}   = "100*um";
	$hit{"maxStep"}         = "500*um";
	$hit{"delay"}           = "10*ns";
	$hit{"riseTime"}        = "1*ns";
	$hit{"fallTime"}        = "1*ns";
	$hit{"mvToMeV"}         = 100;
	$hit{"pedestal"}        = -20;
	print_hit(\%configuration, \%hit);

    %hit = init_hit();
    $hit{"name"}            = "det";
    $hit{"description"}     = "liquid argon";
    $hit{"identifiers"}     = "sector det channel";
    $hit{"signalThreshold"} = "200.0*KeV";
    $hit{"timeWindow"}      = "5000*ns";
    $hit{"prodThreshold"}   = "0.01*um";	 			#se scendo al di sotto non lo considera
    $hit{"maxStep"}         = "1*mm";
    $hit{"delay"}           = "10*ns";
    $hit{"riseTime"}        = "1*ns";
    $hit{"fallTime"}        = "1*ns";
    $hit{"mvToMeV"}         = 100;
    $hit{"pedestal"}        = -20;
    print_hit(\%configuration, \%hit);

    %hit = init_hit();
    $hit{"name"}            = "crs";
    $hit{"description"}     = "BDX crystals";
    $hit{"identifiers"}     = "sector layer paddle";
    $hit{"signalThreshold"} = "200.0*KeV";
    $hit{"timeWindow"}      = "4000*ns";
    $hit{"prodThreshold"}   = "10*um";
    $hit{"maxStep"}         = "1*mm";
    $hit{"delay"}           = "10*ns";
    $hit{"riseTime"}        = "1*ns";
    $hit{"fallTime"}        = "1*ns";
    $hit{"mvToMeV"}         = 100;
    $hit{"pedestal"}        = -20;
    print_hit(\%configuration, \%hit);

}


sub define_bdx_hits
{
	define_cormo_hit();
}


1;
