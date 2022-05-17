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

void lAr_n_eff(string inputname="Sci1cm_p33,6MeV"){
	
	string filename("out_" + inputname + ".root");
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
	
	TH1D *Gen_mom = new TH1D("Gen_mom","Gen_mom",10000,0,11);
		Gen_mom->GetXaxis()->SetTitle("Momentum [GeV]");
	  	Gen_mom->GetYaxis()->SetTitle("Counts");

    TH1D *Gen_mom_lAr2= new TH1D("Gen_mom_lAr2","Gen_mom_lAr2",10000,0,11);
		Gen_mom_lAr2->GetXaxis()->SetTitle("Momentum [GeV]");
	  	Gen_mom_lAr2->GetYaxis()->SetTitle("Counts");

	TH1D *lAr_time = new TH1D("lAr_time","lAr_time",10000,-0.5,999.5);
		lAr_time->GetXaxis()->SetTitle("Time [ns]");
	  	lAr_time->GetYaxis()->SetTitle("Counts");

	TH1D *lAr_totEdep_B_1 = new TH1D("lAr_totEdep_B_1","lAr_totEdep_B_1",100,0,0.00001);
		lAr_totEdep_B_1->GetXaxis()->SetTitle("Energy [GeV]");
	  	lAr_totEdep_B_1->GetYaxis()->SetTitle("Counts"); 	
	
	TH1D *lAr_totEdep_B_2 = new TH1D("lAr_totEdep_B_2","lAr_totEdep_B_2",10,0.00001,0.0001);
		lAr_totEdep_B_2->GetXaxis()->SetTitle("Energy [GeV]");
	  	lAr_totEdep_B_2->GetYaxis()->SetTitle("Counts"); 	
	
	TH1D *lAr_totEdep_B_3 = new TH1D("lAr_totEdep_B_3","lAr_totEdep_B_3",10,0.0001,0.01);
		lAr_totEdep_B_3->GetXaxis()->SetTitle("Energy [GeV]");
	  	lAr_totEdep_B_3->GetYaxis()->SetTitle("Counts"); 	
	
	TH1D *lAr_totEdep_B_4 = new TH1D("lAr_totEdep_B_4","lAr_totEdep_B_4",10,0.01,0.02);
		lAr_totEdep_B_4->GetXaxis()->SetTitle("Energy [GeV]");
	  	lAr_totEdep_B_4->GetYaxis()->SetTitle("Counts"); 	

	TH1D *lAr_totEdep_B_5 = new TH1D("lAr_totEdep_B_5","lAr_totEdep_B_5",100,0.02,0.1);
		lAr_totEdep_B_5->GetXaxis()->SetTitle("Energy [GeV]");
	  	lAr_totEdep_B_5->GetYaxis()->SetTitle("Counts"); 	

	TH1D *lAr_totEdep_B_6 = new TH1D("lAr_totEdep_B_6","lAr_totEdep_B_6",200,0.1,11);
		lAr_totEdep_B_6->GetXaxis()->SetTitle("Energy [GeV]");
	  	lAr_totEdep_B_6->GetYaxis()->SetTitle("Counts"); 	



	//////////////////////
	// START OF THE LOOP
	//////////////////////

	Long64_t nentries = veto->GetEntries();
	if (Debug){
		cout << "How many nentries?" <<endl;
   		cin>>nentries;
    		cout << "Working in debug mode: " <<nentries<< endl;

  	}
  	cout << "WORKING ON nentries =" << nentries << endl;
  	Long64_t nbytes = 0, nb = 0;
  
  	int int_lAr_totEdep_B=0;
	
  	cout<< "start of loop"<<endl;

	for (int jentry=0; jentry<nentries; jentry++) {
	    	//if(!Debug)if((jentry%(nentries/50))==0) cout<<round(100*((jentry/Float_t(nentries))))<<"%"<<endl;
		
		veto->GetEntry(jentry);
		generated->GetEntry(jentry);
		flux->GetEntry(jentry);
		det->GetEntry(jentry);


		int det_nhit = myDet->hitn->size();	
		int gen_nhit = myGen->px->size();	

		for (int ihit=0; ihit < gen_nhit; ihit++) {
			double mom = sqrt(pow(myGen->px->at(ihit),2) +pow(myGen->py->at(ihit),2) + pow(myGen->pz->at(ihit),2) );	
			Gen_mom->Fill(mom/1000);	 
		}
			
		for (int ihit=0; ihit < det_nhit; ihit++) {
			if (myDet->totEdep->at(ihit)>0){		
				lAr_totEdep_B_1->Fill(myDet->dig_Edep->at(ihit)/1000);
				lAr_totEdep_B_2->Fill(myDet->dig_Edep->at(ihit)/1000);
				lAr_totEdep_B_3->Fill(myDet->dig_Edep->at(ihit)/1000);
				lAr_totEdep_B_4->Fill(myDet->dig_Edep->at(ihit)/1000);
				lAr_totEdep_B_5->Fill(myDet->dig_Edep->at(ihit)/1000);
				lAr_totEdep_B_6->Fill(myDet->dig_Edep->at(ihit)/1000);

				lAr_time->Fill(myDet->avg_t->at(ihit)/1000);
				if (myDet->dig_Edep->at(ihit)*1000 >10 && myDet->dig_Edep->at(ihit)*1000<100){

				 int_lAr_totEdep_B = int_lAr_totEdep_B +1;
				 Gen_mom_lAr2->Fill(sqrt(pow(myGen->px->at(ihit),2) +pow(myGen->py->at(ihit),2) + pow(myGen->pz->at(ihit),2) )/1000);

				}
		    }	 
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

		cout<< "int_totEdep_B = "<<int_lAr_totEdep_B<<endl;

        cout<< "end of loop  "<< endl;
        
        ////////////////////////
        //WRITE ON OUTPUT FILE
        ////////////////////////
        
        TFile *g;
  	if(Debug) g = new TFile("Output/Debug.root","RECREATE");
 	else g = new TFile(outname.c_str(),"RECREATE");

 	  	lAr_totEdep_B_1->Write(0,TObject::kOverwrite);
 	  	lAr_totEdep_B_2->Write(0,TObject::kOverwrite);
 	  	lAr_totEdep_B_3->Write(0,TObject::kOverwrite);
 	  	lAr_totEdep_B_4->Write(0,TObject::kOverwrite);
 	  	lAr_totEdep_B_5->Write(0,TObject::kOverwrite);
 	  	lAr_totEdep_B_6->Write(0,TObject::kOverwrite);

    	lAr_time->Write(0,TObject::kOverwrite);	
    	Gen_mom->Write(0,TObject::kOverwrite);
    	Gen_mom_lAr2->Write(0,TObject::kOverwrite);

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
