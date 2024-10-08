# REVERB-2MIX

A package of tools for creating and using REVERB-2MIX dataset

## Requirement
```bash
sudo apt-get install csh
```

## Short description of the REVERB-2MIX dataset

REVERB-2MIX [1] is a dataset composed of a set of noisy reverberant speech mixtures. It is provided as a tool for evaluating speech enhancement techniques in adverse environments. To enable realistic evaluation, the dataset partly contains real recordings, for which utterances uttered by humans were recorded in noisy reverberant rooms separately, and afterwards mixed on computer. To increase diversity of recording conditions, it also contains simulated recordings, which were generated by combining various measured room impulse responses, noise recordings, and clean speech recordings. In addition, as evaluation metrics, not only signal distortion measures, but also automatic speech recognition baseline systems are available for the dataset, and thus a wide range of evaluations can be performed. 

## Specification of the REVERB-2MIX dataset

1.  The REVERB-2MIX dataset was created using the REVERB Challenge dataset (<https://reverb2014.dereverberation.com/>) [2]. Each utterance in the REVERB Challenge dataset contains a single reverberant speech signal with moderate stationary diffuse noise. 

2.  To generate noisy reverberant speech mixtures for REVERB-2MIX, two utterances extracted from the REVERB Challenge dataset were mixed, one from its development set (Dev set) and the other from its evaluation set (Eval set). Because signal levels were not modified at the mixing, power ratios of the signals in mixtures vary dependent on their original signal levels.

3.  Each pair of utterances in each mixture were selected so that they were recorded in the same room, by the same microphone array, and under the same condition (near or far, RealData or SimData). We categorize the utterances in REVERB-2MIX based on the original categories of the data in the REVERB challenge dataset as 
    follows:
    - RealData
        - room1, near
        - room1, far
    - SimuData
        - room1, near
        - room1, far
        - room2, near
        - room2, far
        - room3, near
        - room3, far

4.  A unique characteristic of REVERB-2MIX is that evaluation of enhanced signals is supposed to be performed based only on one of two utterances included in each speech mixture that corresponds to the REVERB Challenge Eval set. This evaluation scheme allows us to use speech enhancement evaluation tools provided for the REVERB Challenge Eval set also for REVERB-2MIX. For enabling this scheme, the number of mixtures in REVERB-2MIX was set at the same as that of the utterances in the REVERB Eval set, and all the utterances in the REVERB Eval set were included in either one of the mixtures in REVERB-2MIX. Furthermore, the length of each mixture in REVERB-2MIX was set at the same as that of the corresponding original utterance in the REVERB Eval set, and the utterance from the Dev set was trimmed or zero-padded at its end to be the same length as that of the Eval set.

5.  The evaluation flow could be as follows:  
    1. Estimate two source signals included in each mixture
    2. Select a signal to be evaluated from the two estimated source signals based, for example, on correlation between the estimated signals and the original signal in the REVERB Eval set
    3. Evaluate the selected signal using the evaluation tools  
    
    A sample matlab code to select an enhanced signal that corresponds to the original signal in the REVERB Eval set is also included in this tool package. Please also check "How to access data in each category" in this README.

6.  The evaluation tools include signal distortion metrics provided for the challenge, such as cepstral distortion and frequency-weighted segmental signal-to-noise ratio, and baseline automatic speech recognition system developed by Kaldi. Please check the REVERB Challenge web site for the detail.

## How to install the REVERB-2MIX dataset

1.  First, install the REVERB Challenge dataset according to the guideline at <https://reverb2014.dereverberation.com/download.html>. 

2.  Run CreateREVERB2MIX.m on matlab interpretor (ver. 2008b or newer), for example, by

    \>> WSJ_dir = 'path_to_WSJCAM0_dataset_dir';  
    \>> REVERB_dir = 'path_to_REVERB_Challenge_dataset_dir';  
    \>> CreateREVERB2MIX(WSJ_dir, REVERB_dir);  

    where WSJ_dir is a path to your WSJCAM0 dataset [3] directory, and REVERB_dir is a path to your REVERB Challenge dataset directory.

3.  Then, the REVERB-2MIX dataset is created under './REVERB_2MIX/' directory.

## How to access data in each category

### Access to mixtures

You can find a set of scp files named as &lt;name_of_data_category>.scp in './REVERB_2MIX/scps/' directory.  Each scp file contains pathes to wav files included in each data category. &lt;name_of_data_category> can be one of the following:

    - RealData_et_for_8ch_near_room1_wav 
    - RealData_et_for_8ch_far_room1_wav
    - SimData_et_for_8ch_near_room1_wav
    - SimData_et_for_8ch_far_room1_wav
    - SimData_et_for_8ch_near_room2_wav
    - SimData_et_for_8ch_far_room2_wav
    - SimData_et_for_8ch_near_room3_wav
    - SimData_et_for_8ch_far_room3_wav

Each line in each scp file contains a pair of label and path to a wav file. As an example, a line can be:

> room1_far_AMI_WSJ21-Array2-2_T21c020y MC_WSJ_AV_Eval/audio/stat/T21/array2/5k/AMI_WSA21-Array2-2_T21c020y.wav

The first item is the label and the second item is the relative path from './REVERB_2MIX/' directory to the wav file. Each wav file contains 8ch audio signals sampled at 16 kHz.

### Access to corresponding original signals in REVERB Eval set

For evaluation, you typically have two enhanced signals for each mixture, and need to select one that corresponds to the REVERB Eval set. For this selection, you can also use the above scp files to find an origianl signal (reference channel) in the REVERB Challenge Eval set that corresponds to a signal included in each mixture. This can be done by concatenating the path to your REVERB challenge dataset directory with each path in each scp file. Then, you can just select enhanced signals to be evaluated by picking up ones that are closer to the original signals.

A sample matlab code, SelectTarget.m, for selecting enhanced signals to be evaluated is also included in this package. You can use the code as:

 \>> wavscp_dir = './REVERB_2MIX/scps/';  
 \>> enh1_dir = 'path_to_enh1_dir';  
 \>> enh2_dir = 'path_to_enh2_dir';  
 \>> REVERB_dir = 'path_to_REVERB_Challenge_dataset_dir';  
 \>> out_dir = 'path_to_output_dir';  
 \>> SelectTarget(wavscp_dir, enh1_dir, enh2_dir, REVERB_dir_name, output_dir);  

 where wavscp_dir is a path to the scp files, enh1_dir and enh2_dir are pathes to directories of the two enhanced signals, REVERB_dir is a path to your REVERB Challenge dataset directory, and out_dir is a path to a directory that stores selected enhanced signals. It is assumed that each signal is located under enh1_dir, enh2_dir, REVERB_dir, and out_dir according to the relative pathes specified in the scp files.

The code assumes that the enhanced signals and the original signal are exactly time aligned. In addition, to improve the accuracy of selection, it is recommeneded to denoise and dereverberate the original signals in the REVERB Eval set in advance using a similar algorithm as one that you use to obtain the enhanced signals from REVERB-2MIX.

## A guide for creating training data set

In a paper [1], a training data set of REVERB-2MIX dataset was also prepared, but it is not included in this tool package. Instead, you may create a similar training set based on the following specification.

1.  The training set used in [1] is composed of 20,000 mixed utterances.

2.  To create each mixed utterance, two utterances were randomly extracted from WSJ0 (si84) [4], and mixed as follows:
    -   Each utterance was convolved with room impulse responses (8ch) randomly extracted from the REVERB challenge training set.
    -   Then, the two utterances were mixed so that their power ratio became between -5 dB and 5 dB.
    -   The length of the mixed utterance was set as the same as the shorter utterance.
    -   Then, the noise randomly extracted from the REVERB challenge training set was added.
    -   The signal to noise ratio was set at 10 to 30 dB, taking the reverberant mixture as the signal.

3.  It may also be necessary to prepare reference signals to be used for training of speech enhancement systems, such as neural network-based systems. For this purpose, various configurations can be adopted. For example, one may extract only early part of an room impulse response and convolve it to clean speech to generate a reference signal. A few examples of such configurations can be found in [1].

## References

[1] T. Nakatani, R. Takahashi, Tsubasa Ochiai, K. Kinoshita, R. Ikeshita, M. Delcroix, and S. Araki, "DNN-supported mask-based convolutional beamforming for simultaneous denoising, dereverberation, and source separation," IEEE ICASSP, pp. 6399-6403, May 2020.  

[2] K. Kinoshita, M. Delcroix, S. Gannot, E. AP Habets, R. Haeb-Umbach, W. Kellermann, V. Leutnant, R. Maas, T. Nakatani, B. Raj, A. Sehr, T. Yoshioka, "A summary of the REVERB challenge: state-of-the-art and remaining challenges in reverberant speech processing research," EURASIP Journal on Advances in Signal Processing, December 2016.  

[3] WSJCAM0 Cambridge, <https://catalog.ldc.upenn.edu/LDC95S24>  

[4] CSR-I (WSJ0), <https://catalog.ldc.upenn.edu/LDC93S6ACS>
