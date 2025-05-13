#!/bin/bash

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install core utilities
echo "Installing core utilities (fzf, bat, eza, toilet, jq, yq, watch, tmux, entr, httpie, parallel, gh, fd, mas)..."
brew install fzf bat eza toilet jq yq watch tmux entr httpie parallel gh fd mas

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# Set Powerlevel10k as the default theme
sed -i '' 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Enable Nerd Font support
echo 'POWERLEVEL9K_MODE="nerdfont-complete"' >> ~/.zshrc

# Install recommended plugins
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# Add plugins to ~/.zshrc
sed -i '' 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Enable correction
sed -i '' 's/^# ENABLE_CORRECTION="true"/ENABLE_CORRECTION="true"/' ~/.zshrc

# Disable insecure completion warning
echo 'ZSH_DISABLE_COMPFIX=true' >> ~/.zshrc

# Add useful aliases and banner
cat << 'EOF' >> ~/.zshrc

# Banner (only show if interactive)
if [[ $- == *i* ]]; then
    clear
    toilet --gay "HELLO CORY"
fi

# Useful Aliases
alias ll='ls -lhA'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'
alias rmf='rm -rf'
alias c='clear'
alias h='history'

# Git Shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcl='git clone'

# System Info
alias cpuinfo='sysctl -n machdep.cpu.brand_string'
alias meminfo='vm_stat | awk "/Pages free/ {print \$3 * 4096 / 1024 / 1024 \" MB Free\"}"'
alias ipinfo='ipconfig getifaddr en0'

# Quick Server and Network Commands
alias serve='python3 -m http.server'
alias ports='lsof -i -P | grep LISTEN'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# ZSH and Powerlevel10k
alias zshrc="nano ~/.zshrc"
alias p10kconfig="p10k configure"

# Miscellaneous
alias pls='sudo !!'
alias upgrade='brew update && brew upgrade && brew cleanup'
alias f='open -a Finder ./'

# fzf (Fuzzy Finder) Aliases
alias fh='history | fzf'
alias fkill='ps aux | fzf | awk "{print \$2}" | xargs kill -9'

# bat (Better cat) Aliases
alias cat='bat'
alias batcat='bat --paging=never'

# eza (Enhanced ls) Aliases
alias ls='eza'
alias la='eza -a'
alias ll='eza -lhF --git'
alias lt='eza -T -L 2'
alias lla='eza -la'

# Show/Hide Hidden Files in Finder
alias showhidden='defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder'
alias hidehidden='defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder'

#sysdump
alias sysdash='~/sysdash.sh'


# Print all aliases
alias help-alias="grep '^alias ' ~/.zshrc | sed 's/^alias //g'"

EOF

# Final message
echo -e "\nSetup complete! Please restart your terminal or run 'exec zsh' to apply the changes. After which run p10kconfigure to configure theme"
