def generate_box_code(box_index, sliceLocation):
    box_index = "{:02}".format(int(box_index))
    code = f"""
###################################################
# Box {box_index}
###################################################

s:Ge/MyBox{box_index}/Type     = "TsBox"
s:Ge/MyBox{box_index}/Material = "MyWater"
s:Ge/MyBox{box_index}/Parent   = "World"
d:Ge/MyBox{box_index}/HLX      = 0.1 m
d:Ge/MyBox{box_index}/HLY      = 0.1 m
d:Ge/MyBox{box_index}/HLZ      = 0.001 m
d:Ge/MyBox{box_index}/TransX   = 0 m
d:Ge/MyBox{box_index}/TransY   = 0 m
d:Ge/MyBox{box_index}/TransZ   = {round(sliceLocation,3)} m
s:Ge/MyBox{box_index}/Color    = "blue"
s:Ge/MyBox{box_index}/DrawingStyle = "WireFrame"
"""

    return code

def generate_scorer_code(box_index):
    box_index = "{:02}".format(int(box_index))
    code = f"""
    
###################################################
# Scorer {box_index}
###################################################

# Dose Scoring
s:Sc/Dose{box_index}/Parent     = "World"
s:Sc/Dose{box_index}/Quantity       = "DoseToMedium"
s:Sc/Dose{box_index}/Component      = "MyBox{box_index}"
#s:Sc/Dose{box_index}/Surface        = "MyBox{box_index}/ZPlusSurface"
i:Sc/Dose{box_index}/XBins          = 30
i:Sc/Dose{box_index}/YBins          = 30
i:Sc/Dose{box_index}/ZBins          = 1
s:Sc/Dose{box_index}/OutputFolder   = "/Applications/topas/OpticalPhantomExperiment/Output"
s:Sc/Dose{box_index}/OutputFile     = "/Applications/topas/OpticalPhantomExperiment/Output/doseout_myplane_slice{box_index}"
b:Sc/Dose{box_index}/OutputToConsole           = "False"
s:Sc/Dose{box_index}/IfOutputFileAlreadyExists = "Overwrite"
sv:Sc/Dose{box_index}/Report        = 2 "mean" "standard_deviation"
s:Sc/Dose{box_index}/OutputType     = "DICOM"
b:Sc/Dose{box_index}/DICOMOutput32BitsPerPixel = "True"

# Electron origin scoring
s:Sc/ElectronScorer{box_index}/Parent           = "World"
s:Sc/ElectronScorer{box_index}/Quantity           = "OriginCount"
s:Sc/ElectronScorer{box_index}/Component          = "MyBox{box_index}"
#s:Sc/ElectronScorer{box_index}/Surface            = "MyBox{box_index}/ZPlusSurface"
i:Sc/ElectronScorer{box_index}/OutputBufferSize   = 1000
b:Sc/ElectronScorer{box_index}/IncludeParentID    = "True"
b:Sc/ElectronScorer{box_index}/IncludeCreatorProcess = "True"
b:Sc/ElectronScorer{box_index}/IncludeVertexInfo  = "True"
i:Sc/ElectronScorer{box_index}/XBins              = 30
i:Sc/ElectronScorer{box_index}/YBins              = 30
i:Sc/ElectronScorer{box_index}/ZBins              = 1
sv:Sc/ElectronScorer{box_index}/OnlyIncludeParticlesNamed = 1 "e-"
s:Sc/ElectronScorer{box_index}/OutputFolder       = "/Applications/topas/OpticalPhantomExperiment/Output"
s:Sc/ElectronScorer{box_index}/OutputFile         = "/Applications/topas/OpticalPhantomExperiment/Output/electrondistribution_ref_slice{box_index}"
b:Sc/ElectronScorer{box_index}/OutputToConsole    = "False"
s:Sc/ElectronScorer{box_index}/IfOutputFileAlreadyExists = "Overwrite"
s:Sc/ElectronScorer{box_index}/OutputType         = "DICOM"
b:Sc/ElectronScorer{box_index}/DICOMOutput32BitsPerPixel = "True"
s:Sc/ElectronScorer{box_index}/Color              = "green"
s:Sc/ElectronScorer{box_index}/DrawingStyle       = "WireFrame"

# Phase space scoring
s:Sc/PhaseScorer{box_index}/Parent           = "World"
s:Sc/PhaseScorer{box_index}/Component             = "MyBox{box_index}"
s:Sc/PhaseScorer{box_index}/Quantity              = "PhaseSpace"
s:Sc/PhaseScorer{box_index}/Surface               = "MyBox{box_index}/ZPlusSurface"
i:Sc/PhaseScorer{box_index}/OutputBufferSize      = 1000
b:Sc/PhaseScorer{box_index}/IncludeParentID       = "True"
b:Sc/PhaseScorer{box_index}/IncludeCreatorProcess = "True"
b:Sc/PhaseScorer{box_index}/IncludeVertexInfo     = "True"
sv:Sc/PhaseScorer{box_index}/OnlyIncludeParticlesNamed = 1 "e-"
s:Sc/PhaseScorer{box_index}/OutputFolder          = "/Applications/topas/OpticalPhantomExperiment/Output"
s:Sc/PhaseScorer{box_index}/OutputFile            = "/Applications/topas/OpticalPhantomExperiment/Output/electron_phasespace_ref_slice{box_index}"
b:Sc/PhaseScorer{box_index}/OutputToConsole       = "True"
s:Sc/PhaseScorer{box_index}/IfOutputFileAlreadyExists = "Overwrite"
s:Sc/PhaseScorer{box_index}/OutputType            = "ASCII"
i:Sc/PhaseScorer{box_index}/BounceLimit           = 1000000


"""

    return code

