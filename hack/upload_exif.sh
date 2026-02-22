#!/usr/bin/env bash
#
# Crea file .md con dati EXIF per ogni immagine nella cartella

S3BUCKET=ginput
CDN_BASE="https://d17enza3bfujl8.cloudfront.net"

if [[ "$#" -ne 1 ]] ; then
  cat << EOF
Usage: $0 <cartella e.g. /c/Users/matte/foto>
EOF
  exit 1
fi

if ! [[ -x "$(command -v exiftool)" ]] ; then
  echo 'Error: must install exiftool first.' >&2
  exit 1
fi

folder=$1

for filepath in "$folder"/*.{jpg,jpeg,JPG,JPEG,heic,HEIC}; do
  [ -f "$filepath" ] || continue
  filename=$(basename "$filepath")
  extension="${filename##*.}"

  id=$(powershell -command "[guid]::NewGuid().ToString().Split('-')[0]")
  new_filename="${id}.${extension}"
  url="${CDN_BASE}/${new_filename}"

  echo "Processing ${filename} -> ${id}"

  # Estrai i dati EXIF
  make=$(exiftool -Make -s3 "$filepath")
  model=$(exiftool -Model -s3 "$filepath")
  exposure=$(exiftool -ExposureTime -s3 "$filepath")
  fnumber=$(exiftool -FNumber -s3 "$filepath")
  iso=$(exiftool -ISO -s3 "$filepath")
  tz=$(exiftool -OffsetTimeOriginal -s3 "$filepath")
  create_date=$(exiftool -CreateDate -s3 "$filepath" | sed 's/\([0-9]*\):\([0-9]*\):\([0-9]*\)/\1-\2-\3/;s/ /T/')
  create_date="${create_date}${tz}"
  aperture=$(exiftool -ApertureValue -s3 "$filepath")
  focal=$(exiftool -FocalLength -s3 "$filepath")
  gps_alt=$(exiftool -GPSAltitude -s3 "$filepath")
  gps_lat=$(exiftool -GPSLatitude -s3 "$filepath")
  gps_lon=$(exiftool -GPSLongitude -s3 "$filepath")

  # Salva i dati EXIF in un file di testo
  exif_file="./content/img/${id}_exif.txt"
  exiftool -Make -Model -ExposureTime -FNumber -ISO -CreateDate -ApertureValue -FocalLength -GPSAltitude -GPSLatitude -GPSLongitude "$filepath" > "${exif_file}"

  

  static_folder="/c/Users/matte/Downloads/githubpages/lento/static"
  cp "$filepath" "${static_folder}/${new_filename}"
  echo "Copiato ${filename} -> ${static_folder}/${new_filename}"

  
  # Crea il file .md
  img="./content/img/${id}.md"
  echo "---" > "${img}"
  echo "title: ${id}" >> "${img}"
  echo "date: ${create_date}" >> "${img}"
  echo "make: ${make}" >> "${img}"
  echo "model: ${model}" >> "${img}"
  echo "exposure_time: ${exposure}" >> "${img}"
  echo "f_number: ${fnumber}" >> "${img}"
  echo "iso: ${iso}" >> "${img}"
  echo "aperture: ${aperture}" >> "${img}"
  echo "focal_length: ${focal}" >> "${img}"
  echo "gps_altitude: ${gps_alt}" >> "${img}"
  echo "gps_latitude: ${gps_lat}" >> "${img}"
  echo "gps_longitude: ${gps_lon}" >> "${img}"
  #echo "img_url: ${url}" >> "${img}"
  echo "img_url: /${new_filename}" >> "${img}"
  echo "original_fn: ${filename}" >> "${img}"
  echo "tags:" >> "${img}"
  echo "- untagged" >> "${img}"
  echo "---" >> "${img}"

  echo "Creato ${img}"

done

echo "Done!"

  # bash hack/upload_exif.sh /c/Users/matte/Downloads/githubpages/lento/upload_immagini