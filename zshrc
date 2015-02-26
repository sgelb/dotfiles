# autostart and -logout X on tty1-3
# see .xinitrc for window managers
if [[ -z "${DISPLAY}" ]] && [[ $(tty) =~ tty[123] ]]; then
  startx
  logout
fi

# exports and variables {{{
export PATH="${PATH}:${HOME}/bin:$(ruby -e 'print Gem.user_dir')"
export EDITOR='/usr/bin/vim'
export SHELL='/bin/zsh'
HISTFILE=${HOME}/.zsh_history
# }}}

# options {{{

setopt append_history # append history list to the history file      
setopt histignorealldups # rm older duplicate from history
setopt histignorespace # don't put to history if ^ is a space 
setopt histsavenodups
setopt sharehistory
setopt incappendhistory
setopt NO_clobber # warning if file exists ('cat /dev/null > ~/.zshrc')
setopt auto_cd # if a command is a folder, cd into it
setopt nonomatch  # try to avoid the 'zsh: no matches found...'
setopt nobeep # avoid "beep"ing
setopt extendedglob
autoload zmv # rename

REPORTTIME=5  # report if cmd runs longer than 5 secondes
HISTSIZE=50000
SAVEHIST=5000 # useful for setopt append_history

# }}}

# statusbar/prompt {{{

# set colors
BLUE="%{[1;34m%}"
RED="%{[1;31m%}"
GREEN="%{[1;32m%}"
CYAN="%{[1;36m%}"
WHITE="%{[1;37m%}"
PINK="%{[1;35m%}"
NO_COLOUR="%{[0m%}"


if [ ${UID} == 1000 ]; then # normal user
  PCOL=${PINK}
elif [ ${UID} == 0 ]; then # root
  PCOL=${RED}
else 
  PCOL=${BLUE}
fi

if [ ${SSH_CONNECTION} ]; then 
  SSH="[${SSH_CONNECTION%% *}]";
else 
  SSH="";
fi

EXITCODE="%(?..%?%1v )"
PS2='`%_> ' # secondary prompt, printed when the shell needs more information to complete a command.
PS3='?# ' # selection prompt used within a select loop.
PS4='+%N:%i:%_> ' # the execution trace prompt (setopt xtrace). default: '+%N:%i>'

autoload -Uz vcs_info
setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*:*' stagedstr "S"
zstyle ':vcs_info:git*:*' unstagedstr "⚡"
zstyle ':vcs_info:*' actionformats '[%b%u%c%a '
zstyle ':vcs_info:*' formats       '[%b%u%c '
zstyle ':vcs_info:git*+set-message:*' hooks git-st

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
local ahead behind remote
local -a gitstatus

# Are we on a remote-tracking branch?
remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
  --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

if [[ -n ${remote} ]] ; then
  ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
  (( ${ahead} )) && gitstatus+=( "${ahead}⇧" )

  behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
  (( ${behind} )) && gitstatus+=( "${behind}⇧" )

  (( !${ahead} && !${behind} )) && gitstatus+=( "≈" )

  hook_com[branch]="${hook_com[branch]}]${(j:/:)gitstatus}"
else
  hook_com[branch]="${hook_com[branch]}]${gitstatus}"
fi
}

case ${TERM} in 
  (xterm*|rxvt*|screen*)
    print -Pn "\e]0;:: %~\a" 
    precmd() {
      vcs_info
      print -Pn "\e]0;:: %~\a" 
    }
    preexec() { print -Pn "\e]0;:: ${1}\a" }
    ;;
esac

PROMPT='${RED}${EXITCODE}${WHITE}${PCOL}::${SSH}${NO_COLOUR} %40<...<%B%~%b%<< ${vcs_info_msg_0_}%# '
# }}}

# completion {{{

zmodload -i zsh/complist
autoload -Uz compinit
compinit -C

# use cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# completers order
zstyle ':completion:*' completer _expand _complete _prefix _approximate

# add a space after word completed by _prefix
zstyle ':completion:*:prefix:*'    add-space true

# verbose descriptions
zstyle ':completion:*'      verbose yes

# list-colors
zstyle ':completion:*'      list-colors ${(s.:.)LS_COLORS}

# 'format' style
zstyle ':completion:*:descriptions'  format "- %d -"
zstyle ':completion:*:messages'    format "- %d -"
zstyle ':completion:*:corrections'  format "- %d (errors: %e) -"
zstyle ':completion:*:warnings'    format "- no matches: %d -"

