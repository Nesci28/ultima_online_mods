#!/bin/bash

EXTENSIONS="png|bmp|jpg|jpeg|gif"
CONVERTED_BASE="converted"

# Pattern for extensions, separated by |
EXT_PATTERN=$(echo "$EXTENSIONS" | sed 's/|/\\|/g')

echo "Finding files matching pattern: _0x[0-9a-f]+.(EXT)"
echo "EXT_PATTERN: $EXT_PATTERN"

# Show all files
echo -e "\nAll files found:"
find . -type f

# Show filtered files
echo -e "\nFiltered files:"
find . -type f | grep -E "_0x[0-9A-Fa-f]+\.(bmp|BMP|png|PNG|jpg|JPG|jpeg|JPEG|gif|GIF)$"

# Process files
find . -type f | grep -E "_0x[0-9A-Fa-f]+\.(bmp|BMP|png|PNG|jpg|JPG|jpeg|JPEG|gif|GIF)$" | while read -r file; do
    relpath="${file#./}"
    filename=$(basename "$file")
    hex=$(echo "$filename" | sed -E 's/.*_0x([0-9A-Fa-f]+)\..*/\1/')
    decimal=$((16#$hex))
    dir=$(dirname "$relpath")
    out_dir="$CONVERTED_BASE/$dir"
    mkdir -p "$out_dir"
    out_file="$out_dir/$decimal.png"
    echo "Converting $file --> $out_file (hex=$hex, dec=$decimal)"
    convert "$file" "$out_file"
done
