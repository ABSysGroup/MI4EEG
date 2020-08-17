""" This file contains the major part of the preprocessing of the EEG and experiment
data exported by brainvision. Mainly it has the potential to take several subjects' files
and chop them into neatly organised segments for further processing.
If run as main, will process data in a given folder.
Won't run in other enviroment that's not windows.

TODO: Add documentation!!!
"""

# Import libraries
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import logging
import glob
import sys
import re
import os

# Import signal processing
from scipy.io import wavfile
from scipy import signal as snl

# Logging to debug the script
logging.basicConfig(level=logging.DEBUG,
                    format=" %(asctime)s - %(levelname)s - %(message)s")

# logging.disable(logging.CRITICAL)

logging.debug("Define classes and functions.")

# Define some classes and functions to make easier the work later on


def str_to_bool(s):
    if s == "True":
        return True
    elif s == "False":
        return False
    else:
        raise ValueError


def segment_line(line):
    """Obtain markers for the experiments from the markers file
    Returns a tuple with the following info:
    Marker number, marker type, marker description, marker data point position,
    marker data points size, marker channels (0 if all of them)
    """
    split_line = line.split("=")
    rest = split_line[1].split(",")
    return int(split_line[0][2:]), rest[0], rest[1], int(rest[2]), int(rest[3]), rest[4]


def facecode(filename):
    """ Translates the string facestim id to the numerical ones """
    faceid = filename[1]
    if filename[2] == "n":
        scr = "1"
    elif filename[2] == "s":
        scr = "2"
    facecode = scr + faceid
    return int(facecode)


def bw4_bandpass(lowcut, highcut, fs, order=4):
    """
    Create a butterworth bandpass filter.
    Usage:
        lowcut: the low end of the band (gain = 1/sqrt(2))
        highcut: the high end of the band (gain = 1/sqrt(2))
        fs: sampling rate (44100Hz)
        order: order of the butterworth filter
    """

    nyq = 0.5 * fs      # Nyquist condition
    low = lowcut / nyq
    high = highcut / nyq
    b, a = snl.butter(order, [low, high], btype="band")
    return b, a


def bw4_bandpass_filter(data, lowcut, hightcut, fs, order=4):
    """
    Apply a butterworth bandpass filter to data
    Usage:
        data: data
        lowcut: the low end of the band (gain = 1/sqrt(2))
        highcut: the high end of the band (gain = 1/sqrt(2))
        fs: sampling rate (44100Hz)
        order: order of the butterworth filter
    """

    b, a = bw4_bandpass(lowcut, hightcut, fs, order=order)
    y = snl.filtfilt(b, a, data)
    return y


def bandpass_filter_check(lowcut, highcut, numcuts):
    """
    Tanken from sample over the internet
    to check the bandpass
    """
    # Sample rate and desired cutoff freqs (in Hz)
    fs = 44100
    # lowcut = 500
    # highcut = 1250

    # Plot the frequency response for a few different orders
    plt.figure(1)
    plt.clf()
    cochlear_tuples = cochlear_space(lowcut, highcut, numcuts)
    for item in cochlear_tuples:
        # for order in [2, 4, 6, 8]:
        if item[1] < 500:
            order = 3
        else:
            order = 4
        b, a = bw4_bandpass(item[0], item[1], fs, order=order)
        w, h = snl.freqz(b, a, worN=2000)
        plt.plot((fs * 0.5 / np.pi) * w, abs(h),
                 label="Segment = {0}, order {1}".format(item, order))
    plt.plot([0, 0.5 * fs], [np.sqrt(0.5), np.sqrt(0.5)],
             "--", label="sqrt(0.5)")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Gain")
    plt.title("Butterworth bandpass of different powers")
    plt.grid(True)
    plt.legend(loc="best")

    # Filter a noisy signal
    T = 0.01
    nsamples = T * fs
    t = np.linspace(0, T, nsamples, endpoint=False)
    a = 0.02
    f0 = 600
    x = 0.1 * np.sin(2*np.pi*1.2*np.sqrt(t))
    x += 0.01 * np.cos(2 * np.pi * 312 * t + 0.1)
    x += a * np.cos(2 * np.pi * f0 * t + .11)
    x += 0.03 * np.cos(2 * np.pi * 2000 * t)
    plt.figure(2)
    plt.clf()
    plt.plot(t, x, label="Noisy Signal")

    y = bw4_bandpass_filter(x, lowcut, highcut, fs, order=6)
    plt.plot(t, y, label="Filtered signal ({0} Hz)".format(f0))
    plt.xlabel("Time (s)")
    plt.hlines([-a, a], 0, T, linestyles="--")
    plt.grid(True)
    plt.axis("tight")
    plt.legend(loc="upper left")

    plt.show()


