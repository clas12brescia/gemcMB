//#define vetoClass_cxx
#include "vetoClass.h"
//#define generatedClass_cxx
#include "generatedClass.h"
//#define fluxClass_cxx
#include "fluxClass.h"
#include <TH2.h>
#include <TH3.h>
#include <TStyle.h>
#include <TCanvas.h>
#include "iostream"
#include <map>

bool Debug = false;

void nVeto_con_loop(string inputname="Sci1cm_p33,6MeV"){
	
	string filename("out_" + inputname + ".root");
	string outname("Output/Sort_" + inputname + ".root");

	// Open the file
	TFile * f = new TFile(filename.c_str());

	// Get the tree(s)
	TTree * veto = (TTree * ) f->Get("veto");
	TTree * generated = (TTree * ) f->Get("generated");
	TTree * flux = (TTree * ) f->Get("flux");

	// new objects 
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
	
	//nVeto
	TH1D *veto_chan = new TH1D("chan","chan",7,-0.5,6.5);
		veto_chan->GetXaxis()->SetTitle("channel");
	  	veto_chan->GetYaxis()->SetTitle("Counts");

	//Enegry 
	
	TH1D *veto_Energy[6];
  		for(int jj=0;jj<6;jj++) {
   		sprintf(name,"veto_Energy_%d",jj);
    	veto_Energy[jj] = new TH1D(name,name,1000,-0.5,999.5);
    	veto_Energy[jj]->GetXaxis()->SetTitle("Energy [keV]");
	  	veto_Energy[jj]->GetYaxis()->SetTitle("Counts");}
 	
	TH1D *veto_Energy_tot = new TH1D("veto_Energy_tot","veto_Energy_tot",1000,-0.5,999.5);
		veto_Energy_tot->GetXaxis()->SetTitle("Energy [keV]");
	  	veto_Energy_tot->GetYaxis()->SetTitle("Counts");

	TH1D *veto_totEdep[6];
  	for(int jj=0;jj<6;jj++) {
   	sprintf(name,"veto_totEdep_%d",jj);
    	veto_totEdep[jj] = new TH1D(name,name,1000,-0.5,999.5);
    	veto_totEdep[jj]->GetXaxis()->SetTitle("Energy [keV]");
	  	veto_totEdep[jj]->GetYaxis()->SetTitle("Counts");}

  	
	TH1D *veto_totEdep_tot = new TH1D("veto_totEdep_tot","veto_totEdep_tot",1000,-0.5,999.5);
		veto_totEdep_tot->GetXaxis()->SetTitle("Energy [keV]");
	  	veto_totEdep_tot->GetYaxis()->SetTitle("Counts");

	// Time  

	TH1D *veto_time[6];
  		for(int jj=0;jj<6;jj++) {
   		sprintf(name,"veto_time_%d",jj);
    	veto_time[jj] = new TH1D(name,name,10000,-0.5,999.5);
    	veto_time[jj]->GetXaxis()->SetTitle("Time [ns]");
	  	veto_time[jj]->GetYaxis()->SetTitle("Counts");}

	TH1D *veto_time_tot = new TH1D("veto_time_tot","veto_time_tot",10000,-0.5,999.5);
		veto_time_tot->GetXaxis()->SetTitle("Time [ns]");
	  	veto_time_tot->GetYaxis()->SetTitle("Counts");
		
    	
    
	//lAr
	TH1D *lAr_Energy_tot = new TH1D("lAr_Energy_tot","lAr_Energy_tot",1000,-0.5,999.5);
		lAr_Energy_tot->GetXaxis()->SetTitle("Energy [keV]");
	  	lAr_Energy_tot->GetYaxis()->SetTitle("Counts");

	TH1D *lAr_time = new TH1D("lAr_time","lAr_time",10000,-0.5,999.5);
		lAr_time->GetXaxis()->SetTitle("Time [ns]");
	  	lAr_time->GetYaxis()->SetTitle("Counts");

	TH1D *lAr_totEdep_g4 = new TH1D("lAr_totEdep_g4 ","lAr_totEdep_g4 ",1000,-0.5,999.5);
		lAr_totEdep_g4 ->GetXaxis()->SetTitle("Energy [keV]");
	  	lAr_totEdep_g4 ->GetYaxis()->SetTitle("Counts");

	TH1D *lAr_totEdep_B = new TH1D("lAr_totEdep_B","lAr_totEdep_B",1000,-0.5,999.5);
		lAr_totEdep_B->GetXaxis()->SetTitle("Energy [keV]");
	  	lAr_totEdep_B->GetYaxis()->SetTitle("Counts"); 	


	//matrix

	TH2F *veto_lAr_Energy = new TH2F("veto_lAr_Energy","veto_lAr_Energy",1000,-0.5,999.5,1000,-0.5,999.5);
		veto_lAr_Energy->GetXaxis()->SetTitle("Energy [keV]");
		veto_lAr_Energy->GetYaxis()->SetTitle("Energy [keV]");

	TH2F *lAr_Energy_time = new TH2F("lAr_Energy_time","lAr_Energy_time",1000,-0.5,999.5,10000,-0.5,999.5);
		lAr_Energy_time->GetXaxis()->SetTitle("Energy [keV]");
		lAr_Energy_time->GetYaxis()->SetTitle("Time [ns]");

	TH2F *veto_Energy_time[6];
	  	for(int jj=0;jj<6;jj++) {
	   	sprintf(name,"veto_Energy_time%d",jj);
	    	veto_Energy_time[jj] = new TH2F(name,name,1000,-0.5,999.5,10000,-0.5,999.5);
	    	veto_Energy_time[jj]->GetXaxis()->SetTitle("Energy [keV]");
		  	veto_Energy_time[jj]->GetYaxis()->SetTitle("Time [ns]");}

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
  
  
  	cout<< "start of loop"<<endl;

	for (int jentry=0; jentry<nentries; jentry++) {
	    	//if(!Debug)if((jentry%(nentries/50))==0) cout<<round(100*((jentry/Float_t(nentries))))<<"%"<<endl;
		
		veto->GetEntry(jentry);
		generated->GetEntry(jentry);
		flux->GetEntry(jentry);
		
		int nhit = myVe->hitn->size(); // Considero solo gli eventi con nhit >0 
		double veto_Energy=0;
		double lAr_Energy=0;

		for (int ihit=0; ihit < nhit ; ihit++) {
			//cout << "     on sector "<<myVe->sector->at(ihit)<<
			// " channel "<<myVe->channel->at(ihit) << 
			// " (ene "<< myVe->totEdep->at(ihit) <<
			// ", adc "<< myVe->adc1->at(ihit)<<
			// ", pid "<< myVe->pid->at(ihit)<<")" << endl;
			int chan = 2*myVe->sector->at(ihit)+myVe->channel->at(ihit); // 0 down, 1 Up, 2 left, 3 right, 4 back, 5 front, 6 lAr
			//cout<<"ihit "<<ihit<<" chan "<<chan<<endl;
			veto_chan->Fill(chan);
			if (myVe->totEdep->at(ihit)>0){		// considero solo gli eventi con energia depositata maggiore di zero
				if (chan>=0 & chan<=5)	//veto
				{
					veto_Energy= veto_Energy + myVe->totEdep->at(ihit)*1000;
					//veto_Energy_tot->Fill(myVe->adc1->at(ihit));
					veto_totEdep_tot->Fill(myVe->totEdep->at(ihit)*1000);   // to be in keV
					veto_time_tot->Fill(myVe->avg_t->at(ihit)/1000);		// to be in ns
				    //veto_Energy[k]->Fill(myVe->adc1->at(ihit));
				    veto_totEdep[chan]->Fill(myVe->totEdep->at(ihit)*1000);
				    veto_time[chan]->Fill(myVe->avg_t->at(ihit)/1000);
				    veto_Energy_time[chan]->Fill(myVe->totEdep->at(ihit)*1000,myVe->avg_t->at(ihit)/1000);
			  	    
				} 
				else if (chan==6)  //lAr
				{		 
					lAr_Energy=lAr_Energy + myVe->totEdep->at(ihit)*1000;  
					//lAr_Energy_tot->Fill(myVe->adc2->at(ihit));
					lAr_totEdep_g4->Fill(myVe->totEdep->at(ihit)*1000);
					lAr_totEdep_B->Fill(myVe->dig_Edep->at(ihit)*1000);
					lAr_time->Fill(myVe->avg_t->at(ihit)/1000);
					lAr_Energy_time->Fill(myVe->totEdep->at(ihit)*1000,myVe->avg_t->at(ihit)/1000);
				}
			}	 
		}
		
		veto_lAr_Energy->Fill(veto_Energy,lAr_Energy);

		//if ((jentry) % int(nentries / 100) == 0 || (jentry) % 100000 == 0) {
      		//std::cout << "                      \r" << jentry << " / " << nentries
		//<< " ====> " << round((float) jentry / nentries * 100.)
		//<< " % " ;
      		//std::cout << round((float) jentry / nentries * 100.)
		//<< " % " ;
      		//std::cout.flush();
    		//}
	}
	
	
        cout<< "end of loop  "<< endl;
        
        ////////////////////////
        //WRITE ON OUTPUT FILE
        ////////////////////////
        
        TFile *g;
  	if(Debug) g = new TFile("Output/Debug.root","RECREATE");
 	else g = new TFile(outname.c_str(),"RECREATE");
 	
 	g-> mkdir("veto");
 	g-> cd("veto");
 	
 	veto_chan->Write(0,TObject::kOverwrite);
 	//veto_Energy_tot->Write(0,TObject::kOverwrite);
    	veto_totEdep_tot->Write(0,TObject::kOverwrite);
    //	lAr_Energy_tot->Write(0,TObject::kOverwrite);
    	lAr_totEdep_g4->Write(0,TObject::kOverwrite);
    	lAr_totEdep_B->Write(0,TObject::kOverwrite);
    	lAr_time->Write(0,TObject::kOverwrite);
    	veto_time_tot->Write(0,TObject::kOverwrite);
    	veto_lAr_Energy->Write(0,TObject::kOverwrite);
    	lAr_Energy_time->Write(0,TObject::kOverwrite);

    	
  	for (int k=0 ; k<6 ; k++){
    	//veto_Energy[k]->Write(0,TObject::kOverwrite);
    	veto_totEdep[k]->Write(0,TObject::kOverwrite);
    	veto_time[k]->Write(0,TObject::kOverwrite);
    	veto_Energy_time[k]->Write(0,TObject::kOverwrite);
   	}
   	
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
