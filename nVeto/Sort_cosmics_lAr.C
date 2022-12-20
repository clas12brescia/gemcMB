#include "vetoClass.h"
#include "generatedClass.h"
#include "detClass.h"
#include "export2ascii.C"
#include <TH2.h>
#include <TH3.h>
#include <TStyle.h>
#include <TCanvas.h>
#include "iostream"
#include <map>
using namespace std;

bool Debug = false;

/*
	Import the bin list and content from
	a singole file using a TGraph, then
	get the arrays from the TGraph 

*/

void Sort_cosmics_lAr(string inputname="Sci1cm_p33,6MeV", int veto_threshold =100){
	
	string filename("/mnt/project_mnt/jlab12/fiber7_fs/gosta/Output_gemc/out_" + inputname + ".root");
  string outname("/mnt/project_mnt/jlab12/fiber7_fs/gosta/Output/Sort_" + inputname +"_thr" + Form ("%d",veto_threshold)+ "keV.root");
	//string outname("Output/Sort_" + inputname +"_thr" + Form ("%d",veto_threshold)+ "_keV.root");

	// Open the file
	TFile * f = new TFile(filename.c_str());
	// Get the tree(s)
	TTree * veto = (TTree * ) f->Get("veto");
	TTree * det = (TTree * ) f->Get("det");
	TTree * generated = (TTree * ) f->Get("generated");

	// new objects 
	detClass * mydet = new detClass(det);
	vetoClass * myVe = new vetoClass(veto);
	generatedClass * myGen= new generatedClass(generated);

	
	////////////////////
	// HISTOS DEFINITION
	////////////////////
	
	char name[100];
	
	
	//lAr
	
	  TH1D *Gen_Ek= new TH1D("Gen_Ek","Gen_Ek",10000,0,11);
		Gen_Ek->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
 	  Gen_Ek->GetYaxis()->SetTitle("Counts");

    TH1D *Gen_Ek_det= new TH1D("Gen_Ek_det","Gen_Ek_det",10000,0,11);
		Gen_Ek_det->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
 	  Gen_Ek_det->GetYaxis()->SetTitle("Counts");

	  TH1D *Edep_veto= new TH1D("Edep_veto","Edep_veto",10000,0,1);
		Edep_veto->GetXaxis()->SetTitle("Kinetic Energy [MeV]");
 	  Edep_veto->GetYaxis()->SetTitle("Counts");
      
 	  TH1D *Edep_det= new TH1D("Edep_det","Edep_det",10000,0,1);
		Edep_det->GetXaxis()->SetTitle("Kinetic Energy [MeV]");
 	  Edep_det->GetYaxis()->SetTitle("Counts");
      
	  TH1D *det_time= new TH1D("det_time","det_time",100000,-0.5,99999.5);
		det_time->GetXaxis()->SetTitle("Time [microseconds]");
    det_time->GetYaxis()->SetTitle("Counts");
    
 	  TH1D *veto_time= new TH1D("veto_time","veto_time",100000,-0.5,99999.5);
		veto_time->GetXaxis()->SetTitle("Time [microseconds]");
    veto_time->GetYaxis()->SetTitle("Counts");
    
    TH1D *det_veto_dT= new TH1D("det_veto_dT","det_veto_dT",8000,-4000.5,3999.5);
		det_veto_dT->GetXaxis()->SetTitle("Time [microseconds]");
    det_veto_dT->GetYaxis()->SetTitle("Counts");
    
    TH1D *nhit_veto= new TH1D("nhit_veto","nhit_veto",1000,-0.5,999.5);
		nhit_veto->GetXaxis()->SetTitle("hit number per event");
    nhit_veto->GetYaxis()->SetTitle("Counts");
    
    TH1D *nhit_det= new TH1D("nhit_det","nhit_det",20,-0.5,19.5);
		nhit_det->GetXaxis()->SetTitle("hit number per event");
    nhit_det->GetYaxis()->SetTitle("Counts");

    TH1D *nhit_veto_thr= new TH1D("nhit_vet_thro","nhit_vet_thro",1000,-0.5,999.5);
		nhit_veto_thr->GetXaxis()->SetTitle("hit number per event");
    nhit_veto_thr->GetYaxis()->SetTitle("Counts");
    
    TH1D *nhit_det_thr= new TH1D("nhit_det_thr","nhit_det_thr",20,-0.5,19.5);
		nhit_det_thr->GetXaxis()->SetTitle("hit number per event");
    nhit_det_thr->GetYaxis()->SetTitle("Counts");
 	
/*  	
  	TH1D *det_pid_Edep= new TH1D("det_pid_Edep","det_pid_Edep",4000,-1000,3000);
		det_pid_Edep->GetXaxis()->SetTitle("Particle ID");
 	  det_pid_Edep->GetYaxis()->SetTitle("Counts"); 

	

	TH2F *det_pid_trackE_Edep= new TH2F("det_pid_trackE_Edep","det_pid_trackE_Edep",4000,-1000,3000,40000,0,4000);
		det_pid_trackE_Edep->GetXaxis()->SetTitle("Particle ID");
	  	det_pid_trackE_Edep->GetYaxis()->SetTitle("Energy[MeV]");  	
	
*/

	//////////////////////
	// START OF THE LOOP
	//////////////////////

	Long64_t nentries = generated->GetEntries();
	if (Debug){
		nentries=1200000;
    	cout << "Working in debug mode: " <<nentries<< endl;
 	}
	

  cout << "WORKING ON nentries =" << nentries << endl;
  cout << "Veto Threshold =" << veto_threshold << endl;
  Long64_t nbytes = 0, nb = 0;
  cout<< "start of loop"<<endl;
  
  int number_hitdet=0;
  int number_hitVe=0;
  int number_hitdet_thr=0;
  int number_hitVe_thr=0;

	for (int jentry=0; jentry<nentries; jentry++) {

		veto->GetEntry(jentry);
		generated->GetEntry(jentry);
		det->GetEntry(jentry);
    
    
    const double det_threshold = 10; //in keV
    const double n_mass = 939.565378; // in MeV
		
		int det_nhit = mydet->hitn->size();	
		int veto_nhit = myVe->hitn->size();
    int det_nhit_thr=0;
    int veto_nhit_thr=0;
    double DeltaT;
    double DeltaT_min;
    double DeltaT_signed;
		double mom = sqrt(pow(myGen->px->at(0),2) + pow(myGen->py->at(0),2) + pow(myGen->pz->at(0),2) );	
		double Ek=sqrt(pow(mom,2) + pow(n_mass,2)) - n_mass; 


		Gen_Ek->Fill(Ek/1000); // in GeV
    nhit_veto->Fill(veto_nhit);
    nhit_det->Fill(det_nhit);
     
    for (int ihit=0; ihit < det_nhit; ihit++){               // Loop on hit in the lAr
       Edep_det->Fill( mydet->totEdep->at(ihit));            // fill histogram with Deposited energy in lAr
       if (mydet->totEdep->at(ihit)*1000> det_threshold){    // Look only at deposited energy higher then thr=10keV (energy visible in experiment)
         det_time->Fill(mydet->avg_t->at(ihit)/1000);        // fill with time information /1000 to be in microseconds
         det_nhit_thr=det_nhit_thr+1;                        // count number of hit with deposited energy higher then thr=10keV 
       }  
    }
      
    for (int jhit=0; jhit < veto_nhit; jhit++){           // Loop on hit in the veto
      Edep_veto->Fill( myVe->totEdep->at(jhit));          // fill histogram with Deposited energy in veto
      if (myVe->totEdep->at(jhit)*1000> veto_threshold){  // Look only at deposited energy higher then thr (energy visible in experiment)
        veto_time->Fill(myVe->avg_t->at(jhit)/1000);      // fill with time information /1000 to be in microseconds
        veto_nhit_thr=veto_nhit_thr+1;                    // count number of hit with deposited energy higher then thr
      }
    }
    
    nhit_veto_thr->Fill(veto_nhit_thr);                    // fill histo with total number of hit with deposited energy higher then thr
    nhit_det_thr->Fill(det_nhit_thr);
    
    //Time coincidence
    
    for (int ihit=0; ihit < det_nhit; ihit++) {
      DeltaT_min=1E8;
      DeltaT_signed=1E8;
      if (mydet->totEdep->at(ihit)*1000> det_threshold && mydet->totEdep->at(ihit)*1000<100){    // Look only at Edep between 10-100keV (neutrino Edep)
        for (int jhit=0; jhit < veto_nhit; jhit++) {
          if ( myVe->totEdep->at(jhit)*1000> veto_threshold){          // Look only at deposited energy higher then thr (energy visible in experiment)
            DeltaT=abs(mydet->avg_t->at(ihit) - myVe->avg_t->at(jhit))/1000;// absoulute value of difference in time between veto and lAr in micros
            if (DeltaT<DeltaT_min){
              DeltaT_min=DeltaT;                // find the minimum delta Time (to reject the event)
              DeltaT_signed= (mydet->avg_t->at(ihit) - myVe->avg_t->at(jhit))/1000; //value of difference in time between veto-lAr in micros with sign
            }  
		      }
        }
        
        det_veto_dT->Fill(DeltaT_signed); // fill with minimum delta time with sign in micro 
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

    for (int i=1; i<nhit_det_thr->GetNbinsX(); i++){            // number of total hit in the lAr over thr
       number_hitdet_thr =  number_hitdet_thr + (nhit_det_thr->GetBinContent(i))*(i-1);
    }
     for (int i=1; i<nhit_veto_thr->GetNbinsX(); i++){            // number of total hit in the Veto over thr
       number_hitVe_thr = number_hitVe_thr + (nhit_veto_thr->GetBinContent(i))*(i-1);
    }
    for (int i=1; i<nhit_det->GetNbinsX(); i++){            // number of total hit in the lAr
       number_hitdet = number_hitdet + (nhit_det->GetBinContent(i))*(i-1);
    }
     for (int i=1; i<nhit_veto->GetNbinsX(); i++){            // number of total hit in the Veto 
       number_hitVe = number_hitVe + (nhit_veto->GetBinContent(i))*(i-1);
    }
    
     cout<< "number of total hit in the crystal: "<< number_hitdet<<endl;
     cout<< "number of hit in the crystal over thr: "<< number_hitdet_thr<<endl;
     cout<< "number of hit in the crystal that have hits in the veto = "<<det_veto_dT->Integral()<<endl; //without overflow
     cout<< "number of hit in the crystal without hit in the veto = "<<number_hitdet_thr - det_veto_dT->Integral(1,8000)<<endl;
     cout<< "number of hit in the crystal within coincidence with veto = "<<det_veto_dT->Integral(3996,4006)<<endl;
	   cout<< "number of hit in the crystal outside coincidence (negative)  = "<<det_veto_dT->Integral(1,3995)<<endl;
     cout<< "number of hit in the crystal outside coincidence (positive)  = "<<det_veto_dT->Integral(4007,8000)<<endl;
     
     cout<< "number of total hit in the veto: "<< number_hitVe<<endl;
     cout<< "number of hit in the veto over thr: "<< number_hitVe_thr<<endl;
;
    //cout<<"hit det over thr"<< det_time->Integral()<<endl;
    
    cout<< "end of loop  "<< endl;

        
        ////////////////////////
        //WRITE ON OUTPUT FILE
        ////////////////////////
        
    TFile *g;
  	if(Debug) g = new TFile("Debug.root","RECREATE");
 	  else g = new TFile(outname.c_str(),"RECREATE");
	  
	  Gen_Ek->Write(0,TObject::kOverwrite);
    Gen_Ek_det->Write(0,TObject::kOverwrite);
    Edep_veto->Write(0,TObject::kOverwrite);
    Edep_det->Write(0,TObject::kOverwrite);
    veto_time->Write(0,TObject::kOverwrite);
    det_time->Write(0,TObject::kOverwrite);
    det_veto_dT->Write(0,TObject::kOverwrite);
    nhit_det->Write(0,TObject::kOverwrite);
    nhit_veto->Write(0,TObject::kOverwrite);
    nhit_det_thr->Write(0,TObject::kOverwrite);
    nhit_veto_thr->Write(0,TObject::kOverwrite);
//	Veto_pid_trackE->Write(0,TObject::kOverwrite);
//	det_pid_trackE->Write(0,TObject::kOverwrite);
//	det_pid_trackE_Edep->Write(0,TObject::kOverwrite);


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
