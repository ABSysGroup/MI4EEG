#!/usr/bin/env python3

"""This script segments all the data of an experiment.

It makes use of the module brainvision_wrangling, which needs to be
installed or on the same folder. It also requires the progress module.

Two arguments are required when calling the script: 
 - the folder where the experiment data is stored
 - the folder where we want the segments to be written

Functions
----------
check_directory: checks whether or not path is a directory and creates 
    it if it does not exist. Aborts when exists but it is not a dir.
synched_pop: calls the pop method on all the elements of a dictionary
    at the same position.
main: The main function with the functionality.
"""

import os
import sys

from brainvision_wrangling import BrainvisionWrapper
from progress.bar import Bar


def check_directory(path: str) -> str:
    """Checks if a path exists in filesystem and whether it is a dir or
    not.

    If it exists but not a directory, it exists with an error code. If 
    it does not exist, it creates the directory.

    Arguments
    ----------
    path: str
        path that is going to be checked

    Returns
    ----------
    str
        returns the path. this is so that it can be used inline.
    """

    if os.path.exists(path):
        if not os.path.isdir(path):
            print(f"{path} exists but is not a directory. Aborting...")
            sys.exit(1)
    else:
        print(f"{path} does not exist. Creating directory...")
        os.mkdir(path)

    return os.path.join(path)  # adds slash if needed


def synched_pop(dictionary: dict, position=0: int) -> dict:
    """Uses the pop method on all the items in a dictionary at the same
    time.

    This could be used to use dictionaries as a repository of stacks.

    Arguments
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


def main():
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
                                                         "*", ending)))

    # Create progress bar to make script more friendly
    bar = Bar('Segmenting data', max=len(file_paths["headers"]))

    # Iterate until no more files are left
    while len(file_paths["headers"]) > 0:
        current_files = synched_pop(file_paths)
        wrapper = BrainvisionWrapper(current_files["headers"],
                                     current_files["logs"])
        wrapper.segment_data()
        wrapper.save_segmented_data(segment_folder)
        bar.next()
    bar.finish()


main()