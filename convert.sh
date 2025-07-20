#!/bin/bash

CONVERTED_BASE="converted"

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
    out_dir="$CONVERTED_BASE/$dir"
    mkdir -p "$out_dir"
    out_file="$out_dir/$decimal.png"
    echo "Converting $file --> $out_file (hex=$hex, dec=$decimal)"
    # Convert PSD (first layer) to PNG with transparency
    convert "$file[0]" -colorspace sRGB PNG32:"$out_file"
done
