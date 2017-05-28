export HISTCONTROL=ignoreboth:erasedups
export PROMPT_COMMAND='history -a'
shopt -s histappend
export HISTSIZE=4096
export HISTFILESIZE=4096
shopt -s checkwinsize

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias less='less -r'
    alias grep='grep --color=always'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=always'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias prettyjson='python -m json.tool'

if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  export TMUX_SESSION_ID="$(date | md5sum | awk '{print $1}')${RANDOM}"
  /usr/local/bin/tmux_collab.sh ${TMUX_SESSION_ID}
  exit
fi
