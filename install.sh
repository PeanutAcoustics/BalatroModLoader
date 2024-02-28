#!/bin/bash

temp_dir_git=$(mktemp -d) # Create a temporary directory
temp_dir=$(mktemp -d) # Create a temporary directory

git clone https://github.com/NanashiTheNameless/BalatroModLoader.git $temp_dir_git

balatro_dir="$(locate -e common/Balatro | grep '/Balatro$' | head -n 1)"

balatro_path="$balatro_dir/Balatro.exe"

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
