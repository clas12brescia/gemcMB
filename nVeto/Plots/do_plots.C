void do_plots(string inputFile="dump_0_465MeV_0.1Pb+0.1Gd+6v+150Pbup+fl4+cosmics_thr1000keV"){
	
	string filename("/mnt/project_mnt/jlab12/fiber7_fs/gosta/Output/Sort_" + inputFile + ".root");

	TFile * f = new TFile(filename.c_str());

	// get histos
	
	TH1D* Gen_Ek;
 	TH1D* Gen_Ek_binT;
	TH1D* Gen_Ek_crs_binT;
	TH1D* NFlux;
    
	Gen_Ek = (TH1D *) f->Get(Form("Gen_Ek"));
 	Gen_Ek_binT = (TH1D *) f->Get(Form("Gen_Ek_binT"));
	Gen_Ek_crs_binT = (TH1D *) f->Get(Form("Gen_Ek_crs_binT"));	

	NFlux = (TH1D *) f->Get(Form("NFlux"));

	TH1D *Eff = (TH1D *)Gen_Ek_crs_binT->Clone("Eff");	
	TH1D *Eff_w = (TH1D *)Eff->Clone("Eff_w");	

	TCanvas * c = new TCanvas("c", "c", 1000, 600);

		NFlux->Draw("HIST");
		//NFlux->Scale(0.2);
	//	gPad->SetLogx();
	//	gPad->SetLogy();

	TCanvas * c1 = new TCanvas("c1", "c1", 1000, 600);
		c1->Divide(1,2);
		c1->cd(1);
			Gen_Ek_binT->SetLineWidth(2);
			Gen_Ek_binT->SetLabelSize(0.06,"xy");
			Gen_Ek_binT->SetTitleSize(0.05,"xy");
			Gen_Ek_binT->SetTitle("Kinetic Energy of generated neutrons");
			Gen_Ek_binT->SetLineColor(kOrange);
			Gen_Ek_binT->Draw("HIST");
	    	//gPad->SetLogx();
			//gPad->SetLogy();

		c1->cd(2);
			Gen_Ek_crs_binT->SetLineWidth(2);
			Gen_Ek_crs_binT->SetLabelSize(0.06,"xy");
			Gen_Ek_crs_binT->SetTitleSize(0.05,"xy");
			Gen_Ek_crs_binT->SetTitle("Kinetic Energy neutron with 10<Edep<200keV in crs");
			Gen_Ek_crs_binT->SetLineColor(kBlack);
			Gen_Ek_crs_binT->Draw("HIST,same");

	/*	c1->cd(3);
			Gen_Ek_lAr->SetLineWidth(2);
			Gen_Ek_lAr->SetTitleSize(0.05,"xy");
			Gen_Ek_lAr->SetLabelSize(0.06,"xy");
			Gen_Ek_lAr->SetTitle("Kinetic Energy of neutrons with 10<Edep<100 keV");
			Gen_Ek_lAr->SetLineColor(kRed);
			Gen_Ek_lAr->Draw("HIST");
*/

	
	cout<<"Gen= "<<Gen_Ek->Integral()<<endl;	
    
	Eff->Divide(Gen_Ek_binT);
	Eff_w->Multiply(Eff,NFlux);
	
 cout<<"integral 0-11 MeV = "<< Gen_Ek_crs_binT->Integral(1,6)<<endl;
 cout<<"integral 11-50 MeV = "<< Gen_Ek_crs_binT->Integral(7,23)<<endl;
 cout<<"integral 50-150 MeV = "<< Gen_Ek_crs_binT->Integral(24,67)<<endl;
 cout<<"integral 150-250 MeV = "<< Gen_Ek_crs_binT->Integral(68,111)<<endl;
 cout<<"integral 250-350 MeV = "<< Gen_Ek_crs_binT->Integral(112,155)<<endl;
 cout<<"integral 350-450 MeV = "<< Gen_Ek_crs_binT->Integral(156,201)<<endl;
 cout<<"integral  = "<< Gen_Ek_crs_binT->Integral()<<endl;
 
 cout<<"integral 0-11 MeV = "<< Eff_w->Integral(1,6)<<endl;
 cout<<"integral 11-50 MeV = "<< Eff_w->Integral(7,23)<<endl;
 cout<<"integral 50-150 MeV = "<< Eff_w->Integral(24,67)<<endl;
 cout<<"integral 150-250 MeV = "<< Eff_w->Integral(68,111)<<endl;
 cout<<"integral 250-350 MeV = "<< Eff_w->Integral(112,155)<<endl;
 cout<<"integral 350-450 MeV = "<< Eff_w->Integral(156,201)<<endl;
 cout<<"integral  = "<< Eff_w->Integral()<<endl;
 
 cout<<"integral 0-11 MeV = "<< NFlux->Integral(1,6)<<endl;
 cout<<"integral 11-50 MeV = "<< NFlux->Integral(7,23)<<endl;
 cout<<"integral 50-150 MeV = "<< NFlux->Integral(24,67)<<endl;
 cout<<"integral 150-250 MeV = "<< NFlux->Integral(68,111)<<endl;
 cout<<"integral 250-350 MeV = "<< NFlux->Integral(112,155)<<endl;
 cout<<"integral 350-450 MeV = "<< NFlux->Integral(156,201)<<endl;
	cout<< "Nflux"<<NFlux->Integral()<<endl;

   // Eff->SetLineWidth(2);
	//Eff->SetLineColor(kBlack);
		
	 	for (int i=1; i<Eff->GetNbinsX()+1; i++){
	 		if (Gen_Ek_crs_binT->GetBinContent(i)!=0 ){
	 			double Eff_err = sqrt(1/(Gen_Ek_crs_binT->GetBinContent(i))+1/(Gen_Ek_binT->GetBinContent(i)))*(Eff->GetBinContent(i));
	 			Eff->SetBinError(i,Eff_err);
	 			double Eff_w_err = sqrt((pow(Eff_err,2)*NFlux->GetBinContent(i) + pow(Eff->GetBinContent(i),2))*NFlux->GetBinContent(i));
	 			//cout<<"Eff_w_err= "<<Eff_w_err<<endl;
	 			//cout<<"Eff_w= "<<Eff_w->GetBinContent(i)<<endl;
	 			Eff_w->SetBinError(i,Eff_w_err);
	 		}
	 	}

	TCanvas * c3 = new TCanvas("c3", "c3", 1000, 600);
	c3->Divide(1,2);
		c3->cd(1);

	 	Eff->SetMarkerColor(4);
	 	Eff->SetTitle("Efficiency");
    Eff->Draw("HIST,E1");
		//Eff->Draw("HIST,E1");
		
		c3->cd(2);
		Eff_w->SetTitle("Efficiency weighted for NFlux");
		Eff_w->SetLineWidth(2);
		Eff_w->SetLineColor(kBlue);
		Eff_w->Draw("HIST,E1");
		
		cout<<"Integral = "<< Eff_w->Integral()<<endl;
		

return;
}