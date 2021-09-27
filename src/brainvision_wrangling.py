"""Handle all the files output by BrainVision Analyser.

Most of our experiments are exported in 4 different files: header files
(.vhdr), marker files (.vmrk), the EEG in a data file (.dat) and the
logfile (which is a .txt). With this in mind, this module is created to
be able to handle all these files and to be able to segment the data
using the information from the different metadata files, writing .dat
files of its own that contain all the information needed to process it
on its own.

Classes
----------
    BrainvisionHeader: Handles .vhdr files
    BrainvisionMarker: Handles .vmrk files
    BrainvisionDat: Handles the .dat files that contain EEG info
        exported from BrainVision
    BrainvisionLog: Handles the .txt files that contain the trials' info
    BrainvisionWrapper: A wrapper that uses previously defined classes
        to unify all the contents of an experiment. It allows us to
        segent the data.
"""
from progress.bar import IncrementalBar
from utils import check_directory
import numpy
import glob
import json
import sys
import os
import re

# Import logging library and start basic configuration
import logging
logging.basicConfig(level=logging.DEBUG,
                    format=" %(asctime)s - %(levelname)s - %(message)s")
logging.disable(logging.CRITICAL)

# Define functions


def segment_vmrk_line(line: str) -> dict:
    """Separate a line into different information points.

    Parameters
    ----------
    line: str
        a line from a file or a string of text.

    Returns
    ----------
    dict
        contains the following information: marker number, type,
            description, data point position, data point size,
            marker channels (0 if all of them).
    """

    # Here we create the regex pattern
    ptn_pt1 = r"Mk(?P<number>\d+)\=(?P<type>[a-zA-Z0-9]*?)\,"
    ptn_pt2 = r"(?P<description>S\d+?)?\,"
    ptn_pt3 = r"(?P<position>\d+)\,"
    ptn_pt4 = r"(?P<size>\d+)\,"
    ptn_pt5 = r"(?P<channel>\d+)"
    parts = [ptn_pt1, ptn_pt2, ptn_pt3, ptn_pt4, ptn_pt5]
    pattern = r"".join(parts)

    # Match the regex
    result = re.search(pattern, line.replace(" ", ""))

    # If there was no regex match return a fake dummy dictionary
    if type(result) == type(None):
        dictionary = {"numer": 0, "type": "dummy", "description":
                      "there was no RegEx match", "position": 0, "size": 0,
                      "channel": None}
        return dictionary

    # Define the keys
    keys = ["number", "type", "description", "position", "size",
            "channel"]

    # Create the dictionary
    dictionary = {key: result[key] for key in keys}

    return dictionary


class BrainvisionHeader:
    """
    Opens a header file from Brainvision and stores relevant information

    Attributes:
    ----------
    data_file: str
        the name of the data file where the EEG data is stored
    marker_file: str
        the name of the file where the data of the markers of the
        experiments is stored
    data_orientation: str
        wheter the data is in vectorized (ch1pt1 ch1pt2 ...) or
        multiplexed (ch1pt1 ch2pt1) form
    data_type: str
        time or frequency domain
    number_channels: int
        the number of eeg channels (taking references and oculars into
        account normally)
    datapoints: int
        the number of points of data in each channel
    sampling_interval: float
        the interval in microseconds between data points, in
        microseconds
    sampling_frequency: float
        the frequency of the signal, in hertz
    decimal_symbol: str
        the decimal symbol used in the data
    segmentation_type:
        whether or not the way to segment the data is using markers
    segment_datapoints: int
        the number of markers in the experiment
    """

    def __init__(self, header_path: str):
        header_file = open(header_path, "r")
        for line in header_file:
            if "DataFile=" in line:
                self.data_file = line.split("=")[1][:-1]
            elif "MarkerFile=" in line:
                self.marker_file = line.split("=")[1][:-1]
            elif "DataOrientation=" in line:
                self.data_orientation = line.split("=")[1]
            elif "DataType=" in line:
                self.data_type = line.split("=")[1]
            elif "NumberOfChannels=" in line:
                self.number_channels = int(line.split("=")[1])
            elif "DataPoints=" in line and not "datapoints" in locals():
                self.datapoints = int(line.split("=")[1])
            elif "SamplingInterval=" in line:
                self.sampling_interval = float(line.split("=")[1])
                self.sampling_freq = 1000000 / self.sampling_interval
            elif "SegmentationType=" in line:
                self.segmentation_type = line.split("=")[1]
            elif "SegmentDataPoints=" in line:
                self.segment_datapoints = int(line.split("=")[1])
            elif "DecimalSymbol=" in line:
                self.decimal_symbol = line.split("=")[1]
        header_file.close()


