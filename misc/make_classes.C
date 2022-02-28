/*
	Valerio, Feb 28 2022

	Run once to generate the classes files (*.C, *.h) 
	and ROOT .d and .pcm files so that in a ROOT
	macro the tree classes can be imported and used.

	Clean everything with:
	
	rm -v *.d *.so *.h *.pcm *Class.C
*/

void make_classes(string inputRootFile = "out.root"){

	TFile * f = new TFile(inputRootFile.c_str());

	// add here the tree names
	string trees[] = {"veto", "flux", "generated"};



	for (auto s :trees) {
		TTree * t = (TTree *) f->Get(s.c_str());
		string className = s + "Class" ;
		string macroName = className + ".C+" ;
		t->MakeClass(className.c_str());
		gROOT->LoadMacro(macroName.c_str());
		delete t;
	}

	// just a closing message
	int ntrees = sizeof(trees)/sizeof(trees[0]);
	cout << "\n... classes for "<<ntrees<<" trees have been created: ";
	for (int i=0; i<ntrees; i++) {
		cout << "("<<i+1<<") "<<trees[i]<< " " ;
	}
	cout << endl;
	return;
	
}