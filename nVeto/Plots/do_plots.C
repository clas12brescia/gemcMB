void do_plots(string inputFile="../Output/Sort_E0-400MeV_flatNDistr.root"){

	TFile * f = new TFile(inputFile.c_str());

	// get histos
	TH1D* h;
	TH1D* h_w;
	TH1D* lAr_totEdep_B_2_w;
	TH1D* Gen_Ek_lAr2;
	TH1D* Gen_Ek;
	TH1D* Gen_Ek_lAr2_w;
	TH1D* Gen_Ek_w;


	Gen_Ek_lAr2 = (TH1D *) f->Get(Form("Gen_Ek_lAr2"));
	Gen_Ek = (TH1D *) f->Get(Form("Gen_Ek"));
	Gen_Ek_lAr2_w = (TH1D *) f->Get(Form("Gen_Ek_lAr2_w"));
	Gen_Ek_w = (TH1D *) f->Get(Form("Gen_Ek_w"));

	TH1D *Eff = (TH1D *)Gen_Ek_lAr2->Clone("Eff");	
	TH1D *Eff_w = (TH1D *)Gen_Ek_lAr2_w->Clone("Eff_w");	
	
		

/*	TCanvas * c = new TCanvas("c", "c", 1000, 600);

		c->cd();
		h_w->SetLineWidth(2);
		h_w->SetLineColor(kRed);
		h_w->DrawNormalized("HIST");
		gPad->SetLogx();
		gPad->SetLogy();

		h->SetLineWidth(2);
		h->SetLineColor(kBlue);
		h->DrawNormalized("HIST, same");
*/
	TCanvas * c1 = new TCanvas("c1", "c1", 1000, 600);

		c1->cd();
		Gen_Ek->SetLineWidth(2);
		Gen_Ek->SetLineColor(kBlue);
		Gen_Ek->Draw("HIST");
		
		Gen_Ek_lAr2->SetLineWidth(2);
		Gen_Ek_lAr2->SetLineColor(kRed);
		Gen_Ek_lAr2->Draw("HIST,same");

	cout<< Gen_Ek->Integral()<<endl;	
	cout<< Gen_Ek_lAr2->Integral()<<endl;

	TCanvas * c2 = new TCanvas("c2", "c2", 1000, 600);

		c2->cd();
		Gen_Ek_w->SetLineWidth(2);
		Gen_Ek_w->SetLineColor(kBlack);
		Gen_Ek_w->Draw("HIST");
		
		Gen_Ek_lAr2_w->SetLineWidth(2);
		Gen_Ek_lAr2_w->SetLineColor(kOrange);
		Gen_Ek_lAr2_w->Draw("HIST,same");

    cout<< Gen_Ek->Integral(10,200)<<endl;	
	cout<< Gen_Ek_lAr2->Integral(10,200)<<endl;
	cout<< Gen_Ek_w->Integral(10,200)<<endl;	
	cout<< Gen_Ek_lAr2_w->Integral(10,200)<<endl;


	Eff->Divide(Gen_Ek);
	Eff_w->Divide(Gen_Ek_w);
	
	TCanvas * c3 = new TCanvas("c3", "c3", 1000, 600);

		c3->cd();
		Eff->SetLineWidth(2);
		Eff->SetLineColor(kBlue);
		Eff->Draw("HIST");

		Eff_w->SetLineWidth(2);
		Eff_w->SetLineColor(kRed);
		Eff_w->Draw("HIST,same");


return;
}