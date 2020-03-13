# Import classes from your brand new package
import glob
import logging
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt

from scipy.io import wavfile
import scipy.signal as snl
import processing as pr

# Define constants: frequency ranges, its limits and the limits of the bins for phase
freq_ranges = {"delta": (1, 3), "theta_low": (3, 5), "theta_high": (5, 7),
               "alpha": (7, 12), "beta": (12, 30), "gamma": (30, 50)}
freq_limits = [0, 1, 3, 5, 7, 12, 30, 50]
phs_lims = [-np.pi, -np.pi/2, 0, np.pi/2, np.pi]

# Load segments path. Might change depending on where you put them directory-wise
data_folder_path = "../DATA_TFM/EEG_Segmentado_filtrado_0.1-100_sin_artefactos/"
segments_folder_path = data_folder_path + "segmentos/test/"
segment_file_paths = glob.glob(segments_folder_path + "*.dat")

# Speech files' paths
multimedia_folder_path = "../DATA_TFM/Stimuli/"
audio_file_paths = glob.glob(multimedia_folder_path + "*.wav")

# Create dictionaries to contain the results of the calculations
segments_processed = {"success": 0, "error": 0}
mutual_information_sf = {"scrambled": {}, "face": {}, "scrambled_n": 0, "face_n": 0}

# Loop over the segments in order to process them
for sgmnt in segment_file_paths:
    # Load EEG and do some basic cleanup
    segment = pr.Segment(sgmnt)
    segment.dump_eyes()
    segment.subtract_reference(rm_ref=False)
    #segment.crop_audio_trial(inplace=True)
    segment.bandpass_data(250, freq_ranges, orden=3)

    # Find the file with the speech of the trial
    speech_audio_path = multimedia_folder_path + segment.audio_file

    try:
        assert(speech_audio_path in audio_file_paths)
    except:
        print("Could not find audio file " + segment.audio_file)
        input("Exitting now... (enter to quit)")
        exit()

    # Process and bin speech
    fs, audio_data = wavfile.read(speech_audio_path)
    inst_phase_aud = np.angle(snl.hilbert(audio_data))
    hist_audio_phs, _ = np.histogram(inst_phase_aud, bins=phs_lims)

    # Calculate MI per band per channel
    mutualinfo = {}

    for band in segment.bp_channels.keys():
        mutualinfo[band] = {}
        for channel, signal in segment.bp_channels[band].items():
            an_signal = snl.hilbert(signal)
            instphase = np.angle(an_signal)
            histphase, _ = np.histogram(instphase, bins=phs_lims)

            mutualinfo[band][channel] = pr.hist_mutual_info(
                histphase, hist_audio_phs)

    # Add it to either face or scrambled distributions
    kw = segment.is_face_kw()
    kwn = kw + "_n"

    mutual_information_sf[kwn] += 1
    if mutual_information_sf[kw] == {}:
        mutual_information_sf[kw] = mutualinfo
    else:
        for band in mutualinfo.keys():
            for channel, value in mutualinfo[band].items():
                    mutual_information_sf[kw][band][channel] += value

# Calculate mean values for MI for each channel
kws = ["face", "scrambled"]
for key in kws:
    kwn = key + "_n"
    for band in mutual_information_sf[key].keys():
        for channel in mutual_information_sf[key][band].keys():
            mutual_information_sf[key][band][channel] /= mutual_information_sf[kwn]

# Find differences in MI between scrambled and non-scrambled
MI_diff = {}
MI_rel = {}
for band in mutual_information_sf["face"].keys():
    MI_diff[band] = {}
    MI_rel[band] = {}
    for channel, value in mutual_information_sf["face"][band].items():
        MI_diff[band][channel] = value - mutual_information_sf["scrambled"][band][channel]
        MI_rel[band][channel] = MI_diff[band][channel] / value

print("And the final results are...:")
print(MI_diff)
print("Being the relative differences...:")
print(MI_rel)