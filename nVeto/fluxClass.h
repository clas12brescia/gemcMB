//////////////////////////////////////////////////////////
// This class has been automatically generated on
// Tue Mar  1 10:47:21 2022 by ROOT version 6.24/06
// from TTree flux/Geant4 flux digitized information
// found on file: out.root
//////////////////////////////////////////////////////////

#ifndef fluxClass_h
#define fluxClass_h

#include <TROOT.h>
#include <TChain.h>
#include <TFile.h>

// Header file for the classes stored in the TTree if any.
#include "vector"

class fluxClass {
public :
   TTree          *fChain;   //!pointer to the analyzed TTree or TChain
   Int_t           fCurrent; //!current Tree number in a TChain

// Fixed size dimensions of array or collections stored in the TTree if any.

   // Declaration of leaf types
   vector<double>  *hitn;
   vector<double>  *id;
   vector<double>  *pid;
   vector<double>  *mpid;
   vector<double>  *tid;
   vector<double>  *mtid;
   vector<double>  *otid;
   vector<double>  *trackE;
   vector<double>  *totEdep;
   vector<double>  *avg_x;
   vector<double>  *avg_y;
   vector<double>  *avg_z;
   vector<double>  *avg_lx;
   vector<double>  *avg_ly;
   vector<double>  *avg_lz;
   vector<double>  *px;
   vector<double>  *py;
   vector<double>  *pz;
   vector<double>  *vx;
   vector<double>  *vy;
   vector<double>  *vz;
   vector<double>  *mvx;
   vector<double>  *mvy;
   vector<double>  *mvz;
   vector<double>  *avg_t;
   vector<double>  *nsteps;
   vector<double>  *procID;

   // List of branches
   TBranch        *b_hitn;   //!
   TBranch        *b_id;   //!
   TBranch        *b_pid;   //!
   TBranch        *b_mpid;   //!
   TBranch        *b_tid;   //!
   TBranch        *b_mtid;   //!
   TBranch        *b_otid;   //!
   TBranch        *b_trackE;   //!
   TBranch        *b_totEdep;   //!
   TBranch        *b_avg_x;   //!
   TBranch        *b_avg_y;   //!
   TBranch        *b_avg_z;   //!
   TBranch        *b_avg_lx;   //!
   TBranch        *b_avg_ly;   //!
   TBranch        *b_avg_lz;   //!
   TBranch        *b_px;   //!
   TBranch        *b_py;   //!
   TBranch        *b_pz;   //!
   TBranch        *b_vx;   //!
   TBranch        *b_vy;   //!
   TBranch        *b_vz;   //!
   TBranch        *b_mvx;   //!
   TBranch        *b_mvy;   //!
   TBranch        *b_mvz;   //!
   TBranch        *b_avg_t;   //!
   TBranch        *b_nsteps;   //!
   TBranch        *b_procID;   //!

   fluxClass(TTree *tree=0);
   virtual ~fluxClass();
   virtual Int_t    Cut(Long64_t entry);
   virtual Int_t    GetEntry(Long64_t entry);
   virtual Long64_t LoadTree(Long64_t entry);
   virtual void     Init(TTree *tree);
   virtual void     Loop();
   virtual Bool_t   Notify();
   virtual void     Show(Long64_t entry = -1);
};

#endif

#ifdef fluxClass_cxx
fluxClass::fluxClass(TTree *tree) : fChain(0) 
{
// if parameter tree is not specified (or zero), connect the file
// used to generate this class and read the Tree.
   if (tree == 0) {
      TFile *f = (TFile*)gROOT->GetListOfFiles()->FindObject("out.root");
      if (!f || !f->IsOpen()) {
         f = new TFile("out.root");
      }
      f->GetObject("flux",tree);

   }
   Init(tree);
}

fluxClass::~fluxClass()
{
   if (!fChain) return;
   delete fChain->GetCurrentFile();
}

Int_t fluxClass::GetEntry(Long64_t entry)
{
// Read contents of entry.
   if (!fChain) return 0;
   return fChain->GetEntry(entry);
}
Long64_t fluxClass::LoadTree(Long64_t entry)
{
// Set the environment to read one entry
   if (!fChain) return -5;
   Long64_t centry = fChain->LoadTree(entry);
   if (centry < 0) return centry;
   if (fChain->GetTreeNumber() != fCurrent) {
      fCurrent = fChain->GetTreeNumber();
      Notify();
   }
   return centry;
}