class BrainvisionMarker:
    """
    Opens a Brainvision marker file and extracts relevant information.

    Attributes
    ----------
    segments: list
        A list of dictionaries that contain the information about data
        segmentation for this experiment. Each dictionary represents a
        data segment containing the following information:
            start_pos: the starting position (in data points) of the
                segment
            audio_start_pos: the starting position (in data points)
                where the audio starts playing
            audio_stim_pos: position where the right/wrong word is
                played
            audio_end_pos: the ending position (in data points) of the
                audio
            end_pos: the ending position (in data points) of the segment
            face_stim: the code of the face stimulus (2 digit code)
            audio_stim: the code of the auditory stimulus (not the
                file name, the 3 digit code)
            correct: whether or not the answer of the subject was
                correct or not

    number_of_segments: int
        the number of segments

    Methods
    ----------
    experiment_crosscheck(log_object, force):
        verify that the segments here are the same as the ones in the
        experiment info file. Checks all the entries until the problem
        has been solved
    """

    def __init__(self, marker_path: str):

        def new_marker_segment() -> dict:
            """Creates a dictionary ready for population with the info
            from a marker segment.

            Returns
            ----------
            dict
                containing the keys necessary
            """

            return {"start": 0, "audio_start": 0, "stim_pos": 0,
                    "audio_end": 0, "end": 0, "face_code": 0,
                    "audio_code": 0, "response_correct": False}

        with open(marker_path, "r") as marker_file:
            self.marker_segments = []

            step = "begin"

            for line in marker_file:

                # If this is not a marker continue with the next line
                if (not "Mk" in line) or ("Mk<" in line):
                    continue

                # Dump line into dictionary
                tidy_line = segment_vmrk_line(line)

                # Check if marker is segment start
                if step == "begin" and tidy_line["type"] == "NewSegment":
                    step = "new"
                    curr_segment = new_marker_segment()
                    continue

                # Check if the stim is in the marker
                if tidy_line["type"] == "Stimulus":

                    stimulus_code = int(tidy_line["description"].replace(
                        "S", ""))
                    position = int(tidy_line["position"])

                    # First marker in segment contains face code
                    if step == "new" and stimulus_code < 99:
                        curr_segment["face_code"] = stimulus_code
                        curr_segment["start"] = position
                        curr_segment["audio_start"] = (position + 125)
                        # 500ms at 250Hz => 125 data points
                        step = "audio_code"
                        continue

                    # Second marker in a segment contains audio code
                    if step == "audio_code" and stimulus_code > 99:
                        curr_segment["audio_code"] = stimulus_code
                        curr_segment["stim_pos"] = position
                        step = "audio_end"
                        continue

                    # Obtain the end of the audio stimulus
                    if step == "audio_end" and stimulus_code == 99:
                        curr_segment["audio_end"] = position
                        step = "answer"
                        continue

                    # Obtain end of segment and append to list
                    if step == "answer" and stimulus_code <= 3:
                        curr_segment["response_correct"] = stimulus_code
                        curr_segment["end"] = position
                        self.marker_segments.append(curr_segment)
                        step = "begin"
                        continue

            self.number_of_segments = len(self.marker_segments)


