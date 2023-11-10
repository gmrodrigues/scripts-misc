#!/bin/bash

# Concatenate all Git-tracked source files and configs into a temp file
TEMP_FILE=$(mktemp)

echo -e "Plain Code listings. Every line starting with # File: <path> is a new file.\n\n"
for file in $(git ls-files); do
    echo -e "\n\n###############################################"
    echo "## File: $file" >> "$TEMP_FILE"
    git show HEAD:"$file" >> "$TEMP_FILE"
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


#!/bin/bash

# Concatenate all Git-tracked source files and configs into a temp file
for file in $(git ls-files); do
    TEMP_FILE=$(mktemp)
    echo "## File: $file" >> "$TEMP_FILE"
    git show HEAD:"$file" >> "$TEMP_FILE"

    cat "$TEMP_FILE"

    # Copy the contents of the temp file to the clipboard
    if command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard < "$TEMP_FILE"
        echo "Contents of $file copied to clipboard!"
    elif command -v pbcopy >/dev/null 2>&1; then
        pbcopy < "$TEMP_FILE"
        echo "Contents of $file copied to clipboard!"
    else
        echo "Error: xclip or pbcopy not found. Contents not copied to clipboard."
    fi

    # Prompt the user before continuing to the next file
    read -p "Press enter to continue to the next file or type 'q' to quit: " choice
    if [[ "$choice" == "q" ]]; then
        break
    fi

    # Remove the temp file
    rm "$TEMP_FILE"
done

