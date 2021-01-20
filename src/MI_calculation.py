# TODO: Better document this calculation and cleanup
# Import classes from your brand new package
import glob
import logging
import numpy as np
import os
import json

import brainvision_wrangling as brainvision
from scipy.io import wavfile
import scipy.stats as stat
import scipy.signal as snl
import processing as pr

# Logging information to be able to debug
logging.basicConfig(level=print,
                    format=" %(asctime)s - %(levelname)s - %(message)s")
# logging.disable(logging.CRITICAL)

# Define constants: frequency ranges, its limits and the limits of the bins for phase
logging.debug("Define frequency ranges and phase limits for discretization.")
freq_ranges = {"low_freq": (0.1, 2), "delta": (1, 3), "theta_low": (3, 5), "theta_high": (5, 7),
               "alpha": (7, 12), "beta": (12, 30), "gamma_low": (30, 50), "gamma_high": (50, 100)}
channels = ['Fp1', 'Fpz', 'Fp2', 'AF7', 'AF3', 'AF4', 'AF8', 'F7', 'F5', 'F3', 'F1', 'Fz', 'F2', 'F4', 'F6', 'F8', 'FT7', 'FC5', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'FC6', 'FT8', 'T7', 'C5', 'C3', 'C1', 'Cz', 'C2', 'C4',
            'C6', 'T8', 'TP7', 'CP5', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4', 'CP6', 'TP8', 'P7', 'P5', 'P3', 'P1', 'Pz', 'P2', 'P4', 'P6', 'P8', 'PO7', 'PO3', 'PO4', 'PO8', 'O1', 'Oz', 'O2', 'HEOG+', 'HEOG', 'VEOG+', 'VEOG', 'M1']
bands = list(freq_ranges.keys())
freq_limits = [0, 1, 3, 5, 7, 12, 30, 50]
# > [-np.pi, -np.pi/2, 0, np.pi/2, np.pi]
phs_lims = np.linspace(-np.pi, np.pi, 5)

# Load segments path. Might change depending on where you put them directory-wise
raw_data_folder_path = "../raw_data/"
segment_folder_path = "../preprocessed_data/segments/"
segment_file_paths = glob.glob(segment_folder_path + "*.dat")
mi_folder_path = "../results/mutualinfo/ds8/"

# Speech files' paths
multimedia_folder_path = "../preprocessed_data/downsampled_audios/"
audio_file_paths = glob.glob(multimedia_folder_path + "*.wav")


# Create a dictionary to contain the results of the calculation

cumdata = {"face": {}, "scrambled": {}, "correct": {}, "incorrect": {}}
for key in cumdata.keys():
    cumdata[key] = {}
    for band in bands:
        cumdata[key][band] = {}
        for channel in channels:
            cumdata[key][band][channel] = []

# This is the computational heavy part
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

    logging.debug("Create AudioStim object using downsampled audio.")
    speech_audio_path = speech_audio_path.replace(".wav", "_ds8.wav")
    audio = pr.AudioStim(speech_audio_path)

    # Compute MI between EEG and speech
    logging.debug("Compute mutual information.")
    mi.compute(audio.data, audio.rate, dump_eyes=False)
    mi.save(mi_folder_path + sgmnt_name + ".mi")

    # Add it to either face or scrambled distributions
    logging.debug("Add values to cumulative data distributions")

    for band in bands:
        for channel in channels:
            if mi.face_nonscrambled:
                cumdata["face"][band][channel].append(mi.mi[band][channel])
            else:
                cumdata["scrambled"][band][channel].append(
                    mi.mi[band][channel])
            if mi.audio_corr:
                cumdata["correct"][band][channel].append(mi.mi[band][channel])
            else:
                cumdata["incorrect"][band][channel].append(
                    mi.mi[band][channel])

# Save cumdata as json
with open("cumdata.json", "w") as jsonfile:
    json.dump(cumdata, jsonfile)

# Calculate mean and std values for MI for each channel
logging.debug("Starting to calculate mean values")

stats = {"face": {}, "scrambled": {}, "correct": {}, "incorrect": {}}
for key in stats.keys():
    stats[key] = {}
    for band in bands:
        stats[key][band] = {}
        for channel in channels:
            stats[key][band][channel] = {}
            stats[key][band][channel]["mean"] = np.mean(
                cumdata[key][band][channel])
            stats[key][band][channel]["std"] = np.std(
                cumdata[key][band][channel])

# Find differences in MI between scrambled and non-scrambled
logging.debug("Differences...")
MI_difference = {}

MI_difference = {}
for key1, key2 in [("face", "scrambled"), ("correct", "incorrect")]:
    type_key = key1 + "_vs_" + key2
    MI_difference[type_key] = {}
    for band in bands:
        MI_difference[type_key][band] = {}
        for channel in channels:
            MI_difference[type_key][band][channel] = stats[key1][band][channel]["mean"] - \
                stats[key2][band][channel]["mean"]
            MI_difference[type_key][band][channel] = MI_difference[type_key][band][channel] / \
                stats[key1][band][channel]["mean"]

logging.debug("Saving data to files...")

# Save MI_diff and MI_rel as json file too
with open("MI_difference.json", "w") as jsonfile:
    json.dump(MI_difference, jsonfile)

# Use kruskal-wallis and ANOVA for analysis
logging.debug("Doing the KW analysis...")
kruskal = {}
for band in bands:
    kruskal[band] = {}
    for channel in channels:
        kruskal[band][channel] = stat.kruskal(
            cumdata["face"][band][channel], cumdata["scrambled"][band][channel])

logging.debug("Saving analysis...")
with open("kruskal_wallis.json", "w") as jsonfile:
    json.dump(kruskal, jsonfile)

input("Waiting for you to close the program...")
