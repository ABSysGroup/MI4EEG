#!/usr/bin/env python3

"""This script segments all the data of an experiment using hard-wired
functions to check for the internal consistency of the data given.

IMPORTANT: The congruency tests used in this script are intentionally
coded to be used with the data from Hernández-Gutiérrez et al. 2021
(published in SCAN, https://doi.org/10.1093/scan/nsab009), so it could
give issues when executing it with other data.

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

from segment_data import synched_pop

data_folder = check_directory(sys.argv[1])
segment_folder = check_directory(sys.argv[2])


def facecode(filename: str) -> int:
    """ Translates the string facestim id to the numerical ones """
    faceid = filename[1]
    if filename[2] == "n":
        scr = "1"
    elif filename[2] == "s":
        scr = "2"
    else:
        scr = "0"
    facecode = scr + faceid
    return int(facecode)


def check_speech_codes(trial: dict):
    """This function checks for inner trial consistency in the log files
    by checking whether or not the file used in the trial is the same as
    the one indicated for the marker using the codes present.

    The log files in the experiment are as such:
    ```
    subject sentenceID      voice   cor_incor       n_s     soundfile       picture stimtrigger     RT      RC
    3       s356    v1      c       n       s356v1c.wav     p1n.jpg 11      388     1       1       1
    3       s331    v4      c       n       s331v4c.wav     p4n.jpg 14      60      1       2       2
    3       s001    v2      c       n       s001v2c.wav     p2n.jpg 12      35      1       3       3
    ```

    So that sentenceID + voice + cor_incor + ".wav" = soundfile

    Returns True if the trial is consistent, False if not.

    Arguments
    ----------
    trial: dict
        a trial given by the log file (a line turned into dictionary)
    """

    code = trial["sentenceID"] + trial["voice"] + trial["cor_incor"]
    from_file_code = trial["soundfile"].replace(".wav", "")
    if code == from_file_code:
        return True
    else:
        return False


def redefine_log_keys(trial: dict):
    """This function redefines the keys for the log dictionary

    Arguments
    ----------
    trial: dict
        trial of the experiment
    """

    result = {}
    result["subject"] = int(trial["subject"])
    result["audio_code"] = int(trial["sentenceID"].replace("s", ""))
    result["correct"] = True if trial["cor_incor"] == "c" else False
    result["scrambled"] = True if trial["n_s"] == "s" else False
    result["audio_file"] = trial["soundfile"]
    result["picture_file"] = trial["picture"]
    result["face_code"] = int(trial["stimtrigger"])

    return result


def experiment_crosscheck(
    marker_object: object, log_object: object, force: bool = False
    ):
    """This methods checks the number of trials between the log file
    and the marker file (object now) to see if they are consistent
    or there are a different number of segments, in which case a
    trial by trial verification will begin. This verification can
    also be forced by passing the right argument to the function.

    The way this crosscheck works is by checking whether or not there is
    a difference in the number of trials in the log object and in the
    marker object and, if so, checking trial by trial the face codes.
    If the face codes are different, then checks the next entry of the
    object with most entries to see if there is a match in the face
    codes (which could be a coincidence and the matching would be an
    error but the probability is very low since two consecutive trials
    do not actually have the same face code) the trial is deleted from
    the object with most trials. If the next face code does not match,
    check does nothing, and that is something we have to review manually

    Arguments
    ----------
    marker_object: BrainvisionMarker
        the marker object for the experiment
    log_object: BrainvisionLog
        the log object for the experiment
    force: bool
        if force is set to True a trial by trial verification will
        be done no matter what.
    """

    # Find the difference in the number of trials (segments) between
    # the marker object and the log object.
    # If difference > 0 there are more segments in the log object, if
    # it is < 0, the marker object has more segments
    # FIXME: The method is not really good.

    difference = (log_object.number_of_trials
                - marker_object.number_of_segments)

    if difference != 0 or force == True:
        logging.warning("The difference of trials between the "
                        + "marker object and the log object is "
                        + str(abs(difference)))
        problematic_idx = []

        if difference > 0:
            min_segments = marker_object.number_of_segments
        else:
            min_segments = log_object.number_of_trials

        # Some definitions to help with the check
        log_face = lambda index: log_object.trials[index]["face_code"]
        marker_face = lambda index: marker_object.marker_segments[index]["face_code"]

        def recursive_comparison(log_idx: int, marker_idx: int):
            """Compares face codes of the marker object and face object
            recursively, checking for a match"""
            try:
                assert log_face(log_idx) == marker_face(marker_idx)
                return log_idx, marker_idx
            except AssertionError:
                redundant_comparison(log_idx+1, marker_idx+1)
            except IndexError:
                return None

        for idx in range(min_segments):
            try:
                assert log_face(idx) == marker_face(idx)

            except AssertionError:
                problematic_idx.append(idx)
                no_fallback = False

                logging.warning(f"Trial with index {idx} has different"
                                + f"face codes in log and marker files."
                                + f" LOG: {log_face(index)} ;"
                                + f" MARKER: {marker_face(index)}")

                if difference > 0:  # Log object has more trials than marker obj
                    # Check if the next trial in the log corresponds to
                    # this segment in the marker object
                    if log_face(idx+1) == marker_face(idx):
                        logging.warning("Entry on log file is incorrect."
                                        + " Next entry corresponds with"
                                        + " the one from marker file.")
                        del log_object.trials[idx]
                        logging.warning("Entry deleted successfully.")
                        difference -= 1
                    else:
                        no_fallback = True
                        # FIXME: No real fallback

                elif difference < 0:  # Marker obj has more trials
                    # Same as before but the other way around
                    if log_face(idx) == marker_face(idx+1):
                        logging.warning("Entry on log file is incorrect."
                                        + " Next entry corresponds with"
                                        + " the one from marker file.")
                        del marker_object.marker_segments[idx]
                        logging.warning("Entry deleted successfully.")
                        diffrence += 1
                    else:
                        no_fallback = True
                        # FIXME: No real fallback

                else:
                    logging.critical("Same number of trials but face "
                                    + "codes are different.")
                    no_fallback = True
                    # FIXME: No real fallback

                if no_fallback:
                    print(f"IDX {idx} diff facecodes and no next "
                        + "option available.")
                    if input("Want to remove from both objects? [y/n]") == "y":
                        print("Deleting and continuing.")
                        del(log_object.trials[idx])
                        del(marker_object.marker_segments[idx)
                    else:
                        print("Exiting with error...")
                        sys.exit(0)

            except IndexError:
                problematic_idx.append(idx)
                # Start deleting entries for the other object until match is found
                if difference < 0:
                    logging.warning("Index out of range for log object."
                                    + " Deleting marker obj entries.")
                    del marker_object.marker_segments[idx]
                    logging.warning("Deleted successfully")
                    difference += 1
                elif difference > 0:
                    logging.warning("Index out of range for marker obj."
                                    + " Deleting log obj entries.")
                    del log_object.trials[idx]
                    logging.warning("Deleted successfully")
                    difference -= 1
                idx -= 2  # next iteration will review previous

    logging.warning(f"Problematic indeces pre-correction: {problematic_idx}")
    logging.warning(f"Difference level: {difference}")

# To get the files, we use glob, sorting them to avoid problems.
file_formats= (("headers", ".vhdr"),
                # ("markers", ".vrmk"),
                # ("data", ".dat"),
                ("logs", ".txt"))
file_paths= {}

for name, ending in file_formats:
    file_paths[name]= sorted(glob.glob(os.path.join(data_folder,
                                                        "*" + ending)))

# Create progress bar to make script more friendly
bar= Bar('Segmenting data', max=len(file_paths["headers"])*2)

# Iterate until no more files are left
while len(file_paths["headers"]) > 0:
    bar.next()
    current_files= synched_pop(file_paths)
    wrapper= BrainvisionWrapper(current_files["headers"],
                                    current_files["logs"])
    wrapper.log.redefine_values(redefine_log_keys)
    wrapper.log.check_inner_trial_consistency(check_speech_codes)
    experiment_crosscheck(wrapper.vmrk, wrapper.log)
    wrapper.segment_data()
    wrapper.save_segmented_data(segment_folder)
    bar.next()
bar.finish()
