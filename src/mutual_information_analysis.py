#!/usr/bin/env python3

"""This script calculates the mutual information between EEG segments
stored in .json files (given by segment_data.py) and audio files. And
exports it in .json files and a little resport in an .md file.

Three arguments are required when calling the script:
 - the folder where the eeg segments are stored in the correct format
 - the folder where the audio files are stored (.wav format)
 - the folder where the results will be exported

Functions
----------

TODO: Continue documentation!!!
FIXME: Make script work
"""

import copy

import os
import re
import sys
import glob
import logging
import numpy as np

from scipy.io import wavfile
from scipy import signal as snl
from scipy import stats as stats
from utils import check_directory

# Logging to debug the script
logging.basicConfig(level=logging.DEBUG,
                    format=" %(asctime)s - %(levelname)s - %(message)s")


def bw4_bandpass(lowcut, highcut, fs, order=4):
    """Create a Butterworth bandpass filter.

    Arguments
    ----------
    lowcut: int
        the low end of the bandpass filter (in Hz) (gain = 1/sqrt(2))
    highcut: int
        the high end of the bandpass filter (in Hz) (gain = 1/sqrt(2))
    fs: int
        sampling rate (in Hz) (for audio files it is usual to be 44.1kHz)
    order: int
        order of the Butterworth filter

    Returns
    ----------
    b, a: Arguments required for a Butterworth filter application
    """

    nyq = 0.5 * fs      # Nyquist condition
    low = lowcut / nyq
    high = highcut / nyq
    b, a = snl.butter(order, [low, high], btype="band")
    return b, a


def bw4_bandpass_filter(data, lowcut, hightcut, fs, order=4):
    """Create and apply a Butterworth bandpass filter to given data.

    Arguments
    ----------
    data: numpy array / list
        the time series to apply the filter to
    lowcut: int
        the low end of the bandpass filter (in Hz) (gain = 1/sqrt(2))
    highcut: int
        the high end of the bandpass filter (in Hz) (gain = 1/sqrt(2))
    fs: int
        sampling rate (in Hz) (for audio files it is usual to be 44.1kHz)
    order: int
        order of the Butterworth filter

    Returns
    ----------
    y: bandpassed data
    """

    b, a = bw4_bandpass(lowcut, hightcut, fs, order=order)
    y = snl.filtfilt(b, a, data)
    return y


def bandpass_channels(channels, fs, band_ranges_dict, order=3):
    """Given a dictionary containing the EEG voltage values for the
    different channels, applies a bandpass to each channel and saves
    each band's channels in a different dictionary inside an all-
    encompassing dictionary.

    Arguments
    ----------
    channels: dict
        dictionary containing the channels
    fs: frequency
    band_ranges_dict: dict
        a dictionary containing tuples with the frequency ranges and
        names for the bands/ranges as keys
    order: int
        order fot eh butterworth filter

    Returns
    ----------
    bp_channels: dict
        contains the bandpassed channels
    """

    bp_channels = {}  # bandpassed channels
    for band, limits in band_ranges_dict.items():
        bp_channels[band] = {}
        for channel, data in channels.items():
            bp_channels[band][channel] = bw4_bandpass_filter(
                data, limits[0], limits[1], fs, order=order)
    return bp_channels


def hilbert_envelope(data):
    """Returns the envelope of the given time series by applying the
    Hilbert transform and obtaining its absolute value.

    Arguments
    ----------
    data: numpy array / list
        given data to obtain the envelope
    """
    return np.abs(snl.hilbert(data))


def multiple_envelopes(list_of_time_series):
    """Given a list containing different time series, the function
    creates an envelope for each data series and then creates a mean
    envelope of all of them.

    Arguments
    ----------
    list_of_time_series: list
        list of numpy arrays or lists containing time series data

    Returns
    ----------
    mean_envelope: numpy array
    envelopes: list containing numpy arrays
    """

    envelopes = []
    for band in band_list:
        envelopes.append(hilbert_envelope(band))
    envelopes = np.array(envelopes)
    mean_envelope = envelopes.mean(axis=0)
    return mean_envelope, envelopes


def normalize_angle(angle):
    """Maps an angle (given in degrees) into the [-pi,pi) range (given
    in radians)

    Arguments
    ----------
    angle: float
        angle in degrees

    Returns
    ----------
    new_angle: float
        angle in the [-pi,pi) range in randians
    """

    new_angle = angle
    while new_angle < -180:
        new_angle += 180
    while new_angle >= 180:
        new_angle -= 180
    new_angle = new_angle/180 * np.pi

    return new_angle


