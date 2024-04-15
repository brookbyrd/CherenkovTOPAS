# @title Default title text
import math
import random
import numpy as np      
import os
import pandas as pd

# Constants
c = 299792458  # Speed of light in vacuum, in meters per second
n = 1.4  # Example refractive index, adjust based on your scenario
elec_mass = 0.511  # Rest mass of electron in MeV

def calculate_cone_angle(beta):
  if beta * c > c / n:
    return math.acos(1/(beta*n))
  else:
    return None

def velocity(energy):

    total_energy = energy + elec_mass  # Total energy = kinetic energy + rest mass
    momentum = math.sqrt(total_energy**2 - (elec_mass)**2)
    velocity = momentum / total_energy
    return velocity

def Rodrigues_angles(alpha_e, beta_e, gamma_sign, cone_angle):
  
  # finding the third angle
  gamma_e = np.sqrt(1 - alpha_e**2 - beta_e**2)  # Z (direction cosine of momentum with respect to Z)

  # set it to negative if flag = 1
  if gamma_sign == 1:
      gamma_e = -gamma_e

  # Vector of cosigns for electron
  vector_e = [alpha_e, beta_e, gamma_e]

  # Ensure the input vector is a unit vector
  vector_e = vector_e / np.linalg.norm(vector_e)

  # Selecting a random direction for the Cherenkov photon
  randomAngle = random.uniform(0, 360)

  # Assign azimuthal (phi) and polar (theta coordinates)
  phi_b = (math.radians(randomAngle))
  theta_b = (math.radians(cone_angle))

  # Generate Photon Vector from Spherical coordinates
  x_b = math.sin(theta_b) * math.cos(phi_b)
  y_b = math.sin(theta_b) * math.sin(phi_b)
  z_b = math.cos(theta_b)

  # Vector of cosigns for cone angles
  vector_b = [x_b, y_b, z_b]

  # Ensure the input vector is a unit vector
  vector_b = vector_b / np.linalg.norm(vector_b)

  # Take the dot product of the two vectors to get the axis of rotation
  rotation_axis = np.cross(vector_e, vector_b)

  # Rodrigues' rotation formula
  rotated_vec = vector_e * math.cos(math.radians(cone_angle)) + \
                  np.cross(rotation_axis, vector_e) * math.sin(math.radians(cone_angle)) + \
                  rotation_axis * np.dot(rotation_axis, vector_e) * (1 - math.cos(math.radians(cone_angle)))

  return vector_e, rotated_vec


def list_specific_files_recursive(directory):
    files = []
    for root, dirs, file_names in os.walk(directory):
        for file_name in file_names:
            if file_name.startswith('electron') and file_name.endswith('.phsp'):
                files.append(os.path.join(root, file_name))
    return files

def main():
  # Specify the directory path
  phsp_filepath = '/Applications/topas/OpticalPhantomTOPAS/OutputElectrons/'  # Adjust the filename as necessary

  # Get the list of specific files, including files in subdirectories
  specific_files = list_specific_files_recursive(phsp_filepath)

  for s in specific_files:
    # Frame to output to
    output = []

    with open(s, 'r') as file:
          for line in file:
              location = [];
              tokens = line.split()
              particle_type = int(tokens[7])  # PDG format
              energy = float(tokens[5])  # Energy in MeV
              location.append(float(tokens[0])) # X location
              location.append(float(tokens[1]))   # Y location
              location.append(float(tokens[2]))   # Z location

              if particle_type == 11:
                  B = velocity(energy)
                  cone_angle = (calculate_cone_angle(B))
                  
                  if cone_angle is not None:
                      cone_angle = math.degrees(cone_angle)

                      # Directionality of particle momentum
                      alpha_e = float(tokens[3]) # U (direction cosine of momentum with respect to X)
                      beta_e = float(tokens[4]) # V (direction cosine of momentum with respect to Y)
                      gamma_sign = int(tokens[8])

                      # calculate the global vector of a photon
                      vector_e, rotated_vec = Rodrigues_angles(alpha_e, beta_e, gamma_sign,cone_angle)
                      
                      # Generate data frame to store all variables
                      # Assuming 'output' is a list, and other variables are already defined
                      output.append([
                          energy, 
                          cone_angle, 
                          location[0],  # x-component of vector_e
                          location[1],  # y-component of vector_e
                          location[2],  # z-component of vector_e
                          vector_e[0],  # x-component of vector_e
                          vector_e[1],  # y-component of vector_e
                          vector_e[2],  # z-component of vector_e
                          rotated_vec[0],  # x-component of rotated_vec
                          rotated_vec[1],  # y-component of rotated_vec
                          rotated_vec[2]   # z-component of rotated_vec
                      ])


    outputFrame = pd.DataFrame(output)
    
    filename = s.split(".")[0].split("/")[-1]
    newFilepath= '/Applications/topas/OpticalPhantomTOPAS/OutputCherenkovPhotons/'
    outputFrame.to_csv(newFilepath + filename +'.csv')

if __name__ == '__main__':
  main()