from scipy.io import savemat
import numpy as np
from os import listdir

'''
This script converts all .npy S matrix data from the given folder into .mat files and
stores them under the given output_path

The data is taken from Jakob Hüpfl and accessed at https://owncloud.tuwien.ac.at/index.php/s/eIbkVjxpvyV7Ita
'''

output_path = "simulation_mat_data"
source_path = "simulation_data/5part/totalmodes3"
folders = listdir(source_path)

for folder in folders:
    S = np.load(f"{source_path}/{folder}/SMatrix.npy")
    t = np.load(f"{source_path}/{folder}/Time.npy")
    dict = {"Sk": S, "tk": t}
    savemat(f"{output_path}/simdata_{folder}.mat", dict)