# Generating code for 15 different boxes
start_value = -0.002

step = 0.002
numberOfBoxes = 1
numberOfBoxes_formatted = "{:02}".format(int(numberOfBoxes))
infiniteHLZ = 0.5 # 1 meter of water
lastSliceLocation = start_value - step*(numberOfBoxes -  2) - infiniteHLZ

header = f"""includeFile = PhantomMaterials.topas
"""

infiniteMedium = f"""
###################################################
# Last Box {numberOfBoxes_formatted}

###################################################
s:Ge/MyBox{numberOfBoxes_formatted}/Type     = "TsBox"
s:Ge/MyBox{numberOfBoxes_formatted}/Material = "MyWater"
s:Ge/MyBox{numberOfBoxes_formatted}/Parent   = "World"
d:Ge/MyBox{numberOfBoxes_formatted}/HLX      = 0.1 m
d:Ge/MyBox{numberOfBoxes_formatted}/HLY      = 0.1 m
d:Ge/MyBox{numberOfBoxes_formatted}/HLZ      = {infiniteHLZ} m
d:Ge/MyBox{numberOfBoxes_formatted}/TransX   = 0 m
d:Ge/MyBox{numberOfBoxes_formatted}/TransY   = 0 m
d:Ge/MyBox{numberOfBoxes_formatted}/TransZ   = {round(lastSliceLocation,3)} m
s:Ge/MyBox{numberOfBoxes_formatted}/Color    = "blue"
s:Ge/MyBox{numberOfBoxes_formatted}/DrawingStyle = "WireFrame"
s:Ge/MyBox{numberOfBoxes_formatted}/OpticalBehavior = "SurfaceDetector"

# s:Ge/OpticalPhantom/Type = "TsCylinder"
# s:Ge/OpticalPhantom/Parent = "World"
# s:Ge/OpticalPhantom/Material = "MyWater"
# d:Ge/OpticalPhantom/RMin     = 0 cm
# d:Ge/OpticalPhantom/RMax     = 1.5 cm
# d:Ge/OpticalPhantom/SPhi     = 0.0 deg
# d:Ge/OpticalPhantom/DPhi     = 360. deg
# d:Ge/OpticalPhantom/HL       = 2.5 cm
# d:Ge/OpticalPhantom/TransX   = 0. cm
# d:Ge/OpticalPhantom/TransY   = 0. cm
# d:Ge/OpticalPhantom/TransZ   = -2.5 cm
# d:Ge/OpticalPhantom/RotX     = 0. deg
# d:Ge/OpticalPhantom/RotY     = 0. deg
# d:Ge/OpticalPhantom/RotZ     = 0. deg
# i:Ge/OpticalPhantom/RBins    = 1
# i:Ge/OpticalPhantom/ZBins    = 1
# i:Ge/OpticalPhantom/PhiBins    = 1
# s:Ge/OpticalPhantom/Color = "blue"
# s:Ge/OpticalPhantom/OpticalBehavior = "SurfaceDetector"

"""

