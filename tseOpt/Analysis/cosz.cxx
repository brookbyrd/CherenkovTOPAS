void cosz(){

		
	  //TFile *f = new TFile("topas4M_151540.root");
	  TFile *f = new TFile("topasAPgn.root");
		TTree *t1 = (TTree*)f->Get("PVCPhaseSpacePlane");
		float x,y,z,cx,cy,energy,w,flag1,flag2;
		float iniKE,vx,vy,vz,inipx,inipy,inipz;
    char process;
		int pid;

		t1->SetBranchAddress("Position_X__cm_", &x);
		t1->SetBranchAddress("Position_Y__cm_", &y);
		t1->SetBranchAddress("Position_Z__cm_", &z);
		t1->SetBranchAddress("Direction_Cosine_X", &cx);
		t1->SetBranchAddress("Direction_Cosine_Y", &cy);
		t1->SetBranchAddress("Energy__MeV_", &energy);
		t1->SetBranchAddress("Particle_Type__in_PDG_Format_", &pid);
		t1->SetBranchAddress("Creator_Process_Name", &process);
		t1->SetBranchAddress("Initial_Kinetic_Energy__MeV_", &iniKE);
		t1->SetBranchAddress("Vertex_Position_X__cm_", &vx);
		t1->SetBranchAddress("Vertex_Position_Y__cm_", &vy);
		t1->SetBranchAddress("Vertex_Position_Z__cm_", &vz);
		

		TH2F *hxy = new TH2F("hxy", "Optical Photons at PVC Surface ", 30, -60, 60, 60, -132, 108);
		TH2F *hxz = new TH2F("hxz", "Optical Photons at PVC Surface", 150, 300, 450, 120, -60, 60);
		TH2F *hyz = new TH2F("hyz", "Optical Photons at PVC Surface", 150, 300, 450, 240, -132, 108);
		//TH2F *hvxy = new TH2F("h_vx_vy", "Vertex of particles that reach phantum surface", 60, -30, 30, 60, -30, 30);
		TH2F *hE = new TH2F("h_E", " ", 240, 0, 12, 240, 0, 12);
		TH2F *hvxz = new TH2F("hvxvz", "Vertex of Optical Photons", 150, 300, 450, 120, -60, 60);
		TH2F *hvyz = new TH2F("hvyvz", "Vertex of Optical Photons", 150, 300, 450, 240, -132, 108);
		//TH2F *hez = new TH2F("h_E_vz", " ", 120, 0, 120, 24, 0, 12);
		//TH2F *hiniez = new TH2F("h_iniE_vz", " ", 120, 0, 120, 24, 0, 12);
		
		TH1F *hEini = new TH1F("h_iniE", " ", 600,  1.24, 3.10);
		TH1F *hEhit = new TH1F("h_hitE", " ", 600, 1.24, 3.10);
		TH1F *hx = new TH1F("hx", "", 24, -60, 60);
		TH1F *hy = new TH1F("hy", "", 48, -132, 108);

		TH1F *hcosz = new TH1F("cosZ", "", 100, -1, 1);
		TH1F *htheta = new TH1F("theta", "", 100, 0, 180);
		TH1F *hphi = new TH1F("phi", "", 100, 0, 360);
		TH1F *hcosphi = new TH1F("cosPhi", "", 100, -1, 1);
		TH1F *hsinphi = new TH1F("sinPhi", "", 100, -1, 1);
		TH1F *hcosz0 = new TH1F("cosZ_center", "", 100, -1, 1);
		TH1F *htheta0 = new TH1F("theta_center", "", 100, 0, 180);
		TH1F *hphi0 = new TH1F("phi_center", "", 100, 0, 360);
		TH1F *hcosphi0 = new TH1F("cosPhi_center", "", 100, -1, 1);
		TH1F *hsinphi0 = new TH1F("sinPhi_center", "", 100, -1, 1);
		TH2F *hcsphi = new TH2F("cosPhi_sinPhi", " ", 100, -1, 1, 100, -1, 1);
		TH2F *hthephi = new TH2F("theta_phi", " ", 100, 0, 360, 100, 0, 90);

    int nentries = (int)t1->GetEntries();

		float disD = -500.;
		float detD = 5.;
    float posX, posY;

		float cz = 0;
    float cosphi, sinphi, theta, phi;
		
		for(int i=0; i<nentries; i++){
				t1->GetEntry(i);
//				cout << x << "\t" << y << "\t" << z << "\t" << energy << "\t"<<iniKE<< "\t"<<vx<<"\t"<<vy<<"\t"<<vz<<endl;
//				
//				if(process=="Cerenkov"){
//          if((cy >= cos(theta2)) && (cy <= cos(theta1))) {
/*
				posX = x + cx*disD/sqrt(1-cx*cx-cy*cy);
				posY = y + cy*disD/sqrt(1-cx*cx-cy*cy);
				if( (posX >= -1.*detD && posX <= detD)&&(posY >= -1.*detD && posY <= detD) ) {
  */         
			      cz = sqrt(1-cx*cx-cy*cy);
						theta = 180*acos(cz)/TMath::Pi();
						cosphi = cx/sin(acos(cz));
            sinphi = cy/sin(acos(cz));
            if(sinphi>=0){
							phi = 180*acos(cosphi)/TMath::Pi();
						}
						if(sinphi<0){
							phi = 180/TMath::Pi()*(2*TMath::Pi()-acos(cosphi));
						}
						//			      cout<< cz <<"\t" << cosphi << "\t" << sinphi<<endl;
/*
*/
				//if( x>=-2.5&&x<=2.5&&y>=97.5&&y<=102.5){
				if( x>=-2.5&&x<=2.5&&y>=-102.5&&y<=-97.5){
//  	      hcsphi->Fill(cosphi, sinphi);
//						hcosz->Fill(cz);
						htheta->Fill(theta);
  	        hphi->Fill(phi);
 //           hthephi->Fill(phi, theta);
//	         hcosphi->Fill(cosphi);
	//		      hsinphi->Fill(sinphi);
//          hxy->Fill(x,y);
//				  hx->Fill(x);
//					hy->Fill(y);
//					hxz->Fill(z,x);
//					hyz->Fill(z,y);
//					hEini->Fill(iniKE);
//					hEhit->Fill(energy);
//					hvxz->Fill(vz,vx);
//					hvyz->Fill(vz,vy);
//					hez->Fill(vz,energy);
//					hiniez->Fill(vz,iniKE);
			  }		

						if( x>=-2.5&&x<=2.5&&y>=-2.5&&y<=2.5){
//						hcosz0->Fill(cz);
						  htheta0->Fill(theta);
			        hphi0->Fill(phi);
//			      hcosphi0->Fill(cosphi);
//			      hsinphi0->Fill(sinphi);
				   
				}
	
				}

		TCanvas *c4 = new TCanvas("c4","c4",700,1000);
/* 
		c4->Divide(1,3);
		c4->cd(1);
		htheta->Scale(1/htheta->Integral());
    htheta->Draw();
		c4->cd(2);
		hphi->Scale(1/hphi->Integral());
    hphi->Draw();
		c4->cd(3);
		hthephi->Scale(1/hthephi->Integral());
    hthephi->Draw();
	*/
		
		
		c4->Divide(1,2);
		c4->cd(1);
		htheta->Scale(1/htheta->Integral());
    htheta->Draw();
		htheta0->Scale(1/htheta0->Integral());
    htheta0->Draw("same");
		htheta0->SetLineColor(kRed);
		c4->cd(2);
		hphi->Scale(1/hphi->Integral());
		hphi->Draw();
		hphi0->Scale(1/hphi0->Integral());
		hphi0->Draw("same");
		hphi0->SetLineColor(kRed);
    
		/*
		hcosz->Scale(1/hcosz->Integral());
    hcosz->Draw();
		hcosz0->Scale(1/hcosz0->Integral());
    hcosz0->Draw("same");
		hcosz0->SetLineColor(kRed);
		*/
		/*
		c4->cd(2);
		hcosphi->Scale(1/hcosphi->Integral());
		hcosphi->Draw();
		hcosphi0->Scale(1/hcosphi0->Integral());
		hcosphi0->Draw("same");
		hcosphi0->SetLineColor(kRed);
    c4->cd(3);
		hsinphi->Scale(1/hsinphi->Integral());
		hsinphi->Draw();
		hsinphi0->Scale(1/hsinphi0->Integral());
		hsinphi0->Draw("same");
		hsinphi0->SetLineColor(kRed);
   */
 //   hcsphi->Draw();
/*
		TCanvas *c4 = new TCanvas("c4","c4",700,1000);
    hxy->Draw("CONT4Z");
		hxy->SetStats(0);
		gStyle->SetPalette(kLightTemperature);
    hxy->GetXaxis()->SetTitle("X (Lateral) (cm) ");
    hxy->GetXaxis()->CenterTitle();
		hxy->GetXaxis()->SetTitleOffset(1.3);
    hxy->GetYaxis()->SetTitle("Y (Vertical) (cm)");
    hxy->GetYaxis()->CenterTitle();
		hxy->GetYaxis()->SetTitleOffset(1.3);
*/
		}
