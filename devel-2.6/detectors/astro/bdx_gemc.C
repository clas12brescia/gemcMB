#include <TH1.h>
#include <TH2.h>
#include <TH3.h>
#include <TStyle.h>
#include <TCanvas.h>
#include <TChain.h>
#include <TFile.h>
#include <time.h>
#include <stdlib.h>



#include <vector>
#include <iostream>

using namespace std;

void bdx_gemc()
{
    
    srand(time(NULL));
   gStyle->SetCanvasBorderMode(0);
   gStyle->SetCanvasColor(10);

   gStyle->SetPadBorderMode(0);
   gStyle->SetPadLeftMargin(0.12);
   gStyle->SetPadRightMargin(0.12);
   gStyle->SetPadColor(10);


   gStyle->SetTitleFont(72,"X");
   gStyle->SetTitleFont(72,"Y");
   gStyle->SetTitleOffset(0.9,"X");
   gStyle->SetTitleOffset(1.2,"Y");
   gStyle->SetTitleSize(0.05,"X");
   gStyle->SetTitleSize(0.05,"Y");

   gStyle->SetLabelFont(72,"X");
   gStyle->SetLabelFont(72,"Y");
   gStyle->SetLabelFont(72,"Z");
   gStyle->SetPalette(1);
   gStyle->SetOptFit(111);
   gStyle->SetOptStat("nemri");
//   gStyle->SetOptStat("");

   float norm=100000;

// opening root files    
    TChain f1chain("generated");
    f1chain.Add("out.root");

    TChain f2chain("veto");
    f2chain.Add("out.root");
    
    TChain f3chain("crs");
    f3chain.Add("out.root");

    TChain f4chain("flux");
    f4chain.Add("out.root");
    
    TTree *f1=(TTree*)&f1chain;
    TTree *f2=(TTree*)&f2chain;
    TTree *f3=(TTree*)&f3chain;
    TTree *f4=(TTree*)&f4chain;

   int   evn;
   float p,theta,phi;
   float Edep_tot,Emax;
   int   nhit,sector[10000],id[10000],pid[10000];
   float t[50000],Edep[50000],E[50000];
   float px,py,pz;
   int   adc[50000],tdc[50000];
    
    double t_up_pd, t_dn_pd, tdiff_pd,t_up_ov, t_dn_ov, tdiff_ov;
    int nn,nhit_up_pd,nhit_dn_pd,nhit_up_ov,nhit_dn_ov;

    vector<double>* veto_vt  = new vector<double>;
    vector<double>* veto_ch  = new vector<double>;
    vector<double>* veto_adc1  = new vector<double>;
    vector<double>* veto_adc2  = new vector<double>;
    vector<double>* veto_adc3  = new vector<double>;
    vector<double>* veto_adc4  = new vector<double>;
    vector<double>* veto_totEdep  = new vector<double>;
    vector<double>* veto_avg_x  = new vector<double>;
    vector<double>* veto_avg_y  = new vector<double>;
    vector<double>* veto_avg_z  = new vector<double>;
    vector<double>* veto_tdc1  = new vector<double>;
  
    
    vector<double>* flux_pid  = new vector<double>;
    vector<double>* flux_id  = new vector<double>;
    vector<double>* flux_px  = new vector<double>;
    vector<double>* flux_py  = new vector<double>;
    vector<double>* flux_pz  = new vector<double>;
    
    vector<double>* crs_totEdep  = new vector<double>;
    vector<double>* crs_pid  = new vector<double>;
    vector<double>* crs_vx  = new vector<double>;
    vector<double>* crs_vy  = new vector<double>;
    vector<double>* crs_vz  = new vector<double>;
    vector<double>* crs_adcr  = new vector<double>;

    f2->SetBranchAddress("veto",&veto_vt);
    f2->SetBranchAddress("channel",&veto_ch);
    f2->SetBranchAddress("adc1",&veto_adc1);
    f2->SetBranchAddress("adc2",&veto_adc2);
    f2->SetBranchAddress("adc3",&veto_adc3);
    f2->SetBranchAddress("adc4",&veto_adc4);
    f2->SetBranchAddress("totEdep",&veto_totEdep);
    f2->SetBranchAddress("avg_x",&veto_avg_x);
    f2->SetBranchAddress("avg_y",&veto_avg_y);
    f2->SetBranchAddress("avg_z",&veto_avg_z);
    f2->SetBranchAddress("tdc1",&veto_tdc1);


    
    f3->SetBranchAddress("totEdep",&crs_totEdep);
    f3->SetBranchAddress("pid",&crs_pid);
    f3->SetBranchAddress("vx",&crs_vx);
    f3->SetBranchAddress("vy",&crs_vy);
    f3->SetBranchAddress("vz",&crs_vz);
    f3->SetBranchAddress("adcr",&crs_adcr);

    f4->SetBranchAddress("pid",&flux_pid);
    f4->SetBranchAddress("id",&flux_id);
    f4->SetBranchAddress("px",&flux_px);
    f4->SetBranchAddress("py",&flux_py);
    f4->SetBranchAddress("pz",&flux_pz);
    
  //g->SetBranchAddress("evn",&evn);
   //g->SetBranchAddress("p",&p);
   //g->SetBranchAddress("theta",&theta);
  // g->SetBranchAddress("phi",&phi);
 //
   Long64_t nentries = f4chain.GetEntries();
   cout << nentries << endl;


   
// Create histos
    
    TH1F *hi_vtXt  = new TH1F("X top", "", 50, -10., 190.);
    TH1F *hi_vtYt  = new TH1F("Y top", "", 50, -10., 90.);
    TH1F *hi_vtXm  = new TH1F("X mid", "", 50, -10., 190.);
    TH1F *hi_vtYm  = new TH1F("Y mid", "", 50, -10., 90.);
    TH1F *hi_vtXb  = new TH1F("X bot", "", 50, -10., 190.);
    TH1F *hi_vtYb  = new TH1F("Y bot", "", 50, -10., 90.);
    TH1F *hi_vtX  = new TH1F("X ave", "", 50, -10., 190.);
    TH1F *hi_vtY  = new TH1F("Y ave", "", 50, -10., 90.);
    TH1F *hi_vtMt  = new TH1F("Mult top", "", 50, -2., 10.);
    TH1F *hi_vtMm  = new TH1F("Mult mid", "", 50, -2., 10.);
    TH1F *hi_vtMb  = new TH1F("Mult bot", "", 50, -2., 10.);
    TH1F *hi_vtM  = new TH1F("Mult", "", 50, -2., 10.);
    TH1F *hi_vtTh  = new TH1F("Th Trk", "", 90, 0., 90.);
    TH1F *hi_vtPh  = new TH1F("Ph Trk", "", 180, 0., 360.);
    
    TH1F *hi_vtTt  = new TH1F("Time t", "", 100, 0., 100.);
    TH1F *hi_vtTm  = new TH1F("Time m", "", 100, 0., 100.);
    TH1F *hi_vtTb  = new TH1F("Time b", "", 100, 0., 100.);
    
    TH1F *hi_vtT  = new TH1F("DTime Trk", "", 50, 0., 10.);

    TH1F *hi_vtSpeed  = new TH1F("Speed", "", 50, 20., 40.);

    
    TH2F *hi_vtXYt  = new TH2F("XY top", "", 50, -10., 190.,50, -10., 90.);
    TH2F *hi_vtXYm  = new TH2F("XY mid", "", 50, -10., 190.,50, -10., 90.);
    TH2F *hi_vtXYb  = new TH2F("XY bot", "", 50, -10., 190.,50, -10., 90.);

    TH2F *hi_vtXY  = new TH2F("XY Trk", "", 50, -10., 190.,50, -10., 90.);

    
    // Crystal
    int Nmu=0;
    int Nne=0;
    int Ng=0;
    int Ne=0;
    int Npr=0;
    int Npart=0;
    
    int NmuT=0;
    int NneT=0;
    int NgT=0;
    int NeT=0;
    int NprT=0;
    int NpartT=0;

    int NmuTall=0;
    int NneTall=0;
    int NgTall=0;
    int NeTall=0;
    int NprTall=0;
    int NpartTall=0;
   
    double crTh1=100.; // 1 MeV -> 10pe
    // Nflux (from sim) x NevGen (from sim) * [ 44.5% (0.2-2 GeV) 41% (if 2-10 GeV) )14% (if 10-100 GeV]
    double frac_spec=0.445;
    double flux_factor= 1248.8/10000*frac_spec;//muon
    //double flux_factor= 48./100000*0.006;//neutron
    double crRateTh1=0.;
    double crRateAntiIVTh1=0.;
    double crRateAntiOVTh1=0.;
    double crRateAntiIVOVTh1=0.;

    int jcounter=0;

    
    
   for (Long64_t jentry=0; jentry < nentries; jentry++) {

       
       flux_id-> clear();
       flux_pid-> clear();
       flux_px-> clear();
       flux_py-> clear();
       flux_pz-> clear();
       
       crs_totEdep-> clear();
       crs_pid-> clear();
       crs_vx-> clear();
       crs_vy-> clear();
       crs_vz-> clear();
       crs_adcr-> clear();

       veto_vt-> clear();
       veto_ch-> clear();
       veto_adc1-> clear();
       veto_adc2-> clear();
       veto_adc3-> clear();
       veto_adc4-> clear();
       
       veto_avg_x-> clear();
       veto_avg_y-> clear();
       veto_avg_z-> clear();
       
       f2->GetEntry(jentry);
       f3->GetEntry(jentry);
       f4->GetEntry(jentry);
       
        nn=flux_id->size();

       double flId=0.;
       double flPid=0.;
       double flPx=0.;
       double flPy=0.;
       double flPz=0.;
       double flPtmp=0.;
       double flP=0.;

       
       
       for(int i=0; i<nn; i++) {
           
           flId=(*flux_id)[i];
           flPid=(*flux_pid)[i];
           if(flPid==22 && flId==2001)
           {
            flPx=(*flux_px)[i];
            flPy=(*flux_py)[i];
            flPz=(*flux_pz)[i];
            flP=sqrt(flPx*flPx+flPy*flPy+flPz*flPz);
            if (flP>flPtmp) flPtmp=flP;
           }
           
       }
       
       
       
       int Iveto;

       
       Iveto=veto_totEdep->size();
       double vtX=-1000;
       double vtY=-1000;
       double vtM=-1000;
       double vtXt=-1000;
       double vtYt=-1000;
       double vtXm=-1000;
       double vtYm=-1000;
       double vtXb=-1000;
       double vtYb=-1000;
 
       double vtTt=-1000;
       double vtTm=-1000;
       double vtTb=-1000;
       double vtT=-1000;
       
       double vt_type,vtCh;
       double Mult=0.;
       double Xave=0.;
       double Yave=0.;
       int Nt=0;
       int Nb=0;
       int Nm=0;
       
       
       
       for (int jj=0; jj<Iveto; jj++)

       {
           vt_type=(*veto_vt)[jj];
           vtCh=(*veto_ch)[jj];
           vtM=(*veto_adc4)[jj];
           
           vtY=(*veto_adc1)[jj]/10000.+90/2.-5.;
           vtX=(*veto_adc3)[jj]/10000.+160./2.;
           vtT=(*veto_tdc1)[jj]/1000.;
           //cout << "  "<<  (*veto_adc1)[jj] <<endl;
           if (vtM > 0)
             //  if (Iveto != 0) cout << "  "<< Iveto  <<endl;
           
           {
               if(vt_type == 1000)
               {hi_vtMt->Fill(vtM);
                   vtXt=vtX;
                   vtYt=vtY;
                   vtTt=vtT;
                hi_vtXt->Fill(vtX);
                hi_vtYt->Fill(vtY);
                hi_vtTt->Fill(vtT);
                hi_vtXYt->Fill(vtX,vtY);
                   Nt=1;
                   Xave=Xave+vtX;
                   Yave=Yave+vtY;
                   Mult=Mult+vtM;
               }
               if(vt_type == 1001)
               {hi_vtMm->Fill(vtM);
                   vtXm=vtX;
                   vtYm=vtY;
                   vtTm=vtT;
                hi_vtXm->Fill(vtX);
                hi_vtYm->Fill(vtY);
                hi_vtTm->Fill(vtT);
                   hi_vtXYm->Fill(vtX,vtY);
                   Nm=1;
                   Xave=Xave+vtX;
                   Yave=Yave+vtY;
                   Mult=Mult+vtM;
               }
               if(vt_type == 1002)
               {hi_vtMb->Fill(vtM);
                   vtXb=vtX;
                   vtYb=vtY;
                   vtTb=vtT;
                hi_vtXb->Fill(vtX);
                   hi_vtYb->Fill(vtY);
                   hi_vtTb->Fill(vtT);
                   hi_vtXYb->Fill(vtX,vtY);
                  Nb=1;
                   Xave=Xave+vtX;
                   Yave=Yave+vtY;
                   Mult=Mult+vtM;
               }
            }
                  }
       if (Nt+Nm+Nb == 3)
       {hi_vtM->Fill(Mult);
        hi_vtX->Fill(Xave/3);
           hi_vtY->Fill(Yave/3);
           hi_vtXY->Fill(Xave/3,Yave/3);

           hi_vtT->Fill(vtTt-vtTb);
   
           double productX = (vtXt - vtXb);
           double productY = (vtYt - vtYb);
           double productZ = 100.;
           
           double normalizedTotal = sqrt(productX * productX + productY * productY + productZ * productZ);
           
           double unitVectorX, unitVectorY, unitVectorZ;
           if(normalizedTotal == 0)
           {
               unitVectorX = productX;
               unitVectorY = productY;
               unitVectorZ = productZ;
           }
           else
           {
               unitVectorX = productX / normalizedTotal;
               unitVectorY = productY / normalizedTotal;
               unitVectorZ = productZ / normalizedTotal;
           }
           double ThTrk= acos(unitVectorZ)*180./acos(-1.);
           double PhTrk= atan(unitVectorY/unitVectorX)*180./acos(-1.);
           if(unitVectorX<0 & unitVectorY>0) PhTrk = PhTrk+180.;
           if(unitVectorX<0 & unitVectorY<0) PhTrk = PhTrk+180.;
           if(unitVectorX>0 & unitVectorY<0) PhTrk = PhTrk+360.;
           PhTrk = (PhTrk+60.)-360.*(int((PhTrk+60.)/360.));
           hi_vtTh->Fill(ThTrk);
           hi_vtPh->Fill(PhTrk);
           double Speed=normalizedTotal/(vtTt-vtTb);
           hi_vtSpeed->Fill(Speed);
           
           
           //cout << "vtXt "<< vtXt<< " vtYt "<< vtYt<<endl;
           //cout << "vtXb "<< vtXb<< " vtYb "<< vtYb<<endl;
           //cout << "cX "<< unitVectorX<< "cy "<< unitVectorY<< "cZ "<< unitVectorZ  <<endl;
           //cout << "ThTrk "<< ThTrk<< " PhTrk "<< PhTrk<<endl;
       }

   }

    TCanvas *c20=new TCanvas("c20","BDX_gemc GEN",750,750);
    c20->Divide(3,4);
    c20->cd(1);
    hi_vtMt->Draw("");
    c20->cd(2);
    hi_vtMm->Draw("");
    c20->cd(3);
    hi_vtMb->Draw("");
    c20->cd(4);
    hi_vtXt->Draw("");
    c20->cd(5);
    hi_vtXm->Draw("");
    c20->cd(6);
    hi_vtXb->Draw("");
    c20->cd(7);
    hi_vtYt->Draw("");
    c20->cd(8);
    hi_vtYm->Draw("");
    c20->cd(9);
    hi_vtYb->Draw("");
    c20->cd(10);
    hi_vtXYt->Draw("COL");
    c20->cd(11);
    hi_vtXYm->Draw("COL");
    c20->cd(12);
    hi_vtXYb->Draw("COL");
  
    
    c20->Print("EEE_Chambers.pdf(","pdf");
    
    TCanvas *c21=new TCanvas("c21","BDX_gemc GEN",750,750);
    c21->Divide(2,3);
    c21->cd(1);
    hi_vtM->Draw("");
    c21->cd(2);
    hi_vtXY->Draw("COL");
    c21->cd(3);
    hi_vtX->Draw("");
    c21->cd(4);
    hi_vtY->Draw("");
    c21->cd(5);
    hi_vtTh->Draw("");
    c21->cd(6);
    hi_vtPh->Draw("");
    
    
        c21->Print("EEE_Chambers.pdf","pdf");
    TCanvas *c22=new TCanvas("c22","BDX_gemc GEN",750,750);
    c22->Divide(2,3);
    c22->cd(1);
    hi_vtT->Draw("");
    c22->cd(2);
    hi_vtSpeed->Draw("");

    
    c22->Print("EEE_Chambers.pdf)","pdf");


}



