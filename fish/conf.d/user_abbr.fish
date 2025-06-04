################################################################################
###                         User Fish Abbreviations                          ###
################################################################################

abbr -a c            'clear'
abbr -a q            'exit'

abbr -a vi           'nvim'
abbr -a vim          'nvim'
abbr -a ff           'fastfetch'
abbr -a cat          'bat'
abbr -a ls           'eza --icons=always --group-directories-first'
abbr -a ll           'eza --all --icons=always --group-directories-first'
abbr -a lg           'lazygit'
abbr -a gs           'git status'
abbr -a gs           'git status --short'
abbr -a gd           'git diff --output-indicator-new=" " --output-indicator-old=" "'
abbr -a ga           'git add'
abbr -a gc           'git commit'
abbr -a gp           'git pull'
abbr -a gP           'git push'
abbr -a gl           'git log --all --graph --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
abbr -a gb           'git branch'
abbr -a gi           'git init'
abbr -a gcl          'git clone'

alias ssh "TERM=xterm-256color command ssh"
