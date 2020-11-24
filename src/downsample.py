# Import classes from your brand new package
import glob
import logging
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt
import os

from scipy.io import wavfile
import scipy.signal as snl
import processing as pr

folder_path = "../raw_data/Stimuli/"
wavs_paths = glob.glob(folder_path + "*.wav")

print("Starting...")
for path in wavs_paths:
    audio = pr.AudioStim(path)
    print("OLD RATE " + str(audio.rate))
    audio.downsample(8)
    print("NEW RATE " + str(audio.rate))
    new_path = "../preprocessed_data/downsampled_audios/"
    new_path += os.path.split(path)[-1].split(".")[0] + "_ds8.wav"
    audio.save(new_path)
    print("File " + new_path + " done")

print("Done")
