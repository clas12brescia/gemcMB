#include "vetoClass.h"
#include "detClass.h"
#include "generatedClass.h"
#include "fluxClass.h"
#include <TH2.h>
#include <TH3.h>
#include <TStyle.h>
#include <TCanvas.h>
#include "iostream"
#include <map>
#include <math.h>

bool Debug = false;

/*
	Import the bin list and content from
	a singole file using a TGraph, then
	get the arrays from the TGraph 

*/

void lAr_n_eff(string inputname="Sci1cm_p33,6MeV"){
	
	string filename("Output_gemc/out_" + inputname + ".root");
	string outname("Output/Sort_" + inputname + ".root");


	// Use a TGraph just to import bin (values and contents)
	// from a text file. The resulting arrays will be used
	// later to compute weigths based on neutron flux 
	TGraph tempGraph = TGraph("tabelle_corrette/bin_flux_table.dat");
	Int_t fluxBinNumber = tempGraph.GetN();
	Double_t * fluxBinLeftEdge = tempGraph.GetX();
	Double_t * fluxBinContent = tempGraph.GetY();


	// Open the file
	TFile * f = new TFile(filename.c_str());

	// Get the tree(s)
	TTree * veto = (TTree * ) f->Get("veto");
	TTree * det = (TTree * ) f->Get("det");
	TTree * generated = (TTree * ) f->Get("generated");
	TTree * flux = (TTree * ) f->Get("flux");

	// new objects 
	detClass * myDet = new detClass(det);
	vetoClass * myVe = new vetoClass(veto);
	generatedClass * myGen= new generatedClass(generated);
	fluxClass * myFl = new fluxClass(flux);

//	myVe->Init(veto);
//	myGen->Init(generated);
//	myFl->Init(flux);
	
	////////////////////
	// HISTOS DEFINITION
	////////////////////
	
	char name[100];
	
	
	//lAr
	
	TH1D *Gen_Ek= new TH1D("Gen_Ek","Gen_Ek",10000,0,0.5);
		Gen_Ek->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_Ek_det= new TH1D("Gen_Ek_det","Gen_Ek_det",10000,0,0.5);
		Gen_Ek_det->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_det->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_Ek_det_binT= new TH1D("Gen_Ek_det_binT","Gen_Ek_det_binT",429,fluxBinLeftEdge);
		Gen_Ek_det_binT->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_det_binT->GetYaxis()->SetTitle("Counts");  	

	TH1D *Gen_mom = new TH1D("Gen_mom","Gen_mom",10000,0,1);
		Gen_mom->GetXaxis()->SetTitle("Momentum [GeV/c^2]");
	  	Gen_mom->GetYaxis()->SetTitle("Counts");

    TH1D *Gen_Ek_lAr= new TH1D("Gen_Ek_lAr","Gen_Ek_lAr",10000,0,0.5);
		Gen_Ek_lAr->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_lAr->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_Ek_lAr_binT= new TH1D("Gen_Ek_lAr_binT","Gen_Ek_lAr_binT",429,fluxBinLeftEdge);
		Gen_Ek_lAr_binT->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_lAr_binT->GetYaxis()->SetTitle("Counts");

	TH1D *NFlux= new TH1D("NFlux","NFlux",429,fluxBinLeftEdge);
		NFlux->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	NFlux->GetYaxis()->SetTitle("flux");  

    TH2D *Edep_lAr_veto= new TH2D("Edep_lAr_veto","Edep_lAr_veto",10000,0,0.5,10000,0,0.5);
		Edep_lAr_veto->GetXaxis()->SetTitle("det Energy [GeV]");
	  	Edep_lAr_veto->GetYaxis()->SetTitle("veto Energy [GeV]");

	TH1D *Edep_veto= new TH1D("Edep_veto","Edep_veto",10000,0,2);
		Edep_veto->GetXaxis()->SetTitle("Energy [GeV]");
	  	Edep_veto->GetYaxis()->SetTitle("counts"); 

	TH1D *adc_veto= new TH1D("adc_veto","adc_veto",10000,0,10);
		adc_veto->GetXaxis()->SetTitle("Energy [GeV]");
	  	adc_veto->GetYaxis()->SetTitle("counts"); 
  	

		
    double Edep_min =10; //in keV
    double Edep_max = 100; //in keV
    double veto_threshold=1000; //in keV
   	double n_mass = 939.565378; // in MeV
  	int det_mult_hit=0;
  	int veto_hit=0;
	int no_hit=0;
	int Edep_no=0;

	//////////////////////
	// START OF THE LOOP
	//////////////////////

	Long64_t nentries = det->GetEntries();
	if (Debug){
		nentries=1000;
		//cout << "How many nentries?" <<endl;
   		//cin>>nentries;
    	cout << "Working in debug mode: " <<nentries<< endl;
  	}

  	cout << "WORKING ON nentries =" << nentries << endl;
  	Long64_t nbytes = 0, nb = 0;
  

  	for (int i=0; i<fluxBinNumber-1; i++) {
		NFlux->Fill(fluxBinLeftEdge[i],fluxBinContent[i]);
	}

  	cout<< "start of loop"<<endl;

	for (int jentry=0; jentry<nentries; jentry++) {
	    	//if(!Debug)if((jentry%(nentries/50))==0) cout<<round(100*((jentry/Float_t(nentries))))<<"%"<<endl;
		
		veto->GetEntry(jentry);
		generated->GetEntry(jentry);
		flux->GetEntry(jentry);
		det->GetEntry(jentry);
		
		
		double theta_lim = atan (178/(-myGen->vy->at(0) - 178));

		int det_nhit = myDet->hitn->size();	
		int veto_nhit = myVe->hitn->size();	

		double mom = sqrt(pow(myGen->px->at(0),2) + pow(myGen->py->at(0),2) + pow(myGen->pz->at(0),2));	
		double theta =  acos(myGen->py->at(0)/mom);
		double Ek=sqrt(pow(mom,2) + pow(n_mass,2)) - n_mass; 


	/*	// Get the weigth from the flux histograms
		// -> Scan the bins from left to right and
		// exit the loop as soon as the correct bin
		// is found.
		// MEMO: energy bins are in GeV, mom is in MeV
		
		Double_t weight = 0;
		for (int i=0; i<fluxBinNumber; i++) {
			if ((Ek/1000 > fluxBinLeftEdge[i]) && (Ek/1000 < fluxBinLeftEdge[i+1])) {
				weight = fluxBinContent[i] ;
				break; 
			}
			
		}
	*/

		Gen_mom->Fill(mom/1000); // in GeV
		Gen_Ek->Fill(Ek/1000);

		double E_dep_veto = 0;
		double E_dep_det = 0;
		double adc2_veto = 0;
		for (int ihit=0; ihit < veto_nhit; ihit++) {
			for (int jhit=0; jhit < det_nhit; jhit++) {
				E_dep_det = E_dep_det + myDet->dig_Edep->at(jhit);	
			}
			E_dep_veto = E_dep_veto + myVe->dig_Edep->at(ihit);	
			adc2_veto = adc2_veto + myVe->adc2->at(ihit);
		}

		
		Edep_lAr_veto->Fill(E_dep_det/1000,E_dep_veto/1000);
		Edep_veto->Fill(E_dep_veto/1000);
		adc_veto->Fill(adc2_veto/1000);

		if (theta< theta_lim){
			Gen_Ek_det->Fill(Ek/1000);
			Gen_Ek_det_binT->Fill(Ek/1000);
			if( E_dep_veto*1000<=veto_threshold){
				if (det_nhit==1){
					if (myDet->dig_Edep->at(0)*1000 >Edep_min && myDet->dig_Edep->at(0)*1000<Edep_max){ // compreso tra 10 e 100 keV
						Gen_Ek_lAr->Fill(Ek/1000);
						Gen_Ek_lAr_binT->Fill(Ek/1000);
					}
					else Edep_no=Edep_no+1;
				}
				else det_mult_hit=det_mult_hit +1;
			}
			else veto_hit=veto_hit +1;
		} 
		

		
				
		if ((jentry) % int(nentries / 100) == 0 || (jentry) % 100000 == 0) {
      	std::cout << "                      \r" << jentry << " / " << nentries
		<< " ====> " << round((float) jentry / nentries * 100.)
		<< " % " ;
      	std::cout << round((float) jentry / nentries * 100.)
		<< " % " ;
      		std::cout.flush();
    	}
		

	}
	cout<<endl;
	cout<<"n with multiple hits in lAr  = "<<det_mult_hit<<endl;
	cout<<"n with E dep>threshold in veto = "<<veto_hit<<endl;
	cout<<"n with Edep in lAr <10 keV or >100 keV = "<<Edep_no<<endl;
    cout<< "end of loop  "<< endl;
        
        ////////////////////////
        //WRITE ON OUTPUT FILE
        ////////////////////////
        
    TFile *g;
  	if(Debug) g = new TFile("Output/Debug.root","RECREATE");
 	else g = new TFile(outname.c_str(),"RECREATE");

 	
	Gen_mom->Write(0,TObject::kOverwrite);
	Gen_Ek->Write(0,TObject::kOverwrite);
    Gen_Ek_lAr->Write(0,TObject::kOverwrite);
    Gen_Ek_lAr_binT->Write(0,TObject::kOverwrite);
    NFlux->Write(0,TObject::kOverwrite);
    Gen_Ek_det_binT->Write(0,TObject::kOverwrite);
    Gen_Ek_det->Write(0,TObject::kOverwrite);
    Edep_veto->Write(0,TObject::kOverwrite);
	adc_veto->Write(0,TObject::kOverwrite);

    Edep_lAr_veto->Write(0,TObject::kOverwrite);
    

 	g->Close();
}


//   vector<double>  *sector;
//   vector<double>  *veto;
//   vector<double>  *channel;
//   vector<double>  *adc1;
//   vector<double>  *tdc1;
//   vector<double>  *hitn;
//   vector<double>  *pid;
//   vector<double>  *trackE;
//   vector<double>  *totEdep;
//   vector<double>  *avg_x;
//   vector<double>  *avg_y;
//   vector<double>  *avg_z;
//   vector<double>  *px;
//   vector<double>  *py;
//   vector<double>  *pz;
//   vector<double>  *vx;
//   vector<double>  *vy;
//   vector<double>  *vz;
//   vector<double>  *avg_t;
//   vector<double>  *nsteps;
//   vector<double>  *procID;
// variabili definite in devel-2.6/source/sensitivity/HitProcess.cc