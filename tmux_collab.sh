#!/bin/bash
session="$1"
help_message="KEY BINDINGS

CTRL j == select left pane
CTRL k == select up pane
CTRL l == select right pane
CTRL h == clear pane scroll back
CTRL+a y == vi copy mode, uses vi keybindings
CTRL+a p == paste buffer
CTRL+a z == zoom in/zoom out pane
CTRL+a d == disconnect session
CTRL+a a == broadcast all panes
CTRL+a ? == key bindings list
CTRL+a : == command prompt
CTRL+a \" == split-window
CTRL+a % == split-window horizontal
CTRL+a c == new-window

"

if tmux list-sessions 2>&1 | grep -qE '^collaborate:'; then
  if [ "$session" == "" ]; then 
    echo "Master session exists, please specify a new session name"
    read -p "session name: " session
  fi

  if tmux list-sessions 2>&1 | grep -qE '^'"$session"':'; then
    tmux attach -t $session
  else
    tmux new -s $session -t collaborate
  fi
else
  tmux -u new-session -s collaborate -n Project -d "echo '$help_message'; /bin/bash -i"
  tmux -u split-window -h -t Project.0 -p 50 /bin/bash

  tmux -u new-window -n Test -d "echo '$help_message'; /bin/bash -i"
  tmux -u split-window -h -t Test.0 -p 50 /bin/bash

  tmux -u new-window -n Shell -d "echo '$help_message'; /bin/bash -i"
  tmux -u split-window -h -t Shell.0 -p 50 /bin/bash
  tmux -u select-window -t Shell

  tmux -u bind a set-window synchronize-panes

  #navigate between panes
  tmux -u bind -n C-k select-pane -U
  tmux -u bind -n C-l select-pane -R
  tmux -u bind -n C-j select-pane -L
  tmux -u unbind -n Tab

  #clear terminal history (reset)
  tmux -u bind -n C-h clear-history

  # default statusbar colors
  tmux -u set-option -g status-bg red
  tmux -u set-option -g status-fg white

  # active window title colors
  tmux -u set-window-option -g window-status-current-fg yellow
  tmux -u set-window-option -g window-status-current-bg black

  # pane border
  tmux -u set-option -g pane-border-fg red
  tmux -u set-option -g pane-active-border-fg white

  # pane number display
  tmux -u set-option -g display-panes-active-colour white
  tmux -u set-option -g display-panes-colour blue

  tmux -u set -g default-terminal "screen-256color"
  tmux -u set -g status-utf8 on
  tmux -u set -g history-limit 100000
  tmux -u set -g prefix C-a

  # mouse control
  tmux -u set-window-option -g mode-mouse on
  tmux -u set-option -g mouse-select-pane on
  tmux -u set-option -g mouse-resize-pane on
  tmux -u set-option -g mouse-select-window on

  # move between windows
  tmux -u bind-key C-p previous-window
  tmux -u bind-key C-n next-window

  tmux -u set-window-option -g utf8 on

  # Vim-style copy/paste
  tmux -u unbind [
  tmux -u bind y copy-mode
  tmux -u unbind p
  tmux -u bind p paste-buffer
  tmux -u bind -t vi-copy v begin-selection
  tmux -u bind -t vi-copy y copy-selection
  tmux -u bind -t vi-copy Escape cancel
  tmux -u set -g mode-keys vi

  tmux -u set-window-option -g utf8 on
  tmux -u set -g set-titles on
  tmux -u setw -g monitor-activity on
  tmux -u set -g visual-activity on
fi
