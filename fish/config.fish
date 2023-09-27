if status is-interactive
    # Commands to run in interactive sessions can go here
end
nitch
set -gx LANG zh_CN.UTF-8
set -gx EDITOR nvim
set -U fish_greeting
set -gx _JAVA_AWT_WM_NONREPARENTING 1
# pnpm
set -gx PNPM_HOME "/home/lwq/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/anaconda/bin/conda
    eval /opt/anaconda/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

