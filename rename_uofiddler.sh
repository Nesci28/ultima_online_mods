#!/bin/bash

# === Items ===
cd ./converted/UOFiddler/items
for file in Item\ 0x*.png; do
    [[ -f "$file" ]] || continue
    hex=$(echo "$file" | sed -E 's/Item 0x([0-9A-Fa-f]+)\.png/\1/')
    decimal=$((16#$hex))
    # Look for a .psd with same hex in ./ART and all subfolders
    if find ../../../ART -type f -iname "*_0x$hex.psd" | grep -q .; then
        mv "$file" "$decimal.png"
    else
        rm "$file"
    fi
done
cd - >/dev/null

# === Textures ===
cd ./converted/UOFiddler/textures
for file in Texture\ 0x*.png; do
    [[ -f "$file" ]] || continue
    hex=$(echo "$file" | sed -E 's/Texture 0x([0-9A-Fa-f]+)\.png/\1/')
    decimal=$((16#$hex))
    # Look for a .psd with same hex in ./ENV and all subfolders
    if find ../../../ENV -type f -iname "*_0x$hex.psd" | grep -q .; then
        mv "$file" "$decimal.png"
    else
        rm "$file"
    fi
done
cd - >/dev/null

# === Gumps ===
cd ./converted/UOFiddler/gumps
for file in Gump\ 0x*.png; do
    [[ -f "$file" ]] || continue
    hex=$(echo "$file" | sed -E 's/Gump 0x([0-9A-Fa-f]+)\.png/\1/')
    decimal=$((16#$hex))
    # Look for a .psd with same hex in ./UI and all subfolders
    if find ../../../UI -type f -iname "*_0x$hex.psd" | grep -q .; then
        mv "$file" "$decimal.png"
    else
        rm "$file"
    fi
done
cd - >/dev/null
