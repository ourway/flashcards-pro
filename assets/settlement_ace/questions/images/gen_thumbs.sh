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
  # Define the output filename
  output_filename="./thumbnails/${name_no_ext}_32x32.jpg"

  # Check if the thumbnail already exists
  if [ ! -f "$output_filename" ]; then
    # Resize the image and save it to the thumbnails directory
    magick "$file" -resize 32x32 "$output_filename"
    echo "Resized $filename to $output_filename"
  else
    echo "Thumbnail $output_filename already exists. Skipping."
  fi
done

echo "Thumbnail generation complete."