void fluxClass::Init(TTree *tree)
{
   // The Init() function is called when the selector needs to initialize
   // a new tree or chain. Typically here the branch addresses and branch
   // pointers of the tree will be set.
   // It is normally not necessary to make changes to the generated
   // code, but the routine can be extended by the user if needed.
   // Init() will be called many times when running on PROOF
   // (once per file to be processed).

   // Set object pointer
   hitn = 0;
   id = 0;
   pid = 0;
   mpid = 0;
   tid = 0;
   mtid = 0;
   otid = 0;
   trackE = 0;
   totEdep = 0;
   avg_x = 0;
   avg_y = 0;
   avg_z = 0;
   avg_lx = 0;
   avg_ly = 0;
   avg_lz = 0;
   px = 0;
   py = 0;
   pz = 0;
   vx = 0;
   vy = 0;
   vz = 0;
   mvx = 0;
   mvy = 0;
   mvz = 0;
   avg_t = 0;
   nsteps = 0;
   procID = 0;
   // Set branch addresses and branch pointers
   if (!tree) return;
   fChain = tree;
   fCurrent = -1;
   fChain->SetMakeClass(1);

   fChain->SetBranchAddress("hitn", &hitn, &b_hitn);
   fChain->SetBranchAddress("id", &id, &b_id);
   fChain->SetBranchAddress("pid", &pid, &b_pid);
   fChain->SetBranchAddress("mpid", &mpid, &b_mpid);
   fChain->SetBranchAddress("tid", &tid, &b_tid);
   fChain->SetBranchAddress("mtid", &mtid, &b_mtid);
   fChain->SetBranchAddress("otid", &otid, &b_otid);
   fChain->SetBranchAddress("trackE", &trackE, &b_trackE);
   fChain->SetBranchAddress("totEdep", &totEdep, &b_totEdep);
   fChain->SetBranchAddress("avg_x", &avg_x, &b_avg_x);
   fChain->SetBranchAddress("avg_y", &avg_y, &b_avg_y);
   fChain->SetBranchAddress("avg_z", &avg_z, &b_avg_z);
   fChain->SetBranchAddress("avg_lx", &avg_lx, &b_avg_lx);
   fChain->SetBranchAddress("avg_ly", &avg_ly, &b_avg_ly);
   fChain->SetBranchAddress("avg_lz", &avg_lz, &b_avg_lz);
   fChain->SetBranchAddress("px", &px, &b_px);
   fChain->SetBranchAddress("py", &py, &b_py);
   fChain->SetBranchAddress("pz", &pz, &b_pz);
   fChain->SetBranchAddress("vx", &vx, &b_vx);
   fChain->SetBranchAddress("vy", &vy, &b_vy);
   fChain->SetBranchAddress("vz", &vz, &b_vz);
   fChain->SetBranchAddress("mvx", &mvx, &b_mvx);
   fChain->SetBranchAddress("mvy", &mvy, &b_mvy);
   fChain->SetBranchAddress("mvz", &mvz, &b_mvz);
   fChain->SetBranchAddress("avg_t", &avg_t, &b_avg_t);
   fChain->SetBranchAddress("nsteps", &nsteps, &b_nsteps);
   fChain->SetBranchAddress("procID", &procID, &b_procID);
   Notify();
}

Bool_t fluxClass::Notify()
{
   // The Notify() function is called when a new file is opened. This
   // can be either for a new TTree in a TChain or when when a new TTree
   // is started when using PROOF. It is normally not necessary to make changes
   // to the generated code, but the routine can be extended by the
   // user if needed. The return value is currently not used.

   return kTRUE;
}

void fluxClass::Show(Long64_t entry)
{
// Print contents of entry.
// If entry is not specified, print current entry
   if (!fChain) return;
   fChain->Show(entry);
}
Int_t fluxClass::Cut(Long64_t entry)
{
// This function may be called from Loop.
// returns  1 if entry is accepted.
// returns -1 otherwise.
   return 1;
}
#endif // #ifdef fluxClass_cxx
