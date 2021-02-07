# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#---------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------
# viモードでの操作の有効化
# bindkey -v

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
# pyenv
#---------------------------------------------------------------------------
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

#--------------------------------------------------------------------------
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
autoload -Uz compinit; compinit

# 予測機能
# autoload predict-on
# predict-on

# cdのタイミングで自動的にpushd
setopt auto_pushd

# 補完候補の一覧表示
setopt auto_list

# 補完候補一覧でファイルの種別を識別マーク表示
setopt list_types

# 自動修正
# setopt correct
# setopt correct_all

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
# autoload promptinit
# promptinit
# prompt pure

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

# --prefix=/usr などの = 以降でも補完
setopt magic_equal_subst

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
autoload history-search-end

# 補完時の色設定
export LSCOLORS='Gxfxcxdxbxegedabagacad'

# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完の選択を楽にする
zstyle ':completion:*' menu select

# 補完候補に色つける
zstyle ':completion:*' list-colors "${LS_COLORS}"

# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true

# 履歴検索機能のショートカット
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^P" history-beginning-search-backward-end
# bindkey "^N" history-beginning-search-forward-end

#---------------------------------------------------------------------------
# FZF
#---------------------------------------------------------------------------
export FZF_LEGACY_KEYBINDINGS=0
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}" --reverse --height=50%'
export FZF_FIND_FILE_COMMAND=$FZF_DEFAULT_COMMAND

# 現在のディレクトリ配下の検索
function fzf-current-search() {
  local res=$(find . | fzf)
  if [ -n "$res" ]; then
      BUFFER="$(dirname $res)"
      CURSOR=${#BUFFER}
  else
      return 1
  fi
  zle reset-prompt
}
zle -N fzf-current-search
bindkey '^f' fzf-current-search

# history の検索
function fzf-history-search() {
  local res=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  if [ -n "$res" ]; then
      BUFFER="$res"
      CURSOR=${#BUFFER}
  else
      return 1
  fi
  zle reset-prompt
}
zle -N fzf-history-search
bindkey '^r' fzf-history-search

# z コマンド結果の検索
function fzf-z-search() {
  local res=$(z | sort -rn | cut -c 12- | fzf)
  if [ -n "$res" ]; then
      BUFFER="$res"
      CURSOR=${#BUFFER}
  else
      return 1
  fi
  zle reset-prompt
}
zle -N fzf-z-search
bindkey '^z' fzf-z-search

# ghq の検索
function fzf-ghq-search() {
  local res=$(ghq list | fzf --preview \
            "bat --color=always --style=header,grid --line-range :80 \
            $(ghq root)/{}/README.*" --reverse --height=50%)
  if [ -n "$res" ]; then
    BUFFER="$(ghq root)/$res"
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}
zle -N fzf-ghq-search
bindkey '^g' fzf-ghq-search

#---------------------------------------------------------------------------
# ZINIT
#---------------------------------------------------------------------------
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# oh-my-zshのセットアップ
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git # <- なんかおまじないらしい
zinit cdclear -q

# プロンプトのカスタマイズ
# setopt promptsubst
# zinit snippet OMZT::gnzh
# zinit light agnoster/agnoster-zsh-theme # <- ここで好きなテーマのGitHubリポジトリを Group/Repository で指定。
# export AGNOSTER_PROMPT_SEGMENTS[2]=

# 補完
zinit light zsh-users/zsh-autosuggestions

# シンタックスハイライト
zinit light zdharma/fast-syntax-highlighting

# クローンしたGit作業ディレクトリで、コマンド `git open` を実行するとブラウザでGitHubが開く
zinit light paulirish/git-open

# iTerm2を使っている場合に、コマンド `tt タブ名` でタブ名を変更できる
zinit light gimbo/iterm2-tabs.zsh

# jq をインタラクティブに使える。JSONを標準出力に出すコマンドを入力した状態で `Alt+j` すると jq のクエリが書ける。
# 要 jq
zinit light reegnz/jq-zsh-plugin

# Gitの変更状態がわかる ls。ls の代わりにコマンド `k` を実行するだけ。
zinit light supercrabtree/k

# z コマンドの利用
zinit light rupa/z

# 親ディレクト移動のクイック操作
zinit light Tarrasch/zsh-bd

# ディレクトリ移動の補完
zinit light b4b4r07/enhancd

# プロンプトの変更
# options: https://bit.ly/36P4HpL
# xterm-256color: https://bit.ly/36M8W5q
# zinit light denysdovhan/spaceship-prompt
# export SPACESHIP_GIT_BRANCH_COLOR='222'
# export SPACESHIP_GIT_STATUS_COLOR='108'
# export SPACESHIP_PYENV_COLOR='172'
# export SPACESHIP_DOCKER_COLOR='111'

zinit ice depth=1; zinit light romkatv/powerlevel10k

# Visual モード
# zinit light b4b4r07/zsh-vimode-visual

# AWS CLI v2の補完。
# 要 AWS CLI v2
# この順序で記述しないと `complete:13: command not found: compdef` のようなエラーになるので注意
autoload bashcompinit && bashcompinit
source ~/.zinit/plugins/drgr33n---oh-my-zsh_aws2-plugin/aws2_zsh_completer.sh
complete -C '/usr/local/bin/aws_completer' aws
zinit light drgr33n/oh-my-zsh_aws2-plugin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
