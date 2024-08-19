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

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


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
cp ./starship.toml ~/.config/starship.toml

source ~/.zshrc

# install asdf plugins
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add python https://github.com/asdf-vm/asdf-python.git

# install asdf versions
asdf install nodejs 20.10.0
asdf install python 3.12.3