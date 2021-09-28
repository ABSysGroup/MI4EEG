# Mutual Information analysis for EEG

The code present in this repository is intended for studying the Mutual
Information (MI) between EEG and another signal (mainly speech) and
making comparisons of the MI values for different experimental 
conditions.

In particular, it was developed to be used directly from the command 
line using data exported from BrainVision Analyzer and `.wav` files as 
the files containing the other signal.

## How to run python scripts from the command line (Linux/MacOS)

1. Make sure you have Python (version 3.5 or higher) installed in your
system.
2. Open a terminal where the script is located.
3. Grant execution permission to the code using the `chmod` command.
4. Since the script file contains a shebang line, you can run the script
as follows: `./script_file_name.py`. If the shebang line was missing, 
please use `python3 script_file_name.py`.

## Pipeline

The standard pipeline for analysis is as follows:

### 1. Segmenting the continuous data into segments/trials

Since the data recorded with the EEG is continuous for every subject, we
have to isolate each trial (also named segment through the code and docs
interchangeably). For that purpose, we have the script called 
`segment_data.py` which can be easily run from the command line. This 
script is intended for files exported from BrainVision Analyzer, where
the data is exported as three different files (`.vhdr`, `.vmrk`, `.dat`)
and a log file (`.txt`).

The script makes use of the code available in `brainvision_wrangling.py`
to transform each data packet comprised of the four different file types
into `.dat` files, each one containing one trial.

Read the documentation given for the script for further usage info.

### 2. Downsampling the audio files (recomended but optional)

Since the sampling rate for audio files is around 44 kHz and most of the
sounds relevant to language are below the 3 kHz frequency, we downsample
the audio data so that the analysis is less computationally expensive.

Using the script `downsample_audio_files.py` downsamplig `.wav` files is
easy as it can be executed from the command line and will downsample all
the files present in a folder by a given factor and will save them in
another folder.

**IMPORTANT**: The Nyquist frequency has to be taken into account not to
introduce systematic errors into the analysis.

### 3. Reading segments and computing Mutual Information

Mutual information analysis can be done with the `MI_analysis.py` script
. It makes use of other code files and can be called from the terminal
once execution is allowed. It only needs the folder where the segmented
data is, the folder where the audio data is and the path of the results
file (it will be created with the name given).

### 4. Statistical analysis

Statistical analysis of the data is externalised to python notebooks. 
Some of them can be found inside the repository, but there is a current 
effort of putting them together into something tidier.

Files previously used (maybe not present in the current state of the
repo) include `MI_calculation.py`, `Face-Noface changes.ipynb`, 
`Correct-Incorrect changes.ipynb`.
