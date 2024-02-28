#!/bin/bash

# Check if the first argument is supplied
if [ -z "$1" ]; then
    echo "Error: No file path supplied."
    exit 1
fi

# Check if the supplied argument is a file
if [ ! -f "$1" ]; then
    echo "Error: The supplied argument is not a file or does not exist."
    exit 1
fi

# If the checks pass, set 'balatro_path' to the first argument
balatro_path="$1"

# Set 'balatro_dir' to the directory containing the file
balatro_dir=$(dirname "$balatro_path")

echo "File path is set to: $balatro_path"
echo "File's directory is set to: $balatro_dir"

if command -v brew &> /dev/null; then
    brew install sevenzip
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install sevenzip
fi

temp_dir_git=$(mktemp -d) # Create a temporary directory
temp_dir=$(mktemp -d) # Create a temporary directory

git clone https://github.com/NanashiTheNameless/BalatroModLoader.git $temp_dir_git

7zz x "$balatro_path" -o"$temp_dir"

echo "Extraction completed to $temp_dir."

sed -i '/self\.SPEEDFACTOR = 1/a \    initSteamodded()' $temp_dir/game.lua

echo "" > "$temp_dir_git/staging.lua"
cat "$temp_dir_git/lua/core.lua" >> "$temp_dir_git/staging.lua"
echo "" >> "$temp_dir_git/staging.lua"
cat "$temp_dir_git/lua/debug.lua" >> "$temp_dir_git/staging.lua"
echo "" >> "$temp_dir_git/staging.lua"
cat "$temp_dir_git/lua/loader.lua" >> "$temp_dir_git/staging.lua"
echo "" >> "$temp_dir_git/staging.lua"
cat "$temp_dir_git/lua/deck.lua" >> "$temp_dir_git/staging.lua"
echo "" >> "$temp_dir_git/staging.lua"
cat "$temp_dir_git/lua/joker.lua" >> "$temp_dir_git/staging.lua"

cat "$temp_dir_git/staging.lua" >> "$temp_dir/main.lua"

7zz a "$balatro_path" "$temp_dir/main.lua"

rm -rf $temp_dir $temp_dir_git
