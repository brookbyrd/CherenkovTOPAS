import uproot
import os
from scipy.io import savemat

Posname = 'AP'

fname = "./topas" + Posname + "gn.root"

mdict = {}
with uproot.open(fname + ":XMinusSidePhaseSpacePlane") as data:
    keys = data.keys()
    keys.remove("Creator_Process_Name")
    print(keys)
    for key in keys:
        print("Starting (front) " + key + " ...")
        arr = data[key].array(library="np")
        mdict.update({key: arr})
        del arr

fout = fname[0:-5] + "_side1.mat"
savemat(fout, mdict, long_field_names=True)
print("Front Plane finished !!!\n")


fname = "./topas" + Posname + "gp.root"

mdict = {}
with uproot.open(fname + ":XMinusSidePhaseSpacePlane") as data:
    keys = data.keys()
    keys.remove("Creator_Process_Name")
    print(keys)
    for key in keys:
        print("Starting (front) " + key + " ...")
        arr = data[key].array(library="np")
        mdict.update({key: arr})
        del arr

fout = fname[0:-5] + "_side1.mat"
savemat(fout, mdict, long_field_names=True)
print("Front Plane finished !!!\n")

