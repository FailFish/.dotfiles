# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Commands
# https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_zsh
# press n instead of nnn, ctrl-g for cd & quit
n ()
{
    # Block nesting of nnn in subshells
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The backslash allows one to alias n to nnn if desired without making an
    # infinitely recursive alias
    \nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

clipb ()
{
	# TODO: port for fish, (maybe) WSL/MAC OS compatible
	if command -v xclip 1>/dev/null; then
		if [[ -p /dev/stdin ]] ; then
			xclip -i -selection clipboard
		else
			xclip -o -selection clipboard
		fi
	else
		echo "install xclip"
	fi
}

# Theme
# Credit to https://github.com/sapegin/dotfiles

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
GRAY="$(tput setaf 8)"
BOLD="$(tput bold)"
UNDERLINE="$(tput sgr 0 1)"
INVERT="$(tput sgr 1 0)"
NOCOLOR="$(tput sgr0)"


# set variable identifying the chroot you work in (can be used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot) # "${debian_chroot:+($debian_chroot)}"
fi

# User color
case $(id -u) in
  0) user_color="$RED" ;;  # root
  *) user_color="$YELLOW" ;;
esac

# Symbols
prompt_symbol="❯"

function prompt_command() {
  # Local or SSH session?
  local remote=
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && remote=1

  # Only show username if not default
  local user_prompt=
  [ "$USER" != "$local_username" ] && user_prompt="$user_color$USER$NOCOLOR"

  # Show hostname inside SSH session
  local host_prompt=
  [ -n "$remote" ] && host_prompt="@$YELLOW$HOSTNAME$NOCOLOR"

  # Show delimiter if user or host visible
  local login_delimiter=
  [ -n "$user_prompt" ] || [ -n "$host_prompt" ] && login_delimiter=":"

  # Show delimiter if user or host visible
  local nix_prompt=
  [ -n "$IN_NIX_SHELL" ] && nix_prompt="[nix]"

  # # Git branch name and work tree status (only when we are inside Git working tree)
  # local git_prompt=
  # if [[ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
  #   # Branch name
  #   local branch="$(git symbolic-ref HEAD 2>/dev/null)"
  #   branch="${branch##refs/heads/}"
  #
  # # Working tree status (red when dirty)
  # local dirty=
  # # Modified files
  # git diff --no-ext-diff --quiet --exit-code --ignore-submodules 2>/dev/null || dirty=1
  # # Untracked files
  # [ -z "$dirty" ] && test -n "$(git status --porcelain)" && dirty=1
  #
  # # Format Git info
  # if [ -n "$dirty" ]; then
  #   git_prompt=" $RED$prompt_dirty_symbol$branch$NOCOLOR"
  # else
  #   git_prompt=" $GREEN$prompt_clean_symbol$branch$NOCOLOR"
  # fi
  # fi

  # Virtualenv
  # local venv_prompt=
  # if [ -n "$VIRTUAL_ENV" ]; then
  #   venv_prompt=" $BLUE$prompt_venv_symbol$(basename $VIRTUAL_ENV)$NOCOLOR"
  # fi

  # Format prompt
  first_line="$user_prompt$host_prompt$login_delimiter$BOLD$CYAN\w$NOCOLOR$nix_prompt"
  # Text (commands) inside \[...\] does not impact line length calculation which fixes stange bug when looking through the history
  # $? is a status of last command, should be processed every time prompt prints
  second_line="\`if [ \$? = 0 ]; then echo \[\$GREEN\]; else echo \[\$RED\]; fi\`\$prompt_symbol\[\$NOCOLOR\] "
  PS1="\n$first_line\n$second_line"

  # Multiline command
  PS2="\[$CYAN\]$prompt_symbol\[$NOCOLOR\] "

  # Terminal title
  local title="$(basename "$PWD")"
  [ -n "$remote" ] && title="$title \xE2\x80\x94 $HOSTNAME"
  echo -ne "\033]0;$title"; echo -ne "\007"
}

PROMPT_COMMAND=prompt_command

# ETC

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL="erasedups:ignoreboth"

# append to the history file, don't overwrite it
shopt -s histappend

# store multiline command as one line
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# Record each line as it gets issued
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias cp="cp -i"                          # confirm before overwriting something
alias rm="rm -i"
alias mv="mv -i"
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
# some manual ls aliases when exa is not installed
if ! grep exa <(type ls) 1>/dev/null; then
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
fi
alias lg='lazygit'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# vi editing mode
set -o vi

# changing basic editor
export EDITOR=vim
export VISUAL=vim

# Prepend $PATH without duplicates
function _prepend_path() {
	if ! $( echo "$PATH" | tr ":" "\n" | grep -qx "$1" ) ; then
		PATH="$1:$PATH"
	fi
}

# Construct $PATH
# PATH='/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'
[ -d /usr/local/bin ] && _prepend_path "/usr/local/bin"
[ -d ~/.local/bin ] && _prepend_path "$HOME/.local/bin"
[ -d ~/.cargo/bin ] && _prepend_path "$HOME/.cargo/bin"
# command -v brew >/dev/null 2>&1 && _prepend_path "$(brew --prefix coreutils)/libexec/gnubin"
export PATH

# added by fzf install script automatically
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# custom environment variables & aliases stored at $HOME/.bashrc_local
if [ -f ~/.bashrc_local ]; then
	source ~/.bashrc_local
fi



eval "$(zoxide init bash)"