# options with no descriptions will display the description of their arguments
zstyle ':completion:*'      auto-description "argument: %d"

# group-name
# the empty string will make zsh use tag names for the group name
zstyle ':completion:*'      group-name ''

# sections
# man pages
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.(^1*)'  insert-sections true
# dict entries
zstyle ':completion:*:words'    separate-sections true

# list-separator
zstyle ':completion:*'      list-separator '#'

# tolerate errors
zstyle -e ':completion:*:approximate:*'  max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle -e ':completion:*:correct:*'  max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 2 )) )'

# Always use menu completion
# select=<N>
zstyle ':completion:*'      menu select

# when completing parameters, prefer expanding exact matches over completing
# longer parameter names, but still offer them
zstyle ':completion:*:expand:*'        accept-exact continue

# processes completion (e.g. kill)
# if sorted, then --forest becomes useless
zstyle ':completion:*:*:kill:*:processes' sort false
zstyle ':completion:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
zstyle ':completion:*:processes'      command 'ps --forest -au${USER} -o pid,time,cmd | grep -v "ps .* pid,time,cmd"'
zstyle ':completion:*:*:kill:*:processes'    list-colors '=(#b) #([0-9]#)[ 0-9:]#([^ ]#)*=01;30=01;31=01;38'

# disable hostname completion
zstyle ':completion:*'   hosts off 

# }}}

# key bindings {{{

bindkey -e
# put job into foreground via ctrl-z:
bindkey -s '^z' "fg\n"
# Cycle in reverse with meta-tab
bindkey -M menuselect "\e[Z" up-line-or-history
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey '\e[7~' beginning-of-line       # home
bindkey '\e[8~' end-of-line             # end
bindkey '\e[3~' delete-char

# }}}

# aliases {{{
alias cp='nocorrect cp'         # no spelling correction on cp
alias feh='feh -x -d --scale-down'
alias http='python -m http.server'
alias ls='ls -b -CF --color=auto'
alias mkdir='nocorrect mkdir'   # no spelling correction on mkdir
alias mp='mplayer.ext -vf screenshot -use-filename-title'
alias mv='nocorrect mv'         # no spelling correction on mv
alias pacman='sudo pacman'
alias rm='nocorrect rm'         # no spelling correction on rm
alias r='rsync -Ph'
alias screen='screen -R'
alias yjs="yuicompressor -o '.js$:.min.js' *.js"
# }}}

# suffix-aliases {{{
alias -s jpg=sxiv
alias -s md=vim 
alias -s mkd=vim 
alias -s pdf=zathura
alias -s png=sxiv
alias -s ps=zathura
alias -s txt=vim 
# }}}

# global aliases {{{
alias -g H='--help | less'
alias -g L=' | less'
# }}}

alias ex=aunpack
compdef '_files -g "*.ace *.gz *.tgz *.bz2 *.tbz *.zip *.rar *.tar *.lha *.7z"' aunpack

# functions {{{

# mkdir && cd into it 
mcd() { 
  mkdir "$@"; cd "$@" 
}

# only slash should be considered as a word separator:
slash-backward-kill-word() {
  local WORDCHARS="${WORDCHARS:s@/@}"
  zle backward-kill-word
}
zle -N slash-backward-kill-word
bindkey '^w' slash-backward-kill-word 

