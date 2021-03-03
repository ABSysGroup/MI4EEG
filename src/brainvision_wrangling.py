"""Handle all the files output by BrainVision Analyser.

Most of our experiments are exported in 4 different files: header files
(.vhdr), marker files (.vmrk), the EEG in a data file (.dat) and the
file that contains the information of the experiment and its trials
(which is a .txt). With this in mind, this module is created to be able
to handle all these files and to be able to segment the data using the
information from the different metadata files, writing .dat files of
its own that contain all the information needed to process it on its 
own.

Classes
----------
BrainvisionHeader: Handles .vhdr files
BrainvisionMarker: Handles .vmrk files
BrainvisionDat: Handles the .dat files that contain EEG info exported 
    from BrainVision
BrainvisionExp: Handles the .txt files that contain the trials' info
BrainvisionWrapper: A wrapper that uses previously defined classes to
    unify all the contents of an experiment. It allows us to segment
    the data.
"""

import numpy
import glob
import sys
import os

# Import logging library and start basic configuration
import logging
logging.basicConfig(level=logging.DEBUG,
                    format=" %(asctime)s - %(levelname)s - %(message)s")


def segment_vmrk_line(line: str) -> int, str, str, int, int, str:
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
    else:
        scr = "0"
    facecode = scr + faceid
    return int(facecode)


def segment_all_data(data_folder_path, segments_folder_path):

    logging.debug("Start with the segment_all_data function")
    logging.debug("Define the file path lists according to the folder paths")

    if "\\" in data_folder_path:  # Adapt file paths to Windows
        header_file_paths = glob.glob(data_folder_path + r"*.vhdr")
        marker_file_paths = glob.glob(data_folder_path + r"*.vmrk")
        data_file_paths = glob.glob(data_folder_path + r"*.dat")
        experiment_file_paths = glob.glob(data_folder_path + r"*_ExpSynt.txt")
    else:  # Sort the list for UNIX systems
        header_file_paths = glob.glob(data_folder_path + "*.vhdr")
        header_file_paths.sort()
        marker_file_paths = glob.glob(data_folder_path + "*.vmrk")
        marker_file_paths.sort()
        data_file_paths = glob.glob(data_folder_path + "*.dat")
        data_file_paths.sort()
        experiment_file_paths = glob.glob(data_folder_path + "*_ExpSynt.txt")
        experiment_file_paths.sort()

    logging.debug("--- Start iterating over all the files ---")

    while len(header_file_paths) > 0:

        vhdr_path = header_file_paths.pop(0)
        vmrk_path = marker_file_paths.pop(0)
        dat_path = data_file_paths.pop(0)
        exp_path = experiment_file_paths.pop(0)

        logging.debug("Create wrapper for file " +
                      str(os.path.split(vhdr_path)[-1]))

        wrapper = BrainvisionWrapper(vhdr_path, exp_path)

        logging.debug("Segmenting data from wrapper...")
        wrapper.segment_data()

        logging.debug("Saving segments...")
        wrapper.save_segmented_data(segments_folder_path)


class BrainvisionHeader:
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


class BrainvisionMarker:
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
            tidy_line = segment_vmrk_line(line)

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