def str_to_bool(bool_in_str):
    """Translate string "true" or "false" values to the corresponding
    boolean values

    Arguments
    ----------
    bool_in_str: str
        writter str containing the boolean value

    Returns
    ----------
    bool
    """

    if bool_in_str.strip().lower() == "true":
        return True
    elif bool_in_str.strip().lower() == "false":
        return False
    else:
        raise ValueError("Could not read whether true or false was written")


def dump_eye_channels(channels_dict):
    """Given a dictionary containing the EEG data with the labels being
    the channel names, deletes the records regarding the eye channels.
    Works IN-PLACE.

    Arguments:
    ----------
    channels_dict: dict
        Dictionary containing the EEG data

    Returns
    ----------
    None
    """
    for label in ["HEOG", "HEOG+", "VEOG", "VEOG+"]:
        if label in channels_dict.keys():
            del channels_dict[label]


def crop_trial(trial_dictionary, start, end, inplace=False):
    """This function crops the trial eeg data to the length given by
    the data positions.

    Arguments
    ----------
    trial_dictionary: dict
        dictionary containing the info of a trial. The key
        "channels" is used.
    start: int
        start position. Included in the cropped version.
    end: int
        end position. Included in the cropped version.
    inplace: bool
        if inplace = True the dictionary will be modified, if it is
        set to false, a new dictionary will be used.

    Returns
    ----------
    new_trial_dictionary: dict (only if inplace = False)
    """

    if inplace:
        for key, values in trial_dictionary["channels"].items():
            trial_dictionary["channels"][key] = values[start:end]
        return None
    else:
        new_dict = copy.deepcopy(trial_dictionary)
        del new_dict["channels"]
        new_dict["channels"] = {}
        for key, values in trial_dictionary["channels"].items():
            new_dict["channels"][key] = values[start:end]
        return new_dict


def crop_trial_to_audio(trial_dictionary, inplace=False):
    """This function crops the trial eeg data to the length of the
    audio track.

    Arguments
    ----------
    trial_dictionary: dict
        dictionary containing the info of a trial. The keys
        "channels", "audio_start_position" and "audio_end_position"
        are used.
    inplace: bool
        if inplace = True the dictionary will be modified, if it is
        set to false, a new dictionary will be used.

    Returns
    ----------
    new_trial_dictionary: dict (only if inplace = False)
    """

    audio_start = trial_dictionary["audio_start_position"]
    audio_end = trial_dictionary["audio_end_position"]

    new_dict = crop_trial(trial_dictionary, audio_start, audio_end,
                          inplace)

    return None if inplace else new_dict


def subtract_reference(channels, reference_label="M1", rm_ref=False,
                       inplace=False):
    """This method subtracts the reference electrode from the rest of 
    electrodes, making it the new reference. Standard is M1.
    Deletes the reference channel afterwards if rm_ref = True

    Arguments
    ----------
    channels: dict
        dictionary containing all the channels for which the reference
        is going to be subtracted
    reference_label: str
        key of the channel that will be the new reference
    rm_ref: bool
        whether to remove the channel that acts as reference or not.
    inplace: bool
        if True it will change the channels in place, if False a new
        dictionary will be returned

    Returns
    ----------
    new_dict: dict
        new dictionary containing re-referenced data (if inplace = False)
    """
    if inplace:
        for key in channels.keys():
            if key != reference_label:
                channels[key] = channels[key] - channels[reference_label]
        if rm_ref == True:
            del(channels[reference_label])

    else:
        new_dict = {}
        for key in channels.keys():
            if key != reference_label:
                new_dict[key] = channels[key] - channels[reference]


def calculate_entropy(histogram):
    """Given an histogramogram from time-series discretized data calculate 
    the probabilities for each of the bins and the entropy of the time
    series.

    Arguments
    ----------
    histogram: numpy array or list
        its length is the number of bins and each element is equal to 
        the number of elements in it

    Returns
    ----------
    entropy: float
    probabilities: list
    """
    total_sum = sum(histogram)
    probabilities = np.zeros(len(histogram))  # Allocate memory for probs
    entropy = 0

    for iter in range(len(histogram)):
        probabilities[iter] = histogram[iter] / total_sum
        entropy -= probabilities[iter] * np.log2(probabilities[iter])

    return entropy, probabilities


