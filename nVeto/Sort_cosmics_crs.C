#include "vetoClass.h"
#include "generatedClass.h"
#include "crsClass.h"
#include "fluxClass.h"
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
  TTree * flux = (TTree * ) f->Get("flux");

	// new objects 
	crsClass * myCrs = new crsClass(crs);
	vetoClass * myVe = new vetoClass(veto);
	generatedClass * myGen= new generatedClass(generated);
  fluxClass * myFl= new fluxClass(flux);

	
	////////////////////
	// HISTOS DEFINITION
	////////////////////
	
	char name[100];
	
	
	  TH1D *Gen_Ek= new TH1D("Gen_Ek","Gen_Ek",10000,0,11);
		Gen_Ek->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
 	  Gen_Ek->GetYaxis()->SetTitle("Counts");

    TH1D *Gen_Ek_crs= new TH1D("Gen_Ek_crs","Gen_Ek_crs",10000,0,11);
		Gen_Ek_crs->GetXaxis()->SetTitle("Kinetic Energy [GeV]");
 	  Gen_Ek_crs->GetYaxis()->SetTitle("Counts");

	  TH1D *Edep_veto= new TH1D("Edep_veto","Edep_veto",100000,0,1000);
		Edep_veto->GetXaxis()->SetTitle("Kinetic Energy [MeV]");
 	  Edep_veto->GetYaxis()->SetTitle("Counts");
      
 	  TH1D *Edep_crs= new TH1D("Edep_crs","Edep_crs",1000,0,1000);
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
  	
  	TH1D *crs_pid_single= new TH1D("crs_pid_single","crs_pid_single",4000,-1000,3000);
		crs_pid_single->GetXaxis()->SetTitle("Particle ID");
 	  crs_pid_single->GetYaxis()->SetTitle("Counts"); 
      
   	TH1D *crs_pid_out_coinc= new TH1D("crs_pid_out_coinc","crs_pid_out_coinc",4000,-1000,3000);
		crs_pid_out_coinc->GetXaxis()->SetTitle("Particle ID");
 	  crs_pid_out_coinc->GetYaxis()->SetTitle("Counts"); 

    TH2F *crs_trackE_vy_g_single= new TH2F("crs_trackE_vy_g_single","crs_trackE_vy_g_single",5000,0,5000,15501,-500,15000);
		crs_trackE_vy_g_single->GetXaxis()->SetTitle("Energy[keV]");
 	  crs_trackE_vy_g_single->GetYaxis()->SetTitle("Vy[cm]");  	
	
	  TH2F *crs_trackE_vy_g_outc= new TH2F("crs_trackE_vy_g_outc","crs_trackE_vy_g_outc",5000,0,5000,15501,-500,15000);
		crs_trackE_vy_g_outc->GetXaxis()->SetTitle("Energy[keV]");
 	  crs_trackE_vy_g_outc->GetYaxis()->SetTitle("Vy[cm]");
      
    TH2F *crs_trackE_vy_n_single= new TH2F("crs_trackE_vy_n_single","crs_trackE_vy_n_single",10000,0,10000,15501,-500,15000);
		crs_trackE_vy_n_single->GetXaxis()->SetTitle("Energy[MeV]");
 	  crs_trackE_vy_n_single->GetYaxis()->SetTitle("Vy[cm]");  	
	
	  TH2F *crs_trackE_vy_n_outc= new TH2F("crs_trackE_vy_n_outc","crs_trackE_vy_n_outc",10000,0,10000,15501,-500,15000);
		crs_trackE_vy_n_outc->GetXaxis()->SetTitle("Energy[MeV]");
 	  crs_trackE_vy_n_outc->GetYaxis()->SetTitle("Vy[cm]");

	  TH1D *flux_lat_trackE_g= new TH1D("flux_lat_trackE_g","flux_lat_trackE_g",15000,0,15000);
		flux_lat_trackE_g->GetYaxis()->SetTitle("Counts");
 	  flux_lat_trackE_g->GetXaxis()->SetTitle("Energy[keV]");
    
    TH1D *flux_lat_trackE_n= new TH1D("flux_lat_trackE_n","flux_lat_trackE_n",10000,0,10000);
		flux_lat_trackE_n->GetYaxis()->SetTitle("Counts");
 	  flux_lat_trackE_n->GetXaxis()->SetTitle("Energy[MeV]");
    
    TH1D *flux2_trackE_g= new TH1D("flux2_trackE_g","flux2_trackE_g",15000,0,15000);
		flux2_trackE_g->GetYaxis()->SetTitle("Counts");
 	  flux2_trackE_g->GetXaxis()->SetTitle("Energy[keV]");
    
    TH1D *flux2_trackE_n= new TH1D("flux2_trackE_n","flux2_trackE_n",10000,0,10000);
		flux2_trackE_n->GetYaxis()->SetTitle("Counts");
 	  flux2_trackE_n->GetXaxis()->SetTitle("Energy[MeV]");
    
    TH1D *flux3_trackE_g= new TH1D("flux3_trackE_g","flux3_trackE_g",15000,0,15000);
		flux3_trackE_g->GetYaxis()->SetTitle("Counts");
 	  flux3_trackE_g->GetXaxis()->SetTitle("Energy[keV]");
    
    TH1D *flux3_trackE_n= new TH1D("flux3_trackE_n","flux3_trackE_n",10000,0,10000);
		flux3_trackE_n->GetYaxis()->SetTitle("Counts");
 	  flux3_trackE_n->GetXaxis()->SetTitle("Energy[MeV]");
    
    TH1D *flux5_trackE_g= new TH1D("flux5_trackE_g","flux5_trackE_g",15000,0,15000);
		flux5_trackE_g->GetYaxis()->SetTitle("Counts");
 	  flux5_trackE_g->GetXaxis()->SetTitle("Energy[keV]");
    
    TH1D *flux5_trackE_n= new TH1D("flux5_trackE_n","flux5_trackE_n",10000,0,10000);
		flux5_trackE_n->GetYaxis()->SetTitle("Counts");
 	  flux5_trackE_n->GetXaxis()->SetTitle("Energy[MeV]");    
    
    TH1D *flux6_trackE_g= new TH1D("flux6_trackE_g","flux6_trackE_g",15000,0,15000);
		flux6_trackE_g->GetYaxis()->SetTitle("Counts");
 	  flux6_trackE_g->GetXaxis()->SetTitle("Energy[keV]");
    
    TH1D *flux6_trackE_n= new TH1D("flux6_trackE_n","flux6_trackE_n",10000,0,10000);
		flux6_trackE_n->GetYaxis()->SetTitle("Counts");
 	  flux6_trackE_n->GetXaxis()->SetTitle("Energy[MeV]"); 
    
    TH1D *flux7_trackE_g= new TH1D("flux7_trackE_g","flux7_trackE_g",15000,0,15000);
		flux7_trackE_g->GetYaxis()->SetTitle("Counts");
 	  flux7_trackE_g->GetXaxis()->SetTitle("Energy[keV]");
    
    TH1D *flux7_trackE_n= new TH1D("flux7_trackE_n","flux7_trackE_n",10000,0,10000);
		flux7_trackE_n->GetYaxis()->SetTitle("Counts");
 	  flux7_trackE_n->GetXaxis()->SetTitle("Energy[MeV]"); 
      
    TH2F *crs_jentry_fluxid_g_single= new TH2F("crs_jentry_fluxid_g_single","crs_jentry_fluxid_g_single",3001,0,3000,81,0,80);
		crs_jentry_fluxid_g_single->GetXaxis()->SetTitle("# single gamma");
 	  crs_jentry_fluxid_g_single->GetYaxis()->SetTitle("flux id");  	
	
	  TH2F *crs_jentry_fluxid_g_outc= new TH2F("crs_jentry_fluxid_g_outc","crs_jentry_fluxid_g_outc",1001,0,1000,81,0,80);
		crs_jentry_fluxid_g_outc->GetXaxis()->SetTitle("# out coinc gamma");
 	  crs_jentry_fluxid_g_outc->GetYaxis()->SetTitle("flux id");
      
    TH2F *crs_jentry_fluxid_n_single= new TH2F("crs_jentry_fluxid_n_single","crs_jentry_fluxid_n_single",3001,0,3000,81,0,80);
		crs_jentry_fluxid_n_single->GetXaxis()->SetTitle("# single neutron");
 	  crs_jentry_fluxid_n_single->GetYaxis()->SetTitle("flux id");  	
	
	  TH2F *crs_jentry_fluxid_n_outc= new TH2F("crs_jentry_fluxid_n_outc","crs_jentry_fluxid_n_outc",1001,0,1000,81,0,80);
		crs_jentry_fluxid_n_outc->GetXaxis()->SetTitle("# out coinc neutron");
 	  crs_jentry_fluxid_n_outc->GetYaxis()->SetTitle("flux id");

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
  int out_coinc=0;
  int out_coinc_x10=0;
  int Edep10_200_crs=0;
  int id_lat_g=0;
  int id_lat_n=0;
  int id2_g=0;
  int id2_n=0;
  int id3_g=0;
  int id3_n=0;
  int id5_g=0;
  int id5_n=0;
  int id6_g=0;
  int id6_n=0;
  int id7_g=0;
  int id7_n=0;
  
  const double crs_threshold = 10;
  const double crs_maxEdep = 200;
  const double coinc_value=2.5; // in micorseconds


	for (int jentry=0; jentry<nentries; jentry++) {

		veto->GetEntry(jentry);
		generated->GetEntry(jentry);
		crs->GetEntry(jentry);
    flux->GetEntry(jentry);
    
    
    const double n_mass = 939.565378; // in MeV
		
		int crs_nhit = myCrs->hitn->size();	
		int veto_nhit = myVe->hitn->size();
    int flux_nhit = myFl->hitn->size();
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
            DeltaT=abs(myCrs->avg_t->at(ihit) - myVe->avg_t->at(jhit))/1000;// absoulute value of difference in time between veto and crs in micros
            if (DeltaT<DeltaT_min){
              DeltaT_min=DeltaT;        // find the minimum delta Time (to reject the event)
              DeltaT_signed= (myCrs->avg_t->at(ihit) - myVe->avg_t->at(jhit))/1000;    //value of difference in time between veto-crs in micros with sign
            }  
		      }
        }
        if (DeltaT_signed==1E8){
          single=single+1;      // number of hit in crs without hit in veto
          crs_pid_single->Fill(myCrs->pid->at(ihit));
          if(myCrs->pid->at(ihit)==22){  //gammas
            crs_trackE_vy_g_single-> Fill (myCrs->trackE->at(ihit)*1000,myCrs->vy->at(ihit)/10); //energy and vertex in cm
            for (int khit=0; khit < flux_nhit; khit++){
              if(myCrs->tid->at(ihit)==myFl->tid->at(khit))  crs_jentry_fluxid_g_single->Fill(single,myFl->id->at(khit));
            }
          }
          if(myCrs->pid->at(ihit)==2112){ // neutrons
            crs_trackE_vy_n_single-> Fill (myCrs->trackE->at(ihit),myCrs->vy->at(ihit)/10);
            for (int khit=0; khit < flux_nhit; khit++){
              if(myCrs->tid->at(ihit)==myFl->tid->at(khit))  crs_jentry_fluxid_n_single->Fill(single,myFl->id->at(khit));
            }
          }
        }
        if ((DeltaT_signed >= coinc_value || DeltaT_signed <= -coinc_value) && DeltaT_signed!=1E8 ){
          out_coinc = out_coinc+1;
          crs_pid_out_coinc->Fill(myCrs->pid->at(ihit));
          if(myCrs->pid->at(ihit)==22){
            crs_trackE_vy_g_outc-> Fill (myCrs->trackE->at(ihit)*1000,myCrs->vy->at(ihit)/10);
            for (int khit=0; khit < flux_nhit; khit++){
              if(myCrs->tid->at(ihit)==myFl->tid->at(khit))  crs_jentry_fluxid_g_outc->Fill(out_coinc,myFl->id->at(khit));
            }
          }
          if(myCrs->pid->at(ihit)==2112){
            crs_trackE_vy_n_outc-> Fill (myCrs->trackE->at(ihit),myCrs->vy->at(ihit)/10);
            for (int khit=0; khit < flux_nhit; khit++){
              if(myCrs->tid->at(ihit)==myFl->tid->at(khit))  crs_jentry_fluxid_n_outc->Fill(out_coinc,myFl->id->at(khit));
            }
          }
        } 
        if ((DeltaT_signed >= coinc_value*10 || DeltaT_signed <= -coinc_value*10) && DeltaT_signed!=1E8 ) out_coinc_x10 = out_coinc_x10+1;
               
        crs_veto_dT->Fill(DeltaT_signed); // fill with minimum delta time with sign in micro 
      } 
		}
    
    
