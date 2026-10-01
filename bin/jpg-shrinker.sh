#!/bin/bash -e

# ##############################################################################
# JPG image size reducer
#
# Release: 0.1.0
# Created by arnold.somogyi@gmail.com
#
# jpg-shrinker.sh <directory> [overwrite]
#    <directory>: Path to the directory containing the JPG files.
#    [overwrite]: Optional. Set to 'true' to replace the original files.
#                 Defaults to 'false'.
# ##############################################################################
QUALITY="50%"

# validation the input arguments
if [ $# -eq 1 ]; then
  DIRECTORY="$1"
  OVERWRITE="false"
elif [ $# -eq 2 ]; then
  DIRECTORY="$1"
  OVERWRITE="$2"
else
  printf "Usage: jpg-shrinker.sh <directory> [overwrite]\n"
  printf "   <directory>: Path to the directory containing the JPG files.\n"
  printf "   [overwrite]: Optional. Set to 'true' to replace the original files.\n"
  printf "                Defaults to 'false'.\n"
  exit 1
fi

# show the environment
printf "Configuration:\n"
printf "   Working directory:  \"%s\"\n" "$DIRECTORY"
printf "   Overwrite originals: %s\n" "$OVERWRITE"
read -r -p "Press [Enter] to continue"

if [ "$OVERWRITE" = "true" ]; then
  CURRENT_DIR=$(pwd)
  cd "$DIRECTORY"
  mogrify -quality "$QUALITY" ./*.jpg
  cd "$CURRENT_DIR"
else
  printf "Not implemented yet\n"
fi
