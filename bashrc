# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


export GOROOT=/usr/local/go
export GOPATH=~/go
PATH="~/bin:~/.local/bin:/usr/local/go/bin:$PATH:$GOPATH/bin"

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1


if [ -f ~/.dotfiles/bash_aliases ]; then
. ~/.dotfiles/bash_aliases
fi

if [ -f ~/.bazel/bin/bazel-complete.bash ]; then
  source ~/.bazel/bin/bazel-complete.bash
fi

export LANG=en_US.utf8

export PROMPT_DIRTRIM=3

#PS1='\[\033]0;\u@\h:\w\007\]\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]'

#prints error codes on red background. error (or lack) must _not_ change number of characters on the line or your terminal will get messed up.
PS1='\[\033]0;\u@\h:\w\007\]$(es=$?; [[ $es -eq 0 ]] && echo "   " || printf "\[$(tput setab 1)\]%3s\[$(tput sgr0)\]" $es)'
PS1+="\[$(tput setaf 2)\]\u@\[$(tput bold)\]\h\[$(tput sgr0)\]:\[$(tput setaf 4;tput bold)\]\w\[$(tput setaf 3)\]\$ \[$(tput sgr0;setterm -linewrap on)\]"
export PS1

# kate: syntax Bash;
