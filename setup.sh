#!/bin/bash

# Disclaimer
echo "This script will install software and modify your system configuration. Proceed with caution."

# Check for Homebrew and install if not found
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed."
fi

# Update and upgrade Homebrew
brew update && brew upgrade

# Install essential command-line tools
brew install git zsh vim curl wget

# Install web development tools
echo "Installing necessary applications..."
brew install node # Node.js (includes npm)
brew install mysql
brew install php
brew install composer

# Install Homebrew Cask
brew tap homebrew/cask

# Install development and productivity tools
echo "Installing development and productivity tools..."
brew install --cask visual-studio-code
brew install --cask google-chrome
brew install --cask firefox
brew install --cask iterm2
brew install --cask rectangle

# Install database management tools
echo "Installing database management tools..."
brew install --cask mysqlworkbench

# Install fonts
echo "Installing fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
brew install --cask font-proggy-clean
brew install --cask font-anonymous-pro
brew install --cask font-jetbrains-mono

# Install additional tools (optional)
echo "Installing additional tools..."
brew install --cask whatsapp
brew install --cask vlc
brew install --cask spotify
brew install --cask bitwarden
brew install zoxide

# Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is already installed."
else
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Set up Oh My Zsh plugins
echo "Installing Oh My Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
git clone https://github.com/lukechilds/zsh-nvm $ZSH_CUSTOM/plugins/zsh-nvm
git clone https://github.com/MichaelAquilina/zsh-you-should-use $ZSH_CUSTOM/plugins/you-should-use

# Ensure zsh-syntax-highlighting is the last plugin
echo "Configuring .zshrc..."
if grep -q "plugins=(" ~/.zshrc; then
  sed -i '' '/plugins=(/c\plugins=(zsh-autosuggestions zsh-completions zsh-nvm you-should-use zsh-syntax-highlighting)' ~/.zshrc
else
  echo 'plugins=(zsh-autosuggestions zsh-completions zsh-nvm you-should-use zsh-syntax-highlighting)' >> ~/.zshrc
fi

# Append starship and zoxide initialization to .zshrc if not already present
if ! grep -q "eval \"\$(starship init zsh)\"" ~/.zshrc; then
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

if ! grep -q "eval \"\$(zoxide init zsh)\"" ~/.zshrc; then
  echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
fi

# Source .zshrc to apply changes
source ~/.zshrc

# Install nvm
echo "Installing nvm..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Install the latest LTS Node.js version using nvm
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

# Install global npm packages for NextJS and React development
echo "Installing global npm packages..."
npm install -g create-next-app
npm install -g create-react-app

# Restore dotfiles
echo "Restoring dotfiles..."
cp -r ./dotfiles/.vim ~/
cp ./dotfiles/.vimrc ~/
mkdir -p ~/.config
cp ./dotfiles/starship.toml ~/.config/
cp ./dotfiles/.gitconfig ~/

echo "Setup complete!"

