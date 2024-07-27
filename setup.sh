#!/bin/zsh

# Disclaimer
echo "This script will install software and modify your system configuration. Proceed with caution."

# Check for Homebrew and install if not found
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed."
fi

# Update and upgrade Homebrew
brew update && brew upgrade

# Install essential command line tools
brew install git zsh vim curl wget

# Install web development tools
echo "Installing necessary applications..."
brew install node # Node.js (includes npm)
brew install mysql
brew install php
brew install composer

# Install development and productivity tools
echo "Installing development and productivity tools..."
brew install --cask visual-studio-code
brew install --cask google-chrome
brew install --cask firefox
brew install --cask iterm2
brew install --cask rectangle
brew install --cask raycast
brew install --cask github
brew install --cask gpg-suite

# Install database management tools
echo "Installing database management tools..."
brew install --cask mysqlworkbench
brew install --cask sequel-ace

# Install fonts
echo "Installing fonts..."
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

plugins=(
  "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
  "zsh-completions https://github.com/zsh-users/zsh-completions"
  "zsh-nvm https://github.com/lukechilds/zsh-nvm"
  "you-should-use https://github.com/MichaelAquilina/zsh-you-should-use"
)

for plugin in "${plugins[@]}"; do
  name="${plugin%% *}"
  url="${plugin##* }"
  if [ -d "$ZSH_CUSTOM/plugins/$name" ]; then
    echo "$name is already installed."
  else
    git clone "$url" "$ZSH_CUSTOM/plugins/$name"
  fi
done

# Configure .zshrc for plugins
echo "Configuring .zshrc..."
if grep -q "plugins=(" ~/.zshrc; then
  sed -i '' 's/plugins=(\([^)]*\))/plugins=(\1 zsh-nvm zsh-syntax-highlighting)/' ~/.zshrc
else
  echo 'plugins=(zsh-nvm zsh-autosuggestions zsh-completions you-should-use zsh-syntax-highlighting)' >> ~/.zshrc
fi

# Install starship prompt if not installed
if ! command -v starship &> /dev/null; then
  echo "Starship not found. Installing starship..."
  brew install starship
fi

# Append starship and zoxide initialization to .zshrc if not already present
if ! grep -q "eval \"\$(starship init zsh)\"" ~/.zshrc; then
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
else
  echo "starship is already in .zshrc" 
fi


if ! grep -q "eval \"\$(zoxide init zsh)\"" ~/.zshrc; then
  echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
else
  echo "zoxide is already in .zshrc" 
fi

# Source .zshrc to apply changes
source ~/.zshrc

# Install the latest LTS Node.js version using nvm
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

# Install global npm packages for NextJS and React development
echo "Installing global npm packages..."
npm install -g create-next-app
npm install -g create-react-app

# Function to handle file replacement with user confirmation
handle_file() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ]; then
    read "response?File $dest already exists. Do you want to replace it? (y/n): "
    if [[ "$response" =~ ^[Yy]$ ]]; then
      cp "$src" "$dest"
      echo "Replaced $dest."
    else
      echo "Skipping $dest."
    fi
  else
    cp "$src" "$dest"
    echo "Copied $src to $dest."
  fi
}

# Restore dotfiles
echo "Restoring dotfiles..."
handle_file ./.vim ~/.
handle_file ./.vimrc ~/
mkdir -p ~/.config
handle_file ./starship.toml ~/.config/starship.toml
handle_file ./.gitconfig ~/

echo "Setup complete!"