def cochlear_frequency(distance, units=None):
    """
    Given a distance, calculates the
    frequency related to that distance in the cochlea
    greenwood 1990
    Units could be:
        None: distance is given as a proportion of the basilar length
        mm: distance is given in mm
        m: distance is given in meters
    """
    A_const = 165.4  # to yield Hz

    if units == None:
        a_const = 2.1
    elif units == "mm":
        a_const = 0.06
    elif units == "m":
        a_const = 60
    else:
        print(
            "Units format passed to function not understood. Please use None, 'mm' or 'm'.")
        raise ValueError

    k_const = 1  # We'll leave it like that
    F = A_const * (10 ** (a_const * distance) - k_const)
    return F


def cochlear_distance(frequency, distance_units=None):
    """
    Calculates the cochlear distance of given
    frequency for human species. Based on
    greenwood 1990.
    """
    A_const = 165.4  # to yield Hz

    if distance_units == None:
        a_const = 2.1
    elif distance_units == "mm":
        a_const = 0.06
    elif distance_units == "m":
        a_const = 60
    else:
        print(
            "Units format passed to function not understood. Please use None, 'mm' or 'm'.")
        raise ValueError

    k_const = 0.88  # Best fit for human range (20, 20k) Hz

    # F = A_const * (10 ** (a_const * x) - k)
    distance = np.log(frequency/A_const + k_const)/np.log(10)/a_const
    return distance


def cochlear_space(lowfreq, highfreq, num, tuples=True):
    """
    Creates a number of frequency bands
    that are evenly distributed according to the
    cochlear map.
    """
    # Check if the frequencies are inside the hearing range of humans
    if lowfreq < cochlear_frequency(0):
        print("Frequency below lowest hearing frequency")
        raise ValueError
    if highfreq > cochlear_frequency(1):
        print("Frequency over highest hearing frequency")
        raise ValueError

    # Obtain the cochlear distance from the apex of the frequencies given
    lowdist = cochlear_distance(lowfreq)
    highdist = cochlear_distance(highfreq)

    # Create a linspace
    space = np.linspace(lowdist, highdist, num+1)

    # Tranform the space and return it
    cochlear_space = cochlear_frequency(space)

    if tuples == False:
        return cochlear_space
    elif tuples == True:
        tuples_list = []
        for i in range(len(cochlear_space)-1):
            new_tuple = (cochlear_space[i], cochlear_space[i+1])
            tuples_list.append(new_tuple)
        print("Number of tuples = {0}".format(len(tuples_list)))
        return tuples_list


def cochlear_bandpass(data, lowcut, highcut, num, fs, order=4):
    """
    This creates a space according to the cochear map
    and filters the different parts of the audio data
    according to the cuts.
    Usage:
        data: data
        lowcut: the low end of the band (gain = 1/sqrt(2))
        highcut: the high end of the band (gain = 1/sqrt(2))
        num: number of intervals
        fs: sampling rate (44100Hz)
        order: order of the butterworth filter
    """

    space = cochlear_space(lowcut, highcut, num)
    bandpassed_data = []
    for step_range in space:
        bandpassed_data.append(bw4_bandpass_filter(data,
                                                   step_range[0], step_range[1], fs, order=order))
    return bandpassed_data


def hilbert_envelope(data):
    """
    Returns the envelope of an audio wave given
    by the absolute value of the hilbert transform
    of the wave
    """
    return np.abs(snl.hilbert(data))


def envelope_bands(band_list):
    """
    Creates the envelope for each of the bands
    of a given audio given by audio_bandpass
    or sth similar
    Band list must be a list of the data
    """
    envelopes = []
    for band in band_list:
        envelopes.append(hilbert_envelope(band))
    envelopes = np.array(envelopes)
    mean_envelope = envelopes.mean(axis=0)
    return mean_envelope, envelopes


