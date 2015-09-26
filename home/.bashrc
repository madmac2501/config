# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# less colors for man pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mroe='more'
alias g='git'

. $HOME/tmp/libs/git/contrib/completion/git-completion.bash
complete -o bashdefault -o default -o nospace -F _git g

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

# maven environment variables
export JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-x64/
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=512m"

# jboss environments variables
#export JBOSS_HOME=/opt/jboss-4.2.2.GA
#export PATH=$PATH:$JBOSS_HOME/bin

# modelsim environment variables
#export PATH=$HOME/modeltech/linux:$PATH
#export LM_LICENSE_FILE=$HOME/modeltech/license.$(hostname).dat

# quilt - tool to manage series of patches
# (configured for debian packages maintenace)
export QUILT_PATCHES="debian/patches"
export QUILT_DIFF_ARGS="--no-timestamps --no-index -pab"
export QUILT_REFRESH_ARGS="--no-timestamps --no-index -pab"

#-------------------------------------------------------------
# Path environment variables
#-------------------------------------------------------------

local_dir="$HOME/local"

# reset paths
PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/local/sbin:/usr/sbin"
unset CPATH
unset LIBRARY_PATH
unset LD_LIBRARY_PATH
unset PKG_CONFIG_PATH
unset GST_PLUGIN_PATH

# path for local superuser bins
PATH=`find $local_dir -maxdepth 2 -type d -regex "$local_dir/.*/sbin" -printf "%p:" 2> /dev/null`$PATH

# path for local bins
PATH=`find $local_dir -maxdepth 2 -type d -regex "$local_dir/.*/bin" -printf "%p:" 2> /dev/null`$PATH

# path for making local headers available to gcc
CPATH=`find $local_dir -maxdepth 2 -type d -regex "$local_dir/.*/include" -printf "%p:" 2> /dev/null`$CPATH

# path for making local libs available to gcc linker
LIBRARY_PATH=`find $local_dir -maxdepth 2 -type d -regex "$local_dir/.*/lib" -printf "%p:" 2> /dev/null`$LIBRARY_PATH

# path for making local libs available to ld.so
LD_LIBRARY_PATH=`find $local_dir -maxdepth 2 -type d -regex "$local_dir/.*/lib" -printf "%p:" 2> /dev/null`$LD_LIBRARY_PATH

# path for local pkg-config files
PKG_CONFIG_PATH=`find $local_dir -maxdepth 3 -type d -regex "$local_dir/.*/lib/pkgconfig" -printf "%p:" 2> /dev/null`$PKG_CONFIG_PATH

# gstreamer environment variables
GST_PLUGIN_PATH=`find $local_dir -maxdepth 2 -type d -regex "$local_dir/gst-\(plugins-\(base\|good\|bad\|ugly\)\|ffmpeg\).*/lib" -printf "%p:" 2> /dev/null`$GST_PLUGIN_PATH


# remove ':' suffix and make them public
if [[ "${PATH}" != "" ]]; then
  export PATH=${PATH%:}
fi
if [[ "${CPATH}" != "" ]]; then
 export CPATH=${CPATH%:}
fi
if [[ "${LIBRARY_PATH}" != "" ]]; then
  export LIBRARY_PATH=${LIBRARY_PATH%:}
fi
if [[ "${LD_LIBRARY_PATH}" != "" ]]; then
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
fi
if [[ "${PKG_CONFIG_PATH}" != "" ]]; then
  export PKG_CONFIG_PATH=${PKG_CONFIG_PATH%:}
fi
if [[ "${GST_PLUGIN_PATH}" != "" ]]; then
  export GST_PLUGIN_PATH=${GST_PLUGIN_PATH%:}
fi

#-------------------------------------------------------------
# Python local's
#-------------------------------------------------------------
#pythonver=`python -c "import sys; print sys.version[:3]"`
#PYTHONPATH="$local_dir/pyrtlsdr/lib/python${pythonver}/site-packages":$PYTHONPATH
#export PYTHONPATH

#-------------------------------------------------------------
# Development environment variables
#-------------------------------------------------------------

#export LANG=C # dont use gettext to avoid concurrency problems
#export MALLOC_CHECK_=2 # debug malloc calls
