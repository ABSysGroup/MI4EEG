# Import classes from your brand new package
import glob
import logging
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt

from scipy.io import wavfile
import scipy.signal as snl
import preprocessing as pp
import analysis as an

logging.basicConfig(level=logging.DEBUG,
                    format=" %(asctime)s - %(levelname)s - %(message)s")

logging.disable(logging.CRITICAL)

if input("Process audio stimuli? (y/n): ").lower() == "y":
    multimedia_folder_path = "../DATA_TFM/Stimuli"
    audio_file_paths = glob.glob(multimedia_folder_path + "/*.wav")
    logging.debug("Starting")
    # logging.debug("Number of filepaths " + str(len(audio_file_paths)))
    # audiostimuli = pp.AudioStims(audio_file_paths)
    # logging.debug("Ending with " + str(audiostimuli.files_number) + " files recorded.")
    # logging.debug(audiostimuli.files.keys())
    fs, data = wavfile.read(audio_file_paths[0])
    band_data = an.cochlear_bandpass(data, 100, 10000, 9, fs)
    mean_env, envs = an.envelope_bands(band_data)
    len(band_data)
    index = 0
    for band in band_data:
        file_name = "multimedia/audio0_bp{0}.wav".format(index)
        wavfile.write(file_name, fs, np.asarray(band, dtype=np.int16))
        index += 1
    index2 = 0
    for env in envs:
        file_name = "multimedia/env0_bp{0}.wav".format(index2)
        wavfile.write(file_name, fs, np.asarray(env, dtype=np.int16))
        index2 += 1

    fig1 = plt.figure()
    ax1 = fig1.add_subplot(111)
    ax1.plot(data)

if input("Process EEG?: (y/n): ").lower() == "y":
    data_folder_path = "../DATA_TFM/EEG_Segmentado_filtrado_0.1-100_sin_artefactos/"
    segments_folder_path = data_folder_path + "segmentos/"
    segment_file_paths = glob.glob(segments_folder_path + "*.dat")
    logging.debug("Starting")
    segment = pp.Segment(segment_file_paths[0])
    freq_ranges = {"delta": (1, 3), "theta_low": (3, 5), "theta_high": (5, 7),
                   "alpha": (7, 12), "beta": (12, 30), "gamma": (30, 50)}
    segment.crop_audio_trial(inplace=True)
    bp_channels = {}
    hilbert_channels = {}

    for key, values in segment.channels.items():
        bp_channels[key] = {}
        hilbert_channels[key] = {}
        hilbert_channels[key]["nobp"] = snl.hilbert(values)
        for rangename, limits in freq_ranges.items():
            bp_channels[key][rangename] = an.bw4_bandpass_filter(values, limits[0],
                                                                 limits[1], 250, order=4)
            hilbert_channels[key][rangename] = snl.hilbert(bp_channels[key][rangename])
            file_name_eeg = "multimedia/eeg/eeg_ch{0}_band{1}.wav".format(
                key, rangename)

# for key1, val1 in hilbert_channels:
#         for val2 in val1["nobp"]:
            
            
    cst = list(segment.channels.keys())[0]
    fig2 = plt.figure()
    ax21 = fig2.add_subplot(311)
    ax21.plot(segment.channels[cst])
    ax22 = fig2.add_subplot(312)
    ax22.plot(bp_channels[cst]["delta"])
    ax23 = fig2.add_subplot(313)
    ax23.plot(bp_channels[cst]["gamma"])

plt.show()
