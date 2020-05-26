# Import classes from your brand new package
import glob
import logging
import numpy as np
import pandas as pd
import os

import matplotlib as mpl
import matplotlib.pyplot as plt

from scipy.io import wavfile
import scipy.signal as snl
import processing as pr

# Logging information to be able to debug
logging.basicConfig(level=print,
                    format=" %(asctime)s - %(levelname)s - %(message)s")
# logging.disable(logging.CRITICAL)

# Define constants: frequency ranges, its limits and the limits of the bins for phase
print("Define frequency ranges and phase limits for discretization.")
freq_ranges = {"delta": (1, 3), "theta_low": (3, 5), "theta_high": (5, 7),
               "alpha": (7, 12), "beta": (12, 30), "gamma": (30, 50)}
freq_limits = [0, 1, 3, 5, 7, 12, 30, 50]
phs_lims = [-np.pi, -np.pi/2, 0, np.pi/2, np.pi]

# Load segments path. Might change depending on where you put them directory-wise
raw_data_folder_path = "../raw_data/"
data_folder_path = "../Data/segments/"
segment_file_paths = glob.glob(data_folder_path + "*.dat")
mi_folder_path = "../Data/mutualinfo/"

# Speech files' paths
multimedia_folder_path = "../raw_data/Stimuli/" # "../Data/downsampled_audios/" 
audio_file_paths = glob.glob(multimedia_folder_path + "*.wav")

# Create dictionaries to contain the results of the calculations
mutual_information_sf = {"scrambled": {},
                         "face": {}, "scrambled_n": 0, "face_n": 0}

number_of_processed = 0

## This is the computational heavy part
# Loop over the segments in order to process them
print("Start iterating over segments \n \n")
for sgmnt in segment_file_paths:
    sgmnt_name = sgmnt.split("/")[-1].split(".")[0]
    print("-- Going over '" + sgmnt_name + "' --")

    # Load EEG and do some basic cleanup
    print("Create MutualInformation object.")
    mi = pr.MutualInformation(sgmnt, "phase", phs_lims, freq_ranges, "test")

    # Find the file with the speech of the trial
    speech_audio_path = multimedia_folder_path + mi.segment.audio_file

    # try:
    #     assert(multimedia_folder_path +
    #            mi.segment.audio_file in audio_file_paths)
    # except:
    #     print("Could not find audio file " + mi.segment.audio_file)
    #     input("Exitting now... (enter to quit)")
    #     exit()

    print("Create AudioStim object.")
    speech_audio_path = speech_audio_path.replace(".wav", "_ds8.wav")
    audio = pr.AudioStim(speech_audio_path)
    # audio.downsample(8)

    # Process and bin speech
    print("Compute mutual information.")
    mi.compute(audio.data, audio.rate)
    mi.save(mi_folder_path + sgmnt_name + "_ds8.mi")

    # Add it to either face or scrambled distributions
    kw = mi.segment.is_face_kw()
    kwn = kw + "_n"

    mutual_information_sf[kwn] += 1
    if mutual_information_sf[kw] == {}:
        mutual_information_sf[kw] = mi.mi
    else:
        for band in mi.bands_dict.keys():
            for channel, value in mi.mi[band].items():
                mutual_information_sf[kw][band][channel] += value

    number_of_processed += 1
    print("Gone over " + str(number_of_processed /
                                     len(segment_file_paths)*100) + "% of files")

# Calculate mean values for MI for each channel
print("Starting to calculate mean values")
kws = ["face", "scrambled"]
for key in kws:
    kwn = key + "_n"
    for band in mutual_information_sf[key].keys():
        for channel in mutual_information_sf[key][band].keys():
            mutual_information_sf[key][band][channel] /= mutual_information_sf[kwn]

# Find differences in MI between scrambled and non-scrambled
print("Differences...")
MI_diff = {}
MI_rel = {}
for band in mutual_information_sf["face"].keys():
    MI_diff[band] = {}
    MI_rel[band] = {}
    for channel, value in mutual_information_sf["face"][band].items():
        MI_diff[band][channel] = value - \
            mutual_information_sf["scrambled"][band][channel]
        MI_rel[band][channel] = MI_diff[band][channel] / value





## SAVE THE STUFF
try:
    with open("MI_diff_ds8.dat", "w") as thing:
        thing.write(str(MI_diff))
except:
    print("This file didn't write, fuck")

with open("MI_rel_ds8.dat", "w") as thing:
    thing.write(str(MI_rel))

print("And the final results are...:")
print(MI_diff)
print("Being the relative differences...:")
print(MI_rel)
input("Waiting for you to close the program...")