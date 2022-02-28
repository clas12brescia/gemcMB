
// G4 headers
#include "G4Poisson.hh"
#include "Randomize.hh"

// gemc headers
#include "veto_hitprocess.h"

// CLHEP units
#include "CLHEP/Units/PhysicalConstants.h"
using namespace CLHEP;

map<string, double> veto_HitProcess :: integrateDgt(MHit* aHit, int hitn)
{
	map<string, double> dgtz;
	vector<identifier> identity = aHit->GetId();

	int sector  = identity[0].id;
	int veto_id = identity[1].id;
	int channel = identity[2].id;
		
	// Digitization Parameters

 //	double adc_conv=10;                 // conversion factor from pC to ADC (typical sensitivy of CAEN VME QDC is of 0.1 pC/ch)
//	double adc_ped=0;                   // ADC Pedestal
//	double tdc_conv=1*ns;               // TDC conversion factor
	
    	// initialize ADC and TDC
   	double timeL = 0;
    	double timeR = 0;
    	int ADC1 = 0;
    	int ADC2 = 0;
    	int ADC3 = 0;
   	int ADC4 = 0;
    	int ADC5 = 0;
   	int ADC6 = 0;
  	int ADC7 = 0;
  	int ADC8 = 0;
  	int TDC1 = 4096;
  	int TDC2 = 4096;
   	int TDC3 = 4096;
 	int TDC4 = 4096;
   	int TDC5 = 4096;
   	int TDC6 = 4096;
   	int TDC7 = 4096;
   	int TDC8 = 4096;

    	// From measurement
   	 // spe = 0.36pC
   	 // Cosmic = 84pC (~235pe)
   	 // Attenuation at 80cm: ~0.85 -> effective att lenght ~350cm
    	//Plastic

   	double light_yield;  // number of optical photons pruced in the scintillator per MeV of deposited energy
  	double att_length      ;               // light at tenuation length
    	double peL=0.;
    	double peR;
    	double etot_g4=0.;
    	double etot_B=0.;
        double Etot   = 0;
        double X_hit_ave=0.;
        double Y_hit_ave=0.;
        double Z_hit_ave=0.;
        double T_hit_ave=0.;
        double Phi_hit=0.;
        double Phi_hit_ave=0.;
        double dLeft  =-10000.;
        double dRight  =-10000.;
        
        int chan=500+2*sector+channel;  //nVeto 500=D,501=U,502=L,503=R,504=F,505=B,506=LAr
        double veff=13*cm/ns    ;// TO BE CHECKED // light velocity in scintillator
        
        // scintillator sizes
        double sx=aHit->GetDetector().dimensions[0];
        double sy=aHit->GetDetector().dimensions[1];
        double sz=aHit->GetDetector().dimensions[2];
               
        cout << "Detecort Id = "<< chan<<" Detector size:    Xsize = " << sx << " " << "Ysize = " << sy<< " " << "Zsize = " << sz 	<< " "<< endl;

        vector<G4ThreeVector> Lpos = aHit->GetLPos(); // Interaction position relative to the detector center
        vector<G4double>      Edep = aHit->GetEdep(); // Deposited energy
        vector<G4double>      Dx   = aHit->GetDx();   // nstep dimension
        vector<int> charge = aHit->GetCharges();      // Charge for each step
        vector<G4double> times = aHit->GetTime();     // Time for each step
        
        unsigned int nsteps = Edep.size();

        for(unsigned int s=0; s<nsteps; s++) Etot = Etot + Edep[s];
        if(Etot>0)
        {
            for(unsigned int s=0; s<nsteps; s++)
            {
                etot_g4=etot_g4+Edep[s];
                
                double birks_constant_lAr = 0.00486;
                double Edep_B_lAr = BirksAttenuation(Edep[s],Dx[s],charge[s],birks_constant_lAr);
                etot_B=etot_B+Edep_B_lAr;
                
                // average hit position XYZ
                X_hit_ave=X_hit_ave+Lpos[s].x();
                Y_hit_ave=Y_hit_ave+Lpos[s].y();
                Z_hit_ave=Z_hit_ave+Lpos[s].z();
                Phi_hit=360-(360-(atan2(Lpos[s].x(),Lpos[s].y())/acos(-1.)*180.+180));
                Phi_hit_ave=Phi_hit_ave+Phi_hit;
                
                // average hit time
                T_hit_ave=T_hit_ave+times[s];
            } 
            
            X_hit_ave=X_hit_ave/nsteps;	// average hit position X
            Y_hit_ave=Y_hit_ave/nsteps;	// average hit position Y
            Z_hit_ave=Z_hit_ave/nsteps;	// average hit position Z
            Phi_hit_ave=Phi_hit_ave/nsteps;	// average Phi
            T_hit_ave=T_hit_ave/nsteps;	// average time 
            dLeft  =sz-Z_hit_ave;		// distance beween interaction point and readout on the left side
            dRight =sz+Z_hit_ave;		// distance beween interaction point and readout on the right side
            timeL= dLeft/veff+T_hit_ave;	// time between interaction and readout on the left side
            timeR= dRight/veff+T_hit_ave; 	// time between interaction and readout on the right side
            
            cout << "AVE X = " << X_hit_ave << " ,Y " << Y_hit_ave << " ,Z " << Z_hit_ave << " ,dRight " << dRight << " ,dLeft " << dLeft << "  ,Etot_B " <<etot_B  << "  ,Etot " <<etot_g4 << endl;
      
           
           
////////////PHOTO ELECTRON CALCULATION////////////////////    
//for nVeto: using directly the extracted pe from ps_sipm 
//////////////////////////////////////////////////////////

            double pe_ave_astro=0.; 
            double T_ave_astro =0.;
            att_length = 6000.; // 6m
            
            if( veto_id==500)
            {
                if (sector==0)	// Up and down - SiPm on the front
                {
                    pe_ave_astro=67*exp(-dRight/att_length);
                    T_ave_astro =timeR;
                } 
                else if (sector==1)	// Right and Left- SiPm on the front
                {
                    pe_ave_astro=67*exp(-dRight/att_length);
                    T_ave_astro =timeR;
                }
                else if (sector==2)	// Front and Back - SiPm on the front
                {
                    pe_ave_astro=67*exp(dRight/att_length);
                    T_ave_astro =timeR;
                }
                
                
                ADC1=G4Poisson(pe_ave_astro*etot_g4/4.1) ; // Scaling for more/less energy release)
                
                double sigmaTL=sqrt(pow(0.2*nanosecond,2.)+pow(1.*nanosecond,2.)/(pe_ave_astro+1.));
                sigmaTL=0.;
                TDC1=(T_ave_astro+G4RandGauss::shoot(0.,sigmaTL))*1000.;//time in ps
               
                //cout <<  " ++ HIT BEGIN ++++++" << endl ;
                //cout <<  " chan: " << channel << endl ;
                //cout <<  " ADC1: " << ADC1 << endl ;
                //cout <<  " TDC1: " << TDC1 << endl ;
                //cout <<  " Channel: " << chan << endl ;
                //cout <<  " ++ HIT END ++++++" << endl ;

            }
            
	    else if( veto_id==550)
            {
                pe_ave_astro=67*exp(-dRight/att_length);
                T_ave_astro =timeR;
             
                ADC6=G4Poisson(pe_ave_astro*etot_g4/4.1) ;
                ADC1=G4Poisson(pe_ave_astro*etot_B/4.1) ; // Scaling for more/less energy release)
                
                double sigmaTL=sqrt(pow(0.2*nanosecond,2.)+pow(1.*nanosecond,2.)/(pe_ave_astro+1.));
                sigmaTL=0.;
                TDC1=(T_ave_astro+G4RandGauss::shoot(0.,sigmaTL))*1000.;//time in ps
               
                //cout <<  " ++ HIT BEGIN ++++++" << endl ;
                //cout <<  " chan: " << channel << endl ;
                cout <<  " ADC1 con Briks per lAr: " << ADC1 <<  " ADC6:senza Briks per lAr solo per confronto " << ADC6 <<endl ;
                //cout <<  " TDC1: " << TDC1 << endl ;
                //cout <<  " Channel: " << chan << endl ;
                //cout <<  " ++ HIT END ++++++" << endl ;

            }
              
      
        }// closes (Etot > 0) loop
        
	dgtz["hitn"]    = hitn;
	dgtz["sector"]  = sector;
	dgtz["veto"]    = veto_id;
	dgtz["channel"] = channel;
	dgtz["adc1"]    = ADC1;// output in pe
	dgtz["adc2"]    = ADC2;//deposited energy in keV
  	dgtz["adc3"]    = ADC3;// ignore
  	dgtz["adc4"]    = ADC4;// ignore
  	dgtz["adc5"]    = ADC5;// ignore
  	dgtz["adc6"]    = ADC6;// ignore
  	dgtz["adc7"]    = ADC7;// ignore
  	dgtz["adc8"]    = ADC8;// ignore

	dgtz["tdc1"]    = TDC1;// output in ps
	dgtz["tdc2"]    = TDC2;// ignore
    	dgtz["tdc3"]    = TDC3;// ignore
    	dgtz["tdc4"]    = TDC4;// ignore
    	dgtz["tdc5"]    = TDC5;// ignore
    	dgtz["tdc6"]    = TDC6;// ignore
    	dgtz["tdc7"]    = TDC7;// ignore
    	dgtz["tdc8"]    = TDC8;// ignore

	return dgtz;
}