def calculate_joint_probabilties(histogram1, histogram2):
    """Given two histograms calculates the joint probabilities of their
    elements.

    Arguments
    ----------
    histogram1: numpy array or list
        its length is the number of bins and each element is equal to 
        the number of elements in it
    histogram2: numpy array or list
        its length is the number of bins and each element is equal to 
        the number of elements in it

    Returns
    ----------
    probs12: numpy array of joint probabilities
    """

    total_sum = sum(histogram1) + sum(histogram2)
    probs12 = np.zeros([len(histogram1), len(histogram2)])

    for iter1 in range(len(histogram1)):
        for iter2 in range(len(histogram2)):
            probs12[iter1, iter2] = (
                histogram1[iter1] + histogram2[iter2])/total_sum

    return probs12


def hist_mutual_info(histogram1, histogram2):
    """Given two histograms from different time-series calculate the 
    mutual information value between the two.

    Arguments
    ----------
    histogram1 and histogram2: numpy array or list
        their length is the number of bins and each element is equal to 
        the number of elements in it

    Returns
    ----------
    int (mutual information value)
    """

    # Since the mutual information equation is symetric on the entropy
    # value, we just save the entropy for the first one

    entropy1, probabilities1 = calculate_entropy(histogram1)
    _, probabilities2 = calculate_entropy(histogram2)
    joint_probabilities = calculate_joint_probabilties(histogram1,
                                                       histogram2)

    cumulative_sum = 0
    for iter1 in range(len(probabilities1)):
        for iter2 in range(len(probabilities2)):
            iter_log = np.log2(joint_probabilities[iter1, iter2] /
                               (probabilities1[iter1]*probabilities2[iter2]))
            cumulative_sum += joint_probabilities[iter1, iter2] * iter_log

    return entropy1 - cumulative_sum


def compute_phase_MI(audio_data, audio_fs: int, segment_dict: dict, phase_binning,
                     bands_dict: dict, channels_list: list, from_stim=False):
    """Compute the Mutual Information between the audio file and the 
    EEG data in the segment file. A bandpass filter is applied before
    the data is binned. After binning probabilities and entropies are
    calculated and then, mutual information between the audio file and
    the EEG is calculated.

    Arguments
    ----------
    audio_data: array
        audio data from the audio files
    audio_fs: int
        frequency of the audio sample
    segment_dict: dict
        dictionary of the given segment. Has to contain bandpassed data
    phase_binning: list / numpy array
        array containing the limits of the bins of the phases which will
        be used to calculate the probabilities.
    bands_dict: dictionary
        dictionary containing the bands' edges, used for the filters
    from_stim: bool
        if True the segment will be cut from the target word

    Returns
    ----------
    mi_results: dict of dicts (bands > channels > MI value)
    """
    # Get the analytic signals
    analytic_audio = snl.hilbert(audio_data)
    analytic_eeg = {}
    for band in segment["bp_channels"].keys():
        analytic_eeg[band] = {}
        for channel, signal in segment["bp_channels"][band].items():
            analytic_eeg[band][channel] = snl.hilbert(signal)

    # If you want to analyse the data from the stimulus, we cut the data.
    # It is done after bandpassing and hilber transform to minimise border effects
    if from_stim:
        new_eeg_start = segment.audio_stim_point
        # proportional start for the audio, Fpz as sample channel, no real reason
        audio_start = (new_eeg_start //
                       len(segment.channels["Fpz"]))*len(analytic_audio)
        analytic_audio = analytic_audio[int(audio_start):]
        for band in analytic_eeg.keys():
            for channel in analytic_eeg[band].keys():
                analytic_eeg[band][channel] = analytic_eeg[band][channel][int(
                    new_eeg_start):]

    # Now, remember that the instant phase is the angle of the
    # analytic signal, the instant amplitude, or envelope,
    # is the absolute value of the analytic signal and the
    # instant frequency is the first derivative of the instant
    # phase.
    hist_audio_phase, _ = np.histogram(np.angle(analytic_audio),
                                       bins=phase_binning)
    mi_results = {}
    for band in segment["bp_channels"].keys():
        mi_results[band] = {}
        for channel, signal in segment["bp_channels"][band].items():
            hist_eeg_phase, _ = np.histogram(np.angle(analytic_eeg[band][channel]),
                                             bins=phase_binning)

            # Calculate Mutual Information
            mi_results[band][channel] = hist_mutual_info(hist_eeg_phase,
                                                         hist_audio_phase)

    # Return the mi_results between the signals
    return mi_results


