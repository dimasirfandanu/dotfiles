# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.

rm -rf $HOME/.npm $HOME/.cargo $HOME/.rustup

zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Don't start tmux.
zstyle ':z4h:' start-tmux       no

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.

z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'
alias cat='batcat'

# Add flags to existing aliases.
alias ls='eza'

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

alias whatsapp='cd $HOME/whatsapp-cli && npm start'

# --- Installations ---

# Update package list once before starting installations
echo "Checking for and installing required packages..."
sudo apt-get update

# Function to install a package if the command doesn't exist
install_if_missing() {
    local cmd=$1
    local pkg=$2
    if ! command -v "$cmd" &> /dev/null; then
        echo "Command '$cmd' not found. Installing '$pkg'..."
        sudo apt-get install -y "$pkg"
    fi
}

# Install packages from apt
install_if_missing "eza" "eza"
install_if_missing "tmux" "tmux"
install_if_missing "batcat" "bat"
install_if_missing "nvim" "neovim"
install_if_missing "neofetch" "neofetch"

# Install LunarVim if not installed
if ! command -v lvim &> /dev/null; then
    echo "Installing LunarVim. This may take a moment..."
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl https://raw.githubusercontent.com/LunarVim/lunarvim/master/utils/installer/install.sh) --yes
fi

# Add LunarVim to the PATH
export PATH="$HOME/.local/bin:$PATH"

# Set LunarVim environment variables
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"$HOME/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"$HOME/.cache/lvim"}"

# Install sherlock if not installed
if [ ! -d "$HOME/sherlock" ]; then
    echo "Sherlock is not installed. Installing it now..."
    git clone https://github.com/sherlock-project/sherlock.git $HOME/sherlock && cd $HOME/sherlock && python3 -m pip install -r requirements.txt
fi

echo "Package installation check complete."

# Alias for clear and neofetch
alias clear='clear && neofetch'

alias sherlock='cd $HOME/sherlock && python3 -m sherlock_project'

cd $HOME
clear
