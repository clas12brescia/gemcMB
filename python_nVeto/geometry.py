from gemc_api_geometry import MyDetector, print_det, init_geom_file


def make_box(configuration):
    # Make a box
    my_box = MyDetector(
        name = "my_box", 
        mother = "root", 
        pos="-5*cm 0*cm -5*cm",
        type="Box", 
        dimensions="10*cm 20*cm 15*cm", 
        material="scintillator",
        color = "00FFFF1",  
        style = 1,  # 0 is wireframe, 1 is solid 
        visible = 1 # 0 is invisible, 1 is visible
        )

    print_det(configuration, my_box)


def make_geometry(configuration):

    init_geom_file(configuration)       #  Overwrites any existing geometry file and starts with an empty file ready to append detectors




    make_box(configuration)

    print("Geometry done.")