def compile__mi_dict(new_data_dict, compiled_dict={}):
    """Puts the values of a dict containing MI values into a new dict 
    that compiles values for similar dicts. E.g. Dict with values gets 
    put in dict with lists.

    Arguments
    ----------
    new_data_dict: dict
        Dictionary containing new data to be added to the compiled dict
    compiled_dict: dict
        Dictionary with a similar schema to the new_data_dict. A new 
        dict can be created if this argument is left blank, so that the
        output of this first run can be used for later additions

    Output
    ----------
    compiled_dict: dict
    """
    new_dict = False
    if compiled_dict == {}:
        new_dict = True

    for band in new_data_dict.keys():
        if new_dict:
            compiled_dict[band] = {}
        for channel in new_data_dict[band].keys():
            if new_dict:
                compiled_dict[band][channel] = []
            compiled_dict[band][channel].append(new_data_dict[band][channel])

    return compiled_dict


def main(segments_folder_path, audio_files_folder_path, results_folder_path):
    # Define constants for the analysis
    freq_ranges = {"delta": (1, 3), "theta_low": (3, 5),
                   "theta_high": (5, 7), "alpha": (7, 12),
                   "beta": (12, 30), "gamma_low": (30, 50),
                   "gamma_high": (50, 100)}
    band_names = list(freq_ranges.keys())
    freq_limits = [1, 3, 5, 7, 12, 30, 50, 100]
    channels = ['Fp1', 'Fpz', 'Fp2', 'AF7', 'AF3', 'AF4', 'AF8', 'F7',
                'F5', 'F3', 'F1', 'Fz', 'F2', 'F4', 'F6', 'F8', 'FT7',
                'FC5', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'FC6', 'FT8',
                'T7', 'C5', 'C3', 'C1', 'Cz', 'C2', 'C4', 'C6', 'T8',
                'TP7', 'CP5', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4', 'CP6',
                'TP8', 'P7', 'P5', 'P3', 'P1', 'Pz', 'P2', 'P4', 'P6',
                'P8', 'PO7', 'PO3', 'PO4', 'PO8', 'O1', 'Oz', 'O2',
                'HEOG+', 'HEOG', 'VEOG+', 'VEOG', 'M1']
    phs_lims = np.linspace(-np.pi, np.pi, 5)

    # Get folder paths
    segments_folder = check_directory(segments_folder_path)
    audio_files_folder = check_directory(audio_files_folder_path)
    results_folder = check_directory(results_folder_path)

    # Get the file paths
    file_formats = (("segments", ".json", segments_folder),
                    ("audios", ".wav", audio_files_folder))
    file_paths = {}

    for name, ending, folder in file_formats:
        file_paths[name] = glob.glob(os.path.join(folder, "*" + ending))

    # Create progress bar for the script to be friendly
    bar = Bar('Computing MI', max=len(file_paths["headers"])*2)

    # Iterate over all segment files
    for path in file_paths["segments"]:
        with open(path, "r") as segment_file:
            # Load segment and check if audio file exists in given folder
            segment = json.load(segment_file)
            audio_path = os.path.join(audio_files_folder,
                                      segment["audio_file_name"])
            try:
                assert audio_path in file_paths["audios"]
            except AssertionError:
                print(f"{audio_path} not found in folder, continuing...")
                continue

            # Start with the pre-processing
            crop_trial_to_audio(segment, inplace=True)
            subtract_reference(segment["channels"], inplace=True)
            segment["bp_channels"] = bandpass_channels(
                segment["channels"], 250, freq_ranges)
            audio_fs, audio_data = wavfile.read(audio_path)

            # Compute mutual information
            # TODO: Add automatic classification of categories
            # FIXME: Classification is not working, cannot do variance tests on this
            mi_factor = {}
            mi_result = compute_phase_MI(audio_data, audio_fs, segment,
                                         phs_lims, freq_ranges)
            mi_cumulative_results = compile__mi_dict(
                mi_result, mi_cumulative_results)
        bar.next()
    bar.finish()
    return mi_cumulative_results


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("There should be 3 arguments passed. Check docs.")
        sys.exit(1)

    main(sys.argv[1], sys.argv[2], sys.argv[3])