def normalize_angle(angle):
    """Maps an angle (given in degrees) into the
    [-pi, pi) range (given in radians)
    """

    new_angle = angle
    while new_angle < -180:
        new_angle += 180
    while new_angle >= 180:
        new_angle -= 180
    new_angle = new_angle/180 * np.pi
    return new_angle


def hist_entropy(hist):
    """Given an histogram with the data
    calculate the entropy"""
    totaln = sum(hist)
    probs = np.zeros(len(hist))
    entropy = 0
    for iter in range(len(hist)):
        probs[iter] = hist[iter]/totaln
        entropy -= probs[iter]*np.log2(probs[iter])
    return entropy, probs


def joint_probs(hist1, hist2):
    """ Calculate joint probabilities given
    two histograms """
    totalN = sum(hist1) + sum(hist2)
    probs12 = np.zeros([len(hist1), len(hist2)])
    for iter1 in range(len(hist1)):
        for iter2 in range(len(hist2)):
            probs12[iter1, iter2] = (hist1[iter1] + hist2[iter2])/totalN
    return probs12


def hist_mutual_info(hist1, hist2):
    entropy1, probs1 = hist_entropy(hist1)
    _, probs2 = hist_entropy(hist2)
    #probs12 = np.outer(probs1, probs2)
    probs12 = joint_probs(hist1, hist2)
    cumsum = 0
    for i in range(len(probs1)):
        for j in range(len(probs2)):
            cumsum += probs12[i, j] * \
                np.log2(probs12[i, j]/(probs1[i]*probs2[j]))
    return entropy1 - cumsum


class Header(object):
    """
    Given a .vhdr file from BrainVision, reads it and extracts
    the useful information we can find within.

    Initialisation:
    Header(header_file): where header_file is the instance of the header file

    Attributes:
    self.data_file: the name of the data file where the EEG data is stored
    self.marker_file: the name of the file where the data of the markers of the experiments is stored
    self.data_orientation: wheter the data is in vectorized (ch1pt1 ch1pt2 ...) or multiplexed (ch1pt1 ch2pt1) form
    self.data_type: time or frequency domain
    self.number_channels: the number of eeg channels (taking references and oculars into account normally)
    self.datapoints: the number of points of data in each channel
    self.sampling_interval: the interval in microseconds between data points, in microseconds
    self.sampling_frequency: the frequency of the signal, in hertz
    self.decimal_symbol: the decimal symbol used in the data
    self.segmentation_type: whether or not the way to segment the data is using markers
    self.segment_datapoints: the number of markers in the experiment (?)
    """

    def __init__(self, header_file):
        for line in header_file:
            if "DataFile=" in line:
                self.data_file = line.split("=")[1][:-1]
            if "MarkerFile=" in line:
                self.marker_file = line.split("=")[1][:-1]
            if "DataOrientation=" in line:
                self.data_orientation = line.split("=")[1]
            if "DataType=" in line:
                self.data_type = line.split("=")[1]
            if "NumberOfChannels=" in line:
                self.number_channels = int(line.split("=")[1])
            if "DataPoints=" in line and not "datapoints" in locals():
                self.datapoints = int(line.split("=")[1])
            if "SamplingInterval=" in line:
                self.sampling_interval = float(line.split("=")[1])
                self.sampling_freq = 1000000 / self.sampling_interval
            if "SegmentationType=" in line:
                self.segmentation_type = line.split("=")[1]
            if "SegmentDataPoints=" in line:
                self.segment_datapoints = int(line.split("=")[1])
            if "DecimalSymbol=" in line:
                self.decimal_symbol = line.split("=")[1]


