void test1(){
	TH1F * num = new TH1F("num", "numeratore", 3, 0, 3);
	TH1F * den = new TH1F("den", "denominatore", 3, 0, 3);

	double dati1[] = {0.7, 0.9, 1.4, 2.3, 2.7, 1.1, 1.15, 0.03};
	double dati2[] = {0.2, 1.9, 1.4, 1.3, 2.9};

	for (int i=0; i<8; i++) {
		num->Fill(dati1[i]);
	}
	for (int i=0; i<5; i++) {
		den->Fill(dati2[i]);
	}


	TH1F * rapporto = (TH1F*) num->Clone("rapporto");
	rapporto->Divide(den);
	rapporto->SetTitle("rapporto fra i due");

	TCanvas * c = new TCanvas();

	c->Divide(1,3);

	c->cd(1);
	num->Draw();

	c->cd(2);
	den->Draw();

	c->cd(3);
	rapporto->Draw();
//	num->Fill()

}

void test2(){

	// Flusso
	TH1F * tonino = new TH1F("tonino", "tonino", 10, 0, 1);
	tonino->SetBinContent(1,100);
	tonino->SetBinContent(2,200);
	tonino->SetBinContent(3,1);
	tonino->SetBinContent(4,300);
	tonino->SetBinContent(5,500);
	tonino->SetBinContent(6,500);
	tonino->SetBinContent(7,300);
	tonino->SetBinContent(8,250);
	tonino->SetBinContent(9,200);
	tonino->SetBinContent(10,100);
	
	// Efficiency test

	TRandom *r =new TRandom(333);
	TH1F * num = new TH1F("num", "numeratore", 10, 0, 1);
	TH1F * den = new TH1F("den", "denominatore", 10, 0, 1);


	TH1F * num_w = new TH1F("num_w", "numeratore pes", 10, 0, 1);
	TH1F * den_w = new TH1F("den_w", "denominatore pes", 10, 0, 1);



	for (int i=0;i<100000 ; i++) {

		// energia
		Double_t ene = r->Rndm(33);

		// numero casuale per efficienza
		Double_t nowr = r->Rndm();

		Double_t peso = tonino->GetBinContent(int(ene*10)+1);

		den->Fill(ene);
		den_w->Fill(ene, peso);

		if (ene>0.75) {
			if (nowr<0.8) {
				num->Fill(ene);
				num_w->Fill(ene, peso);
			}
		}
		else if (ene>0.5) {
			if (nowr<0.5){
				num->Fill(ene);
				num_w->Fill(ene, peso);
			}
		}
		else {
			if (nowr<0.3) {
				num->Fill(ene);
				num_w->Fill(ene, peso);
			}
		}

	}

	TH1F * rapporto = (TH1F*) num->Clone("rapporto");
	rapporto->Divide(den);
	rapporto->SetTitle("rapporto fra i due");

	TH1F * rapporto_w = (TH1F*) num_w->Clone("rapporto_w");
	rapporto_w->Divide(den_w);
	rapporto_w->SetTitle("rapporto fra i due pesati");
	rapporto_w->SetLineColor(kRed);
	TCanvas * c = new TCanvas("c","c", 800,800);

	c->Divide(1,3);

	c->cd(1);
	den->Draw();

	c->cd(2);
	num->Draw();

	c->cd(3);
	rapporto->Draw();




	// Tonino
	TH1F * moltipl = (TH1F*) rapporto->Clone("moltipl");
	moltipl->Multiply(tonino);
	moltipl->SetTitle("tonino moltipl per efficienza");
	TCanvas * c2 = new TCanvas("c2","c2", 800,800);
	c2->Divide(1,2);
	c2->cd(1);
	tonino->Draw();
	c2->cd(2);
	moltipl->Draw();

	TCanvas * c3 = new TCanvas("c3","c3", 800,800);

	c3->Divide(1,3);

	c3->cd(1);
	den_w->Draw("HIST");

	c3->cd(2);
	num_w->Draw("HIST");

	c3->cd(3);
	rapporto_w->Draw("HIST");


	TCanvas * c4 = new TCanvas("c4","c4", 800,800);
	moltipl->DrawNormalized();

	rapporto_w->DrawNormalized("HIST, same");
}

void test_divide(){
	test2();
}
