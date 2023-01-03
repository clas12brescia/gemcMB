#include "vetoClass.h"
#include "generatedClass.h"
#include "crsClass.h"
#include "export2ascii.C"
#include <TH2.h>
#include <TH3.h>
#include <TStyle.h>
#include <TCanvas.h>
#include "iostream"
#include <map>
#include<fstream>
using namespace std;

bool Debug = false;

/*
	Import the bin list and content from
	a singole file using a TGraph, then
	get the arrays from the TGraph 

*/

void Sort_cosmics_crs(string inputname="Sci1cm_p33,6MeV", int veto_threshold =100){
	
	string filename("/mnt/project_mnt/jlab12/fiber7_fs/gosta/Output_gemc/out_" + inputname + ".root");
  string outname("/mnt/project_mnt/jlab12/fiber7_fs/gosta/Output/Sort_" + inputname +"_thr" + Form ("%d",veto_threshold)+ "keV.root");
	//string outname("Output/Sort_" + inputname +"_thr" + Form ("%d",veto_threshold)+ "_keV.root");

	// Open the file
	TFile * f = new TFile(filename.c_str());
	// Get the tree(s)
	TTree * veto = (TTree * ) f->Get("veto");
	TTree * crs = (TTree * ) f->Get("crs");
	TTree * generated = (TTree * ) f->Get("generated");

	// new objects 
	crsClass * myCrs = new crsClass(crs);
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

    TH1D *Gen_Ek_crs= new TH1D("Gen_Ek_crs","Gen_Ek_crs",10000,0,11);
		Gen_Ek_crs->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
 	  Gen_Ek_crs->GetYaxis()->SetTitle("Counts");

	  TH1D *Edep_veto= new TH1D("Edep_veto","Edep_veto",100000,0,1000);
		Edep_veto->GetXaxis()->SetTitle("Kinetic Energy [MeV]");
 	  Edep_veto->GetYaxis()->SetTitle("Counts");
      
 	  TH1D *Edep_crs= new TH1D("Edep_crs","Edep_crs",190,10,200);
		Edep_crs->GetXaxis()->SetTitle("Kinetic Energy [keV]");
 	  Edep_crs->GetYaxis()->SetTitle("Counts");
      
	  TH1D *crs_time= new TH1D("crs_time","crs_time",100000,-0.5,99999.5);
		crs_time->GetXaxis()->SetTitle("Time [microseconds]");
    crs_time->GetYaxis()->SetTitle("Counts");
    
 	  TH1D *veto_time= new TH1D("veto_time","veto_time",100000,-0.5,99999.5);
		veto_time->GetXaxis()->SetTitle("Time [microseconds]");
    veto_time->GetYaxis()->SetTitle("Counts");
    
    TH1D *crs_veto_dT= new TH1D("crs_veto_dT","crs_veto_dT",20000,-10000.5,9999.5);
		crs_veto_dT->GetXaxis()->SetTitle("Time [microseconds]");
    crs_veto_dT->GetYaxis()->SetTitle("Counts");
    
    TH1D *nhit_veto= new TH1D("nhit_veto","nhit_veto",1000,-0.5,999.5);
		nhit_veto->GetXaxis()->SetTitle("hit number per event");
    nhit_veto->GetYaxis()->SetTitle("Counts");
    
    TH1D *nhit_crs= new TH1D("nhit_crs","nhit_crs",20,-0.5,19.5);
		nhit_crs->GetXaxis()->SetTitle("hit number per event");
    nhit_crs->GetYaxis()->SetTitle("Counts");

    TH1D *nhit_veto_thr= new TH1D("nhit_vet_thro","nhit_vet_thro",1000,-0.5,999.5);
		nhit_veto_thr->GetXaxis()->SetTitle("hit number per event");
    nhit_veto_thr->GetYaxis()->SetTitle("Counts");
    
    TH1D *nhit_crs_thr= new TH1D("nhit_crs_thr","nhit_crs_thr",20,-0.5,19.5);
		nhit_crs_thr->GetXaxis()->SetTitle("hit number per event");
    nhit_crs_thr->GetYaxis()->SetTitle("Counts");
 	
/*  	
  	TH1D *crs_pid_Edep= new TH1D("crs_pid_Edep","crs_pid_Edep",4000,-1000,3000);
		crs_pid_Edep->GetXaxis()->SetTitle("Particle ID");
 	  crs_pid_Edep->GetYaxis()->SetTitle("Counts"); 

	

	TH2F *crs_pid_trackE_Edep= new TH2F("crs_pid_trackE_Edep","crs_pid_trackE_Edep",4000,-1000,3000,40000,0,4000);
		crs_pid_trackE_Edep->GetXaxis()->SetTitle("Particle ID");
	  	crs_pid_trackE_Edep->GetYaxis()->SetTitle("Energy[MeV]");  	
	
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
  
  int number_hitCrs=0;
  int number_hitVe=0;
  int number_hitCrs_thr=0;
  int number_hitVe_thr=0;
  int single=0;
  int Edep10_200_crs=0;
  
  const double crs_threshold = 10;
  const double crs_maxEdep = 200;

	for (int jentry=0; jentry<nentries; jentry++) {

		veto->GetEntry(jentry);
		generated->GetEntry(jentry);
		crs->GetEntry(jentry);
    
    
    const double n_mass = 939.565378; // in MeV
		
		int crs_nhit = myCrs->hitn->size();	
		int veto_nhit = myVe->hitn->size();
    int crs_nhit_thr=0;
    int veto_nhit_thr=0;
    double DeltaT;
    double DeltaT_min;
    double DeltaT_signed;
		double mom = sqrt(pow(myGen->px->at(0),2) + pow(myGen->py->at(0),2) + pow(myGen->pz->at(0),2) );	
		double Ek=sqrt(pow(mom,2) + pow(n_mass,2)) - n_mass; 


		Gen_Ek->Fill(Ek/1000); // in GeV
    nhit_veto->Fill(veto_nhit);
    nhit_crs->Fill(crs_nhit);
    
    
    for (int ihit=0; ihit < crs_nhit; ihit++){              // Loop on hit in the crs
       Edep_crs->Fill( myCrs->totEdep->at(ihit)*1000);           // fill histogram with Deposited energy in crs
       if (myCrs->totEdep->at(ihit)*1000> crs_threshold){   // Look only at deposited energy higher then thr=10keV (energy visible in experiment)
         crs_time->Fill(myCrs->avg_t->at(ihit)/1000);       // fill with time information /1000 to be in microseconds
         crs_nhit_thr=crs_nhit_thr+1;                       // count number of hit with deposited energy higher then thr=10keV 
       }  
    }
      
    for (int jhit=0; jhit < veto_nhit; jhit++){           // Loop on hit in the veto
      Edep_veto->Fill( myVe->totEdep->at(jhit));          // fill histogram with Deposited energy in veto
      if (myVe->totEdep->at(jhit)*1000> veto_threshold){  // Look only at deposited energy higher then thr (energy visible in experiment)
        veto_time->Fill(myVe->avg_t->at(jhit)/1000);      // fill with time information /1000 to be in microseconds
        veto_nhit_thr=veto_nhit_thr+1;                    // count number of hit with deposited energy higher then thr
      }
    }
    
    nhit_veto_thr->Fill(veto_nhit_thr); // fill histo with total number of hit with deposited energy higher then thr
    nhit_crs_thr->Fill(crs_nhit_thr);
    
    //Time coincidence
    for (int ihit=0; ihit < crs_nhit; ihit++) {
      DeltaT_min=1E8;
      DeltaT_signed=1E8;
      if (myCrs->totEdep->at(ihit)*1000> crs_threshold && myCrs->totEdep->at(ihit)*1000<crs_maxEdep){  // Look only at Edep between 10-200keV (neutrino Edep)
        Edep10_200_crs =  Edep10_200_crs+1;
        for (int jhit=0; jhit < veto_nhit; jhit++) {
          if ( myVe->totEdep->at(jhit)*1000> veto_threshold){     // Look only at deposited energy higher then thr (energy visible in experiment)
            DeltaT=abs(myCrs->avg_t->at(ihit) - myVe->avg_t->at(jhit))/1000;// absoulute value of difference in time between veto and lAr in micros
            if (DeltaT<DeltaT_min){
              DeltaT_min=DeltaT;        // find the minimum delta Time (to reject the event)
              DeltaT_signed= (myCrs->avg_t->at(ihit) - myVe->avg_t->at(jhit))/1000;    //value of difference in time between veto-lAr in micros with sign
            }  
		      }
        }
        if (DeltaT_signed==1E8) single=single+1;
        crs_veto_dT->Fill(DeltaT_signed); // fill with minimum delta time with sign in micro 
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

    for (int i=1; i<nhit_crs_thr->GetNbinsX(); i++){            // number of total hit in the crs over thr
       number_hitCrs_thr =  number_hitCrs_thr + (nhit_crs_thr->GetBinContent(i))*(i-1);
    }
     for (int i=1; i<nhit_veto_thr->GetNbinsX(); i++){            // number of total hit in the Veto over thr
       number_hitVe_thr = number_hitVe_thr + (nhit_veto_thr->GetBinContent(i))*(i-1);
    }
    for (int i=1; i<nhit_crs->GetNbinsX(); i++){            // number of total hit in the crs 
       number_hitCrs = number_hitCrs + (nhit_crs->GetBinContent(i))*(i-1);
    }
     for (int i=1; i<nhit_veto->GetNbinsX(); i++){            // number of total hit in the Veto 
       number_hitVe = number_hitVe + (nhit_veto->GetBinContent(i))*(i-1);
    }
    
     ofstream fout("Results_cosmics_veto1+2+2_Pb5+5.txt",ios::app);
     fout<<inputname<<endl;
     fout<<"Veto Thr ="<< veto_threshold<<endl;
     fout<<"Crs Thr ="<< crs_threshold<<endl;
     fout<<"Crs max Edep= "<<crs_maxEdep<<endl;
     
     fout<< "number of total hit in the crystal: "<< number_hitCrs<<endl;
     fout<< "number of hit in the crystal over thr: "<< number_hitCrs_thr<<endl;
   
     fout<< "number of hit in the crystal with Edep 10-200 keV = "<<Edep10_200_crs<<endl; 
     fout<< "number of hit in the crystal that have hits in the veto = "<<Edep10_200_crs-single<<endl; //without overflow
     fout<< "number of hit in the crystal without hit in the veto = "<<single<<endl;
     fout<< "number of hit in the crystal within coincidence with veto = "<<crs_veto_dT->Integral(9996,10006)<<endl;
	   fout<< "number of hit in the crystal outside coincidence (negative)  = "<<crs_veto_dT->Integral(1,9995)<<endl;
     fout<< "number of hit in the crystal outside coincidence (positive)  = "<<crs_veto_dT->Integral(10007,20000)<<endl;
     
     fout<< "number of total hit in the veto: "<< number_hitVe<<endl;
     fout<< "number of hit in the veto over thr: "<< number_hitVe_thr<<endl;
     fout.close();

    //cout<<"hit crs over thr"<< crs_time->Integral()<<endl;
    
    
/* 
    cout<<"Veto neutron  = "<<Veto_pid->Integral(3113,3113)<<endl; //pid+1001
    cout<<"Veto proton   = "<<Veto_pid->Integral(3213,3213)<<endl;
    cout<<"Veto gamma    = "<<Veto_pid->Integral(1023,1023)<<endl;
    cout<<"Veto muon     = "<<Veto_pid->Integral(1014,1014)<<endl;
    cout<<"Veto antimuon = "<<Veto_pid->Integral(988,988)<<endl; // 1001-pid
    cout<<"Veto electron = "<<Veto_pid->Integral(1012,1012)<<endl;
    cout<<"Veto positron = "<<Veto_pid->Integral(990,990)<<endl;
    cout<<"Veto pi+ 	 = "<<Veto_pid->Integral(1212,1212)<<endl;
    cout<<"Veto pi-      = "<<Veto_pid->Integral(790,790)<<endl;

    cout<<"crs neutron  = "<<crs_pid->Integral(3113,3113)<<endl; //pid+1001
    cout<<"crs proton   = "<<crs_pid->Integral(3213,3213)<<endl;
    cout<<"crs gamma    = "<<crs_pid->Integral(1023,1023)<<endl;
    cout<<"crs muon     = "<<crs_pid->Integral(1014,1014)<<endl;
    cout<<"crs antimuon = "<<crs_pid->Integral(988,988)<<endl; // 1001-pid
    cout<<"crs electron = "<<crs_pid->Integral(1012,1012)<<endl;
    cout<<"crs positron = "<<crs_pid->Integral(990,990)<<endl;
    cout<<"crs pi+ 	    = "<<crs_pid->Integral(1212,1212)<<endl;
    cout<<"crs pi-      = "<<crs_pid->Integral(790,790)<<endl;

    cout<<"crs Edep neutron  = "<<crs_pid_Edep->Integral(3113,3113)<<endl; //pid+1001
    cout<<"crs Edep proton   = "<<crs_pid_Edep->Integral(3213,3213)<<endl;
    cout<<"crs Edep gamma    = "<<crs_pid_Edep->Integral(1023,1023)<<endl;
    cout<<"crs Edep muon     = "<<crs_pid_Edep->Integral(1014,1014)<<endl;
    cout<<"crs Edep antimuon = "<<crs_pid_Edep->Integral(988,988)<<endl; // 1001-pid
    cout<<"crs Edep electron = "<<crs_pid_Edep->Integral(1012,1012)<<endl;
    cout<<"crs Edep positron = "<<crs_pid_Edep->Integral(990,990)<<endl;
    cout<<"crs Edep pi+ 	   = "<<crs_pid_Edep->Integral(1212,1212)<<endl;
    cout<<"crs Edep pi-      = "<<crs_pid_Edep->Integral(790,790)<<endl;
*/
    cout<< "end of loop  "<< endl;

        
        ////////////////////////
        //WRITE ON OUTPUT FILE
        ////////////////////////
        
    TFile *g;
  	if(Debug) g = new TFile("Debug.root","RECREATE");
 	  else g = new TFile(outname.c_str(),"RECREATE");
	  
	  Gen_Ek->Write(0,TObject::kOverwrite);
    Gen_Ek_crs->Write(0,TObject::kOverwrite);
    Edep_veto->Write(0,TObject::kOverwrite);
    Edep_crs->Write(0,TObject::kOverwrite);
    veto_time->Write(0,TObject::kOverwrite);
    crs_time->Write(0,TObject::kOverwrite);
    crs_veto_dT->Write(0,TObject::kOverwrite);
    nhit_crs->Write(0,TObject::kOverwrite);
    nhit_veto->Write(0,TObject::kOverwrite);
    nhit_crs_thr->Write(0,TObject::kOverwrite);
    nhit_veto_thr->Write(0,TObject::kOverwrite);
//	Veto_pid_trackE->Write(0,TObject::kOverwrite);
//	crs_pid_trackE->Write(0,TObject::kOverwrite);
//	crs_pid_trackE_Edep->Write(0,TObject::kOverwrite);

 /*   export2ascii(nhit_crs,"_" + inputname);
    export2ascii(nhit_veto,"_" + inputname);
    export2ascii(nhit_crs_thr,"500keV_"+ inputname);
    export2ascii(nhit_veto_thr,"1MeV_"+ inputname);
    export2ascii(veto_time,"_thr1MeV_"+ inputname);
    export2ascii(crs_time,"_thr500keV_"+ inputname);
   */ 
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