opticalScorer = f"""
#################################################################
# Cherenkov space scoring for the first box
#################################################################

s:Sc/OpticalScorerMyBox01/Parent           = "World"
s:Sc/OpticalScorerMyBox01/Component             = "MyBox01"
s:Sc/OpticalScorerMyBox01/Quantity              = "PhaseSpace"
s:Sc/OpticalScorerMyBox01/Surface               = "MyBox01/ZPlusSurface"
i:Sc/OpticalScorerMyBox01/OutputBufferSize      = 1000
b:Sc/OpticalScorerMyBox01/IncludeParentID       = "True"
b:Sc/OpticalScorerMyBox01/IncludeCreatorProcess = "True"
b:Sc/OpticalScorerMyBox01/IncludeVertexInfo     = "True"
sv:Sc/OpticalScorerMyBox01/OnlyIncludeParticlesNamed = 1 "opticalphoton"
# d:Sc/OpticalScorerMyBox01/OnlyIncludeIfIncidentParticleKEAbove = 1.38 eV
# d:Sc/OpticalScorerMyBox01/OnlyIncludeIfIncidentParticleKEBelow = 3.1 eV
s:Sc/OpticalScorerMyBox01/OnlyIncludeParticlesGoing = "Out"
s:Sc/OpticalScorerMyBox01/OutputFolder          = "/Applications/topas/OpticalPhantomExperiment/Output"
s:Sc/OpticalScorerMyBox01/OutputFile            = "/Applications/topas/OpticalPhantomExperiment/Output/optical_phasespace_ref_slice01"
b:Sc/OpticalScorerMyBox01/OutputToConsole       = "True"
s:Sc/OpticalScorerMyBox01/IfOutputFileAlreadyExists = "Overwrite"
s:Sc/OpticalScorerMyBox01/OutputType            = "ASCII"
i:Sc/OpticalScorerMyBox01/BounceLimit           = 1000000


# Surface used to detect optical photons
s:Su/SurfaceDetector/Type                = "dielectric_dielectric"
#s:Su/SurfaceDetector/Type                = "dielectric_metal"
#s:Su/SurfaceDetector/Finish              = "polished"
s:Su/SurfaceDetector/Finish              = "ground"
#s:Su/SurfaceDetector/Model               = "unified"
s:Su/SurfaceDetector/Model               = "glisur"
dv:Su/SurfaceDetector/Efficiency/Energies   = 2 1.24 3.1 eV
uv:Su/SurfaceDetector/Efficiency/Values     = 2 1.0 1.0
dv:Su/SurfaceDetector/Reflectivity/Energies = 2 1.24 3.1 eV
uv:Su/SurfaceDetector/Reflectivity/Values   = 2 0.005 0.015


"""

# Open a file in write mode ('w')
with open('/Applications/topas/OpticalPhantomExperiment/PhantomScoring.topas', 'w') as f:
    f.write(header)
    for i in range(1, numberOfBoxes):
            sliceLocation = start_value - step*(i-1)
            f.write(generate_box_code(i, sliceLocation))
    f.write(infiniteMedium)
    f.write(opticalScorer)

# with open('/Applications/topas/OpticalPhantomExperiment/ElectronScoring.topas', 'w') as f:
#     f.write(header)
#     for i in range(1, numberOfBoxes):
#             sliceLocation = start_value - step*(i-1)
#             f.write(generate_box_code(i, sliceLocation))
#     f.write(infiniteMedium)
#     for i in range(1, numberOfBoxes):
#             f.write(generate_scorer_code(i))
