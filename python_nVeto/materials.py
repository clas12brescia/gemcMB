from gemc_api_materials import MyMaterial, print_mat, init_materials_file


def define_materials(configuration):
    

    init_materials_file(configuration)

    # Scintillator
    scintillator = MyMaterial(
        name = "scintillator", 
        description = "nVeto scintillator material", 
        density = "1.032", 
        ncomponents = "2",  
        components = "C 9 H 10")

    print_mat(configuration, scintillator);