# Import classes from your brand new package
import glob
import logging
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt

from scipy.io import wavfile
import scipy.signal as snl
import processing as pr

logging.basicConfig(level=logging.DEBUG,
                    format=" %(asctime)s - %(levelname)s - %(message)s")

# Define constants
freq_ranges = {"delta": (1, 3), "theta_low": (3, 5), "theta_high": (5, 7),
               "alpha": (7, 12), "beta": (12, 30), "gamma": (30, 50)}
freq_limits = [0, 1, 3, 5, 7, 12, 30, 50]

# Find segment files' paths
data_folder_path = "../DATA_TFM/EEG_Segmentado_filtrado_0.1-100_sin_artefactos/"
segments_folder_path = data_folder_path + "segmentos/"
segment_file_paths = glob.glob(segments_folder_path + "*.dat")

# Find audio files' paths
multimedia_folder_path = "../DATA_TFM/Stimuli/"
audio_file_paths = glob.glob(multimedia_folder_path + "*.wav")

logging.debug("Starting")

for sgmnt_path in segment_file_paths:
    # Load one segment (for now)
    segment = pr.Segment(sgmnt_path)

    logging.debug("Try if in audios")

    lang_audio_path = multimedia_folder_path + segment.audio_file

    try:
        assert(lang_audio_path in audio_file_paths)
        logging.debug("Audio file found")
    except:
        print("Could not find audio file " + segment.audio_file)
        input("Exitting now... (enter to quit)")
        exit()

    # AUDIO
    logging.debug("Start processing audio signal")
    # Open audio file and process signal
    fs, audio_data = wavfile.read(lang_audio_path)
    analytic_audio = snl.hilbert(audio_data)
    # amplitud_envelope_aud = np.abs(analytic_audio)
    inst_phase_aud = np.angle(analytic_audio) 
    # inst_freq_aud = (np.diff(inst_phase_aud) /
    #                  (2 * np.pi * fs))  # Derivative of phase

    # Create histograms
    logging.debug("Start creating audio histograms")
    # hist_audio_amp = np.histogram(audio_data, bins=4)
    # hist_audio_env = np.histogram(amplitud_envelope_aud, bins=4)
    hist_audio_phs, _ = np.histogram(inst_phase_aud, bins=4)
    # hist_audio_frq = np.histogram(inst_freq_aud, bins=4)

    # EEG
    logging.debug("Start processing EEG")
    segment.crop_audio_trial(inplace=True)
    # analytic_channels = {}
    # amplitude_envelope_eeg = {}
    inst_phase_eeg = {} 
    # inst_freq_eeg = {}
    for name, channel in segment.channels.items():
        analytic_signal = snl.hilbert(channel)
        # analytic_channels[name] = analytic_signal
        # amplitud_envelope_eeg[name] = np.abs(analytic_signal)
        inst_phase_eeg[name] = np.angle(analytic_signal)
        # inst_freq_eeg[name] = (np.diff(analytic_signal) / (2 * np.pi * 250))

    # Create the histograms
    logging.debug("Start creating EEG histograms")
    # hist_eeg_amp = {}
    # hist_eeg_env = {}
    hist_eeg_phs = {}
    # hist_eeg_frq = {}
    for name in segment.channels.keys():
        # hist_eeg_amp[name] = np.histogram(analytic_channels[name], bins=4)
        # hist_eeg_env[name] = np.histogram(amplitude_envelope_eeg[name], bins=4)
        hist_eeg_phs[name], _ = np.histogram(inst_phase_eeg[name], bins=4)
        # hist_eeg_frq[name] = np.histogram(inst_freq_eeg, bins=4)

    # CALCULATE MUTUAL INFORMATION
    logging.debug("START WITH MUTUAL INFORMATION")
    mutual_information = {}
    for channel in segment.channels.keys():
        try:
            mutual_information[channel] = pr.hist_mutual_info(
                hist_eeg_phs[channel], hist_audio_phs)
        except:
            continue

print(type(mutual_information))
