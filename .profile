# ~/.profile: executed by the command interpreter for login shells.
# This file is NOT read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running zsh
if [ -n "$ZSH_VERSION" ]; then
    # include .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
	. "$HOME/.zshrc"
    fi
else
    # if running bash
    if [ -n "$BASH_VERSION" ]; then
        # include .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
	    . "$HOME/.bashrc"
        fi
    fi
fi



# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
#export LANGUAGE="hu_HU:en_US:en"
export LANGUAGE="en"
export LANG="hu_HU.UTF-8"
export LC_ALL=

case hostname in
    unowebprd) export TERM=xterm-color
	;;
    *) which emacs >/dev/null && emacs --daemon
esac

C=$(readlink .cache)
[ -n "$C" ] && mkdir -p $C
unset C

if [ -z "$DISPLAY" -a -z "$TMUX" ]; then
    tmux attach || tmux
fi
[ -e ~/.profabevjava ] && . ~/.profabevjava
