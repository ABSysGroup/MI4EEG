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

folder_path = "../Data/Stimuli/"
wavs_paths = glob.glob(folder_path + "*.wav")

print("Starting...")
for path in wavs_paths:
        audio = pr.AudioStim(path)
        audio.downsample(8)
        print("RATE " + str(audio.rate))
        new_path = os.path.split(path)[-1]
        new_path = new_path.split(".")[0] + "_ds8.wav"
        audio.save(new_path)
        print("File " + new_path + " done")

print("Done")