class BrainvisionDat:
    """Puts data from a VECTORIZED data file into a dictionary.

    Attributes
    ----------
    channels: dict
        dictionary with the channel names as keys and the eeg signal as
        the value.
    data_segments: list
        populated through the segment_data method. Contains all the
        segments, each one being a dictionary with the channels as keys
        and the EEG values being lists associated to those keys.
    data_segments_number: int or str
        defined on initialization, specified when segment_data is run.

    Methods
    ----------
    segment_data(marker_object, release=True):
        segments the data of the channels given a marker object.
        Populates the data_segments attibute.
    """

    def __init__(self, data_path: str):
        # Parse the whole .dat file with the EEG data inside.
        self.channels = {}
        data_file = open(data_path, "r")
        for line in data_file:
            key = line.split()[0]
            data = numpy.array([float(item)
                                for item in line.replace(",", ".").split()[1:]])
            self.channels[key] = data
        self.data_segments = []
        self.data_segments_number = "unknown"
        data_file.close()

    def segment_data(self, marker_object: object, release: bool = True):
        """Given a marker object the method segments the data into the
        segments indicated by said object.

        Parameters
        ----------
        marker_object: object
            marker object corresponding to this data
        release: bool
            If `release = True`, it will DELETE the channels attribute
            after creating the segmented_data one. This was implemented
            for memory performance purposes.
        """

        for segment in marker_object.marker_segments:
            segment_data = {}
            segment_data["metadata"] = segment
            for key in self.channels.keys():
                segment_data[key] = self.channels[key][segment["start"]
                    :segment["end"]]
            self.data_segments.append(segment_data)
        if release:
            del self.channels
        self.data_segments_number = len(self.data_segments)


class BrainvisionLog:
    """Given a logfile with the information from the experiment, store it
    in a convenient way to cross reference it with the data segments.

    IMPORTANT: These log files are probably exported from the software
    used to do the experiment (Presentation, https://www.neurobs.com/).

    Attributes:
    ----------
    trials: list
        containins a dict for each trial. The keys and explanation of
        values are:
            subject_id: will probably be the same for each trial. ID of
                the subject.
            sentence_id: the ID of the sentence the subject heard
            voice: the ID of the voice that read the sentence
            correct: whether or not the sentence was sintactically
                correct or not
            scrambled: whether or not the shown face was scrambled
            soundfile: the soundfile that played in the background
            face_id: the ID of the face that was shown in the trial
            RT: response time from the query, in ms
    number_of_trials: int
        number of trials
    """

    def __init__(self, log_path: str):
        self.trials = []
        trial_keys = []
        with open(log_path, "r") as log_file:
            for line in log_file:
                elements = line.replace("\n", "").split("\t")

                # Save first row elements as keys
                if trial_keys == []:
                    trial_keys = elements
                    continue

                # Initialize trial dictionary
                trial = {}

                for idx, key in enumerate(trial_keys):
                    trial[key] = elements[idx]

                self.trials.append(trial)

        self.number_of_trials = int(len(self.trials))

    def check_inner_trial_consistency(self, fun, delete: bool = True):
        """This method checks each trial for internal consistency, since
        sometimes each trial has the same data in different places.

        Using the given function `fun` each element of the log is
        checked for consistency. If delete is set to True, the trial
        will be deleted.

        Parameters
        ----------
        fun: function
            A function to which each trial element will be passed to. It
            is very important that it returns True when the trial is
            consistent and False when it is not.
        delete: bool
            If set to True the trials that are inconsistent are removed.
        """
        inconsistencies = []
        for idx, trial in enumerate(self.trials):
            try:
                assert fun(trial)
            except:
                logging.warning(
                    "Trial {} is inconsistent with itself.".format(idx + 1))
                inconsistencies.append(idx)

        if not delete:
            return inconsistencies
        else:
            logging.warning(
                "Deleting {} inconsistent trials".format(len(inconsistencies)))
            for idx in sorted(inconsistencies, reverse=True):
                del(self.trials[idx])
            return None

    def redefine_values(self, fun):
        """Redefines values of the trials according to fun for each
            trial.

        Parameters
        ----------
        fun: function
            Function that evaluates each trial to redefine the values.
        """

        for idx, trial in enumerate(self.trials):
            try:
                new_trial = fun(trial)
                if new_trial != None:
                    self.trials[idx] = new_trial
            except Exception as error:
                logging.error(
                    "An error has ocurred redefining values at index {} with error: {}".format(idx, error))


