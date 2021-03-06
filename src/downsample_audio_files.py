#!/usr/bin/env python3

"""This script downsamples the wav files in the given folder.

Three arguments are required when calling the script:
 - the folder where the audio files are stored
 - the folder where the downsampled versions will be stored
 - the downsampling factor (integer)

 Note: if the downsampling factor is not, indeed, a factor of the rate,
    the user will be asked to continue with a different downsampled
    rate that is an integer.

TODO: Create log file indicating things like rate % factor != 0,
    float(factor) != int(factor), new_rate != int(new_rate), etc.
"""
from utils import check_directory
from progress.bar import Bar
from scipy.io import wavfile
import glob
import sys
import os

if len(sys.argv) != 4:
    print("There should be 3 arguments passed. Check docs.")
    sys.exit(1)

from_dir = check_directory(sys.argv[1])
to_dir = check_directory(sys.argv[2])
factor = int(sys.argv[3])

file_paths = glob.glob(os.path.join(from_dir, "*.wav"))

bar = Bar('Downsampling audio files', max=len(file_paths))

rate_warning = False # Flag for skipping rate check

for path in file_paths:
    filename = os.path.split(path)[1]

    rate, data = wavfile.read(path)

    if rate % factor != 0:
        if not rate_warning:
            print("WARNING: Rate should be multiple of factor")
            print(f"Rate: {rate}, new rate would be {rate/factor}.")
            a = input(f"Do you want to use {rate//factor} as rate? [y/n] ")
            if a == "y":
                rate_warning = True
                print(f"Using {rate//factor} as new rate.")
            else:
                print("Aborting...")
                sys.exit(1)

    data = data[::factor]
    rate = rate//factor

    wavfile.write(os.path.join(to_dir, filename), rate, data)
    bar.next()

bar.finish()
print("Audio files downsampled.")
