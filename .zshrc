# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob nomatch notify
unsetopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gthomas/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#colors and prompt
autoload -U colors && colors
PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

#aliases
alias l='ls -lA --color=auto'


# PATH
export CHROMIUM_USER_FLAGS="--memory-model=low --purge-memory-button --enable-internal-flash"

if [ -x /usr/local/go/bin/go ]; then
    export GOROOT=/usr/local/go
    export PATH=$PATH:$GOROOT/bin
fi
export GOPATH=~/projects/go

ulimit -v 2048000 -m 2048000 -d 2048000

ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
if [ -d $ORACLE_HOME ]; then
    export ORACLE_HOME
    export ORACLE_SID=XE
    export ORACLE_BASE=/u01/app/oracle
    export PATH=$ORACLE_HOME/bin:$PATH
fi

for nm in stterm xfce4-terminal; do
    if which $nm >/dev/null; then
        export TERMINAL=$nm
        break
    fi
fi

# tmux
if which tmux 2>/dev/null; then
    if [ -z "$TMUX" ]; then
        tmux
    fi
fi