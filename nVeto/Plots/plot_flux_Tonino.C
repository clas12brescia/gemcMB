void plot_flux_Tonino(){

	TGraph * temp = new TGraph("../tabelle_corrette/bin_flux_table.dat");

	int tot_left_edge_bins = temp->GetN();
	double * bin_content = temp->GetY();
	double * bin_left_edge = temp->GetX();

	TH1F *  histo = new TH1F("histo", "histo",tot_left_edge_bins-1, bin_left_edge);


	for(int i=0; i<tot_left_edge_bins; i++) {
	
		histo->Fill(bin_left_edge[i], bin_content[i]);
	}

	TCanvas * c = new TCanvas("c", "c", 1000, 800);
	c->SetLogy();
	c->SetLogx();
	histo->Draw("HIST");
}