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
logging.basicConfig(level=logging.DEBUG,
                    format=" %(asctime)s - %(levelname)s - %(message)s")
# logging.disable(logging.CRITICAL)

# Define constants: frequency ranges, its limits and the limits of the bins for phase
logging.debug("Define frequency ranges and phase limits for discretization.")
freq_ranges = {"delta": (1, 3), "theta_low": (3, 5), "theta_high": (5, 7),
               "alpha": (7, 12), "beta": (12, 30), "gamma": (30, 50)}
freq_limits = [0, 1, 3, 5, 7, 12, 30, 50]
phs_lims = [-np.pi, -np.pi/2, 0, np.pi/2, np.pi]

# Load segments path. Might change depending on where you put them directory-wise
raw_data_folder_path = "../raw_data/"
data_folder_path = "../Data/"
segment_file_paths = glob.glob(data_folder_path + "*.dat")

# Speech files' paths
multimedia_folder_path = "../Data/Stimuli/"
audio_file_paths = glob.glob(multimedia_folder_path + "*.wav")

# Create dictionaries to contain the results of the calculations
mutual_information_sf = {"scrambled": {},
                         "face": {}, "scrambled_n": 0, "face_n": 0}

number_of_processed = 0
# Loop over the segments in order to process them
logging.debug("Start iterating over segments \n \n")
for sgmnt in segment_file_paths[:1000]:
    logging.debug("-- Going over '" + sgmnt + "' --")

    # Load EEG and do some basic cleanup
    logging.debug("Create MutualInformation object.")
    mi = pr.MutualInformation(sgmnt, "phase", phs_lims, freq_ranges, "test")

    # Find the file with the speech of the trial
    speech_audio_path = multimedia_folder_path + mi.segment.audio_file

    try:
        assert(multimedia_folder_path +
               mi.segment.audio_file in audio_file_paths)
    except:
        print("Could not find audio file " + mi.segment.audio_file)
        input("Exitting now... (enter to quit)")
        exit()

    logging.debug("Create AudioStim object.")
    audio = pr.AudioStim(speech_audio_path)
    audio.downsample(8)

    # Process and bin speech
    logging.debug("Compute mutual information.")
    mi.compute(audio.data, audio.rate)

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
    logging.debug("Gone over " + str(number_of_processed /
                                     len(segment_file_paths[:100])*100) + "% of files")

# Calculate mean values for MI for each channel
logging.debug("Starting to calculate mean values")
kws = ["face", "scrambled"]
for key in kws:
    kwn = key + "_n"
    for band in mutual_information_sf[key].keys():
        for channel in mutual_information_sf[key][band].keys():
            mutual_information_sf[key][band][channel] /= mutual_information_sf[kwn]

# Find differences in MI between scrambled and non-scrambled
logging.debug("Differences...")
MI_diff = {}
MI_rel = {}
for band in mutual_information_sf["face"].keys():
    MI_diff[band] = {}
    MI_rel[band] = {}
    for channel, value in mutual_information_sf["face"][band].items():
        MI_diff[band][channel] = value - \
            mutual_information_sf["scrambled"][band][channel]
        MI_rel[band][channel] = MI_diff[band][channel] / value

with open("pleasesavethis.dat", "w") as thing:
    thing.write(MI_diff)

with open("pleasesavethisrelative.dat", "w") as thing:
    thing.write(MI_rel)


print("And the final results are...:")
print(MI_diff)
print("Being the relative differences...:")
print(MI_rel)
