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

bool Debug = false;

/*
	Import the bin list and content from
	a singole file using a TGraph, then
	get the arrays from the TGraph 

*/

void lAr_n_eff_cosmics(string inputname="Sci1cm_p33,6MeV"){
	
	string filename("Output_gemc/out_" + inputname + ".root");
	string outname("Output/Sort_" + inputname + ".root");


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
	
	TH1D *Gen_Ek= new TH1D("Gen_Ek","Gen_Ek",10000,0,11);
		Gen_Ek->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_mom = new TH1D("Gen_mom","Gen_mom",10000,0,11);
		Gen_mom->GetXaxis()->SetTitle("Momentum [MeV/c^2]");
	  	Gen_mom->GetYaxis()->SetTitle("Counts");

    TH1D *Gen_Ek_lAr2= new TH1D("Gen_Ek_lAr2","Gen_Ek_lAr2",10000,0,11);
		Gen_Ek_lAr2->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_lAr2->GetYaxis()->SetTitle("Counts");

	TH1D *Edep= new TH1D("Edep","Edep",10000,0,11);
		Edep->GetXaxis()->SetTitle("Edep [GeV]");
	  	Edep->GetYaxis()->SetTitle("Counts");
  	

    double Edep_min =10;
    double Edep_max = 100;
   	int int_lAr_totEdep_B=0;
  	double n_mass = 939.565378;
  	int n=0;

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
  

  	cout<< "start of loop"<<endl;

	for (int jentry=0; jentry<nentries; jentry++) {
	    	//if(!Debug)if((jentry%(nentries/50))==0) cout<<round(100*((jentry/Float_t(nentries))))<<"%"<<endl;
		
		veto->GetEntry(jentry);
		generated->GetEntry(jentry);
		flux->GetEntry(jentry);
		det->GetEntry(jentry);


		int det_nhit = myDet->hitn->size();	
		
		double mom = sqrt(pow(myGen->px->at(0),2) + pow(myGen->py->at(0),2) + pow(myGen->pz->at(0),2) );	
		//cout<< "mom "<<mom<<endl;

		double Ek=sqrt(pow(mom,2) + pow(n_mass,2)) - n_mass; 

		Gen_mom->Fill(mom/1000); // in GeV
		Gen_Ek->Fill(Ek/1000); // in GeV


		double E_dep_tot =0;
		for (int ihit=0; ihit < det_nhit; ihit++) {
			E_dep_tot = E_dep_tot + myDet->dig_Edep->at(ihit);	 
		}

		
		if (E_dep_tot*1000 >Edep_min && E_dep_tot*1000<Edep_max){ // compreso tra 10 e 100 keV
			Gen_Ek_lAr2->Fill(Ek/1000);
			n=n+1;
			//cout<<"Ek = "<<Ek<<"  edep = "<<E_dep_tot*1000<<endl;
		}
		Edep->Fill(E_dep_tot/1000);

		

		if ((jentry) % int(nentries / 100) == 0 || (jentry) % 100000 == 0) {
      	std::cout << "                      \r" << jentry << " / " << nentries
		<< " ====> " << round((float) jentry / nentries * 100.)
		<< " % " ;
      	std::cout << round((float) jentry / nentries * 100.)
		<< " % " ;
      		std::cout.flush();
    	}
		

	}

	cout<< "n"<< n<<endl;
	cout<<"Integral lar2= "<< Gen_Ek_lAr2->Integral()<<endl;
	cout<<"Integral tot= "<< Gen_Ek->Integral()<<endl;
    cout<< "end of loop  "<< endl;
        
        ////////////////////////
        //WRITE ON OUTPUT FILE
        ////////////////////////
        
    TFile *g;
  	if(Debug) g = new TFile("Output/Debug.root","RECREATE");
 	else g = new TFile(outname.c_str(),"RECREATE");

 	
	Gen_mom->Write(0,TObject::kOverwrite);
	Gen_Ek->Write(0,TObject::kOverwrite);
	Gen_Ek_lAr2->Write(0,TObject::kOverwrite);
    Edep->Write(0,TObject::kOverwrite); 

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