class Marker(object):
    """
    Given a .vmrk file from BrainVision, reads it and extracts
    the useful information we can find within.

    Initialisation:
    Marker(marker_file): where header_file is the instance of the marker file

    Attributes:
    self.segments: dictionaries containing information on the data segmentation. Each list represents
        a data segment, containing the following information:
            start_pos: the starting position (in data points) of the segment
            audio_start_pos: the starting position (in data points) where the audio starts playing
            audio_stim_pos: position where the right/wrong word is played
            audio_end_pos: the ending position (in data points) of the audio
            end_pos: the ending position (in data points) of the segment
            face_stim: the code of the face stimulus (2 digit code)
            audio_stim: the code of the auditory stimulus (not the file name, the 3 digit code)
            correct: whether or not the answer of the subject was correct or not
    self.segments_number: the number of segments

    Methods:
    experiment_crosscheck(subject_object): verify that the segments here are the same as the ones in the experiment info file.
        Checks all the entries until the problem has been solved
    """

    def __init__(self, marker_file):

        self.segments = []
        step = "begin"

        def new_segment():  # Create a new and clean maker holder for a segment
            x = {"start": 0, "astart": 0, "astim": 0, "aend": 0,
                 "end": 0, "fcode": 0, "acode": 0,
                 "response_correct": False}
            return x

        for line in marker_file:

            # If this is not a marker continue with the next line
            if not "Mk" in line or "Mk<" in line:
                continue

            # Put the line nicely
            tidy_line = segment_line(line)

            # Get segment start
            if step == "begin" and "New Segment" in tidy_line:
                step = "new"
                curr_segment = new_segment()
                continue

            # Search for the stimuli
            if "Stimulus" in tidy_line:
                # Obtain the face stimulus code and the data position
                if step == "new" and int(tidy_line[2][1:]) < 99:
                    curr_segment["fcode"] = int(tidy_line[2][1:])
                    curr_segment["start"] = tidy_line[3]
                    curr_segment["astart"] = tidy_line[3] + \
                        125  # 500ms at 250Hz => 125 data points
                    step = "acode"
                    continue

                # Obtain the audio stimulus code and data position
                if step == "acode" and int(tidy_line[2][1:]) > 99:
                    curr_segment["acode"] = int(tidy_line[2][1:])
                    curr_segment["astim"] = tidy_line[3]
                    step = "aend"
                    continue

                # Obtain the end of the audio stimulus
                if step == "aend" and int(tidy_line[2][1:]) == 99:
                    curr_segment["aend"] = tidy_line[3]
                    step = "answer"
                    continue

                # Obtain end of segment and append to list
                if step == "answer" and int(tidy_line[2][1:]) <= 3:
                    curr_segment["end"] = tidy_line[3]
                    curr_segment["response_correct"] = int(tidy_line[2][1:])
                    self.segments.append(curr_segment)
                    step = "begin"
                    continue

        self.segments_number = len(self.segments)

    def experiment_crosscheck(self, subject_object):

        difference = subject_object.trials_number - self.segments_number

        logging.warning("Subject - dataEEG lenght diff: " +
                        str(abs(difference)))

        problematic_idx = []
        idx = 0  # starting index

        while difference != 0:
            try:
                assert(
                    subject_object.trials[idx]["face_id"] == self.segments[idx]["fcode"])
            except IndexError:
                problematic_idx.append(idx)
                if difference < 0:
                    logging.warning(
                        "Index out of range for subject obj. Deleting dataEEG obj. entry.")
                    del self.segments[idx]
                    logging.warning("Corrected succesfuly")
                    difference += 1
                elif difference > 0:
                    logging.warning(
                        "Index out of range for dataEEG obj. Deleting subject obj. entry.")
                    del subject_object.trials[idx]
                    logging.warning("Corrected succesfuly")
                    difference -= 1
                idx -= 2  # review last index
            except AssertionError:
                problematic_idx.append(idx)
                logging.warning("Trial with index " + str(idx) + " has face_ids that do not match between both files. " +
                                "EXP: " + str(subject_object.trials[idx]["face_id"]) + " MARK: " + str(self.segments[idx]["fcode"]) + ". Deleting the entry from the file with most entries.")
                if difference > 0:
                    if subject_object.trials[idx+1]["face_id"] == self.segments[idx]["fcode"]:
                        logging.warning(
                            "Incorrect trial on subject object. Deleting entry.")
                        del subject_object.trials[idx]
                        logging.warning("Corrected succesfully")
                        difference -= 1
                elif difference < 0:
                    if subject_object.trials[idx]["face_id"] == self.segments[idx+1]["fcode"]:
                        logging.warning(
                            "Incorrect trial on dataEEG object. Deleting entry.")
                        del self.segments[idx]
                        logging.warning("Corrected succesfully")
                        difference += 1
                elif difference == 0:
                    logging.critical(
                        "Same number of trials but faces still different!")
                    break

            if difference == 0:
                logging.warning("Differences reduced to zero.")
                break   # breaks for loop

            idx += 1

        logging.warning(
            "Problematic indeces pre-correction: " + str(problematic_idx))
        logging.warning("Difference level: " + str(difference))


