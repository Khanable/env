setopt auto_cd
setopt no_case_glob
setopt share_history

autoload -U compinit
compinit

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':completion:*' recent-dirs-insert true

autoload -U zargs
autoload -U zcp zln zmv

#Case insensitive completion
#Basically from here but without preferring case sensitive match and performing case insensitive if no case sensitive match exists
#https://stackoverflow.com/questions/24226685/have-zsh-return-case-insensitive-auto-complete-matches-but-prefer-exact-matches
#Create a file ~/.oh-my-zsh/custom/better-completion.zsh (assuming you are using default paths for oh-my-zsh) with the following lines
#
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#Explanation:
#
#Rules for matches in zsh completion in general are defined in the matcher-list style. For oh-my-zsh this is defined in ~/.oh-my-zsh/lib/completion.zsh (once for case-sensitive and once for case-insensitive). You could change it there but it would probably be gone if you updated your oh-my-zsh. ~/.oh-my-zsh/custom is specifially intended for customization and files with extension .zsh are loaded from there by .oh-my-zsh/oh-my-zsh.sh at the end of the configuration.
#
#The default (case-insensitive) settings for matcher-list in oh-my-zsh are:
#
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#The first of which tells to handle upper and lower case interchangeable. As it is the first rule, it will be invariably used for every match.
#
#The only change needed is to prepend '' for simple completion (it is even the first example in zshcompsys(1) for matcher-list)
#
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#This tries first to complete the current word exactly as its written, before trying case-insensitive or other matches.
#
#To be complete:
#
#The second (original) rule allows for partial completion before ., _ or -, e.g. f.b -> foo.bar.
#The third rule allows for completing on the left side of the written text, e.g. bar -> foobar)
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

alias ls='ls -la --color=auto'

gd="git diff"
gl="git log"
gad="git add"
grs="git restore"
gmg="git merge"
gsh="git stash"
gcp="git cherry-pick"
grb="git rebase"
gcl="git clean"
gap="git apply"
alias gd="$gd"
alias gdw="$gd -w"
alias gds="$gd --staged"
alias gdsw="$gd --staged -w"
alias gcm="git commit"
alias gl="$gl"
alias glw="$gl -w"
alias gad="$gad"
alias gadp="$gad -p"
alias gadi="$gad -i"
alias grs="$grs"
alias grss="$grs --staged"
alias grv="git revert"
alias gmg="$gmg"
alias gmga="$gmg --abort"
alias gmgw="$gmg -Xignore-all-space"
alias gmt="git mergetool"
alias gco="git checkout"
alias gap="$gap"
alias gapiw="$gap --cached --ignore-whitespace"
alias gapcw="$gap --index --ignore-whitespace"
alias gbr="git branch"
alias gst="git status"
alias gsh="$gsh"
alias gshp="$gsh pop"
alias gcp="$gcp"
alias gcpw="$gcp -Xignore-all-space"
alias grb="$grb"
alias grbc="$grb --continue"
alias grba="$grb --abort"
alias grbw="$grb -Xignore-all-space"
alias grbi="$grb -i"
alias grbiw="$grb -i -Xignore-all-space"
alias gcln="$gcl -n"
alias gcl="$gcl"
