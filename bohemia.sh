#!/usr/bin/env bash
set -e

LAYOUT="${1:-home}"
SESSION="${2:-dev}"

# Ensure a unique session name
BASE_SESSION="$SESSION"
i=1
while tmux has-session -t "$SESSION" 2>/dev/null; do
  SESSION="${BASE_SESSION}-${i}"
  ((i++))
done
tmux new-session -d -s "$SESSION"

# Get the initial (left) pane ID
PANE_LEFT=$(tmux display-message -p -t "$SESSION" '#{pane_id}')

# Build panes according to layout
if [ "$LAYOUT" = "office" ]; then
  # 5-pane layout: left | (top-R1 top-R2 / bot-R1 bot-R2)
  PANE_RIGHT=$(tmux split-window -h -d -t "$PANE_LEFT" -P -F '#{pane_id}')
  PANE_BOTTOM_RIGHT=$(tmux split-window -v -d -t "$PANE_RIGHT" -P -F '#{pane_id}')
  tmux split-window -h -d -t "$PANE_RIGHT" -P -F '#{pane_id}' >/dev/null
  tmux split-window -h -d -t "$PANE_BOTTOM_RIGHT" -P -F '#{pane_id}' >/dev/null
elif [ "$LAYOUT" = "home" ]; then
  # 3-pane layout: left | (top-R / bot-R)
  PANE_RIGHT=$(tmux split-window -h -d -t "$PANE_LEFT" -P -F '#{pane_id}')
  tmux split-window -v -d -t "$PANE_RIGHT" -P -F '#{pane_id}' >/dev/null
elif [ "$LAYOUT" = "split" ]; then
  # 2-pane layout: left | right
  tmux split-window -h -d -t "$PANE_LEFT" -P -F '#{pane_id}' >/dev/null
else
  echo "Unknown layout: $LAYOUT (use 'office', 'home', or 'split')"
  exit 1
fi

# Focus the left (main) pane
tmux select-pane -t "$PANE_LEFT"

# Attach (or switch if already inside tmux)
if [ -n "$TMUX" ]; then
  tmux switch-client -t "$SESSION"
else
  tmux attach-session -t "$SESSION"
fi
