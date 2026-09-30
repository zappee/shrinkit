#!/bin/bash -e

# ##############################################################################
# Video size reducer
#
# Release: 0.1.0
# Created by arnold.somogyi@gmail.com
#
# video-shrinker.sh <directory> [overwrite]
#    <directory>: Path to the folder containing the video files.
#    [overwrite]: Set to 'true' to replace original videos.
#                 Set to 'false' to keep originals. (Default)
# ##############################################################################
FILE_MASK="*.mp4"
VIDEO_BIT_RATE="3000k"
VIDEO_FRAME_RATE="25"
AUDIO_BITRATE="80k"
AUDIO_CHANNELS="1"

# validation the input arguments
if [ $# -eq 1 ]; then
  DIRECTORY="$1"
  OVERWRITE="false"
elif [ $# -eq 2 ]; then
  DIRECTORY="$1"
  OVERWRITE="$2"
else
  printf "Usage: video-shrinker.sh <directory> [overwrite]\n"
  printf "   <directory>: Path to the folder containing the video files.\n"
  printf "   [overwrite]: Set to 'true' to replace original videos.\n"
  printf "                Set to 'false' to keep originals. (Default: false)\n"
  exit 1
fi

# get the file list
IFS=$'\n'
mapfile -t FILES < <(find "$DIRECTORY" -type f -name "$FILE_MASK")

# show the environment
printf "Configuration:\n"
printf "   working directory:   \"%s\"\n" "$DIRECTORY"
printf "   overwrite originals: %s\n" "$OVERWRITE"
printf "   files selected:       %s\n" "${#FILES[@]}"
read -r -p "Press [Enter] to continue"

# loop on file list
for FILE in "${FILES[@]}"; do
  printf ">>> Phase-1: %s" "$FILE"
  ffmpeg -i "$FILE" -f null -r:v "$VIDEO_FRAME_RATE" -vcodec libx264 -preset slow -filter:v bwdif=mode=send_field:parity=auto:deint=interlaced -b:v "$VIDEO_BIT_RATE" -flags +loop -cmp chroma -b:v 1250k -maxrate 1500k -bufsize 4M -bt 256k -refs 1 -bf 3 -coder 1 -me_method umh -me_range 16 -subq 7 -partitions +parti4x4+parti8x8+partp8x8+partb8x8 -g 250 -keyint_min 25 -level 30 -qmin 10 -qmax 51 -qcomp 0.6 -trellis 2 -sc_threshold 40 -i_qfactor 0.71 -acodec aac -strict experimental -b:a "$AUDIO_BITRATE" -ar 48000 -ac "$AUDIO_CHANNELS" -b:v "$VIDEO_BIT_RATE" -b:a "$AUDIO_BITRATE" -an -passlogfile "$FILE.log" -pass 1  -y /dev/null
  printf ">>> Phase-2: %s" "$FILE"

  # Rotate video in phase 2:
  #    90° clockwise (right):                ffmpeg -i input.mp4 -vf "transpose=1" output.mp4
  #    90° counterclockwise (left):          ffmpeg -i input.mp4 -vf "transpose=2" output.mp4
  #    180° rotation (upside down):          ffmpeg -i input.mp4 -vf "hflip,vflip" output.mp4
  #    90° clockwise + vertical flip:        ffmpeg -i input.mp4 -vf "transpose=3" output.mp4
  #    90° counterclockwise + vertical flip: ffmpeg -i input.mp4 -vf "transpose=0" output.mp4

  # Use -vf "transpose=2,transpose=2" for 180 degrees.
  ffmpeg -y -i "$FILE" -f mp4 -r:v "$VIDEO_FRAME_RATE" -vcodec libx264 -preset slow -filter:v bwdif=mode=send_field:parity=auto:deint=interlaced -b:v "$VIDEO_BIT_RATE" -flags +loop -cmp chroma -b:v 1250k -maxrate 1500k -bufsize 4M -bt 256k -refs 1 -bf 3 -coder 1 -me_method umh -me_range 16 -subq 7 -partitions +parti4x4+parti8x8+partp8x8+partb8x8 -g 250 -keyint_min 25 -level 30 -qmin 10 -qmax 51 -qcomp 0.6 -trellis 2 -sc_threshold 40 -i_qfactor 0.71 -acodec aac -strict experimental -b:a "$AUDIO_BITRATE" -ar 48000 -ac "$AUDIO_CHANNELS" -b:v "$VIDEO_BIT_RATE" -b:a "$AUDIO_BITRATE" -passlogfile "$FILE.log" -pass 2 "$FILE.out.mp4"
done

# overwrite the original video files
if [ "$OVERWRITE" = "true" ]; then
  for FILE in "$DIRECTORY"/*.mp4.out.mp4; do
    mv "$FILE" "${FILE//.mp4.out/}"
  done
fi

# delete temp files
rm -- "$DIRECTORY"/*.log
rm -- "$DIRECTORY"/*.mbtree