class DataEEG(object):
    """
    Given a data file in VECTORIZED form (careful with this), it puts the data into a dictionary

    Attributes:
    self.channels: dictionary with the channels as keys and the values as values

    Methods:
    segment_data(marker_object, release=True): segments the data of the channels. See its documentation
    """

    def __init__(self, data_file):
        # Parse the whole .dat file with the EEG data inside.
        self.channels = {}
        for line in data_file:
            key = line.split()[0]
            data = np.array([float(item)
                             for item in line.replace(",", ".").split()[1:]])
            self.channels[key] = data

    def segment_data(self, marker_object, release=True):
        """
        Given a marker object the method segments the data into the segments indicated
        by said object. 
        Creates the attribute data_segments, which is a list containing all the segments 
        (each one being a dictionary with the channels as keys and the values being lists
        with the EEG values). Also creates data_segments_number, giving the number of segments.
        If release = True, it will delete the self.channels attribute not
        to have an object with too much memory occupied.
        """
        self.data_segments = []
        for segment in marker_object.segments:
            segment_data = {}
            for key in self.channels.keys():
                segment_data[key] = self.channels[key][segment["start"]                                                       :segment["end"]]
            self.data_segments.append(segment_data)
        if release == True:
            del self.channels
        self.data_segments_number = len(self.data_segments)


class Subject(object):
    """
    Given a .txt file with the info of each trial from the experiment,
    store it in a convinient way to cross reference it with the data segments.

    Initialisation:
    Subject(experiment_file): where experiment_file is the instance of the experiment file

    Attributes:
    self.trials: list containing a dict for each trial. The keys and explanation of values are:
        subject_id: will probably be the same for each trial. ID of the subject.
        sentence_id: the ID of the sentence the subject heard
        voice: the ID of the voice that read the sentence
        correct: whether or not the sentence was sintactically correct or not
        scrambled: whether or not the shown face was scrambled
        soundfile: the soundfile that played in the background
        face_id: the ID of the face that was shown in the trial
        RT: response time from the query, in ms
    self.trials_number: number of trials
    """

    def __init__(self, experiment_file):
        self.trials = []
        for line in experiment_file:
            # Ignore the first row
            if "sentenceID" in line:
                continue

            trial = {}
            LINE = line.split()
            trial["subject_id"] = int(LINE[0])
            trial["sentence_id"] = int(LINE[1][1:])
            trial["voice"] = int(LINE[2][1:])
            if LINE[3] == "c":
                trial["correct"] = True
            else:
                trial["correct"] = False
            if LINE[4] == "s":
                trial["scrambled"] = True
            else:
                trial["scrambled"] = False
            trial["soundfile"] = LINE[5]

            try:
                assert(facecode(LINE[6]) == int(LINE[7]))
                trial["face_id"] = int(LINE[7])
            except:
                logging.critical("The experiment file is broken, " +
                                 "the facestim from the same trial does not match itself. Trial n. " +
                                 str(len(trial.keys())+1))
            trial["RT"] = int(LINE[8])

            self.trials.append(trial)

        self.trials_number = int(len(self.trials))


class AudioStim(object):
    """
    A class meant to contain the audio files of the sentences
    the subject hear during the experiment.

    Initialisation:
    AudioStim(audio_file_paths): where audio_file_paths is a list with the
        paths of the audio files.

    Attributes:
    self.files: dictionary, with the keys equal to the filenames
        and the values being the audio files
    self.files_number: integer indicating the number of audio files
    self.envelope: using the hilbert tranform given by scipy.signal
        calculates the signal envelope

    Methods:
    self.amplitude_envelope(release=True): Calculates the amplitude envelope
        (self.envelope). If release=True, deletes the values from self.files
        (to make some space in the memory).
    """

    def __init__(self, audio_file_path):
        self.rate, self.data = wavfile.read(audio_file_path)

    def downsample(self, factor):
        """ Downsample the audio data by a factor of factor """

        logging.debug("Downsampling audio signal...")
        self.data = self.data[::factor]
        # self.data = snl.decimate(self.data, factor)
        self.rate = self.rate/factor
        logging.debug("Signal downsampled.")

    def save(self, path):
        """ Save to path .wav """
        wavfile.write(path, int(self.rate), self.data)


