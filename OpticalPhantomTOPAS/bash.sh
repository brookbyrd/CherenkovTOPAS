export TOPAS_G4_DATA_DIR=/Applications/G4Data
export QT_QPA_PLATFORM_PLUGIN_PATH=/Applications/topas/Frameworks

# Path to your TOPAS binary
TOPAS="/Applications/topas/bin/topas"


# Number of simulations to run
NUM_SIMULATIONS=9

# Loop through the desired number of simulations
for (( i=6; i<=NUM_SIMULATIONS; i++ ))
do

    # Run TOPAS with the modified parameter file
    $TOPAS OpticalPhantomMaterials/batch${i}.topas

done

