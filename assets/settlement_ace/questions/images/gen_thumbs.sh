#!/bin/bash

# Create the thumbnails directory if it doesn't exist
mkdir -p ./thumbnails

# Find all JPG files in the current directory (case-insensitive)
# and process each one
find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | while IFS= read -r -d $'\0' file; do
  # Get the filename without the path
  filename=$(basename "$file")
  # Get the filename without the extension
  name_no_ext="${filename%.*}"

  # Define the output filename for 48x48 thumbnail
  output_filename_48="./thumbnails/${name_no_ext}_48x48.jpg"
  # Define the output filename for 128x128 thumbnail
  output_filename_128="./thumbnails/${name_no_ext}_128x128.jpg"

  # Process 48x48 thumbnail
  # Check if the 48x48 thumbnail already exists
  if [ ! -f "$output_filename_48" ]; then
    # Resize the image and save it to the thumbnails directory
    magick "$file" -resize 48x48! "$output_filename_48"
    echo "Resized $filename to $output_filename_48"
  else
    echo "Thumbnail $output_filename_48 already exists. Skipping."
  fi

  # Process 128x128 thumbnail
  # Check if the 128x128 thumbnail already exists
  if [ ! -f "$output_filename_128" ]; then
    # Resize the image and save it to the thumbnails directory
    magick "$file" -resize 128x128! "$output_filename_128"
    echo "Resized $filename to $output_filename_128"
  else
    echo "Thumbnail $output_filename_128 already exists. Skipping."
  fi
done

echo "Thumbnail generation complete."
