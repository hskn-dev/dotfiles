#---------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------
# iTerm
export CLICOLOR=1
export TERM=xterm-256color

# Lang
export LANG=ja_JP.UTF-8

# ビープ音を鳴らさないようにする
setopt no_beep

# 色を使用出来るようにする
autoload -U colors; colors

#---------------------------------------------------------------------------
# Alias
#---------------------------------------------------------------------------
alias 'vim'='nvim'
alias 'tf'='terraform'
alias ls="ls -G"
alias ll='ls -ltr'

#---------------------------------------------------------------------------
# Complement
#---------------------------------------------------------------------------
# 補完機能を有効にする
autoload -U compinit; compinit

# 予測機能
autoload predict-on
predict-on

# cdのタイミングで自動的にpushd
setopt auto_pushd

# 補完候補の一覧表示
setopt auto_list

# 補完候補一覧でファイルの種別を識別マーク表示
setopt list_types

# 自動修正
setopt correct
setopt correct_all

# 補完キー（Tab, Ctrl+I) による補完候補の選択
setopt auto_menu

# ディレクトリ名だけで､ディレクトリの移動をする
setopt auto_cd

# # 日本語ファイル名を表示可能にする
setopt print_eight_bit

# 補完結果をできるだけ詰める
setopt list_packed

# カッコの対応などを自動的に補完
setopt auto_param_keys

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# 補完候補表示時にビープ音を鳴らさない
setopt nolistbeep

#---------------------------------------------------------------------------
# Prompt
#---------------------------------------------------------------------------
# プロンプトを変更
autoload -U promptinit; promptinit
prompt pure

#---------------------------------------------------------------------------
# History
#---------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 重複したコマンドラインはヒストリに追加しない
setopt hist_ignore_dups

# 履歴の共有
setopt share_history

# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store

# 余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks

# 履歴ファイルに時刻を記録
setopt extended_history

# 履歴をインクリメンタルに追加
setopt inc_append_history

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
autoload history-search-end

# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 履歴検索機能のショートカット
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^P" history-beginning-search-backward-end
# bindkey "^N" history-beginning-search-forward-end

#---------------------------------------------------------------------------
# ZPLUG
#---------------------------------------------------------------------------
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "rupa/z", use:z.sh

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load –verbose

#---------------------------------------------------------------------------
# FZF
#---------------------------------------------------------------------------
export FZF_LEGACY_KEYBINDINGS=0
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}" --reverse --height=50%'
export FZF_FIND_FILE_COMMAND=$FZF_DEFAULT_COMMAND

# 現在のディレクトリ配下の検索
fzf-current-search() {
    local res=$(find . | fzf)
    if [ -n "$res" ]; then
        BUFFER="cd $(dirname $res)"
        zle accept-line
    else
        return 1
    fi
}
zle -N fzf-current-search
bindkey '^f' fzf-current-search

# history の検索
fzf-history-search() {
    local res=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
    if [ -n "$res" ]; then
        BUFFER="$res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fzf-history-search
bindkey '^r' fzf-history-search

# z コマンド結果の検索
fzf-z-search() {
    local res=$(z | sort -rn | cut -c 12- | fzf)
    if [ -n "$res" ]; then
        BUFFER="cd $res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fzf-z-search
bindkey '^z' fzf-z-search

# ghq の検索
function fzf-ghq-search() {
  local res=$(ghq list | fzf --preview \
            "bat --color=always --style=header,grid --line-range :80 \
            $(ghq root)/{}/README.*" --reverse --height=50%)
  if [ -n "$res" ]; then
    BUFFER="cd $(ghq root)/$res"
    zle accept-line
  fi
  zle -R -c
}
zle -N fzf-ghq-search
bindkey '^g' fzf-ghq-search