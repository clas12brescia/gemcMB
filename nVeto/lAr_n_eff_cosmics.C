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
	
	string filename("/mnt/project_mnt/jlab12/fiber7_fs/gosta/Output_gemc/out_" + inputname + ".root");

	//string outname("Output/Sort_" + inputname +"_thr0keV.root");
	//string outname("/mnt/project_mnt/jlab12/fiber7_fs/gosta/Output/Sort_" + inputname +"_thr100keV.root");
	string outname("Output/Sort_" + inputname +"_thr1MeV.root");


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

    TH1D *Gen_Ek_lAr= new TH1D("Gen_Ek_lAr","Gen_Ek_lAr",10000,0,11);
		Gen_Ek_lAr->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
	  	Gen_Ek_lAr->GetYaxis()->SetTitle("Counts");

	TH1D *Edep= new TH1D("Edep","Edep",10000,0,11);
		Edep->GetXaxis()->SetTitle("Edep [GeV]");
	  	Edep->GetYaxis()->SetTitle("Counts");

	TH1D *Veto_pid= new TH1D("Veto_pid","Veto_pid",4000,-1000,3000);
		Veto_pid->GetXaxis()->SetTitle("Particle ID");
	  	Veto_pid->GetYaxis()->SetTitle("Counts");  	

	TH1D *lAr_pid= new TH1D("lAr_pid","lAr_pid",4000,-1000,3000);
		lAr_pid->GetXaxis()->SetTitle("Particle ID");
	  	lAr_pid->GetYaxis()->SetTitle("Counts");  	
  	
  	TH1D *lAr_pid_Edep= new TH1D("lAr_pid_Edep","lAr_pid_Edep",4000,-1000,3000);
		lAr_pid_Edep->GetXaxis()->SetTitle("Particle ID");
	  	lAr_pid_Edep->GetYaxis()->SetTitle("Counts"); 

	TH2F *Veto_pid_trackE= new TH2F("Veto_pid_trackE","Veto_pid_trackE",4000,-1000,3000,10000,0,10000);
		Veto_pid_trackE->GetXaxis()->SetTitle("Particle ID");
	  	Veto_pid_trackE->GetYaxis()->SetTitle("Energy[MeV]");  

	TH2F *lar_pid_trackE= new TH2F("lar_pid_trackE","lar_pid_trackE",4000,-1000,3000,4000,0,10000);
		lar_pid_trackE->GetXaxis()->SetTitle("Particle ID");
	  	lar_pid_trackE->GetYaxis()->SetTitle("Energy[MeV]");  	
	

	TH2F *lar_pid_trackE_Edep= new TH2F("lar_pid_trackE_Edep","lar_pid_trackE_Edep",4000,-1000,3000,40000,0,4000);
		lar_pid_trackE_Edep->GetXaxis()->SetTitle("Particle ID");
	  	lar_pid_trackE_Edep->GetYaxis()->SetTitle("Energy[MeV]");  	
	


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

	    const double Edep_min =10;
	    const double Edep_max = 100;
	    const double veto_threshold=1000; //in keV
	  	const double n_mass = 939.565378;
		int counter=0;

		int det_nhit = myDet->hitn->size();	
		int veto_nhit = myVe->hitn->size();	
		
		double mom = sqrt(pow(myGen->px->at(0),2) + pow(myGen->py->at(0),2) + pow(myGen->pz->at(0),2) );	
		double Ek=sqrt(pow(mom,2) + pow(n_mass,2)) - n_mass; 

		Gen_mom->Fill(mom/1000); // in GeV
		Gen_Ek->Fill(Ek/1000); // in GeV

		for (int ihit=0; ihit < det_nhit; ihit++) {
			lAr_pid->Fill(myDet->pid->at(ihit));	
			lar_pid_trackE->Fill(myDet->pid->at(0),myDet->trackE->at(0));	
		}

		for (int ihit=0; ihit < veto_nhit; ihit++) {
			Veto_pid->Fill(myVe->pid->at(ihit));
			Veto_pid_trackE->Fill(myVe->pid->at(ihit),myVe->trackE->at(ihit));	 			
		}


		for (int ihit=0; ihit < veto_nhit; ihit++) { 
			if(myVe->dig_Edep->at(ihit)*1000>veto_threshold) {
				counter=counter+1;
			} 
			if (counter>0) break;			 			
		}

		
		if (det_nhit==1){
			if (myDet->dig_Edep->at(0)*1000 >Edep_min && myDet->dig_Edep->at(0)*1000<Edep_max){ // compreso tra 10 e 100 keV
				if(counter==0){ 
						Gen_Ek_lAr->Fill(Ek/1000);
						lAr_pid_Edep->Fill(myDet->pid->at(0));
						cout<< "pid = "<<myDet->pid->at(0) << "En = "<<myDet->trackE->at(0)<<endl;
						lar_pid_trackE_Edep->Fill(myDet->pid->at(0),myDet->trackE->at(0));
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


	cout<<"n con Edep 10-100 keV = "<<Gen_Ek_lAr->Integral()<<endl;
    
/* */
    cout<<"Veto neutron  = "<<Veto_pid->Integral(3113,3113)<<endl; //pid+1001
    cout<<"Veto proton   = "<<Veto_pid->Integral(3213,3213)<<endl;
    cout<<"Veto gamma    = "<<Veto_pid->Integral(1023,1023)<<endl;
    cout<<"Veto muon     = "<<Veto_pid->Integral(1014,1014)<<endl;
    cout<<"Veto antimuon = "<<Veto_pid->Integral(988,988)<<endl; // 1001-pid
    cout<<"Veto electron = "<<Veto_pid->Integral(1012,1012)<<endl;
    cout<<"Veto positron = "<<Veto_pid->Integral(990,990)<<endl;
    cout<<"Veto pi+ 	 = "<<Veto_pid->Integral(1212,1212)<<endl;
    cout<<"Veto pi-      = "<<Veto_pid->Integral(790,790)<<endl;

    cout<<"lar neutron  = "<<lAr_pid->Integral(3113,3113)<<endl; //pid+1001
    cout<<"lar proton   = "<<lAr_pid->Integral(3213,3213)<<endl;
    cout<<"lar gamma    = "<<lAr_pid->Integral(1023,1023)<<endl;
    cout<<"lar muon     = "<<lAr_pid->Integral(1014,1014)<<endl;
    cout<<"lar antimuon = "<<lAr_pid->Integral(988,988)<<endl; // 1001-pid
    cout<<"lar electron = "<<lAr_pid->Integral(1012,1012)<<endl;
    cout<<"lar positron = "<<lAr_pid->Integral(990,990)<<endl;
    cout<<"lar pi+ 	    = "<<lAr_pid->Integral(1212,1212)<<endl;
    cout<<"lar pi-      = "<<lAr_pid->Integral(790,790)<<endl;

    cout<<"lar Edep neutron  = "<<lAr_pid_Edep->Integral(3113,3113)<<endl; //pid+1001
    cout<<"lar Edep proton   = "<<lAr_pid_Edep->Integral(3213,3213)<<endl;
    cout<<"lar Edep gamma    = "<<lAr_pid_Edep->Integral(1023,1023)<<endl;
    cout<<"lar Edep muon     = "<<lAr_pid_Edep->Integral(1014,1014)<<endl;
    cout<<"lar Edep antimuon = "<<lAr_pid_Edep->Integral(988,988)<<endl; // 1001-pid
    cout<<"lar Edep electron = "<<lAr_pid_Edep->Integral(1012,1012)<<endl;
    cout<<"lar Edep positron = "<<lAr_pid_Edep->Integral(990,990)<<endl;
    cout<<"lar Edep pi+ 	 = "<<lAr_pid_Edep->Integral(1212,1212)<<endl;
    cout<<"lar Edep pi-      = "<<lAr_pid_Edep->Integral(790,790)<<endl;

    cout<< "end of loop  "<< endl;

        
        ////////////////////////
        //WRITE ON OUTPUT FILE
        ////////////////////////
        
    TFile *g;
  	if(Debug) g = new TFile("Output/Debug.root","RECREATE");
 	else g = new TFile(outname.c_str(),"RECREATE");

 	
	Gen_mom->Write(0,TObject::kOverwrite);
	Gen_Ek->Write(0,TObject::kOverwrite);
    Edep->Write(0,TObject::kOverwrite);
    lAr_pid->Write(0,TObject::kOverwrite);
	Veto_pid->Write(0,TObject::kOverwrite);
	Veto_pid_trackE->Write(0,TObject::kOverwrite);
	lar_pid_trackE->Write(0,TObject::kOverwrite);
	lar_pid_trackE_Edep->Write(0,TObject::kOverwrite);


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
