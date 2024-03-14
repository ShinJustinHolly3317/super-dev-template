#!/bin/bash

# Check if Homebrew is installed, install if not
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found, installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Update Homebrew
brew update

# Install packages
brew install git colima docker asdf awscli starship telnet

# Check and install Visual Studio Code
if brew info --cask visual-studio-code &> /dev/null
then
    echo "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
else
    echo "Visual Studio Code is not available via Homebrew Cask. Please install manually."
fi

echo "Installation completed."

cp ./.zshrc ~/.zshrc
source ~/.zshrc