y1, probs1 = calculate_entropy(histogram1)
_, probs2 = calculate_entropy(histogram2)
# probs12 = np.outer(probs1, probs2)
probs12 = joint_probs(histogram1, histogram2)


def is_face(self):
    """Returns boolean. True if subject was shown
    a face during this trial, False if not"""

    if face_code[0] == "1":
        return True
    else:
        return False


def is_face_kw(self):
    """Returns a string. If the subject was shown
    a face during the trial returns "face", else
    returns "scrambled" """

    if face_code[0] == "1":
        return "face"
    else:
        return "scrambled"


def is_correct(self):
    """Returns boolean. True if the sentence is correct,
    False if the sentence is incorrect"""

    if audio_code[0] == "1":
        return True
    else:
        return False


def is_correct_kw(self):
    """Returns a string. If the sentence was correct
    returns "correct". If not, returns "incorrect"""

    if audio_code[0] == "1":
        return "correct"
    else:
        return "incorrect"


def __facecheck__(self):
    if face_code[0] == "1":
        face_nonscrambled = True
    elif face_code[0] == "2":
        self.face_nonscrambled = False
    else:
        self.face_nonscrambled = "error"


def __audiocheck__(self):
    if self.audio_code[0] == "1":
        self.audio_corr = True
    elif self.audio_code[0] == "2":
        self.audio_corr = False
    else:
        self.audio_corr = "error"


def save(self, file_path):
    with open(file_path, "w") as mifile:
        header = "Subject: " + str(self.subject) +  \
            " SegmentNumber: " + str(self.segment_number) + \
            " FaceCode: " + str(self.face_code) + \
            " Nonscrambled: " + str(self.face_nonscrambled) + \
            " AudioCode: " + str(self.audio_code) + \
            " AudioCorr: " + str(self.audio_corr) + \
            " AudioFile: " + str(self.audio_file) + \
            " Mode: " + str(self.mode) + "\n"
        channels_info = "Channels>>>" + str(self.channels_labels) + "\n"
        bands_info = "Bands>>>" + str(self.bands_dict) + "\n"
        discret_info = "Discretization>>>" + \
            str(self.discretization) + "\n"
        comments = "Comments>>>" + str(self.comments) + "\n"
        spacer = "---" + "\n"
        meta2save = [header, channels_info,
                     bands_info, discret_info, comments, spacer]
        data2save = []
        for band in self.mi.keys():
            line2save = str(band) + ":"
            for channel in self.channels_labels:
                line2save += " " + str(self.mi[band][channel])
            data2save.append(line2save + "\n")

        mifile.writelines(meta2save)
        mifile.writelines(data2save)


def load(self, file_path):
    """This method is used to load a mi file"""

    self.segment = "loaded"

    with open(file_path) as mifile:
        self.mi = {}
        for line in mifile:
            try:  # First metadata line
                self.subject
            except AttributeError:
                splitline = line.split(" ")
                self.subject = splitline[1]
                self.segment_number = splitline[3]
                self.face_code = splitline[5]
                self.face_nonscrambled = str_to_bool(splitline[7])
                if self.face_nonscrambled == "error":
                    self.__facecheck__()
                self.audio_code = splitline[9]
                self.audio_corr = str_to_bool(splitline[11])
                if self.audio_corr == "error":
                    self.__audiocheck__()
                self.audio_file = splitline[13]
                self.mode = splitline[15]
                continue

            try:
                self.channels_labels
            except AttributeError:
                self.channels_labels = eval(
                    line.replace("\n", "").split(">>>")[-1])
                continue

            try:
                self.bands_dict
            except AttributeError:
                self.bands_dict = eval(
                    line.replace("\n", "").split(">>>")[-1])
                continue

            try:
                self.discretization
            except AttributeError:
                self.discretization = [
                    float(num) for num in re.findall("-?\d*\.\d*", line)]

            try:
                self.comments
            except AttributeError:
                self.comments = line.replace("\n", "").split(">>>")[-1]
                continue

            if "---" in line:
                continue

            splitline = line.replace("\n", "").split(" ")
            band = splitline[0][:-1]
            self.mi[band] = {}  # Band dict creation
            splitline = splitline[1:]
            for index in range(len(splitline)):
                self.mi[band][self.channels_labels[index]
                              ] = splitline[index]


