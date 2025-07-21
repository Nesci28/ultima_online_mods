#!/bin/bash

AI_BASE="converted/ai"
MAGICK_BASE_FUZZ0="converted/magick_fuzz0"
MAGICK_BASE_FUZZ5="converted/magick_fuzz5"
MAGICK_BASE_FUZZ10="converted/magick_fuzz10"

echo "Finding PSD files matching pattern: _0x[0-9A-Fa-f]+.psd"

# Show all files
echo -e "\nAll files found:"
find . -type f

# Show filtered files
echo -e "\nFiltered PSD files:"
find . -type f | grep -E "_0x[0-9A-Fa-f]+\.psd$"

# Process files
find . -type f | grep -E "_0x[0-9A-Fa-f]+\.psd$" | while read -r file; do
    relpath="${file#./}"
    filename=$(basename "$file")
    hex=$(echo "$filename" | sed -E 's/.*_0x([0-9A-Fa-f]+)\..*/\1/')
    decimal=$((16#$hex))
    dir=$(dirname "$relpath")

    # AI output
    ai_dir="$AI_BASE/$dir"
    mkdir -p "$ai_dir"
    ai_file="$ai_dir/$decimal.png"
    echo "Exporting $file to $ai_file (hex=$hex, dec=$decimal) for AI background removal"
	convert "$file[0]" -colorspace sRGB PNG32:"$ai_file"

	# Use a temporary file for backgroundremover output
	tmp_file="${ai_file}.tmp"
	removebg "$ai_file" "$tmp_file"

	# Only replace if backgroundremover succeeded and output is valid
	if [ -s "$tmp_file" ] && file "$tmp_file" | grep -q 'PNG image data'; then
	    mv "$tmp_file" "$ai_file"
	    echo "Background removed for $ai_file"
	else
	    echo "Warning: backgroundremover failed for $ai_file"
	    [ -f "$tmp_file" ] && rm "$tmp_file"
	fi

    # Magick output
    magick_dir="$MAGICK_BASE_FUZZ0/$dir"
    mkdir -p "$magick_dir"
    magick_file="$magick_dir/$decimal.png"
    echo "Exporting $file to $magick_file (hex=$hex, dec=$decimal) with black -> transparent"
    convert "$file[0]" -colorspace sRGB PNG32:- | magick - -transparent black "$magick_file"

    # Magick output
    magick_dir="$MAGICK_BASE_FUZZ5/$dir"
    mkdir -p "$magick_dir"
    magick_file="$magick_dir/$decimal.png"
    echo "Exporting $file to $magick_file (hex=$hex, dec=$decimal) with black -> transparent"
    convert "$file[0]" -colorspace sRGB PNG32:- | magick - -fuzz 5% -transparent black "$magick_file"

    # Magick output
    magick_dir="$MAGICK_BASE_FUZZ10/$dir"
    mkdir -p "$magick_dir"
    magick_file="$magick_dir/$decimal.png"
    echo "Exporting $file to $magick_file (hex=$hex, dec=$decimal) with black -> transparent"
    convert "$file[0]" -colorspace sRGB PNG32:- | magick - -fuzz 10% -transparent black "$magick_file"
done
