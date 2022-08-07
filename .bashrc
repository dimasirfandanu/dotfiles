#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Sourcing
source $HOME/.profile 
source /usr/share/doc/pkgfile/command-not-found.bash
source /usr/share/doc/pkgfile/command-not-found.zsh

# Paths
export PATH=$HOME/.local/bin:$PATH

# EnvVars
export TMUXCONF=$HOME/.tmux.conf
export VIMRC=$HOME/.vimrc
export ALYML=$HOME/.config/alacritty/alacritty.yml
export RCLUA=$HOME/.config/awesome/rc.lua
export AWSTCONF=$HOME/.config/awesome/autorun.sh
export BASHRC=$HOME/.bashrc
export ZSHRC=$HOME/.zshrc
export NEOCONF=$HOME/.config/neofetch/config.conf
export LVLUA=$HOME/.config/lvim/config.lua

# Plugs conf
fuck () # thefuck alias
{
  TF_PYTHONIOENCODING=$PYTHONIOENCODING;
  export TF_SHELL=zsh;
  export TF_ALIAS=fuck;
  TF_SHELL_ALIASES=$(alias);
  export TF_SHELL_ALIASES;
  TF_HISTORY="$(fc -ln -10)";
  export TF_HISTORY;
  export PYTHONIOENCODING=utf-8;
  TF_CMD=$(
    thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@
    ) && eval $TF_CMD;
  unset TF_HISTORY;
  export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
  test -n "$TF_CMD" && print -s $TF_CMD
}

# Term init random changing colorscheme
chkr () { # Check running terminal
	pgrep -c $TERM
}
alinit() { # alacritty init
	if [[ "$TERM" == "alacritty" ]]; then
		alacritty-themes $(shuf $(alacritty-themes --list|cut -d " " -f 2) -en 1) &> /dev/null
	fi
}
alias at=alinit
ttyinit() { # TTY init
	if [[ "$TERM" == "linux" ]]; then
		ttycolor $(shuf -en 1 $(ttycolor -l)) 
	fi
}
alias tt=ttyinit
if [[ $(chkr) > 1 ]]; then # Term exec
  echo "$TERM is running not changing theme" &> /dev/null
elif [[ $(chkr) == 1 ]]; then
  alinit
else
  ttyinit
fi

# Term init display and greeting
clear
randdisply () # Randomize terminal display init
{
  export randnumbdisp=$(shuf -i 1-2 -n1) # Generate random numbers for display assignment
  if [[ $randnumbdisp == 1 ]]; then
    nerdfetch # Assigning nerdfetch
  elif [[ $randnumbdisp == 2 ]]; then
    colorscript -r # Assigning colorscript
  fi
}
randdisply
randgreet () # Randomize greeting text
{
  export FT=$HOME/friendly_terminal/
  export randnumbgreet=$(shuf -i 1-2 -n1) # Generate random numbers for greeting assignment
  if [[ $randnumbgreet == 1 ]]; then
    fortune # Assigning fortune
  elif [[ $randnumbgreet == 2 ]]; then
    python $FT/randline.py $FT/quotes_for_terminal.txt dimas # Assigning friendly_terminal
  fi
}
randgreet

# Aliases
# PS1='[\u@\h \W]\$ '
alias c='clear && randdisply && randgreet'
alias cc='$(readlink /proc/$$/exe)'
alias n=neofetch
# Aliases for exa
alias e='/usr/bin/exa -s 'modified' --icons -a' 
alias ee='/usr/bin/exa -s 'modified' --icons -alh'
alias et='/usr/bin/exa -s 'modified' --icons -a -T'
alias eet='/usr/bin/exa -s 'modified' --icons -alh -T'
alias ep='/usr/bin/exa -s 'modified' --icons -lh -T'
#
alias b=bat
alias vc=/usr/bin/'protonvpn-cli c -f'
alias vd=/usr/bin/'protonvpn-cli d'
alias ddgr='BROWSER=lynx ddgr'
# Aliases for yay
alias yrcns='yay -Rcns'
alias ys='yay -S'
alias ysl='yay --sortby popularity'
alias ysyu='yay -Syu'
alias yf='yay -F'
alias yql='yay -Ql'
alias ysi='yay -Si'
alias ysy='yay -Sy'
#
alias pg='ping google.com'
alias nvim=lvim
alias v=nvim
alias wl='sudo wondershaper -a wlan0 -d 2560'
alias wr='sudo wondershaper -c -a wlan0'
alias ws='sudo wondershaper -s -a wlan0'
alias rn='nmcli d modify wlan0 ipv4.address 192.168.1.$(shuf -i 10-99 -n1)/24'
alias pb='~/.config/polybar/launch.sh --$(shuf ~/.config/polybar/themes-list -n1)'
alias p=peco
alias vp='variety -p --profile=~/.config/variety-profiles/.variety/ &'
alias anaconda='ternimal length=100 thickness=1,4,1,0,0 radius=6,12 gradient=0:#666600,0.5:#00ff00,1:#003300'
alias swarm='ternimal length=200 thickness=0,4,19,0,0'
alias z=zathura
alias cs=colorscript
alias cp='rsync -r -P'
alias webs='python -m http.server 8080'
alias pv='pipe-viewer'
alias pvn='pipe-viewer -n'
