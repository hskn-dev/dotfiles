alias vim='nvim'
alias tf='terraform'

set -gx EDITOR /usr/local/bin/nvim
set -x PATH ~/.bin $PATH
#set -x XDG_CONFIG_HOME ~/.config $XDG_CONFIG_HOME
set -x XDG_CONFIG_HOME ~/.config
#set -x XDG_CACHE_HOME ~/.cache $XDG_CACHE_HOME
set -x XDG_CACHE_HOME ~/.cache

set -U FZF_LEGACY_KEYBINDINGS 0
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --glob "!.git/*"'
set -x FZF_DEFAULT_OPTS '--preview "bat  --color=always --style=header,grid --line-range :100 {}" --reverse --height=50%'
set -x FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND

set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

source (pyenv init - | psub)

set -g theme_color_scheme "dracula"
set -g fish_color_command "green"
set -g theme_date_format "+%Y/%m/%d %H:%M:%S"
set -g theme_date_timezone Asia/Tokyo
eval (direnv hook fish)

status --is-interactive; and source (rbenv init -|psub)

### bobthefish config
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
# set -g theme_display_git no
# set -g theme_display_git_dirty no
# set -g theme_display_git_untracked no
# set -g theme_display_git_ahead_verbose yes
# set -g theme_display_git_dirty_verbose yes
# set -g theme_display_git_stashed_verbose yes
set -g theme_display_git_default_branch yes
# set -g theme_git_default_branches master main
# set -g theme_git_worktree_support yes
# set -g theme_use_abbreviated_branch_name yes
# set -g theme_display_vagrant yes
# set -g theme_display_docker_machine no
# set -g theme_display_k8s_context yes
# set -g theme_display_hg yes
set -g theme_display_virtualenv yes
# set -g theme_display_nix no
set -g theme_display_ruby no
# set -g theme_display_nvm yes
# set -g theme_display_user ssh
# set -g theme_display_hostname ssh
# set -g theme_display_vi no
# set -g theme_display_date no
# set -g theme_display_cmd_duration yes
# set -g theme_title_display_process yes
# set -g theme_title_display_path no
# set -g theme_title_display_user yes
# set -g theme_title_use_abbreviated_path no
# set -g theme_date_format "+%a %H:%M"
# set -g theme_date_timezone America/Los_Angeles
# set -g theme_avoid_ambiguous_glyphs yes
# set -g theme_powerline_fonts no
# set -g theme_nerd_fonts yes
# set -g theme_show_exit_status yes
# set -g theme_display_jobs_verbose yes
# set -g default_user your_normal_user
# set -g theme_color_scheme dark
# set -g fish_prompt_pwd_dir_length 0
# set -g theme_project_dir_length 1
# set -g theme_newline_cursor yes
# set -g theme_newline_prompt '$ '

fix_path
