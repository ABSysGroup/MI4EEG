# Import modules
import ipywidgets
import numpy as np
import pandas as pd
import logging
import glob
import os

# Plotting
import matplotlib as mpl
import matplotlib.pyplot as plt

# Signal processing
import scipy.signal as snl
from scipy.io import wavfile
import scipy.stats as stats

with open("MI_rel.dat", "r") as f:
    line = f.readline()
    MI_rel = eval(line)

with open("MI_rel_ds8.dat", "r") as f:
    line = f.readline()
    MI_rel_ds8 = eval(line)

bands = list(MI_rel.keys())
channels = list(MI_rel["delta"].keys())

mi_folder = "../Data/mutualinfo/"
mi_files = glob.glob(mi_folder + "*.mi")
mi_files.sort()
ds8_files = glob.glob(mi_folder + "ds8/*.mi")
ds8_files.sort()

bands = list(MI_rel.keys())
k = bands[5]
labels = list(MI_rel[k].keys())
mi_rel_vals = list(MI_rel[k].values())
ds8_rel_vals = list(MI_rel_ds8[k].values())

x = np.arange(len(labels))  # the label locations
width = 0.35  # the width of the bars

fig, ax = plt.subplots()
rects1 = ax.bar(x - width/2, mi_rel_vals, width, label='No downsampling')
rects2 = ax.bar(x + width/2, ds8_rel_vals, width, label='Downsampling')

ax.set_ylabel('Relative Mutual Information')
ax.set_title('Comparison between downsampled and non-downsampled MI values GAMMA band')
ax.set_xticks(x)
plt.xticks(rotation=90)
ax.set_xticklabels(labels)
ax.legend()


fig.tight_layout()

plt.show()