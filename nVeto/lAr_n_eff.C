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

void lAr_n_eff(string inputname="Sci1cm_p33,6MeV"){
	
	string filename("out_" + inputname + ".root");
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
	
	TH1D *Gen_mom_binT = new TH1D("Gen_mom_binT","Gen_mom_binT",429,fluxBinLeftEdge);
		Gen_mom_binT->GetXaxis()->SetTitle("Momentum [GeV/c^2]");
	  	Gen_mom_binT->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_Ek_binT= new TH1D("Gen_Ek_binT","Gen_Ek_binT",429,fluxBinLeftEdge);
		Gen_Ek_binT->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_binT->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_mom = new TH1D("Gen_mom","Gen_mom",10000,0,1);
		Gen_mom->GetXaxis()->SetTitle("Momentum [GeV/c^2]");
	  	Gen_mom->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_Ek= new TH1D("Gen_Ek","Gen_Ek",10000,0,0.5);
		Gen_Ek->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek->GetYaxis()->SetTitle("Counts");


    TH1D *Gen_Ek_lAr2= new TH1D("Gen_Ek_lAr2","Gen_Ek_lAr2",10000,0,0.5);
		Gen_Ek_lAr2->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_lAr2->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_Ek_w= new TH1D("Gen_Ek_w","Gen_Ek_w",10000,0,0.5);
		Gen_Ek_w->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_w->GetYaxis()->SetTitle("Counts");

    TH1D *Gen_Ek_lAr2_w= new TH1D("Gen_Ek_lAr2_w","Gen_Ek_lAr2_w",10000,0,0.5);
		Gen_Ek_lAr2_w->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_lAr2_w->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_Ek_lAr2_binT= new TH1D("Gen_Ek_lAr2_binT","Gen_Ek_lAr2_binT",429,fluxBinLeftEdge);
		Gen_Ek_lAr2_binT->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_lAr2_binT->GetYaxis()->SetTitle("Counts");

	TH1D *Gen_Ek_w_binT= new TH1D("Gen_Ek_w_binT","Gen_Ek_w_binT",429,fluxBinLeftEdge);
		Gen_Ek_w_binT->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_w_binT->GetYaxis()->SetTitle("Counts");

    TH1D *Gen_Ek_lAr2_w_binT= new TH1D("Gen_Ek_lAr2_w_binT","Gen_Ek_lAr2_w_binT",429,fluxBinLeftEdge);
		Gen_Ek_lAr2_w_binT->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_lAr2_w_binT->GetYaxis()->SetTitle("Counts");

	TH1D *NFlux= new TH1D("NFlux","NFlux",429,fluxBinLeftEdge);
		NFlux->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	NFlux->GetYaxis()->SetTitle("flux");  

		

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
  
  	int int_lAr_totEdep_B=0;
  	double n_mass = 939.565378;
  	
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


		int det_nhit = myDet->hitn->size();	
		
		double mom = sqrt(pow(myGen->px->at(0),2) +pow(myGen->py->at(0),2) + pow(myGen->pz->at(0),2) );	
		//cout<< "mom "<<mom<<endl;

		double Ek=sqrt(pow(mom,2) + pow(n_mass,2)) - n_mass; 

		Gen_mom->Fill(mom/1000); // in GeV
		Gen_Ek->Fill(Ek/1000);
		Gen_mom_binT->Fill(mom/1000);
		Gen_Ek_binT->Fill(Ek/1000);

		// Get the weigth from the flux histograms
		// -> Scan the bins from left to right and
		// exit the loop as soon as the correct bin
		// is found.
		// MEMO: energy bins are in GeV, mom is in MeV
		
		Double_t weight = 0;
		for (int i=0; i<fluxBinNumber; i++) {
			if ((Ek/1000 > fluxBinLeftEdge[i]) && (Ek/1000 < fluxBinLeftEdge[i+1])) {
				//cout << "mom "<<mom<<" -> bin found at "<< fluxBinLeftEdge[i] << " with content "<<fluxBinContent[i]<<endl;
				weight = fluxBinContent[i] ;
				break; 
			}
			
		}


		double E_dep_tot =0;
		for (int ihit=0; ihit < det_nhit; ihit++) {
			E_dep_tot = E_dep_tot + myDet->dig_Edep->at(ihit);
			//cout<< " "<< myDet->dig_Edep->at(ihit)<<" "<< E_dep_tot<<" "<< det_nhit<<endl;	 
		}

		if (E_dep_tot*1000 >10 && E_dep_tot*1000<100){ // compreso tra 10 e 100 keV
			Gen_Ek_lAr2->Fill(Ek/1000);
			Gen_Ek_lAr2_w->Fill(Ek/1000,weight);
			Gen_Ek_lAr2_binT->Fill(Ek/1000);
			Gen_Ek_lAr2_w_binT->Fill(Ek/1000,weight);
		}

		Gen_Ek_w->Fill(Ek/1000,weight);
		Gen_Ek_w_binT->Fill(Ek/1000,weight);
						

		if ((jentry) % int(nentries / 100) == 0 || (jentry) % 100000 == 0) {
      	std::cout << "                      \r" << jentry << " / " << nentries
		<< " ====> " << round((float) jentry / nentries * 100.)
		<< " % " ;
      	std::cout << round((float) jentry / nentries * 100.)
		<< " % " ;
      		std::cout.flush();
    	}
		

	}

	cout<< "Gen_Ek "<<Gen_Ek->Integral()<<endl;
	cout<< "Gen_Ek_lAr2 "<< Gen_Ek_lAr2->Integral()<<endl;
	cout<< "Gen_Ek_w "<< Gen_Ek_w->Integral()<<endl;	
	cout<< "Gen_Ek_lAr2_w "<< Gen_Ek_lAr2_w->Integral()<<endl;

    cout<< "end of loop  "<< endl;
        
        ////////////////////////
        //WRITE ON OUTPUT FILE
        ////////////////////////
        
    TFile *g;
  	if(Debug) g = new TFile("Output/Debug.root","RECREATE");
 	else g = new TFile(outname.c_str(),"RECREATE");

 	
	Gen_mom->Write(0,TObject::kOverwrite);
	Gen_Ek->Write(0,TObject::kOverwrite);
	Gen_mom_binT->Write(0,TObject::kOverwrite);
	Gen_Ek_binT->Write(0,TObject::kOverwrite);
	Gen_Ek_w->Write(0,TObject::kOverwrite);
    Gen_Ek_lAr2->Write(0,TObject::kOverwrite);
    Gen_Ek_lAr2_w->Write(0,TObject::kOverwrite);
    Gen_Ek_w_binT->Write(0,TObject::kOverwrite);
    Gen_Ek_lAr2_binT->Write(0,TObject::kOverwrite);
    Gen_Ek_lAr2_w_binT->Write(0,TObject::kOverwrite);
    NFlux->Write(0,TObject::kOverwrite);
    

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
