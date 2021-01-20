# Mutual Information Analysis of EEG experiments

The code present here was created to analyse a specific EEG experiment, but it might be generalised in the future and some snippets could be useful for other experiments.

## Main pipeline

As with many other data analysis frameworks, here we have a generic approach:

- Data extraction: The data that we used for this analysis was extrated from BrainVisionAnalyser. It was exported using `.vhdr`, `.vmrk`, `.exp` and `.dat` files.

- Data wrangling: Done through the functions and classes defined in the `processing.py` file. The most useful class here is the BrainVisionWrapper, that helps us use BrainVision's output format and use it as if we had dictionaries through segmentation. We take the `.vhdr`, `.vmrk`, `.exp` and `.dat` files and through a segmentation we transform that into `.dat` files containing the trials of the experiment. We also downsample the audio files containing the speech used during the experiment.

- Data analysis: After having our EEG data in `.dat` files with enough metainformation to work, we load the audio files (`.wav` format) that we previously downsampled alongside them. A Hilbert transform is used to get the analytic function of the EEG and the speech and then the instantaneous phase is extracted. An histogram of the phase is then created, using four bins of equal amplitude. Since phase is contained between -pi and pi, the bins have edges [-pi, -pi/2, 0, pi/2, pi]. Then, probabilities and entropy are calculated for each signal and then mutual information is obtained.

- Data visualization: Most of the data visualization is obtained from outside using R. Here, as of the last update of this readme, only raw numerical data are extracted through Jupyter notebooks.

## Contact

You can contact me for any information or improvements at: rodrigo(dot)perezordoyobellido(at)gmail(dot)com