class BrainvisionWrapper:
    """Wrapper that loads all the data exported from BrainVision.

    This wrapper is meant to encapsulate all the 4 files we're using
    from brainvision to do the analysis. .vhdr, .vmrk, .dat and .exp.
    It will contain all the objects and will make interactions easier.

    Files are saved in the object as self.vhdr, self.vmkr, self.log
    and self.dat
    """

    def __init__(self, header_file_path: str, log_file_path: str):
        """
        Pararameters
        ---------
        header_file_path: str
            path to the .vhdr file of the experiment
        log_file_path: stf
            path to the .txt file containing the log of the experiment
        """

        logging.debug("BrainvisionWrapper: Initializing objects...")

        try:
            self.vhdr = BrainvisionHeader(header_file_path)
        except IOError as error:
            raise IOError(
                "Not able to access .vhdr file. Error: " + str(error))

        data_folder = os.path.split(header_file_path)[0]

        try:
            marker_file_path = os.path.join(data_folder,
                                            self.vhdr.marker_file)
            self.vmrk = BrainvisionMarker(marker_file_path)
        except IOError as error:
            raise IOError(
                "Not able to access .vmrk file. Error: " + str(error))

        try:
            data_file_path = os.path.join(data_folder,
                                          self.vhdr.data_file)
            self.dat = BrainvisionDat(data_file_path)
        except IOError as error:
            raise IOError("Not able to access .dat file. Error: " + str(error))

        try:
            self.log = BrainvisionLog(log_file_path)
        except IOError as error:
            raise IOError("Not able to access log file. Error: " + str(error))

    def segment_data(self, release=True):
        """Segments data of loaded experiment."""

        self.dat.segment_data(self.vmrk, release)

    def check_segments_consistency(self):
        """Since the data for the segments is obtained from different
        sources (BrainVisionAnalyzer and Presentation) more often than
        not the number of trials is different between log and marker
        files. For that purpose, this function wants to check the
        segments given by the markers and by the log and get rid of the
        ones that are not present in both"""

        vmkr_segments = self.vmrk.number_of_segments
        log_segments = self.log.number_of_trials

        # Get difference, normally log file has more segments
        difference = log_segments - vmkr_segments

        # Use file with least segments as "ground truth"
        if difference > 0:  # log file has more segments
            pass
        else:  # vmrk file has more segments
            pass

    def save_segmented_data(self, segments_folder_path: str):
        """Saves segmented data to json files for further processing.

        Parameters
        ----------
        segments_folder_path: str
            path to the folder where the segments will be stored
        """

        assert self.dat.data_segments != [], ("Data must be segmented"
                                              + " before you save it.")

        check_directory(segments_folder_path)

        # PRINT NUMBER OF SEGMENTS [[DEBUG]]
        print("Number of segments")
        print("DAT: " + str(len(self.dat.data_segments)))
        print("MRK: " + str(self.vmrk.number_of_segments))
        print("LOG: " + str(self.log.number_of_trials))

        # Create a bar to display progress of saving to files
        bar = IncrementalBar("Saving segments",
                             max=self.log.number_of_trials)

        segment_number = 0

        for sgmnt in self.dat.data_segments:
            try:
                file_name = "sujeto_{}_segmento_{}.json".format(
                    str(self.log.trials[0]["subject"]), segment_number+1)

                file_path = os.path.join(segments_folder_path, file_name)

                # We have to "flip inside-out" the metadata and data
                metadata = sgmnt["metadata"]

                json_data = {"face_code": metadata["face_code"],
                             "audio_code": metadata["audio_code"],
                             "audio_file_name": self.log.trials[segment_number]["soundfile"],
                             "audio_start_position": metadata["audio_start"] - metadata["start"],
                             "audio_end_position": metadata["audio_end"] - metadata["start"],
                             "trigger_position": metadata["stim_pos"] - metadata["start"],
                             "channels": {}}

                for key in sgmnt.keys():
                    if key == "metadata":
                        continue
                    json_data["channels"][key] = sgmnt[key].tolist()

                with open(file_path, "w") as json_file:
                    json.dump(json_data, json_file)

                segment_number += 1
            except Exception as error:
                print("\nSomething went wrong: " + repr(error))

            bar.next()
        bar.finish()
