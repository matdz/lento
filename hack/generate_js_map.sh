#!/bin/bash

CONTENT_DIR="content/img"

output=""
first=true

for file in "$CONTENT_DIR"/*.md; do
    title=$(grep -m1 '^title:' "$file" | sed 's/title: *//')
    lat_raw=$(grep -m1 '^gps_latitude:' "$file" | sed 's/gps_latitude: *//')
    lon_raw=$(grep -m1 '^gps_longitude:' "$file" | sed 's/gps_longitude: *//')
    lat_dec=$(grep -m1 '^gps_latitude_dec:' "$file" | sed 's/gps_latitude_dec: *//')
    lon_dec=$(grep -m1 '^gps_longitude_dec:' "$file" | sed 's/gps_longitude_dec: *//')

    if [ -z "$lat_raw" ] || [ -z "$lon_raw" ]; then
        continue
    fi

    convert_to_decimal() {
        local raw="$1"
        echo "$raw" | awk '{
            deg = $1
            min = $3
            sec = $4
            dir = $5
            # rimuovi apici e virgolette
            gsub(/['"'"'"]/, "", min)
            gsub(/['"'"'"]/, "", sec)
            decimal = deg + min/60 + sec/3600
            if (dir == "S" || dir == "W") decimal = -decimal
            printf "%.6f", decimal
        }'
    }

    lat=$(convert_to_decimal "$lat_raw")
    lon=$(convert_to_decimal "$lon_raw")

    entry="{\"ID\":\"$title\",\"Name\":\"$title\",\"Latitude\":$lat_dec,\"Longitude\":$lon_dec}"

    if [ "$first" = true ]; then
        output="$entry"
        first=false
    else
        output="$output,$entry"
    fi
done

echo "$output"