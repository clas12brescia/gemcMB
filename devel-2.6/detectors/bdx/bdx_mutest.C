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

void bdx_mutest()
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

    
// opening root files    
    TChain f1chain("generated");
    f1chain.Add("outMacro.root");

    TChain f2chain("veto");
    f2chain.Add("outMacro.root");
    
    TChain f3chain("crs");
    f3chain.Add("outMacro.root");

    TChain f4chain("flux");
    f4chain.Add("outMacro.root");
    
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
    vector<double>* veto_pid  = new vector<double>;
   
    
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
    vector<double>* crs_xch  = new vector<double>;
    vector<double>* crs_ych  = new vector<double>;

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
    f2->SetBranchAddress("pid",&veto_pid);


    
    f3->SetBranchAddress("totEdep",&crs_totEdep);
    f3->SetBranchAddress("pid",&crs_pid);
    f3->SetBranchAddress("vx",&crs_vx);
    f3->SetBranchAddress("vy",&crs_vy);
    f3->SetBranchAddress("vz",&crs_vz);
    f3->SetBranchAddress("adcr",&crs_adcr);
    f3->SetBranchAddress("xch",&crs_xch);
    f3->SetBranchAddress("ych",&crs_ych);

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
    // scint alone (over Thr)
    TH2F *hi_vtIVPdEdep  = new TH2F("Vt - Pd.vs.ADC", "", 200, 0., 600.,13,1.,13.1);
    TH1F *hi_vtRate  = new TH1F("Vt - Pd Rate (kHz)", "",100,-.1,14.1);
    TH2F *hi_vtXY   = new TH2F("Vt - X.vs.Y", "",3, 0., 2.1, 3, 0., 2.1);
    // Cr alone
    TH1F *hi_crRate  = new TH1F("Cr - Rate (kHz)", "", 100,0.,2.1);
    TH1F *hi_crAll  = new TH1F("Cr - Cr ADC", "", 100, 0., 3500.);
    TH2F *hi_XY   = new TH2F("Cr & Veto - Vt X.vs.Y Rate (kHz)", "",3, 0., 2.1, 3, 0., 2.1);
    TH1F *hi_crMu  = new TH1F("Cr & Veto - Cr ADC", "", 100, 0., 3500.);
    //Cosmic
    TH1F *hi_crTS   =new TH1F("Cr & Vt Cos -  Top-Side Rate (kHz) ", "",100,-0.1,11.1);
    TH1F *hi_crMuNc  = new TH1F("Cr & Veto  noCos - Cr ADC", "", 100, 0., 3500.);// No cosmics
 


    TH1F *hi_flP  = new TH1F("Flux P", "", 100, 0., 500.);
    TH1F *hi_crGamma1  = new TH1F("Crs gamma Energy (all)", "", 100, 0., 50.);
    TH1F *hi_crGamma2  = new TH1F("Crs gamma Energy (no veto)", "", 100, 0., 50.);
    TH1F *hi_crGVx  = new TH1F("Crs gamma X", "", 100, -1000., 1000.);
    TH1F *hi_crGVy  = new TH1F("Crs gamma Y", "", 100, -1000., 1000.);
    TH1F *hi_crGVz  = new TH1F("Crs gamma Z", "", 100, -1000., 1000.);
    TH2F *hi_crGVxVy   = new TH2F("Crs gamma XvsY", "",200, -500., 500., 200, -500, 5000.);
    
    TH1F *hi_vtIVEnergy  = new TH1F("IV max Energy", "", 100, 0., 50.);
    TH1F *hi_vtIVAdc  = new TH1F("IV max ADC", "", 100, 0., 100.);

    TH2F *hi_vtIVTpEdep  = new TH2F("IV top 4 ADC ch Energy", "", 200, 0., 400.,4,1.,4.1);
    TH2F *hi_vtIVBtEdep  = new TH2F("IV bottom 4 ADC ch Energy", "", 200, 0., 400.,4,1.,4.1);
    TH2F *hi_vtIVLtEdep  = new TH2F("IV left 4 ADC ch Energy", "", 200, 0., 400.,4,1.,4.1);
    TH2F *hi_vtIVRtEdep  = new TH2F("IV right 4 ADC ch Energy", "", 200, 0., 400.,4,1.,4.1);
    TH2F *hi_vtIVUDEdep  = new TH2F("IV Upstrm/Dwnstrm ADC Energy", "", 200, 0., 800.,2,1.,2.1);
    

    TH2F *hi_calEdep  = new TH2F("Crs Deposed Energy (MeV)", "", 200, 0., 100.,17,0.,16.1);
    TH2F *hi_calAdc  = new TH2F("Crs ADC (pe)", "", 200, 0., 5000.,17,0.,16.1);
    TH2F *hi_crPid  = new TH2F("Crs Id", "", 100, -20., 25.,17,0.,16.1);

    
    // Crystal
    int Ncr=17; // number of crystals in the detector
    int Nmu[17];
    int Nne[17];
    int Ng[17];
    int Ne[17];
    int Npr[17];
    int Npart[17];
    
    int NmuT[17];
    int NneT[17];
    int NgT[17];
    int NeT[17];
    int NprT[17];
    int NpartT[17];

    int NmuTall[17];
    int NneTall[17];
    int NgTall[17];
    int NeTall[17];
    int NprTall[17];
    int NpartTall[17];
   
    int sIx=0;// specimen crystal (0 from 16) for more detailed information
    double crTh1=100.; // 1 MeV -> 10pe
    // Nflux (from sim) x NevGen (from sim) * [ 44.5% (if 0.2-2 GeV)  41% (if 2-10 GeV) )14% (if 10-100 GeV]
    //double flux_factor= 138.7/400000*frac_spec;//muon
    double flux_factor= 48./100000*0.006;//neutron
    double crRateTh1[17];
    double crRateAntiIVTh1[17];
    double crRateAntiOVTh1[17];
    double crRateAntiIVOVTh1[17];
    
        for (int s=0; s<17; s++) //initialization
        {
            crRateTh1[s] = 0.;
            crRateAntiIVTh1[s] = 0.;
            crRateAntiOVTh1[s] = 0.;
            crRateAntiIVOVTh1[s] = 0.;
            Nmu[s] =0;
            Nne[s] =0;
            Ng[s] =0;
            Ne[s] =0;
            Npr[s] =0;
            Npart[s] =0;
           
            NmuT[s] =0;
            NneT[s] =0;
            NgT[s] =0;
            NeT[s] =0;
            NprT[s] =0;
            NpartT[s] =0;
           
            NmuTall[s] =0;
            NneTall[s] =0;
            NgTall[s] =0;
            NeTall[s] =0;
            NprTall[s] =0;
            NpartTall[s] =0;
           }

    int jcounter=0;
           int jkl=0;
    double cosmR[20];
    for (int s=0; s<20; s++) cosmR[s]=0;
 
    //PARAMETERS
    
    float normRate=10./0.2/1000.; // Assuming to run at 10uA, event generated for 0.2uA in Hz PIPE3
    normRate=10./0.168/1000.; // Assuming to run at 10uA, event generated for 0.168uA in Hz PIPE2
    normRate=10./0.0168/1000.; // Assuming to run at 10uA, event generated for 0.084uA in Hz PIPE1
    //normRate=10./0.51/1000.; // Assuming to run at 10uA, event generated for 0.51uA PIPE3 40/80 cm
    //normRate=0.15*14/10000/0.15/1000.; // 15%/15% 10-100 GeV / Cosmic 10k gen x 14Hz rate
    normRate=0.12*38./20000.; //0.12 n/cm2/mn *38 10-100 GeV / Cosmic 10k gen x 14Hz rate
    normRate=0.09*36./20000.; //0.12 n/cm2/mn *38 10-100 GeV / Cosmic 10k gen x 14Hz rate
    // Nflux (from sim) x NevGen (from sim) * [ 44.5% (if 0.2-2 GeV)  41% (if 2-10 GeV) )14% (if 10-100 GeV]
    double frac_spec=14.0;
    double flux_rate=138.7;
    double Nev=100000.;
    normRate=frac_spec/100*flux_rate/Nev;
    //normRate=0.006*36./20000.; //0.12 n/cm2/mn *38 10-100 GeV / Cosmic 10k gen x 14Hz rate
    //normRate=1.;
    //normRate=0.445*36./20000;
    //normRate=0.41*37./20000;
    //normRate=0.142*38./20000;
    
    double vtThr=100.; // putting a threshold to 10 pe (MIPs at 50pe = 2 MeV -> 400 KeV)
    double crThr=50.; // putting a threshold of 100 pe (MIPs at 1670 pe = 32 MeV -> ~2 MeV with 6x6mm2)
    
    
    //double vtIVthr=2.; // putting IV threshold at 5pe
    double vtIVthr_2sipm=5.;//IV threshold on 2 sipm
    //double vtIVthr_2sipm_singlebars=15.;//IV bottom threshold on 2 sipm
    
    double vtOV_eff=.98;// OV inefficiency
    
    double vtIV_effT=.98;// IV Top efficiency
    double vtIV_effB=.98;// IV Bottom efficiency
    double vtIV_effR=.98;// IV Right efficiency
    double vtIV_effL=.98;// IV Left efficiency
    double vtIV_effU=.98;// IV Upstream efficiency
    double vtIV_effD=.98;// IV Downstream efficiency

    
    
    
    
   for (Long64_t jentry=0; jentry < nentries; jentry++) {
       veto_vt-> clear();
       veto_ch-> clear();
       veto_adc1-> clear();
       veto_adc2-> clear();
       veto_adc3-> clear();
       veto_adc4-> clear();
       veto_totEdep-> clear();
       veto_avg_x-> clear();
       veto_avg_y-> clear();
       veto_avg_z-> clear();
       veto_pid-> clear();

       
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
       crs_xch-> clear();
       crs_ych-> clear();
      
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
       double vtIVEmax=0.;
       double vtOVEmax=0.;
       double vtE=0.;
       int flag_IV=0;
       int flag_OV=0;

       int flag_fw=0;
       int flag_bw=0;
       int flag_top=0;
       int flag_bot=0;
       int flag_cosmic=0;
       int flag_muon=0;
       int flag_neutron=0;

       
       
       int flag_OV_dead=0;

       double vt_type;
       double vtAdc1=0.;
       double vtAdc2=0.;
       double vtAdc3=0.;
       double vtAdc4=0.;
       double vtAvgz=0.;
       double vtAvgx=0.;
       double vtIVAdcmax=0.;
       double vtOVAdcmax=0.;
       double vtCh=-9999.;
       double rndm=0.;
       
       
       double vtId[20];
       for (int jj=1; jj<14; jj++) vtId[jj]=0;// initialization
       //cout << "  "<< Iveto  <<endl;
       for (int jj=0; jj<Iveto; jj++)// I'm assuming we only have 1 hit per paddle per event (no multiuple hits in the same event)
       {
           
           vtE=(*veto_totEdep)[jj];
           vt_type=(*veto_vt)[jj];
           vtCh=(*veto_ch)[jj];
        
           
           vtAdc1=(*veto_adc1)[jj];
           vtAdc2=(*veto_adc2)[jj];
           vtAdc3=(*veto_adc3)[jj];
           vtAdc4=(*veto_adc4)[jj];
           
           vtAvgz=(*veto_avg_z)[jj];
           vtAvgx=(*veto_avg_x)[jj];
           
               if(vt_type == 6 )//BDX-hodo +  Edep>0
           {
         //  cout << "Edep="<< vtE << " Channel= "<<vtCh<<"   "<< "adc = "<< vtAdc1 << " " <<   vtAdc2 <<" "<<  vtAdc3 << " "<<  vtAdc4 << " "<<endl;
               if (vtAdc1>vtThr)// Edep> Threshold
               {
                   vtId[int(vtCh)]=1;// filling detector Id matrix
                   // no inefficiency for paddles
                   hi_vtIVPdEdep->Fill(vtAdc1,vtCh*1.); //Occupancy
                   hi_vtRate->Fill(vtCh*1.,normRate);// Rate on scintillators
                   
               }

             }
           
       }

       // Trigger condition: vtId only filled when over Threshold
       
       
      // for (int ii=1; ii<14; ii++)
       //{
           //if(vtId[ii] !=0) cout <<"ii=" << ii<<" X,Y=  "<< vtId[ii] <<endl;
           
      // }

       double hodo[3][3]; //  X%Y paddles
       for (int ii=0; ii<3; ii++)
       {   hodo[ii][0]=0;
           hodo[ii][1]=0;
           hodo[ii][2]=0;}
      
            if(vtId[7]!=0 && vtId[5]!=0)// front right FR
            {if(vtId[10]!=0 && vtId[8]!=0) hodo[2][2]=1; //back top BT
             if(vtId[11]!=0 && vtId[8]!=0) hodo[2][1]=1; // back Center BC
             if(vtId[11]!=0 && vtId[9]!=0) hodo[2][0]=1;}// Back bottom BB
       
       
            if(vtId[6]!=0 && vtId[5]!=0) // front center FC
            {if(vtId[10]!=0 && vtId[8]!=0) hodo[1][2]=1; //back top BT
             if(vtId[11]!=0 && vtId[8]!=0) hodo[1][1]=1; // back Center BC
             if(vtId[11]!=0 && vtId[9]!=0) hodo[1][0]=1;}// Back bottom BB
       
            if(vtId[6]!=0 && vtId[4]!=0) // front Left FL
            {if(vtId[10]!=0 && vtId[8]!=0) hodo[0][2]=1; //back top BT
             if(vtId[11]!=0 && vtId[8]!=0) hodo[0][1]=1; // back Center BC
             if(vtId[11]!=0 && vtId[9]!=0) hodo[0][0]=1;}// Back bottom BB
       
       for (int ii=0; ii<3; ii++)
        {for (int ij=0; ij<3; ij++)
         { if (hodo[ii][ij]!=0) hi_vtXY->Fill(ii*1.,ij*1.);
          // cout <<"ii jj=" << ii<< "," << ij<<" X,Y=  "<< hodo[ij][ii] <<endl;
         }
        }
       
       // Cosmic ray id and rej
       double cosm[10];
       for (int ii=0; ii<10; ii++) cosm[ii]=0.;
       // ch=1 T/B
       // ch=2 NO T/B/L/R
       // ch=3 NO T/B/L/R but F/B active
       // ch=4 L/R
       // ch=5 T
       // ch=6 B
       // ch=7 T/L
       // ch=8 T/R
       if ((vtId[13]!=0) && (vtId[12]!=0))
       {cosm[1]=1; // Top & Bottom ch=1
       }
       if (!(vtId[13]!=0 || vtId[12]!=0 || vtId[1]!=0 || vtId[2]!=0)) //  NO T/B/L/R
           {
           cosm[2]=1;
           if ((vtId[3]!=0) && (vtId[6]!=0 || vtId[7]!=0)) cosm[3]=1; // but F/B active
           }
       if (vtId[1]!=0 && vtId[2]!=0) cosm[4]=1; // L/R
       if (vtId[13]!=0) cosm[5] =1; // Top
       if (vtId[12]!=0) cosm[6] =1; // Bottom
       if (vtId[13]!=0 && vtId[1]!=0) cosm[7] =1; // T/L
       if (vtId[13]!=0 && vtId[2]!=0) cosm[8] =1; // T/R
       //}
       
       int cosmic=0;
       for (int ii=0; ii<10; ii++) if(cosm[ii]!=0) cosmic=1;
       
       
// Crystal & Cal reconstruction
       double crEdep=0;
       int crPid=-9999;
       double crAdcr=0.;
       double crGVx=-9999.;
       double crGVy=-9999.;
       double crGVz=-9999.;
       int jmx=0;
       double emx=0;
       double xcr=-1;
       double ycr=-1;
       int calIcr;
       int Indx[17];
       int Ix=0;
       
       double calAdcr[17];

        if (crs_totEdep->size() >= 1) // Starting Cal Processing if  at least something in the calorimeter
        {
            for (int s=0; s<1; s++) //initialization
            {
             calAdcr[s] = 0.;
             Indx[s] = 0.;
             
            }
            for (int ii=0; ii<int(crs_totEdep->siz e()); ii++)
            {
                xcr=(*crs_xch)[ii];
                ycr=(*crs_ych)[ii];
                crAdcr=(*crs_adcr)[ii];
                calIcr=0;
                if (xcr*ycr != 0) calIcr=(xcr-1.)*4+ycr; // 0,0 ->0 1,1 -> 1 1,2-> 2 .. 2,1 ->5 ...
                if (crAdcr>calAdcr[calIcr])
                {calAdcr[calIcr]=crAdcr;
                    Indx[calIcr]=ii;}
                //cout <<"ii=" << ii<<" X,Y=  "<< (*crs_xch)[ii] << "  "<< (*crs_ych)[ii] << " Index=" << calIcr << " Edep="<< calEdep[calIcr]<<endl;
                if ((*crs_adcr)[ii]>emx)
                {jmx=ii;
                    emx=(*crs_adcr)[ii];
            }
            }
            //for (int s=0; s<17; s++) cout <<"s=" << s<<" edep="<< calEdep[s] <<endl;
            for (int s=0; s<1; s++) // looping over each crystal per event
            {
                if (calAdcr[s] >crThr )// to be considered a Cal hit over Thr
                {   Ix=Indx[s];
                    
                   // if (flag_OV==0) cout <<"@@@@@@@@ s=" << s<<" edep="<< calAdcr[s] << "  " <<(*crs_adcr)[Ix] <<endl;
                    
                    crEdep=(*crs_totEdep)[Ix];
                    crGVx=(*crs_vx)[Ix];
                    crGVy=(*crs_vy)[Ix];
                    crGVz=(*crs_vz)[Ix];
                    crAdcr=(*crs_adcr)[Ix];
                    crPid=(*crs_pid)[Ix];
                    hi_calAdc->Fill(crAdcr,s);
                    hi_calEdep->Fill(crEdep,s);
                    
                    if (crAdcr>crThr) // particle Id for ADC in the crystal > threshold
                    {   cosm[0]=1; // Hit in the crystal
                        hi_crAll->Fill(crAdcr);
                        hi_crRate->Fill(1.0,normRate);
                        
                        
                        
                        // Coincidence with the Veto
                        for (int i=0; i<3; i++)
                        {for (int ij=0; ij<3; ij++)
                         { if (hodo[i][ij]!=0)
                          { hi_XY->Fill(i,ij,normRate);
                            hi_crMu->Fill(crAdcr);
                            if(cosmic==0) hi_crMuNc->Fill(crAdcr);
                            // cout <<"ii jj=" << ii<< "," << ij<<" X,Y=  "<< hodo[ij][ii] <<endl;
                           }
                          }
                         }
                        
                         for (int i=0; i<10; i++)
                         {
                         if(cosm[i]!= 0)
                         {hi_crTS->Fill(i*1.,normRate);
                             cosmR[i]=cosmR[i]+normRate;
                         }
                         }
   
                    }
                    
                 }
            }
        }//Closing Cal processing
      // cout <<" "<<endl;

       
   }
    cout  << " ----------------------------------" << endl;
    cout  << " BDX hodo counters" << endl;
    cout  << " ----------------------------------" << endl;
    cout  << " Nev generated = " << Nev   <<endl;
    cout  << " Norm flux Rate (Hz) = " << flux_rate   <<endl;
    cout  << " Muon Spec fraction (%) = " << frac_spec   <<endl;
    cout  << " Thres scint (pe) = " << vtThr  <<endl;
    cout  << " Thres cryst (pe) = " << crThr  <<endl;
    cout  << " Rate (Hz) Crystal= " << cosmR[0] <<" +- "<< sqrt(cosmR[0]/normRate)*normRate  <<" ("<<int(1/sqrt(cosmR[0]/normRate)*100) <<"%)" <<endl;
    cout  << " Rate (Hz) Top/Bottom= " << cosmR[1] <<" +- "<< sqrt(cosmR[1]/normRate)*normRate   <<" ("<<int(1/sqrt(cosmR[1]/normRate)*100) <<"%)"<<endl;
    cout  << " Rate (Hz) NO Top/Bottom/L/R = " << cosmR[2] <<" +- "<< sqrt(cosmR[2]/normRate)*normRate   <<" ("<<int(1/sqrt(cosmR[2]/normRate)*100) <<"%)"<<endl;
    cout  << " Rate (Hz) NO Top/Bottom/L/R but Front/Back active = " << cosmR[3] <<" +- "<< sqrt(cosmR[3]/normRate)*normRate  <<" ("<<int(1/sqrt(cosmR[3]/normRate)*100) <<"%)" <<endl;
    cout  << " Rate (Hz) L/R = " << cosmR[4] <<" +- "<< sqrt(cosmR[4]/normRate)*normRate  <<" ("<<int(1/sqrt(cosmR[4]/normRate)*100) <<"%)" <<endl;
    cout  << " Rate (Hz) T = " << cosmR[5]  <<" +- "<< sqrt(cosmR[5]/normRate)*normRate  <<" ("<<int(1/sqrt(cosmR[5]/normRate)*100) <<"%)"<<endl;
    cout  << " Rate (Hz) B = " << cosmR[6]  <<" +- "<< sqrt(cosmR[6]/normRate)*normRate  <<" ("<<int(1/sqrt(cosmR[6]/normRate)*100) <<"%)"<<endl;
    cout  << " Rate (Hz) T/L = " << cosmR[7]  <<" +- "<< sqrt(cosmR[7]/normRate)*normRate  <<" ("<<int(1/sqrt(cosmR[7]/normRate)*100) <<"%)"<<endl;
    cout  << " Rate (Hz) T/R = " << cosmR[8]  <<" +- "<< sqrt(cosmR[8]/normRate)*normRate  <<" ("<<int(1/sqrt(cosmR[8]/normRate)*100) <<"%)"<<endl;
    cout  << "End BDX-hodo counters" <<endl;

    
    
    // Indexing calIcr=(xcr-1.)*4+ycr;
    //             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
    int xIx[17] = {0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4};
    int yIx[17] = {0, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4};

        for (int s=0; s<0; s++)
        {
                cout  << " ----------------------------------" << endl;
                cout  << " Crystal # "<< s << " X="<< xIx[s] << " Y=" << yIx[s] <<endl;
                cout  << " ----------------------------------" << endl;
                cout  << " Particles with Edep > 0  (no thresholds)"<< endl;
                cout  << " Ntot = " << Npart[s]   <<endl;
                cout  << " Nsum = " << Nmu[s]+Ne[s]+Ng[s]+Nne[s]+Npr[s]  <<endl;
                cout  << " Nmu+- = " << Nmu[s]   <<endl;
                cout  << " Ne+- = " << Ne[s]   <<endl;
                cout  << " Ng = " << Ng[s]   <<endl;
                cout  << " Nnu = " << Nne[s]   <<endl;
                cout  << " Npr = " << Npr[s]   <<endl;
                cout  << " Rates given for  ADC threshold > "<< crTh1<< endl;
                cout  << " Rate (per crystal) Hz= " << crRateTh1[s]*flux_factor   << " ("<<crRateTh1[s] <<" particles) "<< endl;//flux factor
                cout  << " Rate no IV Hz= " << crRateAntiIVTh1[s] *  flux_factor    << " ("<< crRateAntiIVTh1[s]<<" particles) "<<endl;//flux factor
                cout  << " Rate no OV Hz= " << crRateAntiOVTh1[s] *  flux_factor   << " ("<<crRateAntiOVTh1[s] <<" particles) "<<endl;//flux factor
                cout  << " Rate no IV && no OV Hz= " << crRateAntiIVOVTh1[s] * flux_factor    << " ("<<crRateAntiIVOVTh1[s] <<" particles) "<<endl;//flux factor
                   
                cout  << "Particles in the crystals with no IV" <<endl;
                cout  << " Ntot = " << NpartT[s]   << "("<<NpartT[s]*1./Npart[s]<<" %)"<<endl;
                cout  << " Nsum = " << NmuT[s]+NeT[s]+NgT[s]+NneT[s]+NprT[s] << "("<<(NmuT[s]+NeT[s]+NgT[s]+NneT[s]+NprT[s])*1./(Nmu[s]+Ne[s]+Ng[s]+Nne[s]+Npr[s]) <<" %)" <<endl;
                cout  << " Nmu+- = " << NmuT[s] << "("<<NmuT[s]*1./(Nmu[s]+0.00001)<<" %)"  <<endl;
                cout  << " Ne+- = " << NeT[s] << "("<<NeT[s]*1./(Ne[s]+0.00001)<<" %)"  <<endl;
                cout  << " Ng = " << NgT[s]  << "("<<NgT[s]*1./(Ng[s]+0.00001)<<" %)" <<endl;
                cout  << " Nnu = " << NneT[s]  << "("<<NneT[s]*1./(Nne[s]+0.00001)<<" %)" <<endl;
                cout  << " Npr = " << NprT[s] << "("<<NprT[s]*1./(Npr[s]+0.00001)<<" %)"  <<endl;
                   
                cout  << "Particles in the crystals with NO IV && NO OV" <<endl;
                cout  << " Ntot = " << NpartTall[s]   << "("<<NpartTall[s]*1./Npart[s]<<" %)"<<endl;
                cout  << " Nsum = " << NmuTall[s]+NeTall[s]+NgTall[s]+NneTall[s]+NprTall[s] << "("<<(NmuTall[s]+NeTall[s]+NgTall[s]+NneTall[s]+NprTall[s])*1./(Nmu[s]+Ne[s]+Ng[s]+Nne[s]+Npr[s]) <<" %)" <<endl;
                cout  << " Nmu+- = " << NmuTall[s] << "("<<NmuTall[s]*1./(Nmu[s]+0.00001)<<" %)"  <<endl;
                cout  << " Ne+- = " << NeTall[s] << "("<<NeTall[s]*1./(Ne[s]+0.00001)<<" %)"  <<endl;
                cout  << " Ng = " << NgTall[s]  << "("<<NgTall[s]*1./(Ng[s]+0.00001)<<" %)" <<endl;
                cout  << " Nnu = " << NneTall[s]  << "("<<NneTall[s]*1./(Nne[s]+0.00001)<<" %)" <<endl;
                cout  << " Npr = " << NprTall[s] << "("<<NprTall[s]*1./(Npr[s]+0.00001)<<" %)"  <<endl;
                cout  << " +++++++++++++++++++++++++++++++++++" << endl;
                cout  << "  "<<endl;

        }


    cout  << "End Particles in the crystals" <<endl;

    
    TCanvas *c20=new TCanvas("c20","BDX_gemc GEN",750,750);
    c20->Divide(2,4);
    c20->cd(1);
     hi_vtIVPdEdep->Draw("");
    c20->cd(2);
    hi_vtXY->Draw("BOX");
        c20->cd(3);
       hi_vtRate->Draw("");
       c20->cd(4);
       hi_crRate->Draw("");
    c20->cd(5);
    hi_crMu->Draw("");
    c20->cd(6);
    hi_XY->Draw("COLZ");
    c20->cd(7);
    hi_crMuNc->Draw("");
    c20->cd(8);
    hi_crTS->Draw("");
    
    c20->Print("mutest.pdf");