logging.debug("Start iterating over segments \n \n")
for sgmnt in segment_file_paths:
    sgmnt_name = sgmnt.split("/")[-1].split(".")[0]
    logging.debug("-- Going over '" + sgmnt_name + "' --")

    # Load EEG and do some basic cleanup
    logging.debug("Create MutualInformation object.")
    arguments = {"segment_path": sgmnt, "mode": "phase", "discretization": phs_lims,
                 "bands_dict": freq_ranges, "comments": "MI between EEG and audio"}
    mi = pr.MutualInformation()
    mi.load_segment(**arguments)

    # Re-reference the segment
    # for channel in channels:
    #    mi.segment.channels[channel] = mi.segment.channels[channel] - (mi.segment.channels["M1"]/2)

    # Re-reference point by point average (without eyes)
    logging.debug("Reference by avg")
    mi.segment.dump_eyes()
    channels = list(mi.segment.channels.keys())
    point_mean = np.array(list(mi.segment.channels.values())).mean(axis=0)
    for channel in mi.segment.channels.keys():
        mi.segment.channels[channel] -= point_mean

    # Find the file with the speech of the trial
    speech_audio_path = multimedia_folder_path + mi.segment.audio_file

    logging.debug("Create AudioStim object using downsampled audio.")
    speech_audio_path = speech_audio_path.replace(".wav", "_ds8.wav")
    audio = pr.AudioStim(speech_audio_path)

    # Compute MI between EEG and speech
    logging.debug("Compute mutual information.")
    mi.compute(audio.data, audio.rate, dump_eyes=False, from_stim=True)
    mi.save(mi_folder_path + sgmnt_name + ".mi")

    # Add it to either face or scrambled distributions
    logging.debug("Add values to cumulative data distributions")

    for band in bands:
        for channel in channels:
            if mi.face_nonscrambled:
                cumdata["face"][band][channel].append(mi.mi[band][channel])
            else:
                cumdata["scrambled"][band][channel].append(
                    mi.mi[band][channel])
            if mi.audio_corr:
                cumdata["correct"][band][channel].append(mi.mi[band][channel])
            else:
                cumdata["incorrect"][band][channel].append(
                    mi.mi[band][channel])

# Save cumdata as json
with open("cumdata.json", "w") as jsonfile:
    json.dump(cumdata, jsonfile)

# Calculate mean and std values for MI for each channel
logging.debug("Starting to calculate mean values")

stats = {"face": {}, "scrambled": {}, "correct": {}, "incorrect": {}}
for key in stats.keys():
    stats[key] = {}
    for band in bands:
        stats[key][band] = {}
        for channel in channels:
            stats[key][band][channel] = {}
            stats[key][band][channel]["mean"] = np.mean(
                cumdata[key][band][channel])
            stats[key][band][channel]["std"] = np.std(
                cumdata[key][band][channel])

# Find differences in MI between scrambled and non-scrambled
logging.debug("Differences...")
MI_difference = {}

MI_difference = {}
for key1, key2 in [("face", "scrambled"), ("correct", "incorrect")]:
    type_key = key1 + "_vs_" + key2
    MI_difference[type_key] = {}
    for band in bands:
        MI_difference[type_key][band] = {}
        for channel in channels:
            MI_difference[type_key][band][channel] = stats[key1][band][channel]["mean"] - \
                stats[key2][band][channel]["mean"]
            MI_difference[type_key][band][channel] = MI_difference[type_key][band][channel] / \
                stats[key1][band][channel]["mean"]

logging.debug("Saving data to files...")

# Save MI_diff and MI_rel as json file too
with open("MI_difference.json", "w") as jsonfile:
    json.dump(MI_difference, jsonfile)

# Use kruskal-wallis and ANOVA for analysis
logging.debug("Doing the KW analysis...")
kruskal = {}
for band in bands:
    kruskal[band] = {}
    for channel in channels:
        kruskal[band][channel] = stat.kruskal(
            cumdata["face"][band][channel], cumdata["scrambled"][band][channel])

logging.debug("Saving analysis...")
with open("kruskal_wallis.json", "w") as jsonfile:
    json.dump(kruskal, jsonfile)

input("Waiting for you to close the program...")
