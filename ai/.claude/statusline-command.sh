#!/bin/bash
# Claude Code statusLine: model, effort, context usage, and ccusage session/today spend.
input=$(cat)

RESET="\033[0m"

fmt_tokens() {
  awk -v n="$1" 'BEGIN {
    if (n >= 1000000) printf "%.1fM", n/1000000;
    else if (n >= 1000) printf "%dk", int(n/1000);
    else printf "%d", n;
  }'
}

colorize() {
  local rgb="$1" text="$2"
  local r g b
  read -r r g b <<< "$rgb"
  printf "\033[38;2;%d;%d;%dm%s${RESET}" "$r" "$g" "$b" "$text"
}

GREY_RGB="140 140 140"

rainbow_colorize() {
  local text="$1"
  local colors=("170 70 70" "180 120 70" "170 150 60" "90 150 90" "90 150 150" "150 100 170")
  local i len c idx out
  out=""
  len=${#text}
  for ((i = 0; i < len; i++)); do
    c="${text:$i:1}"
    idx=$((i % ${#colors[@]}))
    out+="$(colorize "${colors[$idx]}" "$c")"
  done
  printf "%s" "$out"
}

modelId=$(echo "$input" | jq -r '.model.id // ""')
modelDisplay=$(echo "$input" | jq -r '.model.display_name // .model.id // "model"')
modelLc=$(echo "$modelId $modelDisplay" | tr '[:upper:]' '[:lower:]')
case "$modelLc" in
  *haiku*) modelRgb="170 150 60" ;;
  *sonnet*) modelRgb="90 150 90" ;;
  *opus*) modelRgb="150 100 170" ;;
  *) modelRgb="150 150 150" ;;
esac
modelOut=$(colorize "$modelRgb" "$modelDisplay")

effortLevel=$(echo "$input" | jq -r '.effort.level // empty')
effortOut=""
if [ -n "$effortLevel" ]; then
  effortLc=$(echo "$effortLevel" | tr '[:upper:]' '[:lower:]')
  if [ "$effortLc" = "max" ]; then
    effortOut=$(rainbow_colorize "$effortLevel")
  else
    case "$effortLc" in
      low) effortRgb="170 150 60" ;;
      medium) effortRgb="90 150 90" ;;
      high) effortRgb="150 100 170" ;;
      xhigh) effortRgb="170 70 70" ;;
      *) effortRgb="150 150 150" ;;
    esac
    effortOut=$(colorize "$effortRgb" "$effortLevel")
  fi
fi

YELLOW_RGB="170 150 60"
ORANGE_RGB="200 120 40"
RED_RGB="170 70 70"

contextTokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
if [ -n "$contextTokens" ] && [ "$contextTokens" != "null" ]; then
  if [ "$contextTokens" -le 100000 ]; then
    ctxRgb="$GREY_RGB"
  elif [ "$contextTokens" -le 150000 ]; then
    ctxRgb="$YELLOW_RGB"
  elif [ "$contextTokens" -le 250000 ]; then
    ctxRgb="$ORANGE_RGB"
  else
    ctxRgb="$RED_RGB"
  fi
  contextOut=$(colorize "$ctxRgb" "$(fmt_tokens "$contextTokens")")
else
  contextOut=$(colorize "$GREY_RGB" "n/a")
fi

refresh_cache() {
  local cacheFile="$1" ttl="$2"; shift 2
  local nowEpoch cacheMtime fresh
  nowEpoch=$(date +%s)
  cacheMtime=0
  if [ -s "$cacheFile" ]; then
    cacheMtime=$(stat -f %m "$cacheFile" 2>/dev/null || stat -c %Y "$cacheFile" 2>/dev/null || echo 0)
  fi
  if [ $((nowEpoch - cacheMtime)) -gt "$ttl" ]; then
    fresh=$(npx --yes ccusage@latest "$@" --json 2>/dev/null)
    if [ -n "$fresh" ]; then
      echo "$fresh" > "$cacheFile"
    fi
  fi
}

cost_color() {
  awk -v c="$1" 'BEGIN {
    if (c >= 50) print "'"$RED_RGB"'";
    else if (c >= 25) print "'"$YELLOW_RGB"'";
    else print "'"$GREY_RGB"'";
  }'
}

DAILY_CACHE_FILE="$HOME/.claude/.ccusage-daily-cache.json"
SESSION_CACHE_FILE="$HOME/.claude/.ccusage-session-cache.json"
CACHE_TTL=300

refresh_cache "$DAILY_CACHE_FILE" "$CACHE_TTL" daily
refresh_cache "$SESSION_CACHE_FILE" "$CACHE_TTL" session

today=$(date +%Y-%m-%d)
todayCost=""
if [ -s "$DAILY_CACHE_FILE" ]; then
  todayCost=$(jq -r --arg d "$today" '(.daily[]? | select((.date // .period) == $d) | .totalCost) // empty' "$DAILY_CACHE_FILE" 2>/dev/null)
fi
if [ -n "$todayCost" ]; then
  todayFmt=$(awk -v c="$todayCost" 'BEGIN { printf "%.2f", c }')
  todayRgb=$(cost_color "$todayCost")
  todayOut=$(colorize "$todayRgb" "\$${todayFmt}")
else
  todayOut=$(colorize "$GREY_RGB" "n/a")
fi

sessionId=$(echo "$input" | jq -r '.session_id // empty')
sessionCost=""
if [ -n "$sessionId" ] && [ -s "$SESSION_CACHE_FILE" ]; then
  sessionCost=$(jq -r --arg sid "$sessionId" '
    (.session[]? | select(.period == $sid) | .totalCost) // empty
  ' "$SESSION_CACHE_FILE" 2>/dev/null | head -n1)
fi
if [ -n "$sessionCost" ]; then
  sessionFmt=$(awk -v c="$sessionCost" 'BEGIN { printf "%.2f", c }')
  sessionRgb=$(cost_color "$sessionCost")
  sessionOut=$(colorize "$sessionRgb" "\$${sessionFmt}")
else
  sessionOut=$(colorize "$GREY_RGB" "n/a")
fi

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
branch=""
if [ -n "$cwd" ]; then
  branch=$(git --git-dir="$cwd/.git" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -z "$branch" ]; then
    branch=$(cd "$cwd" 2>/dev/null && git --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  fi
fi
branchOut=""
[ -n "$branch" ] && branchOut=$(printf "\033[2m%s${RESET}" "$branch")

modelSegment="$modelOut"
[ -n "$effortOut" ] && modelSegment="$modelOut [$effortOut]"

parts=("$modelSegment" "Context : $contextOut" "Session : $sessionOut" "Today : $todayOut")
[ -n "$branchOut" ] && parts+=("$branchOut")

out=""
for p in "${parts[@]}"; do
  if [ -z "$out" ]; then
    out="$p"
  else
    out="$out | $p"
  fi
done
printf "%s" "$out"
