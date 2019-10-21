#!/bin/bash
OUTPUT_DIR=gfonts_files

cp build/3270Medium.ttf $OUTPUT_DIR/3270/3270-Regular.ttf
cp build/3270SemiNarrow.ttf $OUTPUT_DIR/3270semicondensed/3270SemiCondensed-Regular.ttf
cp build/3270Narrow.ttf $OUTPUT_DIR/3270condensed/3270Condensed-Regular.ttf

for fontdir in 3270 3270semicondensed 3270condensed
do
  cp LICENSE.txt $OUTPUT_DIR/$fontdir
  cp DESCRIPTION.*.html $OUTPUT_DIR/$fontdir
done

for font in $OUTPUT_DIR/*/*.ttf
do
  gftools fix-nonhinting $font $font
  gftools fix-dsig $font --autofix
done

# Cleanup gftools mess:
rm $OUTPUT_DIR/*/*-backup-fonttools-prep-gasp.ttf

export OPTIONS="--no-progress"
export OPTIONS="$OPTIONS --exclude-checkid /check/ftxvalidator" # We lack this on Travis.
export OPTIONS="$OPTIONS --exclude-checkid /check/metadata" # Comment this out after creating a METADATA.pb file.
export OPTIONS="$OPTIONS --exclude-checkid /check/description" # Comment this out after creating a DESCRIPTION.en_us.html file.
export OPTIONS="$OPTIONS --exclude-checkid /check/varfont" # Comment this out when making a variable font.
export OPTIONS="$OPTIONS --loglevel INFO --ghmarkdown Fontbakery-check-results.md"
for fontdir in $OUTPUT_DIR/*
do
  if [ -d "$fontdir" ]; then
    fontbakery check-googlefonts $OPTIONS $fontdir/*.ttf
  fi
done