class BrainvisionDat:
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
            data = numpy.array([float(item)
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
                segment_data[key] = self.channels[key][segment["start"]
                    :segment["end"]]
            self.data_segments.append(segment_data)
        if release:
            del self.channels
        self.data_segments_number = len(self.data_segments)


class BrainvisionExp:
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
        trial_keys = []
        for line in experiment_file:
            elements = line.split()

            # Save first row elements as keys
            if trial_keys == []:
                trial_keys = elements
                continue
            
            # Initialize trial dictionary
            trial = {}
            
            for idx, key in enumerate(trial_keys):
                trial[key] = elements[idx]

            self.number_of_trials = int(len(self.trials))

    def check_trial_consistency(self, fun, delete=True):
        """ This method checks each trial for internal consistency using the external funcion
        fun. If delete is set to True, the trials that are inconsistent are removed.
        The fun function should return True when the trial is consistent and False
        when it is not"""
        inconsistencies = []
        for idx, trial in enumerate(self.trials):
            try:
                assert fun(trial)
            except:
                logging.warning("Trial {} is inconsistent with itself.".format(idx + 1))
                inconsistencies.append(idx)

        if not delete:
            return inconsistencies
        else:
            logging.warning("Deleting {} inconsistent trials".format(len(inconsistencies)))
            for idx in sorted(inconsistencies, reverse=True):
                del(self.trials[idx])
            return None

    def redefine_values(self, fun):
        """Redefines values of the trials according to fun for each trial."""
        for idx, trial in enumerate(self.trials):
            try:
                fun(trial)
            except Exception as error:
                logging.error("An error has ocurred redefining values at index {} with error: {}".format(idx, error))


class BrainvisionWrapper:
    """ This wrapper is meant to encapsulate all the 4 files we're using
    from brainvision to do the analysis. .vhdr, .vmrk, .dat and .exp.
    It will contain all the objects and will make interactions easier.

    Files are saved in the object as self.vhdr, self.vmkr, self.exp
    and self.dat
    """

    def __init__(self, header_file_path, exp_file_path):

        logging.debug("BrainvisionWrapper: Initializing objects...")

        try:
            with open(header_file_path, "r") as header_file:
                self.vhdr = BrainvisionHeader(header_file_path)
        except IOError as error:
            raise IOError(
                "Not able to access .vhdr file. Error: " + str(error))

        data_folder = os.path.split(header_file_path)[0]

        try:
            with open(data_folder + self.vhdr.marker_file, "r") as marker_file:
                self.vmrk = BrainvisionMarker(marker_file)
        except IOError as error:
            raise IOError(
                "Not able to access .vmrk file. Error: " + str(error))

        try:
            with open(data_folder + self.vhdr.data_file, "r") as exp_file:
                self.dat = BrainvisionDat(exp_file)
        except IOError as error:
            raise IOError("Not able to access .dat file. Error: " + str(error))

        try:
            with open(exp_file_path, "r") as exp_file:
                self.exp = BrainvisionExp(exp_file)
        except IOError as error:
            raise IOError("Not able to access .exp file. Error: " + str(error))

        logging.debug("Experiment crosscheck...")
        self.vmrk.experiment_crosscheck(self.exp)

    def segment_data(self, release=True):
        self.dat.segment_data(self.vmrk, release)

    def save_segmented_data(self, segments_folder_path):
        try:
            os.mkdir(segments_folder_path)
        except:
            logging.debug("Segments folder already exists")

        num = 1

        for sgmnt in self.dat.data_segments:

            file_name = str(
                self.exp.trials[0]["subject_id"]) + "_segmento_" + str(num) + ".dat"
            num += 1

            if sys.platform[:3] == "win":
                file_name = segments_folder_path + "\\sujeto_" + file_name
            else:
                file_name = segments_folder_path + "/sujeto_" + file_name

            with open(file_name, "w") as sgmnt_file:
                face_code = sgmnt["fcode"]
                audio_code = sgmnt["acode"]
                audio_file_name = self.exp.trials[num-1]["soundfile"]
                audio_start = sgmnt["astart"] - sgmnt["start"]
                stim_start = sgmnt["astim"] - sgmnt["start"]
                audio_end = sgmnt["aend"] - sgmnt["start"]
                metadata = "FaceCode: " + str(face_code) + " AudioCode: " + \
                    str(audio_code) + " AudioFile: " + str(audio_file_name) + \
                    " AudioStart: " + str(audio_start) + " StimStart: " + \
                    str(stim_start) + " AudioEnd: " + str(audio_end) + "\n"
                sgmnt_file.write(metadata)
                for key in sgmnt.keys():
                    line = key + " " + \
                        str(list(self.dat.data_segments[num-2][key]))[
                            1:-1].replace(", ", " ") + "\n"
                    sgmnt_file.write(line)


if __name__ == "__main__":

    # File paths should be defined differently whether running windows or other OS
    data_folder_path = "../raw_Data/EEG/"
    multimedia_folder_path = "../raw_Data/Stimuli/"
    segments_folder_path = "../Data/segments/"

    if sys.platform[:3] == "win":
        data_folder_path = data_folder_path.replace("/", "\\")
        multimedia_folder_path = multimedia_folder_path.replace("/", "\\")
        segments_folder_path = segments_folder_path.replace("/", "\\")

    logging.debug("Run the segment_all_data function")
    segment_all_data(data_folder_path, segments_folder_path)
    logging.info("End of script (as main)")
