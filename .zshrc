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
