""" This file contains the major part of the preprocessing of the EEG and experiment
data exported by brainvision. Mainly it has the potential to take several subjects' files
and chop them into neatly organised segments for further processing.
If run as main, will process data in a given folder.
Won't run in other enviroment that's not windows.

TODO: Add documentation!!!
"""

# Import libraries
import numpy as np
import logging
import glob
import sys
import re
import os

# Import signal processing
from scipy.io import wavfile
from scipy import signal as snl
from scipy import stats as stats
import matplotlib.pyplot as plt

# Logging to debug the script
logging.basicConfig(level=logging.DEBUG,
                    format=" %(asctime)s - %(levelname)s - %(message)s")

# logging.disable(logging.CRITICAL)

logging.debug("Define classes and functions.")

# Define some classes and functions to make easier the work later on


def str_to_bool(s):
    if s.strip().lower() == "true":
        return True
    elif s.strip().lower() == "false":
        return False
    else:
        raise ValueError("Could not read whether true or false was written")


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
    # probs12 = np.outer(probs1, probs2)
    probs12 = joint_probs(hist1, hist2)
    cumsum = 0
    for i in range(len(probs1)):
        for j in range(len(probs2)):
            cumsum += probs12[i, j] * \
                np.log2(probs12[i, j]/(probs1[i]*probs2[j]))
    return entropy1 - cumsum


def kolmo_smir(data, plot=False):
    hist, bin_edges = np.histogram(data, int(np.ceil(len(data)/50)))
    values = []
    for i in range(len(hist)):
        values.append([hist[i], (bin_edges[i]+bin_edges[i+1])/2])
    data = np.hstack([np.repeat(x, int(f)) for f, x in values])
    loc, scale = stats.norm.fit(data)
    n = stats.norm(loc=loc, scale=scale)
    if plot:
        plt.hist(data, bins=np.arange(
            data.min(), data.max()+0.2, 0.2), rwidth=0.5)
        x = np.arange(data.min(), data.max()+0.2, 0.2)
        plt.plot(x, 350*n.pdf(x))
        plt.show()
    return stats.kstest(data, n.cdf)


class AudioStim:
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


class Segment:
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

    def crop_audio_toStim(self, inplace=True):
        """
        Crops the audio from the trigger to the end of the audio
        """
        if inplace:
            for key, values in self.channels.items():
                self.channels[key] = values[self.audio_stim_point:self.audio_end]
        else:
            self.cropped_channels = {}
            for key, values in self.channels.items():
                self.cropped_channels[key] = values[self.audio_stim_point:self.audio_end]

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

    def is_correct(self):
        """Returns boolean. True if the sentence is correct,
        False if the sentence is incorrect"""

        if self.audio_code[0] == "1":
            return True
        else:
            return False

    def is_correct_kw(self):
        """Returns a string. If the sentence was correct
        returns "correct". If not, returns "incorrect"""

        if self.audio_code[0] == "1":
            return "correct"
        else:
            return "incorrect"

    def dump_eyes(self):
        """Deletes the channels related to eye movements.
        These channels are labelled HEOG, HEOG+, VEOG, VEOG+
        """
        for label in ["HEOG", "HEOG+", "VEOG", "VEOG+"]:
            if label in self.channels.keys():
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


class MutualInformation:
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

    def compute(self, audio_data, audio_fs, crop_audio=True, dump_eyes=True, sub_ref=False, from_stim=False):

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


        # If you want to analyse the data from the stimulus, we cut the data.
        # It is done after bandpassing and hilber transform to minimise border effects
        if from_stim:
            new_start = self.segment.audio_stim_point
            # proportional start for the audio, M1 as sample channel, no real reason
            audio_start = (self.segment.audio_stim_point//len(self.segment.channels["M1"]))*len(self.analytic_audio)
            self.analytic_audio = self.analytic_audio[int(audio_start):]
            for band in self.analytic_eeg.keys():
                for channel in self.analytic_eeg[band].keys():
                    self.analytic_eeg[band][channel] = self.analytic_eeg[band][channel][int(new_start):]

        # Now, remember that the instant phase is the angle of the
        # analytic signal, the instant amplitude, or envelope,
        # is the absolute value of the analytic signal and the
        # instant frequency is the first derivative of the instant
        # phase.

        if self.mode.lower() == "phase":
            self.hist_audio_phs, _ = np.histogram(
                np.angle(self.analytic_audio), bins=self.discretization)
            self.mi = {}
            for band in self.segment.bp_channels.keys():
                self.mi[band] = {}
                for channel, signal in self.segment.bp_channels[band].items():
                    self.histphase, _ = np.histogram(
                        np.angle(self.analytic_eeg[band][channel]), bins=self.discretization)

                    self.mi[band][channel] = hist_mutual_info(
                        self.histphase, self.hist_audio_phs)

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