# expand '...' to '../..'
rationalise-dot() {
  if [[ ${LBUFFER} = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# When a line is killed, put it in the history anyway in case we want to
# return to it
TRAPINT() {
  # Store the current buffer in the history.
  zle &&
    [[ ${HISTNO} -eq ${HISTCMD} ]] && # only if we're not back in the history
  print -s -r -- ${BUFFER}

  # Return the default exit code so zsh aborts the current command.
  return ${1}
}

# Show ip
showmyip() {
  wget -qO - http://cfaj.freeshell.org/ipaddr.cgi
}

# Update packages
pub() {
  # Show latest news
  curl --silent "https://www.archlinux.org/feeds/news/" | \
    tr -d '\n\r' | \
    sed 's/<\/item>/<\/item>\n/g' | \
    sed -r 's/.*<title>(.*)<\/title>.*archlinux.org,([0-9]{4}-[0-9]{2}-[0-9]{2}).*/\2 \1/' | \
    head -3
  echo
  echo Press enter for update 
  read
  echo
  yaourt -Syua
  rehash
}

# Download lorem ipsum picture
lorempic () {
  wget http://lorempixel.com/640/480/cats/${1} -O $1:l.jpg
}

# whiten scan
whiteboard () {
  convert ${1} -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 ${2};
  optipng -o7 ${2};
}

# github.com/rupa/z
. /usr/lib/z.sh

# }}}

# ls_colors {{{
LS_COLORS=''
LS_COLORS=${LS_COLORS}:'no=0' # Normal text = Default foreground
LS_COLORS=${LS_COLORS}:'fi=0' # Regular file = Default foreground
LS_COLORS=${LS_COLORS}:'di=32' # Directory = Bold, Yellow
LS_COLORS=${LS_COLORS}:'ln=01;36' # Symbolic link = Bold, Cyan
LS_COLORS=${LS_COLORS}:'pi=33' # Named pipe = Yellow
LS_COLORS=${LS_COLORS}:'so=01;35' # Socket = Bold, Magenta
LS_COLORS=${LS_COLORS}:'do=01;35' # DO = Bold, Magenta
LS_COLORS=${LS_COLORS}:'bd=01;37' # Block device = Bold, Grey
LS_COLORS=${LS_COLORS}:'cd=01;37' # Character device = Bold, Grey
LS_COLORS=${LS_COLORS}:'ex=35' # Executable file = Light, Blue
LS_COLORS=${LS_COLORS}:'*FAQ=31;7' # FAQs = Foreground Red, Background Black
LS_COLORS=${LS_COLORS}:'*README=31;7' # READMEs = Foreground Red, Background Black
LS_COLORS=${LS_COLORS}:'*INSTALL=31;7' # INSTALLs = Foreground Red, Background Black
LS_COLORS=${LS_COLORS}:'*.sh=47;31' # Shell-Scripts = Foreground White, Background Red
LS_COLORS=${LS_COLORS}:'*.vim=35' # Vim-"Scripts" = Purple
LS_COLORS=${LS_COLORS}:'*.torrent=4;33' # Torrents = Orange, Underline
LS_COLORS=${LS_COLORS}:'*.swp=00;44;37' # Swapfiles (Vim = Foreground Blue, Background White
LS_COLORS=${LS_COLORS}:'*.sl=30;33' # Slang-Scripts = Yellow
LS_COLORS=${LS_COLORS}:'*,v=5;34;93' # Versioncontrols = Bold, Yellow
LS_COLORS=${LS_COLORS}:'or=01;05;31' # Orphaned link = Bold, Red, Flashing
LS_COLORS=${LS_COLORS}:'*.c=1;33' # Sources = Bold, Yellow
LS_COLORS=${LS_COLORS}:'*.C=1;33' # Sources = Bold, Yellow
LS_COLORS=${LS_COLORS}:'*.h=1;33' # Sources = Bold, Yellow
LS_COLORS=${LS_COLORS}:'*.cc=1;33' # Sources = Bold, Yellow
LS_COLORS=${LS_COLORS}:'*.awk=1;33' # Sources = Bold, Yellow
LS_COLORS=${LS_COLORS}:'*.pl=1;33' # Sources = Bold, Yellow
LS_COLORS=${LS_COLORS}:'*.jpg=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.jpeg=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.JPG=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.gif=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.png=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.jpeg=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.ppm=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.pgm=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.pbm=1;32' # Images = Bold, Green
LS_COLORS=${LS_COLORS}:'*.tar=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.tgz=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.gz=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.zip=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.sit=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.lha=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.lzh=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.arj=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.bz2=31' # Archive = Red
LS_COLORS=${LS_COLORS}:'*.html=36' # HTML = Cyan
LS_COLORS=${LS_COLORS}:'*.htm=1;34' # HTML = Bold, Blue
LS_COLORS=${LS_COLORS}:'*.php=1;45' # PHP = White, Cyan
LS_COLORS=${LS_COLORS}:'*.doc=1;34' # MS-Word *lol* = Bold, Blue
LS_COLORS=${LS_COLORS}:'*.txt=1;34' # Plain/Text = Bold, Blue
LS_COLORS=${LS_COLORS}:'*.o=1;36' # Object-Files = Bold, Cyan
LS_COLORS=${LS_COLORS}:'*.a=1;36' # Shared-libs = Bold, Cyan
export LS_COLORS
# }}}