class Segment(object):
    """This class makes the usage of the segment files easier"""

    def __init__(self, file_path):
        with open(file_path, "r") as segment_file:
            self.segment_name = os.path.split(file_path)[-1].split(".")[0]
            metadata = segment_file.readline().split(" ")
            self.face_code = metadata[1]
            self.audio_code = metadata[3]
            self.audio_file = metadata[5]
            self.audio_start = 125  # 500ms after the start of the trial the audio starts
            self.audio_stim_point = int(metadata[7])
            self.audio_end = int(metadata[9])
            self.channels = {}
            for line in segment_file:
                key = line.split(" ")[0]
                self.channels[key] = np.array(
                    [float(number) for number in line.split(" ")[1:]])

    def crop_audio_trial(self, inplace=True):
        """
        This function crops the trial out given the audio_start and
        audio_end values
        """
        if inplace:
            for key, values in self.channels.items():
                self.channels[key] = values[self.audio_start:self.audio_end]
        else:
            self.cropped_channels = {}
            for key, values in self.channels.items():
                self.cropped_channels[key] = values[self.audio_start:self.audio_end]

    def bandpass_data(self, fs, band_ranges_dict, orden=3):
        self.bp_channels = {}
        for band, limits in band_ranges_dict.items():
            self.bp_channels[band] = {}
            for channel, data in self.channels.items():
                self.bp_channels[band][channel] = bw4_bandpass_filter(
                    data, limits[0], limits[1], fs, order=orden)

    def is_face(self):
        """Returns boolean. True if subject was shown
        a face during this trial, False if not"""

        if self.face_code[0] == "1":
            return True
        else:
            return False

    def is_face_kw(self):
        """Returns a string. If the subject was shown
        a face during the trial returns "face", else
        returns "scrambled" """

        if self.face_code[0] == "1":
            return "face"
        else:
            return "scrambled"

    def dump_eyes(self):
        """Deletes the channels related to eye movements.
        These channels are labelled HEOG, HEOG+, VEOG, VEOG+
        """

        for label in ["HEOG", "HEOG+", "VEOG", "VEOG+"]:
            del self.channels[label]

    def subtract_reference(self, reference_label="M1", rm_ref=False):
        """This method subtracts the reference electrode
        from the rest of electrodes. The reference electrode's
        label is the only input for the method. Standard is M1
        Deletes the reference channel afterwards if rm_ref = True
        """

        for key in self.channels.keys():
            if key != reference_label:
                self.channels[key] = self.channels[key] - \
                    self.channels[reference_label]
        if rm_ref == True:
            del(self.channels[reference_label])


