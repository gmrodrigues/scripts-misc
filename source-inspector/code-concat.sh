#!/bin/bash

# Get the git root directory (absolute path)
GIT_ROOT=$(git rev-parse --show-toplevel)

# Remove GIT_ROOT prefix from PWD to get relative path
RELATIVE_PATH="${PWD#$GIT_ROOT}"

# Optional: remove leading slash if present
RELATIVE_PATH="${RELATIVE_PATH#/}"

echo "$RELATIVE_PATH"

# Concatenate all source files and configs into a temp file
TEMP_FILE=$(mktemp)

echo "Gerando concatenação dos seguintes arquivos:" >&2

for file in $(find . -type f \( \
    -name "*.yaml" -o \
    -name "*.yml" -o \
    -name "*.md" -o \
    -name "*.sh" -o \
    -name "*.conf" -o \
    -name "*.php" -o \
    -name "*.java" -o \
    -name "*.py" -o \
    -name "*.js" -o \
    -name "*.go" \
    \) ); do
    file="${file#./}"
    echo " - $file" >&2
    echo "## File: $RELATIVE_PATH/$file" >> "$TEMP_FILE"
    cat "$file" >> "$TEMP_FILE"
    echo -e "\n\n" >> "$TEMP_FILE"
done

# Output to stdout
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
