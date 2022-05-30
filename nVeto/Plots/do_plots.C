void do_plots(string inputFile="../Output/Sort_E0-400MeV_EnflatDistr.root"){

	TFile * f = new TFile(inputFile.c_str());

	// get histos
	
	TH1D* Gen_Ek;
	TH1D* Gen_Ek_binT;

	TH1D* Gen_Ek_lAr2;
	TH1D* Gen_Ek_lAr2_binT;

	TH1D* NFlux;
    
	Gen_Ek = (TH1D *) f->Get(Form("Gen_Ek"));
	Gen_Ek_binT = (TH1D *) f->Get(Form("Gen_Ek_binT"));
	
	Gen_Ek_lAr2 = (TH1D *) f->Get(Form("Gen_Ek_lAr2"));
	Gen_Ek_lAr2_binT = (TH1D *) f->Get(Form("Gen_Ek_lAr2_binT"));	
	
	NFlux = (TH1D *) f->Get(Form("NFlux"));

	TH1D *Eff = (TH1D *)Gen_Ek_lAr2_binT->Clone("Eff");	
	TH1D *Eff_w = (TH1D *)Eff->Clone("Eff_w");	

	TCanvas * c = new TCanvas("c", "c", 1000, 600);

		NFlux->Draw("HIST");
		gPad->SetLogx();
		gPad->SetLogy();


	TCanvas * c1 = new TCanvas("c1", "c1", 1000, 600);

		Gen_Ek->SetLineWidth(2);
		Gen_Ek->SetLineColor(kOrange);
		Gen_Ek->Draw("HIST,same");

TCanvas * c2 = new TCanvas("c2", "c2", 1000, 600);

		Gen_Ek_lAr2->SetLineWidth(2);
		Gen_Ek_lAr2->SetLineColor(kRed);
		Gen_Ek_lAr2->Draw("HIST,E1");

		gPad->SetLogx();
		gPad->SetLogy();


	cout<< Gen_Ek->Integral()<<endl;	
	cout<< Gen_Ek_lAr2->Integral()<<endl;
    
    
	Eff->Divide(Gen_Ek_binT);
	Eff_w->Multiply(Eff,NFlux);

	cout<< Eff->Integral()<<endl;
	cout<< Eff_w->Integral()<<endl;
	cout<< NFlux->Integral()<<endl;

	TCanvas * c3 = new TCanvas("c3", "c3", 1000, 600);

		Eff->SetLineWidth(2);
		Eff->SetLineColor(kBlack);
		Eff->Draw("HIST");

		gPad->SetLogx();
		gPad->SetLogy();

	TCanvas * c4 = new TCanvas("c4", "c4", 1000, 600);

		Eff_w->SetLineWidth(2);
		Eff_w->SetLineColor(kBlue);
		Eff_w->Draw("HIST");

		gPad->SetLogx();
		gPad->SetLogy();


return;
}