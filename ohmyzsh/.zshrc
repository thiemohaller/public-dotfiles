# --- Shell & oh-my-zsh ---
export SHELL=/bin/zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  macos
  vscode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# --- Basics ---
alias ll='ls -lah'
alias gs='git status'
export EDITOR='nano'

HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.zsh_history"

# --- Prompt setup ---
setopt PROMPT_SUBST
autoload -U add-zsh-hook
autoload -U colors && colors

# Git segment (single-line: branch + dirty/clean)
ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red} ✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green} ✓%f"

git_prompt_info() {
  local ref dirty
  ref=$(git symbolic-ref --short HEAD 2>/dev/null \
        || git describe --tags --exact-match 2>/dev/null) || return
  [[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="$ZSH_THEME_GIT_PROMPT_DIRTY" || dirty="$ZSH_THEME_GIT_PROMPT_CLEAN"
  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${ZSH_THEME_GIT_PROMPT_SUFFIX}${dirty}"
}

CMD_START=0
EXEC_TIME_PROMPT=""
record_start_preexec() { CMD_START=$EPOCHREALTIME }
update_prompt_precmd() {
  local last_status=$? dur_ms out
  if (( CMD_START )); then
    dur_ms=$(( (EPOCHREALTIME - CMD_START) * 1000 ))
    CMD_START=0
    if (( dur_ms >= 1000 )); then
      out="$(printf '%.1fs' "$(( dur_ms / 1000.0 ))")"
    else
      out="${dur_ms%.*}ms"
    fi
    EXEC_TIME_PROMPT="%F{yellow}${out}%f"
  fi
}
add-zsh-hook preexec record_start_preexec
add-zsh-hook precmd update_prompt_precmd

# --- Spotify status (AppleScript; cached every 20s) ---
SPOTIFY_LAST_UPDATE=0
SPOTIFY_CACHE=""
SPOTIFY_PROMPT=""

spotify_prompt() {
  local now=$EPOCHSECONDS artist track state
  if (( now - SPOTIFY_LAST_UPDATE >= 20 )); then
    SPOTIFY_LAST_UPDATE=$now
    SPOTIFY_CACHE=""
    if [[ "$(osascript -e 'tell application "System Events" to (name of processes) contains "Spotify"')" == "true" ]]; then
      artist="$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)"
      track="$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)"
      state="$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)"
      if [[ "$state" == "playing" && -n "$artist" && -n "$track" ]]; then
        SPOTIFY_CACHE="  ${artist} — ${track}"
      fi
    fi
  fi
  SPOTIFY_PROMPT="$SPOTIFY_CACHE"
}
add-zsh-hook precmd spotify_prompt

# --- Final Prompts ---
# Left: arrow + full path + git
PROMPT='%F{green}➜ %F{blue}%~%f $(git_prompt_info)
%(?.%F{magenta}.%F{red})❯%f '

# Right: exec time (if any) + Spotify (if playing)
RPROMPT='${EXEC_TIME_PROMPT}%F{green}${SPOTIFY_PROMPT}%f'