/*
    TCanvas *c21=new TCanvas("c21","BDX_gemc GEN",750,750);
    c21->Divide(2,3);
    //hi_crGVxVy->Draw("COLZ");
    //c21->cd(1);
    //hi_calEdep->Draw("COLZ");
    c21->cd(1);
    hi_vtIVTpEdep->Draw("COLZ");
    c21->cd(2);
    hi_vtIVBtEdep->Draw("COLZ");
    c21->cd(3);
    hi_vtIVLtEdep->Draw("COLZ");
    c21->cd(4);
    hi_vtIVRtEdep->Draw("COLZ");
    c21->cd(5);
    hi_vtIVUDEdep->Draw("COLZ");
    c21->cd(6);
    hi_vtIVPdEdep->Draw("COLZ");

    TCanvas *c22=new TCanvas("c22","BDX_gemc GEN",750,750);
    c22->Divide(2,3);
    c22->cd(1);
    hi_vtOVTpEdep->Draw("COLZ");
    c22->cd(2);
    hi_vtOVBtEdep->Draw("COLZ");
    c22->cd(3);
    hi_vtOVLtEdep->Draw("COLZ");
    c22->cd(4);
    hi_vtOVRtEdep->Draw("COLZ");
    c22->cd(5);
    hi_vtIVUDEdep->Draw("COLZ");
    
    TCanvas *c23=new TCanvas("c23","BDX_gemc GEN",750,750);
    c23->Divide(2,2);
    c23->cd(1);
    hi_calEdep->Draw("COLZ");
    c23->cd(2);
    hi_calAdc->Draw("COLZ");

    
  //  cout << "Counter = "<<jkl<<endl;
*/
 
}



