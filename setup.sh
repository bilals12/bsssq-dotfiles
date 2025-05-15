#!/bin/bash

DOTFILES="$HOME/dotfiles"
CONFIG_SRC="$DOTFILES/.config"
CONFIG_DEST="$HOME/.config"

# List of .config subdirectories to exclude from symlinking
EXCLUDES=("AWS VPN Client" "AWSVPNClient" "git" "gh" ".DS_Store")

# Function to check if value is in array
contains() {
  local match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# Loop through each directory in repo's .config
for dir in "$CONFIG_SRC"/*; do
  name="$(basename "$dir")"
  contains "$name" "${EXCLUDES[@]}" && continue

  src="$CONFIG_SRC/$name"
  dest="$CONFIG_DEST/$name"

  # Backup existing directory if it exists and isn't a symlink
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up $dest to $dest.backup"
    mv "$dest" "$dest.backup"
  fi

  # Remove existing symlink
  if [ -L "$dest" ]; then
    rm "$dest"
  fi

  echo "Symlinking $src -> $dest"
  ln -s "$src" "$dest"
done

echo "Config symlinking complete!"

