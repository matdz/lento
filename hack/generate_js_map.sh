#!/bin/bash

# Cartella dei file .md
CONTENT_DIR="content/img"

output=""
first=true

for file in "$CONTENT_DIR"/*.md; do
    # Estrai i campi dal frontmatter
    title=$(grep -m1 '^title:' "$file" | sed 's/title: *//')
    lat_raw=$(grep -m1 '^gps_latitude:' "$file" | sed 's/gps_latitude: *//')
    lon_raw=$(grep -m1 '^gps_longitude:' "$file" | sed 's/gps_longitude: *//')

    # Salta il file se mancano le coordinate GPS
    if [ -z "$lat_raw" ] || [ -z "$lon_raw" ]; then
        continue
    fi

    # Converti da "5 deg 53' 34.29" S" a decimale
    convert_to_decimal() {
        local raw="$1"
        local deg=$(echo "$raw" | grep -oP '^\d+')
        local min=$(echo "$raw" | grep -oP "\d+(?=')")
        local sec=$(echo "$raw" | grep -oP "[0-9]+\.[0-9]+(?=\")")
        local dir=$(echo "$raw" | grep -oP '[NSEW]$')

        local decimal=$(echo "scale=6; $deg + $min/60 + $sec/3600" | bc)

        if [ "$dir" = "S" ] || [ "$dir" = "W" ]; then
            decimal=$(echo "scale=6; -$decimal" | bc)
        fi

        echo "$decimal"
    }

    lat=$(convert_to_decimal "$lat_raw")
    lon=$(convert_to_decimal "$lon_raw")

    # Costruisci la entry JSON
    entry="{\"ID\":\"$title\",\"Name\":\"$title\",\"Latitude\":$lat,\"Longitude\":$lon}"

    if [ "$first" = true ]; then
        output="$entry"
        first=false
    else
        output="$output,$entry"
    fi
done

echo "$output"