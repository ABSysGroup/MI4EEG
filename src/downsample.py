import processing as pr
import glob
import os

folder_path = "../raw_data/Stimuli/"
wavs_paths = glob.glob(folder_path + "*.wav")

print("Starting...")
for path in wavs_paths:
    audio = pr.AudioStim(path)
    print("OLD RATE " + str(audio.rate))
    audio.downsample(8)
    print("NEW RATE " + str(audio.rate))
    new_path = "../preprocessed_data/downsampled_audios/"
    new_path += os.path.split(path)[-1].split(".")[0] + "_ds8.wav"
    audio.save(new_path)
    print("File " + new_path + " done")

print("Done")