class MutualInformation(object):
    def __init__(self):
        """ Initialization of object """
        pass

    def load_segment(self, segment_path, mode, discretization, bands_dict, comments):
        """ This method is used to load from a trial in a segment file path.
        It requires computing the MI later alongside the audio data.
            segment_path: the path of the segment file
            mode: the mode of calculation (phase, frequency...)
            discretization: the discretization limits
            bands_dict: a dictonary with the bandnames as keys and the limits as values
            comments: any extra comments?
        """

        self.segment = Segment(segment_path)
        self.subject = self.segment.segment_name.split("_")[1]
        self.segment_number = self.segment.segment_name.split("_")[3]

        self.face_code = self.segment.face_code
        self.__facecheck__()

        self.audio_code = self.segment.audio_code
        self.__audiocheck__()

        self.audio_file = self.segment.audio_file

        self.channels_labels = list(self.segment.channels.keys())
        self.mode = mode
        self.discretization = discretization
        self.bands_dict = bands_dict
        self.comments = comments

    def __facecheck__(self):
        if self.face_code[0] == "1":
            self.face_nonscrambled = True
        elif self.face_code[0] == "2":
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

    def compute(self, audio_data, audio_fs, crop_audio=True, dump_eyes=True, sub_ref=False):

        if self.segment == "loaded":
            print("This file was loaded from a .mi file, data's already available.")
            return None

        if dump_eyes:
            self.segment.dump_eyes()

        # Do this again to refresh
        self.channels_labels = list(self.segment.channels.keys())
        if crop_audio:
            self.segment.crop_audio_trial(inplace=True)
        if sub_ref:
            self.segment.subtract_reference(rm_ref=False)
        self.segment.bandpass_data(250, self.bands_dict, orden=3)

        # Get the analytic signals
        self.analytic_audio = snl.hilbert(audio_data)
        self.analytic_eeg = {}
        for band in self.segment.bp_channels.keys():
            self.analytic_eeg[band] = {}
            for channel, signal in self.segment.bp_channels[band].items():
                self.analytic_eeg[band][channel] = snl.hilbert(signal)

        # Now, remember that the instant phase is the angle of the
        # analytic signal, the instant amplitude, or envelope,
        # is the absolute value of the analytic signal and the
        # instant frequency is the first derivative of the instant
        # phase.

        if self.mode.lower() == "phase":
            hist_audio_phs, _ = np.histogram(
                np.angle(self.analytic_audio), bins=self.discretization)
            self.mi = {}
            for band in self.segment.bp_channels.keys():
                self.mi[band] = {}
                for channel, signal in self.segment.bp_channels[band].items():
                    histphase, _ = np.histogram(
                        np.angle(self.analytic_eeg[band][channel]), bins=self.discretization)

                    self.mi[band][channel] = hist_mutual_info(
                        histphase, hist_audio_phs)

        elif self.mode.lower() == "envelope":
            hist_audio_phs, _ = np.histogram(
                np.abs(self.analytic_audio), bins=self.discretization)
            self.mi = {}
            for band in self.segment.bp_channels.keys():
                self.mi[band] = {}
                for channel, signal in self.segment.bp_channels[band].items():
                    histphase, _ = np.histogram(
                        np.abs(self.analytic_eeg[band][channel]), bins=self.discretization)

                    self.mi[band][channel] = hist_mutual_info(
                        histphase, hist_audio_phs)

        elif self.mode.lower() == "frequency":
            hist_audio_phs, _ = np.histogram(
                np.abs(self.analytic_audio), bins=self.discretization)
            self.mi = {}
            for band in self.segment.bp_channels.keys():
                self.mi[band] = {}
                for channel, signal in self.segment.bp_channels[band].items():
                    histphase, _ = np.histogram(
                        np.abs(self.analytic_eeg[band][channel]), bins=self.discretization)

                    self.mi[band][channel] = hist_mutual_info(
                        histphase, hist_audio_phs)
            print("WIP")
            return None

        else:
            print(
                "Can't understand selected mode, please, retry with 'phase', 'envelope' or 'frequency'.")
            return None

        # Calculate phases and so on
        # fs, audio_data = wavfile.read(speech_audio_path)
        inst_phase_aud = np.angle(snl.hilbert(audio_data))
        hist_audio_phs, _ = np.histogram(
            inst_phase_aud, bins=self.discretization)

        self.mi = {}
        for band in self.segment.bp_channels.keys():
            self.mi[band] = {}
            for channel, signal in self.segment.bp_channels[band].items():
                an_signal = snl.hilbert(signal)
                instphase = np.angle(an_signal)
                histphase, _ = np.histogram(
                    instphase, bins=self.discretization)

                self.mi[band][channel] = hist_mutual_info(
                    histphase, hist_audio_phs)

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
                    self.discretization = eval(
                        line.replace("\n", "").split(">>>")[-1])
                    continue

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