vector<identifier>  veto_HitProcess :: processID(vector<identifier> id, G4Step *step, detector Detector)
{
	id[id.size()-1].id_sharing = 1;
	return id;
}



double veto_HitProcess::BirksAttenuation(double destep, double stepl, int charge, double birks)
{
	//Example of Birk attenuation law in organic scintillators.
	//adapted from Geant3 PHYS337. See MIN 80 (1970) 239-244
	//
	// Taken from GEANT4 examples advanced/amsEcal and extended/electromagnetic/TestEm3
	//
	double response = destep;
	if (birks*destep*stepl*charge != 0.)
	{
		response = destep/(1. + birks*destep/stepl);
	}
	return response;
}


double veto_HitProcess::BirksAttenuation2(double destep,double stepl,int charge,double birks)
{
	//Extension of Birk attenuation law proposed by Chou
	// see G.V. O'Rielly et al. Nucl. Instr and Meth A368(1996)745
	// 
	//
	double C=9.59*1E-4*mm*mm/MeV/MeV;
	double response = destep;
	if (birks*destep*stepl*charge != 0.)
	{
		response = destep/(1. + birks*destep/stepl + C*pow(destep/stepl,2.));
	}
	return response;
}


map< string, vector <int> >  veto_HitProcess :: multiDgt(MHit* aHit, int hitn)
{
	map< string, vector <int> > MH;
	
	return MH;
}



// - electronicNoise: returns a vector of hits generated / by electronics.
vector<MHit*> veto_HitProcess :: electronicNoise()
{
    vector<MHit*> noiseHits;
    
    // first, identify the cells that would have electronic noise
    // then instantiate hit with energy E, time T, identifier IDF:
    //
    // MHit* thisNoiseHit = new MHit(E, T, IDF, pid);
    
    // push to noiseHits collection:
    // noiseHits.push_back(thisNoiseHit)
    
    return noiseHits;
}

// - charge: returns charge/time digitized information / step
map< int, vector <double> > veto_HitProcess :: chargeTime(MHit* aHit, int hitn)
{
    map< int, vector <double> >  CT;
    
    return CT;
}

// - voltage: returns a voltage value for a given time. The inputs are:
// charge value (coming from chargeAtElectronics)
// time (coming from timeAtElectronics)
double veto_HitProcess :: voltage(double charge, double time, double forTime)
{
    return 0.0;
}








