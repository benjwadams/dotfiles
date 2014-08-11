# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
autoload -U compinit && compinit
setopt complete_in_word
setopt autocd extendedglob multios
bindkey -v

#auto start tmux with 256 color support
[[ -z "$TMUX" ]] && exec tmux -2

#useful tidbit from SO for inserting sudo at beginning of line
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo
#use emacs style delete when using vi insert keymap
bindkey -M viins $terminfo[kbs] backward-delete-char
#edit commands in vim
autoload -U edit-command-line && zle -N edit-command-line
bindkey -M vicmd v edit-command-line
#disable CTRL-s from "freezing" the terminal and ctrl-q, respectively stty -ixon -ixoff
#

alias ls='ls --color' 
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias mnd='matlab -nodesktop -nosplash'
alias -g L='|less'
alias -g C='xclip -selection clipboard'
alias -s 'txt=vim'
alias -s 'shp=qgis'

#zle-keymap-select () {
#  case $KEYMAP in
#    vicmd) print -rn -- $terminfo[cvvis];; # block cursor
#    viins) print -rn -- $terminfo[cnorm];; # less visible cursor
#  esac
#} 


#TODO: fallback gracefully for non 256 color terms
#TODO: Add handlers for non-tmux
zle-keymap-select () {
    if [[ "$KEYMAP" = 'vicmd' ]]; then
        printf '\033Ptmux;\033\033]12;orange\007\033\\'
    else
        printf '\033Ptmux;\033\033]12;grey\007\033\\'
    fi
}; zle -N zle-keymap-select


zle-line-init () {
      zle -K viins
        echo -ne '\033Ptmux;\033\033]12;grey\007\033\\'
}; zle -N zle-line-init

#RPROMPT="Battery: $(acpi | egrep -o '[[:digit:]]+%')%"

#enable zsh syntax highlighting
source ~/.zsh_scripts/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 

#powerline for zsh
source /usr/share/zsh/site-contrib/powerline.zsh

export VIMSERVER=vimserv
#run in vim server
alias startvims="vim --servername $VIMSERVER"
alias vims="vim --servername $VIMSERVER --remote-tab-wait"
alias da=django-admin.py
export EDITOR="vim --servername $VIMSERVER --remote-tab-wait" 

alias shutdown='sudo shutdown'
alias halt='sudo halt'
alias reboot='sudo reboot'

export GEOSERVER_DATA_DIR=/home/benjamin/geonode/geoserver/data

stty stop undef # to unmap ctrl-s

#color man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
} 

export PATH=$PATH:/home/benjamin/anaconda/bin