def segment_all_data(data_folder_path, segments_folder_path):

    logging.debug("Start with the segment_all_data function")
    logging.debug("Define the file path lists according to the folder paths")

    if "\\" in data_folder_path:  # Adapt file paths to Windows
        header_file_paths = glob.glob(data_folder_path + r"*.vhdr")
        marker_file_paths = glob.glob(data_folder_path + r"*.vmrk")
        data_file_paths = glob.glob(data_folder_path + r"*.dat")
        experiment_file_paths = glob.glob(data_folder_path + r"*_ExpSynt.txt")
        # audio_file_paths = glob.glob(multimedia_folder_path + r"\*.wav")
        # picture_file_paths = glob.glob(multimedia_folder_path + r"\*.jpg")
    else:  # Sort the list for linux
        # Here I sort the lists because if not it will raise an error later
        header_file_paths = glob.glob(data_folder_path + "*.vhdr")
        header_file_paths.sort()
        marker_file_paths = glob.glob(data_folder_path + "*.vmrk")
        marker_file_paths.sort()
        data_file_paths = glob.glob(data_folder_path + "*.dat")
        data_file_paths.sort()
        experiment_file_paths = glob.glob(data_folder_path + "*_ExpSynt.txt")
        experiment_file_paths.sort()

    logging.debug("Start iterating over all the files \n\n")

    for j in range(len(header_file_paths)):  # Start processing by subject

        logging.info("Starting to process file " +
                     os.path.split(header_file_paths[j])[-1])

        header_file_path = header_file_paths[j]
        marker_file_path = marker_file_paths[j]
        data_file_path = data_file_paths[j]
        experiment_file_path = experiment_file_paths[j]

        logging.debug("Create header object")
        with open(header_file_path, "r") as header_file:
            header = Header(header_file)
            assert(os.path.split(data_file_path)
                   [-1] == header.data_file)
            assert(os.path.split(marker_file_path)
                   [-1] == header.marker_file)

        logging.debug("Create marker object")
        with open(marker_file_path, "r") as marker_file:
            marker = Marker(marker_file)

        logging.debug("The number of marker_segments is: " +
                      str(marker.segments_number))

        logging.debug("Create subject object")

        with open(experiment_file_path, "r") as exp_file:
            subject = Subject(exp_file)

        logging.debug(
            "The number of trials given by the experiment file is: " + str(subject.trials_number))

        logging.debug("Crosscheck markers-experiment")
        marker.experiment_crosscheck(subject)

        logging.debug("Create DataEEG object (could take up to a minute)")
        with open(data_file_path, "r") as data_file:
            data = DataEEG(data_file)

        logging.debug("Chop data into segments")
        data.segment_data(marker, release=True)

        logging.debug("The number of data segments is: " +
                      str(data.data_segments_number))

        logging.debug("Define and create the folder the segmented data files")

        # Try to create segments' folder, will return error if already exists
        try:
            os.mkdir(segments_folder_path)
        except:
            print("Segment folder already existed, continuing")

        logging.debug("Starting to create files containing the segments")

        for i in range(data.data_segments_number):
            if sys.platform[:3] == "win":
                segment_file = open(segments_folder_path + "\\sujeto_" + str(subject.trials[0]["subject_id"]) +
                                    "_segmento_" + str(i+1) + ".dat", "w")
            else:
                segment_file = open(segments_folder_path + "/sujeto_" + str(subject.trials[0]["subject_id"]) +
                                    "_segmento_" + str(i+1) + ".dat", "w")
            face_code = marker.segments[i]["fcode"]
            audio_code = marker.segments[i]["acode"]
            audio_file_name = subject.trials[i]["soundfile"]
            audio_start = marker.segments[i]["astart"] - \
                marker.segments[i]["start"]
            stim_start = marker.segments[i]["astim"] - \
                marker.segments[i]["start"]
            audio_end = marker.segments[i]["aend"] - \
                marker.segments[i]["start"]
            metadata = "FaceCode: " + str(face_code) + " AudioCode: " + \
                str(audio_code) + " AudioFile: " + str(audio_file_name) + \
                " AudioStart: " + str(audio_start) + " StimStart: " + \
                str(stim_start) + " AudioEnd: " + str(audio_end) + "\n"
            segment_file.write(metadata)
            for key in data.data_segments[i].keys():
                line = key + " " + \
                    str(list(data.data_segments[i][key]))[
                        1:-1].replace(", ", " ") + "\n"
                segment_file.write(line)
            segment_file.close()

    logging.debug("End of segment_all_data function")
    return None


if __name__ == "__main__":

    # File paths should be defined differently whether running windows or other OS
    data_folder_path = "../raw_Data/EEG/"
    multimedia_folder_path = "../raw_Data/Stimuli/"
    segments_folder_path = "../Data/segments/"

    if sys.platform[:3] == "win":
        data_folder_path = data_folder_path.replace("/", "\\")
        multimedia_folder_path = multimedia_folder_path.replace("/", "\\")
        segments_folder_path = segments_folder_path.replace("/", "\\")

    logging.info("Start of program. Script running as main")
    logging.debug("Define the folder paths")

    logging.debug("Run the segment_all_data function")
    segment_all_data(data_folder_path, segments_folder_path)
    logging.info("End of script (as main)")
