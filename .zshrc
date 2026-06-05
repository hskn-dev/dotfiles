#---------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------
# viins キーマップを選択
# bindkey -v

# emacs キーマップを選択
bindkey -e

# Secret
[[ ! -f ~/.secret/env.sh ]] || source ~/.secret/env.sh

# iTerm
export CLICOLOR=1
export TERM=xterm-256color

# Lang
export LANG=ja_JP.UTF-8

# ビープ音を鳴らさないようにする
setopt no_beep

# 色を使用出来るようにする
autoload -U colors; colors

#--------------------------------------------------------------------------
# Alias
#---------------------------------------------------------------------------
alias 'vim'='nvim'
alias 'tf'='terraform'
alias 'ls'="ls -G"
alias 'll'='ls -ltr'
alias 'cls'='clear'
alias 'tmuxg'='tmux new-session -d; \
        tmux setw synchronize-panes off; \
        tmux splitw -v -t 1; \
        tmux select-pane -t 0; \
        tmux attach-session'
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias awsopt="oathtool --totp --base32 ${AWS_OPT_KEY}"
alias sw-media-prd="source ~/oathtool/MediaPrdSwitchAdminRole.sh"
alias sw-media-prd-ssh="source ~/oathtool/MediaPrdSSHOnSSM.sh"
alias sw-furusele-dev="source ~/oathtool/FuruseleDevSwitchAdminRole.sh"
alias sw-ys-dev="source ~/oathtool/YSDevSwitchAdminRole.sh"
alias sw-ys-prd="source ~/oathtool/YSPrdSwitchAdminRole.sh"
alias sw-cbv="source ~/oathtool/CBVentureSwitchRole.sh"
alias sw-sandbox="source ~/oathtool/SandboxSwitchSRERole.sh"
alias sw-tenshoku-dev="source ~/oathtool/TenshokuDevSwitchAdminRole.sh"
alias sw-tenshoku-prd="source ~/oathtool/TenshokuPrdSwitchAdminRole.sh"
alias sw-rad-dev="source ~/oathtool/ResearchAndDevelopmentSwitchAdminRole.sh"
alias ghh='cd ~/ghq/$(ghq list | fzf)'
alias plm='pulumi'
alias gitroot='cd "$(git rev-parse --show-toplevel)"'

#---------------------------------------------------------------------------
# pyenv
#---------------------------------------------------------------------------
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
#eval "$(pyenv init --path)"
eval "$(pyenv init -)"

#---------------------------------------------------------------------------
# poetry
#---------------------------------------------------------------------------
export PATH=$HOME/.local/bin:$PATH

#---------------------------------------------------------------------------
# Java (log4j)
#---------------------------------------------------------------------------
export CLASSPATH="/Users/kengo-hashimoto/java/bin/log4j-core.jar:/Users/kengo-hashimoto/java/bin/log4j-api.jar"

#---------------------------------------------------------------------------
# goenv
#---------------------------------------------------------------------------
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export GOROOT="$GOENV_ROOT"
export PATH="$GOROOT/shims/go:$PATH"

#export GOPATH="$GOENV_ROOT"
#export PATH="$GOPATH/shims:$PATH"

export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/php@8.2/lib"
export CPPFLAGS="-I/opt/homebrew/opt/php@8.2/include"

#---------------------------------------------------------------------------
# vim
#---------------------------------------------------------------------------
export EDITOR=vim
export DIRENV_WARN_TIMEOUT=100s
#eval "$(direnv hook zsh)"

#---------------------------------------------------------------------------
# volta
#---------------------------------------------------------------------------
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

#---------------------------------------------------------------------------
# serverless
#---------------------------------------------------------------------------
export AWS_SDK_LOAD_CONFIG=1

#---------------------------------------------------------------------------
# Complement
#---------------------------------------------------------------------------
# 補完候補表示時にビープ音を鳴らさない
setopt nolistbeep

#---------------------------------------------------------------------------
# Prompt
#---------------------------------------------------------------------------
# プロンプトは Starship を使用 (.zshrc 末尾で init + ~/.config/starship.toml で設定)。

