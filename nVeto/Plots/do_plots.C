void do_plots(string inputFile="../Output/Sort_E0-400MeV_flatNDistr.root"){

	TFile * f = new TFile(inputFile.c_str());

	// get histos
	TH1D * allh[6];
	TH1D * allh_w[6];
	for (int i=0; i<6; i++) {
		allh[i] = (TH1D *) f->Get(Form("lAr_totEdep_B_%d", i+1));
		allh_w[i] = (TH1D *) f->Get(Form("lAr_totEdep_B_%d_w", i+1));
	}


	TCanvas * c = new TCanvas("c", "c", 1000, 600);
	c->Divide(2,3);

	for (int i=0; i<6; i++) {
		c->cd(i+1);
		allh_w[i]->SetLineWidth(2);
		allh_w[i]->SetLineColor(kBlue);
		allh_w[i]->DrawNormalized("HIST");

		allh[i]->SetLineWidth(2);
		allh[i]->SetLineColor(kRed);
		allh[i]->DrawNormalized("HIST, same");

	}



	return;
}