################################################################################
###                           User Fish Variables                            ###
################################################################################
set -gx EDITOR              (which nvim)
set -gx VISUAL              $EDITOR
set -gx SUDO_EDITOR         $EDITOR
set -gx FCEDIT              $EDITOR
set -gx MANPAGER            "nvim +Man!"
set -gx TERMINA             kitty
set -gx BROWSER             zen-browser

# Go
set -x GOPATH ~/go
fish_add_path $GOPATH/bin

# pnpm
set -gx PNPM_HOME "/home/lwq/.local/share/pnpm"
if type -q pnpm
   if not string match -q -- $PNPM_HOME $PATH
      set -gx PATH "$PNPM_HOME" $PATH
   end
end
# pnpm end

if type -q starship 
   starship init fish | source
end

if type -q fzf 

   set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
   set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
   set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
   set show_file_or_dir_preview "if test -d {}; eza --tree --color=always {} | head -200; else; bat -n --color=always --line-range :500 {}; end"
   set -x FZF_CTRL_T_OPTS "--preview '$show_file_or_dir_preview'"
   set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"
   set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS  
	--ansi 
	--layout=reverse 
	--info=inline-right 
  --bind=ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-x:jump
  --bind=ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --bind=ctrl-a:beginning-of-line,ctrl-e:end-of-line
  --bind=ctrl-j:down,ctrl-k:up
  --color=border:#27a1b9 
  --color=fg:#c0caf5 
  --color=gutter:#16161e 
  --color=header:#ff9e64 
  --color=hl+:#2ac3de 
  --color=hl:#2ac3de 
  --color=info:#545c7e 
  --color=marker:#ff007c 
  --color=pointer:#ff007c 
  --color=prompt:#2ac3de 
  --color=query:#c0caf5:regular 
  --color=scrollbar:#27a1b9 
  --color=separator:#ff9e64 
  --color=spinner:#ff007c 
"
   fzf --fish | source
end
