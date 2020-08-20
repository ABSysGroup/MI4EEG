# TODO: Better document this calculation and cleanup
# Import classes from your brand new package
import glob
import logging
import numpy as np
import pandas as pd
import os
import json

import matplotlib as mpl
import matplotlib.pyplot as plt

from scipy.io import wavfile
import scipy.stats as stats
import scipy.signal as snl
import processing as pr

# Logging information to be able to debug
logging.basicConfig(level=print,
                    format=" %(asctime)s - %(levelname)s - %(message)s")
# logging.disable(logging.CRITICAL)

# Define constants: frequency ranges, its limits and the limits of the bins for phase
logging.debug("Define frequency ranges and phase limits for discretization.")
freq_ranges = {"low_freq": (0.1, 2), "delta": (1, 3), "theta_low": (3, 5), "theta_high": (5, 7),
               "alpha": (7, 12), "beta": (12, 30), "gamma": (30, 50), "high_freq": (50, 100)}
freq_limits = [0, 1, 3, 5, 7, 12, 30, 50]
phs_lims = np.linspace(-np.pi, np.pi, 4)
# phs_lims = [-np.pi, -np.pi/2, 0, np.pi/2, np.pi]

# Load segments path. Might change depending on where you put them directory-wise
raw_data_folder_path = "../raw_data/"
data_folder_path = "../Data/segments/"
segment_file_paths = glob.glob(data_folder_path + "*.dat")
mi_folder_path = "../Data/mutualinfo/ds1_2/"

# Speech files' paths
multimedia_folder_path = "../raw_data/Stimuli/"  # "../Data/downsampled_audios/"
audio_file_paths = glob.glob(multimedia_folder_path + "*.wav")

# Create dictionaries to contain the results of the calculations
mutual_information_sf = {"scrambled": {},
                         "face": {}, "scrambled_n": 0, "face_n": 0}

number_of_processed = 0

cumdata = {}

#  This is the computational heavy part
# Loop over the segments in order to process them
logging.debug("Start iterating over segments \n \n")
for sgmnt in segment_file_paths:
    sgmnt_name = sgmnt.split("/")[-1].split(".")[0]
    logging.debug("-- Going over '" + sgmnt_name + "' --")

    # Load EEG and do some basic cleanup
    logging.debug("Create MutualInformation object.")
    arguments = {"segment_path": sgmnt, "mode": "phase", "discretization": phs_lims,
                 "bands_dict": freq_ranges, "comments": "MI between EEG and audio"}
    mi = pr.MutualInformation()
    mi.load_segment(**arguments)

    # Find the file with the speech of the trial
    speech_audio_path = multimedia_folder_path + mi.segment.audio_file

    # try:
    #     assert(multimedia_folder_path +
    #            mi.segment.audio_file in audio_file_paths)
    # except:
    #     logging.debug("Could not find audio file " + mi.segment.audio_file)
    #     input("Exitting now... (enter to quit)")
    #     exit()

    logging.debug("Create AudioStim object.")
    # speech_audio_path = speech_audio_path.replace(".wav", "_ds8.wav")
    audio = pr.AudioStim(speech_audio_path)
    # audio.downsample(8)

    # Process and bin speech
    logging.debug("Compute mutual information.")
    mi.compute(audio.data, audio.rate, dump_eyes=False)
    mi.save(mi_folder_path + sgmnt_name + ".mi")

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

    try:
        bands
        channels
    except NameError:
        bands = list(mi.mi.keys())
        channels = list(mi.mi[bands[0]].keys())

    if cumdata == {}:
        for band in bands:
            cumdata[band] = {}
            for channel in channels:
                cumdata[band][channel] = {"face": [], "noface": []}

    for band in bands:
        for channel in channels:
            if mi.face_nonscrambled:
                cumdata[band][channel]["face"].append(mi.mi[band][channel])
            else:
                cumdata[band][channel]["noface"].append(mi.mi[band][channel])

    number_of_processed += 1
    logging.debug("Gone over " + str(number_of_processed /
                                     len(segment_file_paths)*100) + "% of files")

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


logging.debug("Saving data to files...")
# Save cumdata as json
with open("cumdata.json", "w") as jsonfile:
    json.dump(cumdata, jsonfile)

# Save MI_diff and MI_rel as json file too
with open("MI_diff_rel.json", "w") as jsonfile:
    json.dump({"MI_diff": MI_diff, "MI_rel": MI_rel}, jsonfile)

# Use kruskal-wallis and ANOVA for analysis
logging.debug("Doing the ANOVA and KW analysis...")
fandp_anova = {}
for band in bands:
    fandp_anova[band] = {}
    for channel in channels:
        fandp_anova[band][channel] = stats.f_oneway(
            cumdata[band][channel]["face"], cumdata[band][channel]["noface"])
fandp_kruskal = {}
for band in bands:
    fandp_kruskal[band] = {}
    for channel in channels:
        fandp_kruskal[band][channel] = stats.kruskal(
            cumdata[band][channel]["face"], cumdata[band][channel]["noface"])

logging.debug("Saving analysis...")
with open("anova.json", "w") as jsonfile:
    json.dump(fandp_anova, jsonfile)
with open("kw.json", "w") as jsonfile:
    json.dump(fandp_kruskal, jsonfile)

input("Waiting for you to close the program...")
