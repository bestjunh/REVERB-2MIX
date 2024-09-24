#!/bin/bash

# AMI_WSJ20-Array1-2_T10c020s
# AMI_WSJ20-Array2-1_T10c0212

NAME1="./REVERB_frac2wav/AMI_WSJ17-Array1-"
# NAME1="./REVERB_frac2wav/AMI_WSJ17-Array2-"
NAME2="_T7c020x"

ffmpeg -i $NAME1"1"$NAME2".flac" $NAME1"1"$NAME2".wav"
ffmpeg -i $NAME1"2"$NAME2".flac" $NAME1"2"$NAME2".wav"
ffmpeg -i $NAME1"3"$NAME2".flac" $NAME1"3"$NAME2".wav"
ffmpeg -i $NAME1"4"$NAME2".flac" $NAME1"4"$NAME2".wav"
ffmpeg -i $NAME1"5"$NAME2".flac" $NAME1"5"$NAME2".wav"
ffmpeg -i $NAME1"6"$NAME2".flac" $NAME1"6"$NAME2".wav"
ffmpeg -i $NAME1"7"$NAME2".flac" $NAME1"7"$NAME2".wav"
ffmpeg -i $NAME1"8"$NAME2".flac" $NAME1"8"$NAME2".wav"