// flux ----------------------------------------------------------------    
    for (int ihit=0; ihit < flux_nhit; ihit++){              // Loop on hit in the crs
       if ((myFl->id->at(ihit)==13 || myFl->id->at(ihit)==42) && myFl->pid->at(ihit)==22){
         id_lat_g=id_lat_g +1;
         flux_lat_trackE_g->Fill(myFl->trackE->at(ihit)*1000); 
       }
       if ((myFl->id->at(ihit)==13 || myFl->id->at(ihit)==42) && myFl->pid->at(ihit)==2112){
         flux_lat_trackE_n->Fill(myFl->trackE->at(ihit)); 
         id_lat_n=id_lat_n +1;
       }
       if (myFl->id->at(ihit)==23 && myFl->pid->at(ihit)==22){
         id2_g=id2_g +1;
         flux2_trackE_g->Fill(myFl->trackE->at(ihit)*1000); 
       }
       if (myFl->id->at(ihit)==23 && myFl->pid->at(ihit)==2112){
         flux2_trackE_n->Fill(myFl->trackE->at(ihit)); 
         id2_n=id2_n +1;
       }
       if (myFl->id->at(ihit)==33 && myFl->pid->at(ihit)==22){
         id3_g=id3_g +1;
         flux3_trackE_g->Fill(myFl->trackE->at(ihit)*1000);

       }
       if (myFl->id->at(ihit)==33 && myFl->pid->at(ihit)==2112){
         flux3_trackE_n->Fill(myFl->trackE->at(ihit)); 
         id3_n=id3_n +1;
       }
       if (myFl->id->at(ihit)==50 && myFl->pid->at(ihit)==22){
         id5_g=id5_g +1;
         flux5_trackE_g->Fill(myFl->trackE->at(ihit)*1000); 
       }
       if (myFl->id->at(ihit)==50 && myFl->pid->at(ihit)==2112){
         flux5_trackE_n->Fill(myFl->trackE->at(ihit)); 
         id5_n=id5_n +1;
       }
       if (myFl->id->at(ihit)==60 && myFl->pid->at(ihit)==22){
         id6_g=id6_g +1;
         flux6_trackE_g->Fill(myFl->trackE->at(ihit)*1000); 
       }
       if (myFl->id->at(ihit)==60 && myFl->pid->at(ihit)==2112){
         flux6_trackE_n->Fill(myFl->trackE->at(ihit)); 
         id6_n=id6_n +1;
       }
       if (myFl->id->at(ihit)==70 && myFl->pid->at(ihit)==22){
         id7_g=id7_g +1;
         flux7_trackE_g->Fill(myFl->trackE->at(ihit)*1000); 
       }
       if (myFl->id->at(ihit)==70 && myFl->pid->at(ihit)==2112){
         flux7_trackE_n->Fill(myFl->trackE->at(ihit)); 
         id7_n=id7_n +1;
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
    
     ofstream fout("Results_cosmics_0.1Pb+6v+5Pb+50w+fl5.txt",ios::app);
     fout<<inputname<<endl;
     fout<<"Nentries = "<<nentries<<endl;
     fout<<"Veto Thr = "<< veto_threshold<<endl;
     fout<<"Crs Thr = "<< crs_threshold<<endl;
     fout<<"Crs max Edep= "<<crs_maxEdep<<endl;
     fout<<"Coincidence = "<<coinc_value<<endl;
     
     fout<<" "<<endl; 
     fout<< "number of total hit in the veto:       "<< number_hitVe<<endl;
     fout<< "number of hit in the veto over thr:    "<< number_hitVe_thr<<endl;
     fout<< "number of total hit in the crystal:    "<< number_hitCrs<<endl;
     fout<< "number of hit in the crystal over thr: "<< number_hitCrs_thr<<endl;
     fout<<number_hitVe<<" "<<number_hitVe_thr<<" "<< number_hitCrs<<" "<<number_hitCrs_thr<<endl;
     
     fout<<" "<<endl; 
     fout<< "number of hit in the crystal with Edep 10-200 keV      = "<<Edep10_200_crs<<endl; 
     fout<< "number of hit in the crystal with hits in the veto     = "<<Edep10_200_crs-single<<endl; //without overflow
     fout<< "number of hit in the crystal without hit in the veto   = "<<single<<endl;
     fout<< "number of hit in the crystal in coincidence with veto  = "<<Edep10_200_crs-single-out_coinc<<endl;
	   fout<< "number of hit in the crystal outside coincidence       = "<<out_coinc<<endl;
     fout<< "number of hit in the crystal outside coincidence X10   = "<<out_coinc_x10<<endl;  
       
       
     fout<<" "<<endl;    
     fout<<"crs neutron single  = "<<crs_pid_single->Integral(3113,3113)<<endl; //pid+1001
     fout<<"crs proton  single  = "<<crs_pid_single->Integral(3213,3213)<<endl;
     fout<<"crs gamma single    = "<<crs_pid_single->Integral(1023,1023)<<endl;
     fout<<"crs muon  single    = "<<crs_pid_single->Integral(1014,1014)<<endl;
     fout<<"crs antimuon single = "<<crs_pid_single->Integral(988,988)<<endl; // 1001-pid
     fout<<"crs electron single = "<<crs_pid_single->Integral(1012,1012)<<endl;
     fout<<"crs positron single = "<<crs_pid_single->Integral(990,990)<<endl;
     fout<<"crs pi+ single 	    = "<<crs_pid_single->Integral(1212,1212)<<endl;
     fout<<"crs pi- single      = "<<crs_pid_single->Integral(790,790)<<endl;
     fout<<" "<<endl; 
     fout<<"crs neutron out coinc  = "<<crs_pid_out_coinc->Integral(3113,3113)<<endl; //pid+1001
     fout<<"crs proton  out coinc  = "<<crs_pid_out_coinc->Integral(3213,3213)<<endl;
     fout<<"crs gamma out coinc    = "<<crs_pid_out_coinc->Integral(1023,1023)<<endl;
     fout<<"crs muon  out coinc    = "<<crs_pid_out_coinc->Integral(1014,1014)<<endl;
     fout<<"crs antimuon out coinc = "<<crs_pid_out_coinc->Integral(988,988)<<endl; // 1001-pid
     fout<<"crs electron out coinc = "<<crs_pid_out_coinc->Integral(1012,1012)<<endl;
     fout<<"crs positron out coinc = "<<crs_pid_out_coinc->Integral(990,990)<<endl;
     fout<<"crs pi+ out coinc 	   = "<<crs_pid_out_coinc->Integral(1212,1212)<<endl;
     fout<<"crs pi- out coinc      = "<<crs_pid_out_coinc->Integral(790,790)<<endl;
    
     fout<<"--------------------------------------------------------------------"<<endl;
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
    crs_pid_out_coinc->Write(0,TObject::kOverwrite);
    crs_pid_single->Write(0,TObject::kOverwrite);
    crs_trackE_vy_g_single->SetOption("text");
    crs_trackE_vy_g_outc->SetOption("text");
    crs_trackE_vy_n_single->SetOption("text");
    crs_trackE_vy_n_outc->SetOption("text");
    crs_trackE_vy_g_single->Write(0,TObject::kOverwrite);
    crs_trackE_vy_g_outc->Write(0,TObject::kOverwrite);
    crs_trackE_vy_n_single->Write(0,TObject::kOverwrite);
    crs_trackE_vy_n_outc->Write(0,TObject::kOverwrite);
    
 	  flux_lat_trackE_g->Write(0,TObject::kOverwrite);
	  flux_lat_trackE_n->Write(0,TObject::kOverwrite);
    flux2_trackE_g->Write(0,TObject::kOverwrite);	
    flux2_trackE_n->Write(0,TObject::kOverwrite);
	  flux3_trackE_g->Write(0,TObject::kOverwrite);
	  flux3_trackE_n->Write(0,TObject::kOverwrite);
    flux5_trackE_g->Write(0,TObject::kOverwrite);	
    flux5_trackE_n->Write(0,TObject::kOverwrite);
    flux6_trackE_g->Write(0,TObject::kOverwrite);	
    flux6_trackE_n->Write(0,TObject::kOverwrite);
    flux7_trackE_g->Write(0,TObject::kOverwrite);	
    flux7_trackE_n->Write(0,TObject::kOverwrite);
    crs_jentry_fluxid_g_single->SetOption("box");
    crs_jentry_fluxid_g_single->Write(0,TObject::kOverwrite);
    crs_jentry_fluxid_n_single->SetOption("box");
    crs_jentry_fluxid_n_single->Write(0,TObject::kOverwrite);
    crs_jentry_fluxid_g_outc->SetOption("box");
    crs_jentry_fluxid_g_outc->Write(0,TObject::kOverwrite);
    crs_jentry_fluxid_n_outc->SetOption("box");
    crs_jentry_fluxid_n_outc->Write(0,TObject::kOverwrite);    
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
