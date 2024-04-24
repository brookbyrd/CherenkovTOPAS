import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

def generate_topas_file(batch_name, file_ending, absorption_length, scattering_length):
    header = f"""includeFile = PhantomExperiment.topas

# Set seed
i:Ts/Seed = 1

# Conditions for Phantom
s:Ge/fileEnding = "_{file_ending.replace(".", "")}"

# Add on to the files to identify optical properties
s:Sc/OpticalScorerMyBox01/OutputFile = Sc/OpticalScorerMyBox01/OutputFile + Ge/fileEnding

"""
    
    # Write to file
    with open('/Applications/topas/OpticalPhantomExperiment/OpticalPhantomMaterials/' + batch_name + '.topas', 'w') as f:
        f.write(header)
        
        # Define the list of multipliers
        mus_multipliers = [1.293, 1.170, 1.044, 0.912, 0.781, 0.644]
        mua_multipliers = [1.0158, 1.0513, 1.0092, 0.9909, 0.9908, 1.0277]

        line = "dv:Ma/MyWater/Miehg/Values  = 6 "
        
        # Iterate over each multiplier
        for multiplier_mus in mus_multipliers:
            # Construct the line with multiplied values
            line += " ".join([str(np.round(scattering_length * multiplier_mus,5))])
            line += " "
        line += " cm\n"
            
        # Write the line to the file
        f.write(line)

        line = "dv:Ma/MyWater/AbsLength/Values  = 6 "

        # Iterate over each multiplier
        for multiplier_mua in mua_multipliers:
            # Construct the line with multiplied values
            line += " ".join([str(np.round(absorption_length * multiplier_mua,5))])
            line += " "
        line += " cm\n"
            
        # Write the line to the file
        f.write(line)     

# Assuming df is defined
# μs' = μs * (1 - g) so mus is 10x mus'
set_mus = [6.89, 10.89, 20.35]
set_mua = [0.11, 0.40, 0.61]

b = 1
for temp_mus in set_mus:
    for temp_mua in set_mua:

        #   Define the absorption and scattering lengths
        # scattering_length = 1 / (temp_mus * 10) 
        scattering_length = 1 / (temp_mus) 
        absorption_length = 1 / (temp_mua)
        
        # Generate .topas file
        #generate_topas_file(batch_name, file_ending, energies, absorption_lengths, scattering_lengths)
        generate_topas_file(f"batch{b}", f"mus_{np.round(temp_mus, 2)}_mua_{np.round(temp_mua, 2)}",  absorption_length, scattering_length)

        b+=1