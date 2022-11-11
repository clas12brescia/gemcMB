
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
  
  // double birks_constant=aHit->GetDetector().GetLogical()->GetMaterial()->GetIonisation()->GetBirksConstant();
   // G4cout << " Birks constant is: " << aHit->GetDetector().GetLogical()->GetMaterial()->GetIonisation()->GetBirksConstant() << endl;

 //	double adc_conv=10;                 // conversion factor from pC to ADC (typical sensitivy of CAEN VME QDC is of 0.1 pC/ch)
//	double adc_ped=0;                   // ADC Pedestal
//	double tdc_conv=1*ns;               // TDC conversion factor
	
    	// initialize ADC and TDC
   	double timeL = 0;
    double timeR = 0;
    double dig_Edep = 0;
    double ADC1 = 0;
    double ADC2 = 0;
    double ADC3 = 0;
   	double ADC4 = 0;
    double ADC5 = 0;
   	double ADC6 = 0;
  	double ADC7 = 0;
  	double ADC8 = 0;
  	double TDC1 = 4096;
  	double TDC2 = 4096;
   	double TDC3 = 4096;
 	double TDC4 = 4096;
   	double TDC5 = 4096;
   	double TDC6 = 4096;
   	double TDC7 = 4096;
   	double TDC8 = 4096;

    // From measurement
   	// spe = 0.36pC
   	// Cosmic = 84pC (~235pe)
   	// Attenuation at 80cm: ~0.85 -> effective att lenght ~350cm
	//Plastic

   	//double light_yield;  // number of optical photons pruced in the scintillator per MeV of deposited energy
    double att_length      ;               // light at tenuation length
    double peL=0.;
    //double peR;
    double etot=0.;
    double Etot   = 0;
    double X_hit_ave=0.;
    double Y_hit_ave=0.;
    double Z_hit_ave=0.;
    double T_hit_ave=0.;
    double Phi_hit=0.;
    double Phi_hit_ave=0.;
    double dLeft  =-10000.;
    double dRight  =-10000.;
    double veff=13*cm/ns    ;// TO BE CHECKED // light velocity in scintillator
        
    // scintillator sizes
    double sx=aHit->GetDetector().dimensions[0];
    double sy=aHit->GetDetector().dimensions[1];
    double sz=aHit->GetDetector().dimensions[2];
               
    // cout <<"sector= "<<sector<<"   Detector size: Zsize = " << sz << endl;

    vector<G4ThreeVector> Lpos = aHit->GetLPos(); // Interaction position relative to the detector center
    vector<G4double>      Edep = aHit->GetEdep(); // Deposited energy
    vector<G4double>      Dx   = aHit->GetDx();   // nstep dimension
    vector<int>           charge = aHit->GetCharges(); // Charge for each step
    vector<G4double>      times = aHit->GetTime();  // Time for each step
        
    unsigned int nsteps = Edep.size();
	
    for(unsigned int s=0; s<nsteps; s++) Etot = Etot + Edep[s];
    if(Etot>0)
    {
        for(unsigned int s=0; s<nsteps; s++) // ciclo sugli nstep di ogni hit che formano l'evento
        {
            etot=etot+Edep[s];
                                                            
            // average hit position XYZ
            X_hit_ave=X_hit_ave+Lpos[s].x();
            Y_hit_ave=Y_hit_ave+Lpos[s].y();
            Z_hit_ave=Z_hit_ave+Lpos[s].z();
           // Phi_hit=360-(360-(atan2(Lpos[s].x(),Lpos[s].y())/acos(-1.)*180.+180));
            //Phi_hit_ave=Phi_hit_ave+Phi_hit;
            
            // average hit time
            T_hit_ave=T_hit_ave+times[s];
        } 
            
        X_hit_ave=X_hit_ave/nsteps;	// average hit position X
        Y_hit_ave=Y_hit_ave/nsteps;	// average hit position Y
        Z_hit_ave=Z_hit_ave/nsteps;	// average hit position Z
        // Phi_hit_ave=Phi_hit_ave/nsteps;	// average Phi
        T_hit_ave=T_hit_ave/nsteps;	// average time 
        dLeft  =sz-Z_hit_ave;		// distance beween interaction point and readout on the left side
        //dRight =sz+Z_hit_ave;		// distance beween interaction point and readout on the right side
        timeL= dLeft/veff+T_hit_ave;	// time between interaction and readout on the left side
        //timeR= dRight/veff+T_hit_ave; 	// time between interaction and readout on the right side
        
        //cout << "AVE X = " << X_hit_ave << " ,Y " << Y_hit_ave << " ,Z " << Z_hit_ave << " ,dRight " << dRight << " ,dLeft " << dLeft << "  ,etot " <<etot  << "  ,Etot " <<etot << endl;
        //cout<<"dLeft= "<<dLeft<<"  dRight= "<<dRight<<endl;
        dig_Edep=etot; 

//////////////////////////////////////////////////////////
        double *pe_sipm;// response for a mip (2..05 MeV energy released in 1cm thick)

        pe_sipm=IVresponseProposal(sector, channel, X_hit_ave, Y_hit_ave, Z_hit_ave,sx,sy,sz);
            
        ADC1=G4Poisson(pe_sipm[0]*etot/2.05) ; // Scaling for more/less energy release)
        ADC2=G4Poisson(pe_sipm[1]*etot/2.05) ; // Scaling for more/less energy release)
        ADC3=G4Poisson(pe_sipm[2]*etot/2.05) ; // Scaling for more/less energy release)
        ADC4=G4Poisson(pe_sipm[3]*etot/2.05) ; // Scaling for more/less energy release)
        

      /*  cout<<"Etot  "<< etot<<" sector "<<sector<<"  channel" << channel <<endl;
        cout<<" pe sipm[0]  "<<pe_sipm[0]<<"  adc1  "<<ADC1<<endl;  
        cout<<" pe sipm[1]  "<<pe_sipm[1]<<"  adc2  "<<ADC2<<endl; 
        cout<<" pe sipm[2]  "<<pe_sipm[2]<<"  adc3  "<<ADC3<<endl; 
        cout<<" pe sipm[3]  "<<pe_sipm[3]<<"  adc4  "<<ADC4<<endl;  
*/
        //adding a gaussian spread accoring to Luca's tabel
        if(ADC1>0) ADC1=(ADC1+G4RandGauss::shoot(0.,13.));
        else ADC1=0.;
        if(ADC2>0) ADC2=(ADC2+G4RandGauss::shoot(0.,13.));
        else ADC2=0.;
        if(ADC3>0) ADC3=(ADC3+G4RandGauss::shoot(0.,13.));
        else ADC3=0.;
        if(ADC4>0) ADC4=(ADC4+G4RandGauss::shoot(0.,13.));
        else ADC4=0.;
     
            
        double sigmaTL=sqrt(pow(0.2*nanosecond,2.)+pow(1.*nanosecond,2.)/(peL+1.));
        sigmaTL=0.;
        TDC1=(timeL+G4RandGauss::shoot(0.,sigmaTL))*1000.;//time in ps
        TDC2=(timeL+G4RandGauss::shoot(0.,sigmaTL))*1000.;//time in ps
        TDC3=(timeL+G4RandGauss::shoot(0.,sigmaTL))*1000.;//time in ps
        TDC4=(timeL+G4RandGauss::shoot(0.,sigmaTL))*1000.;//time in ps
        
         //cout <<  log_msg << " veto: " << veto_id   << ", channel: " << channel << ", sector: " << sector << endl;
          //cout << "X " << X_hit_ave << " " << "Y " << Y_hit_ave << " " << "Z " << Z_hit_ave << " "<< "T " <<T_hit_ave << " " << endl;
          //cout << "sipm1 " << pe_sipm[0] << " " << "sipm2 " << pe_sipm[1] << " " << "sipm3 " << pe_sipm[2] << " " << "sipm4 " << pe_sipm[3] << " " << endl;
        // cout << "dLeft " << dLeft << " " << "timeL " << timeL << " " << endl;
        
        //cout << "energy right: " << ADC2 / (adc_conv*sensor_gain*sensor_qe*light_yield) << " E left: " << ADC1 / (adc_conv*sensor_gain*sensor_qe*light_yield) << endl;
        //cout << "energy forw: " << ADCF / (adc_conv*sensor_gain*sensor_qe*light_yield) << " E back: " << ADCB / (adc_conv*sensor_gain*sensor_qe*light_yield) << endl;
            
        //cout << " Light collection: " << light_coll << endl; 
            
        }// closes (Etot > 0) loop
        
	dgtz["hitn"]    = hitn;
	dgtz["sector"]  = sector;
	dgtz["veto"]    = veto_id;
	dgtz["channel"] = channel;
    dgtz["dig_Edep"]= dig_Edep;// deposited energy in MeV
	dgtz["adc1"]    = ADC1;
	dgtz["adc2"]    = ADC2;
  	dgtz["adc3"]    = ADC3;
  	dgtz["adc4"]    = ADC4;
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

