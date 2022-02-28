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

void nVeto_con_loop_G(){
	

	// Open the file
	TFile * f = new TFile("out.root");

	// Get the tree(s)
	TTree * veto = (TTree * ) f->Get("veto");
	TTree * generated = (TTree * ) f->Get("generated");
	TTree * flux = (TTree * ) f->Get("flux");

	// new objects 
	vetoClass * myVe = new vetoClass();
	generatedClass * myGen= new generatedClass();
	fluxClass * myFl = new fluxClass();

	myVe->Init(veto);
	myGen->Init(generated);
	myFl->Init(flux);
	
	////////////////////
	// HISTOS DEFINITION
	////////////////////
	
	char name[100];
	
	//nVeto
	TH1D *veto_chan = new TH1D("chan","chan",7,-0.5,6.5);
	TH1D *veto_Energy_tot = new TH1D("veto_Energy_tot","veto_Energy_tot",100,-0.5,1000.5);
	TH1D *veto_totEdep_tot = new TH1D("veto_totEdep_tot","veto_totEdep_tot",100,-0.5,1000.5);
	
	TH1D *veto_Energy[6];
  	for(int jj=0;jj<6;jj++) {
   	sprintf(name,"veto_Energy_%d",jj);
    	veto_Energy[jj] = new TH1D(name,name,100,-0.5,1000.5);}
    	
    	TH1D *veto_totEdep[6];
  	for(int jj=0;jj<6;jj++) {
   	sprintf(name,"veto_totEdep_%d",jj);
    	veto_totEdep[jj] = new TH1D(name,name,100,-0.5,1000.5);}

	//lAr
	TH1D *lAr_Energy_tot = new TH1D("lAr_Energy_tot","lAr_Energy_tot",100,-0.5,1000.5);
	TH1D *lAr_totEdep_tot = new TH1D("lAr_totEdep_tot","lAr_totEdep_tot",100,-0.5,1000.5);


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
		
		for (int ihit=0; ihit < nhit ; ihit++) {
			//cout << "     on sector "<<myVe->sector->at(ihit)<<
			// " channel "<<myVe->channel->at(ihit) << 
			// " (ene "<< myVe->totEdep->at(ihit) <<
			// ", adc "<< myVe->adc1->at(ihit)<<
			// ", pid "<< myVe->pid->at(ihit)<<")" << endl;
			double chan = 2*myVe->sector->at(ihit)+myVe->channel->at(ihit); // 0 down, 1 Up, 2 left, 3 right, 4 back, 5 front, 6 lAr
			//cout<<"ihit "<<ihit<<" chan "<<chan<<endl;
			veto_chan->Fill(chan);
			
			if (chan>=0 & chan<=5)	//veto
			{
				veto_Energy_tot->Fill(myVe->adc1->at(ihit));
				veto_totEdep_tot->Fill(myVe->totEdep->at(ihit));
				for(unsigned int k=0;k<6 ;k++){
			        	if(chan == k) {
			        	veto_Energy[k]->Fill(myVe->adc1->at(ihit));
			        	veto_totEdep[k]->Fill(myVe->totEdep->at(ihit));
		  			}
				}  
			} 
			else if (chan==6)  //lAr
			{		   
				lAr_Energy_tot->Fill(myVe->adc1->at(ihit));
				lAr_totEdep_tot->Fill(myVe->totEdep->at(ihit));
			}	 
		}
		
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
 	else g = new TFile("Output/Sort.root","RECREATE");
 	
 	g-> mkdir("veto");
 	g-> cd("veto");
 	
 	veto_chan->Write(0,TObject::kOverwrite);
 	veto_Energy_tot->Write(0,TObject::kOverwrite);
    	veto_totEdep_tot->Write(0,TObject::kOverwrite);
    	lAr_Energy_tot->Write(0,TObject::kOverwrite);
    	lAr_totEdep_tot->Write(0,TObject::kOverwrite);
    	
  	for (int k=0 ; k<6 ; k++){
    	veto_Energy[k]->Write(0,TObject::kOverwrite);
    	veto_totEdep[k]->Write(0,TObject::kOverwrite);
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

