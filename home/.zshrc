# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR=nvim
export VISUAL=nvim

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"


# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"
#
# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Aliases
alias l='ls -lah --color'
alias tm='tmux new-session -A -s default'
alias g="git"
alias gs="git status -sb"
alias gp="git push"
#alias gh="git diff HEAD"

# Lifehack, prun = poetry run
alias prun="poetry run"
alias restart_camera="systemctl --user restart pipewire pipewire-pulse wireplumber"

# Status of the here.timer job runner (~/.config/here.d)
here-status() {
  local B=$'\e[1m' D=$'\e[2m' G=$'\e[32m' R=$'\e[31m' X=$'\e[0m'
  local bar=${(l:56::─:)} log=${XDG_STATE_HOME:-$HOME/.local/state}/here/last.log
  local state next
  if [[ $OSTYPE == darwin* ]]; then  # untested: no Mac to try it on
    launchctl print gui/$UID/com.jonas.here &>/dev/null && state=active || state=inactive
  else
    state=$(systemctl --user is-active here.timer)
    next=$(systemctl --user list-timers here.timer --output=json | jq -r '.[0].next // empty')
  fi
  local -a lines jobs=(~/.config/here.d/*(N*:t))
  jobs=(${jobs:#*.*})
  [[ -r $log ]] && lines=("${(@f)$(<$log)}")
  local last=${${lines[1]#== run }:-never} result="$G✓ success" dot=$G●
  [[ $state == active ]] || dot=$R●
  [[ -n ${(M)lines:#!! *} ]] && result="$R✗ failed"

  print "$D╭─$X$B here.timer $X$D${bar:14}$X"
  print "$D│$X ${B}timer$X   $dot $state$X"
  print "$D│$X ${B}last$X    $last  $result$X"
  [[ -n $next ]] && print "$D│$X ${B}next$X    in $(( (next / 1000000 - $(date +%s)) / 60 ))min $D($(date -d @$((next / 1000000)) +%H:%M))$X"
  print "$D│$X ${B}jobs$X    ${(j:, :)jobs}"
  print "$D├─$X$B last run output $X$D${bar:19}$X"
  (( ${#lines} > 1 )) && print -rl -- "${(@)lines[2,-1]/#/$D│$X }" || print "$D│ (no output)$X"
  print "$D╰${bar:1}$X"
}

# Source local configurations (work-specific aliases/functions)
# This file is tracked as empty but ignored for changes
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# Secret tokens (gitignored), exported to every shell
[ -f ~/.env ] && { set -a; source ~/.env; set +a; }

# Shell integrations
eval "$(fzf --zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Setup fc command
export FCEDIT=nvim

export PATH="/home/jonas/.local/bin:$PATH"

. "$HOME/.local/share/../bin/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/jonas/google-cloud-sdk/path.zsh.inc' ]; then . '/home/jonas/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/jonas/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/jonas/google-cloud-sdk/completion.zsh.inc'; fi

# zk Zettelkasten notebook
export ZK_NOTEBOOK_DIR="$HOME/git_strawberry/notes"

# opencode
export PATH=/home/jonas/.opencode/bin:$PATH