double* veto_HitProcess::IVresponseProposal(int sector, int channel, double xx, double yy,double zz, double sx, double sy, double sz)
{
    // Response of the different IV plastic paddles
    // ch
    //
    //
    static double response[4];
    
    for(unsigned int s=0; s<4; s++)response[s] = 0.;
    
    if (sector==4)//top
    {
        double x=xx/10.;
        double y=(sz-zz)/10.;
        double normfactor[4]={1.23, 1.45, 1.25, 1.91};

        double parm[4][8]={
            {1.99627e+01,   1.64910e-01,    -5.83528e-01,   -7.34483e-03,   -1.25062e-03,   4.43805e-03,    5.63766e-05,    1.40682e-05},
            {1.86162e+01,   4.36475e-02,    -6.78752e-02,   -5.47887e-03,   -1.60512e-04,   -2.33958e-02,   5.55285e-05,    -5.94424e-05},
            {1.85966e+01,   1.96301e-01,    1.34868e-01,    -7.66131e-04,   -1.61720e-03,   -1.91598e-02,   -1.76198e-06,   -4.72970e-05},
            {9.73394e+00,   1.56111e-01,    3.27558e-01,    2.45041e-03,    -1.31615e-03,   5.82688e-03,    -1.48528e-05,   2.35177e-05}
            
        };
        
        int s=0;
        if (channel == 0) s=0;
        if (channel == 1) s=1;
        if (channel == 2) s=2;
        if (channel == 3) s=3;

        response[s] = parm[s][7]*x*x*y + parm[s][6]*x*y*y + parm[s][5]*x*x + parm[s][4]*y*y + parm[s][3]*x*y + parm[s][2]*x + parm[s][1]*y + parm[s][0];
        response[s] = response[s] * normfactor[s];
        //     cout <<  " x: " << x <<  " y: " << y << " zz: " << zz << endl ;
        //cout <<  " res[0]: " << response[0] <<  " res[1]: " << response[1]<<  " res[2]: " << response[2]<<  " res[3]: " << response[3]  << endl ; 
        
    }
    else if (sector==3)//bottom copying the top with X,Y swapped
    {// Assuming an overall size of 42.8 cm with 4 bars of
        double x=-(xx-sx)/10;
        double y=(sz-zz)/10.;
        
        double normfactor[4]={1.23, 1.45, 1.25, 1.91};
        
        double parm[4][8]={
            {1.99627e+01,   1.64910e-01,    -5.83528e-01,   -7.34483e-03,   -1.25062e-03,   4.43805e-03,    5.63766e-05,    1.40682e-05},
            {1.86162e+01,   4.36475e-02,    -6.78752e-02,   -5.47887e-03,   -1.60512e-04,   -2.33958e-02,   5.55285e-05,    -5.94424e-05},
            {1.85966e+01,   1.96301e-01,    1.34868e-01,    -7.66131e-04,   -1.61720e-03,   -1.91598e-02,   -1.76198e-06,   -4.72970e-05},
            {9.73394e+00,   1.56111e-01,    3.27558e-01,    2.45041e-03,    -1.31615e-03,   5.82688e-03,    -1.48528e-05,   2.35177e-05}
            
        };
        
        int s=0;
        if (channel == 0) s=0;
        if (channel == 1) s=1;
        if (channel == 2) s=2;
        if (channel == 3) s=3;

        response[s] = parm[s][7]*x*x*y + parm[s][6]*x*y*y + parm[s][5]*x*x + parm[s][4]*y*y + parm[s][3]*x*y + parm[s][2]*x + parm[s][1]*y + parm[s][0];
            response[s] = response[s] * normfactor[s];
    
        // cout <<  " x: " << x <<  " y: " << y << " zz: " << zz << endl ;
        //  cout <<  " res[0]: " << response[0] <<  " res[1]: " << response[1]<<  " res[2]: " << response[2]<<  " res[3]: " << response[3]  << endl ;
        
    }
    else if (sector==5)// Side Upstream
    {// Assuming an overall size of 42.8 cm with 4 bars of
        double x=-xx/10;
        double y=(yy+sy)/10.;
        
        double parm[4]={-0.04, -0.05, 1.4, 85.};
        double normfactor[1]={1.13};
       
        for(unsigned int s=0; s<4; s++) response[s] =0.;

        int s=0;
        if (channel == 0) s=0;
        if (channel == 1) s=1;
        if (channel == 2) s=2;
        if (channel == 3) s=3;

        response[s] = parm[0]*x*x + parm[1]*y*y + parm[2]*y + parm[3];
        response[s] = response[s] * normfactor[0];

        // cout <<  " x: " << x <<  " y: " << y << " yy: " << yy << endl ;
        // cout <<  " res[0]: " << response[0] <<  " res[1]: " << response[1]<<  " res[2]: " << response[2]<<  " res[3]: " << response[3]  << endl ;
        
    }
    else if (sector==6)// Side Downstream
    {// Assuming an overall size of 42.8 cm with 4 bars of
        double x=xx/10;
        double y=(yy+sy)/10.;
        
        double parm[4]={-0.04, -0.05, 1.4, 75.};
        double normfactor[1]={1.03};
        
        int s=0;
        if (channel == 0) s=0;
        if (channel == 1) s=1;
        if (channel == 2) s=2;
        if (channel == 3) s=3;

        for(unsigned int s=0; s<4; s++) response[s] =0.;

        response[s] = parm[0]*x*x + parm[1]*y*y + parm[2]*y + parm[3];
        response[s] = response[s] * normfactor[0];

        //cout <<  " x: " << x <<  " y: " << y << " yy: " << yy << endl ;
        //cout <<  " res[0]: " << response[0] <<  " res[1]: " << response[1]<<  " res[2]: " << response[2]<<  " res[3]: " << response[3]  << endl ;
        
    }
    
    else if (sector==1)//Right
    {
        double x=-yy/10.;
        double y=(sz-zz)/10.;
 
        double parm[4][8]={
            {2.34524e+01,   4.28317e-02,    -5.91894e-01,   -5.13309e-03,   -2.47905e-04,   -3.44887e-03,   4.25481e-05,    -1.03817e-05},
            {1.68313e+01,   5.36853e-02,    -2.14037e-01,   -4.80535e-03,   -4.65364e-04,   -1.66572e-02,   4.89028e-05,    -3.33380e-05},
            {2.50310e+01,   -3.10007e-02,   3.57657e-01,    -1.39833e-02,   2.99406e-04,    -3.23669e-02,   1.27237e-04,    -1.13100e-05},
            {1.74834e+01,   1.83925e-01,    5.36737e-01,    7.09769e-04,    -1.64490e-03,   7.48199e-03,    3.43011e-08,    2.11894e-05}
            
        };
        double normfactor[4]={1.08, 1.02, 0.96, 0.97};

        int s=0;
        if (channel == 0) s=0;
        if (channel == 1) s=1;
        if (channel == 2) s=2;
        if (channel == 3) s=3;

        response[s] = parm[s][7]*x*x*y + parm[s][6]*x*y*y + parm[s][5]*x*x + parm[s][4]*y*y + parm[s][3]*x*y + parm[s][2]*x + parm[s][1]*y + parm[s][0];
                    response[s] = response[s] * normfactor[s];
        //cout <<  " x: " << x <<  " y: " << y << " zz: " << zz << endl ;
        //cout <<  " res[0]: " << response[0] <<  " res[1]: " << response[1]<<  " res[2]: " << response[2]<<  " res[3]: " << response[3]  << endl ;
        
    }
    else if (sector==2)//Left
    {
        double x=-yy/10.;
        double y=(sz-zz)/10.;
        
        double parm[4][8]={
            {8.12418e+00,   6.61315e-02,    -2.99641e-01,   -9.10408e-04,   -6.79474e-04,   2.00648e-03,    1.24963e-05,    -1.73809e-05},
            {1.19501e+01,   4.76291e-02,    -1.77047e-01,   9.27111e-05,    -4.63061e-04,   -1.40014e-02,   4.39766e-06,    -2.93896e-05},
            {1.68607e+01,   -4.15476e-02,   2.54857e-01,    -6.87363e-03,   3.26876e-04,    -2.65178e-02,   5.62748e-05,    -3.56067e-06},
            {9.73394e+00,   1.56111e-01,    3.27558e-01,    2.45041e-03,    -1.31615e-03,   5.82688e-03,    -1.48528e-05,   2.35177e-05}
            
        };
        double normfactor[4]={1.09, 1.14, 0.68, 0.63};

        int s=0;
        if (channel == 0) s=0;
        if (channel == 1) s=1;
        if (channel == 2) s=2;
        if (channel == 3) s=3;

        response[s] = parm[s][7]*x*x*y + parm[s][6]*x*y*y + parm[s][5]*x*x + parm[s][4]*y*y + parm[s][3]*x*y + parm[s][2]*x + parm[s][1]*y + parm[s][0];
        response[s] = response[s] * normfactor[s];
    
    }
    
    //  cout <<  " res[0]: " << response[0] <<  " res[1]: " << response[1]<<  " res[2]: " << response[2]<<  " res[3]: " << response[3]  << endl ;
    // cout <<  " res[0]: " << response[0] << " channel " << channel<<endl;
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