#---------------------------------------------------------------------------
# History
#---------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

#---------------------------------------------------------------------------
# FZF
#---------------------------------------------------------------------------
export FZF_LEGACY_KEYBINDINGS=0
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_FIND_FILE_COMMAND=$FZF_DEFAULT_COMMAND
INPUTS=~/inputs

# zsh / bash 補完を有効化
autoload -Uz compinit && compinit
autoload -U bashcompinit && bashcompinit

# プロンプト: Starship (homebrew: brew install starship)。設定は ~/.config/starship.toml。
command -v starship >/dev/null && eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kengo-hashimoto/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kengo-hashimoto/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/kengo-hashimoto/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kengo-hashimoto/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# gcloud
#source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
#source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kengo-hashimoto/work/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kengo-hashimoto/work/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kengo-hashimoto/work/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kengo-hashimoto/work/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib"
export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"

export PATH="/opt/homebrew/opt/unzip/bin:$PATH"

# Added by Antigravity
export PATH="/Users/kengo-hashimoto/.antigravity/antigravity/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/kengo-hashimoto/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# homebrew rsync
export PATH="/opt/homebrew/bin:$PATH"

# direnv
eval "$(direnv hook zsh)"

# claude code
# AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY は claude code の /login でセットアップ
#export AWS_REGION="ap-northeast-1"
#export CLAUDE_CODE_USE_BEDROCK=1
#export ANTHROPIC_MODEL="global.anthropic.claude-opus-4-7"
#export ANTHROPIC_DEFAULT_SONNET_MODEL="jp.anthropic.claude-sonnet-4-6"
#export ANTHROPIC_DEFAULT_OPUS_MODEL="global.anthropic.claude-opus-4-7"
#export ANTHROPIC_DEFAULT_HAIKU_MODEL="jp.anthropic.claude-haiku-4-5-20251001-v1:0"

#---------------------------------------------------------------------------
# モダン CLI ツール (zoxide / atuin / eza)  ※ homebrew で導入
#---------------------------------------------------------------------------
# atuin: Ctrl-R 履歴検索の置き換え。fzf より後に init して Ctrl-R を atuin に渡す。
#        上矢印も奪うのが嫌なら `atuin init zsh --disable-up-arrow`。
command -v atuin >/dev/null && eval "$(atuin init zsh)"

# zoxide: cd の賢い置き換え (z でジャンプ / zi で fzf 選択)。
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# eza: ls の置き換え (色 / アイコン / git 状態)。アイコンは ghostty 内蔵 Nerd Font で表示。
if command -v eza >/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --git --group-directories-first'
  alias la='eza -la --icons --git --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
fi

# Headroom 経由で Claude Code 起動 (port 38787)
# HEADROOM_MODE=cache: 過去ターンを凍結しプレフィックスキャッシュ安定を優先
#   (Anthropic は cache_read=0.1x と安いため、長い会話で履歴を圧縮し直して
#    再キャッシュ(cache_write=1.25x)を招く token モードより総額が安くなる)
#   token モードを試す時は HEADROOM_MODE=token hc ... で上書き可
# 使い方:
#   hc -a issue-manager            → --agent issue-manager -n issue-manager
#   hc -a developer -n my-session  → -n を明示すればそちらを優先
#   hc --resume                    → agent 無しで素通し
hc() {
  local agent="" name="" passthrough=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -a|--agent) agent="$2"; shift 2 ;;
      -n|--name)  name="$2";  shift 2 ;;
      *) passthrough+=("$1"); shift ;;
    esac
  done

  local args=()
  [[ -n "$agent" ]] && args+=(--agent "$agent")
  if [[ -n "$name" ]]; then
    args+=(-n "$name")
  elif [[ -n "$agent" ]]; then
    args+=(-n "$agent")   # -n 省略時はエージェント名をセッション名に
  fi
  args+=("${passthrough[@]}")

  HEADROOM_MODE="${HEADROOM_MODE:-cache}" headroom wrap claude -p 38787 -- "${args[@]}"
}
