#!/bin/bash

# Concatenate all source files and configs into a temp file
TEMP_FILE=$(mktemp)
for file in $(find . -type f \( -name "*.sh" -o -name "*.conf" \) ); do
    echo "## File: $file" >> "$TEMP_FILE"
    cat "$file" >> "$TEMP_FILE"
done

cat "$TEMP_FILE"

# Copy the contents of the temp file to the clipboard
if command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard < "$TEMP_FILE"
    echo "Contents copied to clipboard!"
elif command -v pbcopy >/dev/null 2>&1; then
    pbcopy < "$TEMP_FILE"
    echo "Contents copied to clipboard!"
else
    echo "Error: xclip or pbcopy not found. Contents not copied to clipboard."
fi

# Remove the temp file
rm "$TEMP_FILE"
