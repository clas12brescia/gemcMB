void do_plots(string inputFile="../Output/Sort_Dump_E0-400MeV_veto20cm.root"){

	TFile * f = new TFile(inputFile.c_str());

	// get histos
	
	TH1D* Gen_Ek;
	
	TH1D* Gen_Ek_lAr;
	TH1D* Gen_Ek_lAr_binT;

	TH1D* Gen_Ek_det;
	TH1D* Gen_Ek_det_binT;

	TH1D* NFlux;
    
	Gen_Ek = (TH1D *) f->Get(Form("Gen_Ek"));
		
	Gen_Ek_det = (TH1D *) f->Get(Form("Gen_Ek_det"));
	Gen_Ek_det_binT = (TH1D *) f->Get(Form("Gen_Ek_det_binT"));	
	
	Gen_Ek_lAr = (TH1D *) f->Get(Form("Gen_Ek_lAr"));
	Gen_Ek_lAr_binT = (TH1D *) f->Get(Form("Gen_Ek_lAr_binT"));	

	NFlux = (TH1D *) f->Get(Form("NFlux"));

	TH1D *Eff = (TH1D *)Gen_Ek_lAr_binT->Clone("Eff");	
	TH1D *Eff_w = (TH1D *)Eff->Clone("Eff_w");	

	TCanvas * c = new TCanvas("c", "c", 1000, 600);

		NFlux->Draw("HIST");
		NFlux->Scale(0.2);
		gPad->SetLogx();
		gPad->SetLogy();

	TCanvas * c1 = new TCanvas("c1", "c1", 1000, 600);
		c1->Divide(1,3);
		c1->cd(1);
			Gen_Ek->SetLineWidth(2);
			Gen_Ek->SetLabelSize(0.06,"xy");
			Gen_Ek->SetTitleSize(0.05,"xy");
			Gen_Ek->SetTitle("Kinetic Energy of generated neutrons");
			Gen_Ek->SetLineColor(kOrange);
			Gen_Ek->Draw("HIST");
	    	//gPad->SetLogx();
			//gPad->SetLogy();

		c1->cd(2);
			Gen_Ek_det->SetLineWidth(2);
			Gen_Ek_det->SetLabelSize(0.06,"xy");
			Gen_Ek_det->SetTitleSize(0.05,"xy");
			Gen_Ek_det->SetTitle("Kinetic Energy of impinging neutrons");
			Gen_Ek_det->SetLineColor(kBlack);
			Gen_Ek_det->Draw("HIST,same");

		c1->cd(3);
			Gen_Ek_lAr->SetLineWidth(2);
			Gen_Ek_lAr->SetTitleSize(0.05,"xy");
			Gen_Ek_lAr->SetLabelSize(0.06,"xy");
			Gen_Ek_lAr->SetTitle("Kinetic Energy of neutrons with 10<Edep<100 keV");
			Gen_Ek_lAr->SetLineColor(kRed);
			Gen_Ek_lAr->Draw("HIST");


	
	cout<<"Gen= "<<Gen_Ek->Integral()<<endl;	

	cout<<"Gen det= "<< Gen_Ek_det_binT->Integral(1,100)<<endl;
	cout<<"Gen lAr2= "<< Gen_Ek_lAr_binT->Integral(1,100)<<endl;
	cout<<"Gen det= "<< Gen_Ek_det_binT->Integral(101,110)<<endl;
	cout<<"Gen lAr2= "<< Gen_Ek_lAr_binT->Integral(101,110)<<endl;
	cout<<"Gen det= "<< Gen_Ek_det_binT->Integral(111,120)<<endl;
	cout<<"Gen lAr2= "<< Gen_Ek_lAr_binT->Integral(111,120)<<endl;
	cout<<"Gen det= "<< Gen_Ek_det_binT->Integral(121,130)<<endl;
	cout<<"Gen lAr2= "<< Gen_Ek_lAr_binT->Integral(121,130)<<endl;
	cout<<"Gen det= "<< Gen_Ek_det_binT->Integral(131,230)<<endl;
	cout<<"Gen lAr2= "<< Gen_Ek_lAr_binT->Integral(131,230)<<endl;
	cout<<"Gen det= "<< Gen_Ek_det_binT->Integral(231,430)<<endl;
	cout<<"Gen lAr2= "<< Gen_Ek_lAr_binT->Integral(231,430)<<endl;

    
	Eff->Divide(Gen_Ek_det_binT);
	Eff_w->Multiply(Eff,NFlux);
	

	cout<< "eff= "<<Eff->Integral(1,100)<<endl;
	cout<< "eff= "<<Eff->Integral(101,110)<<endl;

	cout<< Eff_w->Integral()<<endl;
	cout<< "Nflux"<<NFlux->Integral(1,100)<<endl;
	cout<< "Nflux"<<NFlux->Integral(101,110)<<endl;
	cout<< "Nflux"<<NFlux->Integral(111,120)<<endl;
	cout<< "Nflux"<<NFlux->Integral(121,130)<<endl;
	cout<< "Nflux"<<NFlux->Integral(131,230)<<endl;
	cout<< "Nflux"<<NFlux->Integral(231,430)<<endl;


    Eff->SetLineWidth(2);
	Eff->SetLineColor(kBlack);
		
	 	for (int i=1; i<Eff->GetNbinsX()+1; i++){
	 		if (Gen_Ek_lAr_binT->GetBinContent(i)!=0 || (Gen_Ek_det_binT->GetBinContent(i))!=0){
	 			double Eff_err = sqrt(1/(Gen_Ek_lAr_binT->GetBinContent(i))+1/(Gen_Ek_det_binT->GetBinContent(i)))*(Eff->GetBinContent(i));
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
		gPad->SetLogx();
		gPad->SetLogy();

		c3->cd(2);
		Eff_w->SetTitle("Efficiency weighted for NFlux");
		Eff_w->SetLineWidth(2);
		Eff_w->SetLineColor(kBlue);
		Eff_w->Draw("HIST,E1");

		cout<<"Integral(0,99) = "<< Eff_w->Integral(1,100)<<endl;
		cout<<"Integral(100,109) = "<< Eff_w->Integral(101,110)<<endl;
		cout<<"Integral(110,119) = "<< Eff_w->Integral(111,120)<<endl;
		cout<<"Integral(120,129) = "<< Eff_w->Integral(121,130)<<endl;
		cout<<"Integral(130,229) = "<< Eff_w->Integral(131,230)<<endl;
		cout<<"Integral(230,429) = "<< Eff_w->Integral(231,430)<<endl;
		
		gPad->SetLogx();
		gPad->SetLogy();


return;
}