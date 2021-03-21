#!/usr/bin/env python3

"""This script segments all the data of an experiment.

It makes use of the module brainvision_wrangling, which needs to be
installed or on the same folder. It also requires the progress module.

Two arguments are required when calling the script: 
 - the folder where the experiment data is stored
 - the folder where we want the segments to be written

Functions
----------
synched_pop: calls the pop method on all the elements of a dictionary
    at the same position.
main: The main function with the functionality.
"""

import os
import sys
import glob

from brainvision_wrangling import BrainvisionWrapper
from utils import check_directory
from progress.bar import Bar


def synched_pop(dictionary: dict, position: int = 0) -> dict:
    """Uses the pop method on all the items in a dictionary at the same
    time.

    This could be used to use dictionaries as a repository of stacks.

    Parameters
    ----------
    dictionary: dict
        the dictionary that contains the objects that need to be popped
    position: int, optional
        the position that will be passed to the pop function

    Returns
    ----------
    dict
        a dictionary containing under the same keys the popped elements
    """
    buffer = {}
    for key in dictionary.keys():
        buffer[key] = dictionary[key].pop(position)
    return buffer



data_folder = check_directory(sys.argv[1])
segment_folder = check_directory(sys.argv[2])

# To get the files, we use glob. We sort the to avoid problems.
file_formats = (("headers", ".vhdr"),
                # ("markers", ".vrmk"),
                # ("data", ".dat"),
                ("logs", ".txt"))
file_paths = {}

for name, ending in file_formats:
    file_paths[name] = sorted(glob.glob(os.path.join(data_folder,
                                                        "*" + ending)))

# Create progress bar to make script more friendly
bar = Bar('Segmenting data', max=len(file_paths["headers"])*2)

# Iterate until no more files are left
while len(file_paths["headers"]) > 0:
    bar.next()
    current_files = synched_pop(file_paths)
    wrapper = BrainvisionWrapper(current_files["headers"],
                                    current_files["logs"])
    wrapper.segment_data()
    wrapper.save_segmented_data(segment_folder)
    bar.next()
bar.finish()
