alias 'vim'='nvim'
alias 'tf'='terraform'

export CLICOLOR=1
export TERM=xterm-256color
export LANG=ja_JP.UTF-8

# 補完機能を有効にする
autoload -U compinit; compinit

# 色を使用出来るようにする
autoload -U colors; colors

# プロンプトを変更
autoload -U promptinit; promptinit
prompt pure

setopt auto_list
setopt auto_menu
setopt auto_cd
setopt share_history

# # 日本語ファイル名を表示可能にする
setopt print_eight_bit

# ヒストリの設定
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

zstyle ':completion:*:default' menu select=1 

# vcsの表示    
# zstyle ':vcs_info:*' enable git svn hg bzr
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:*' stagedstr "+"
# zstyle ':vcs_info:*' unstagedstr "*"
# zstyle ':vcs_info:*' formats '(%b%c%u)'    
# zstyle ':vcs_info:*' actionformats '(%b(%a)%c%u)' 

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# export PATH="/usr/local/Homebrew/bin:$PATH"

# use zplug (https://github.com/zplug/zplug/blob/master/doc/guide/ja/README.md)
# source ~/.zplug/init.zsh

# self manage
# zplug "zplug/zplug", hook-build:'zplug --self-manage'

# z command
# source $(brew --prefix)/etc/profile.d/z.sh

# plugins
# zplug "sindresorhus/pure"
zplug "chrissicool/zsh-256color"
zplug "Tarrasch/zsh-colors"
# zplug "zsh-users/zsh-completions"
# zplug "plugins/git", from:oh-my-zsh
# zplug "peterhurford/git-aliases.zsh"
# zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "ascii-soup/zsh-url-highlighter"
# zplug "zsh-users/zsh-history-substring-search", defer:3
# zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
# zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
# zplug "mollifier/anyframe"
# zplug "b4b4r07/enhancd", use:init.sh
# zplug "x-motemen/ghq", as:command, from:gh-r
zplug "rupa/z", use:z.sh
# zplug "sjl/z-zsh", use:z.sh

# テーマファイルを読み込む
# zplug 'dracula/zsh', as:theme

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load –verbose

# FZF Options
export FZF_LEGACY_KEYBINDINGS=0
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}" --reverse --height=50%'
export FZF_FIND_FILE_COMMAND=$FZF_DEFAULT_COMMAND


# current fzf-search
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

# history fzf-search
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

# z fzf-search
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

# ghq fzf-search
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