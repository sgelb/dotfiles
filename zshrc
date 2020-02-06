# autostart and -logout X on tty1-3
# see .xinitrc for window managers
if [[ -z "${DISPLAY}" ]] && [[ $(tty) =~ tty[123] ]]; then
  startx
  logout
elif [[ $(tty) = /dev/tty4 ]]; then
  exec sway
fi

# exports and variables {{{
export GOPATH=${HOME}/code/golang
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.node_modules_global/bin:${GOPATH}/bin:${HOME}/.npm/bin:$(ruby -e 'print Gem.user_dir')/bin:${HOME}/.poetry/bin"
export EDITOR='/usr/bin/nvim'
export SHELL='/bin/zsh'
export HISTFILE=${HOME}/.zsh_history

# Highlight search results in ack.
export ACK_COLOR_MATCH='red'
# }}}

# options {{{

setopt APPEND_HISTORY # append history list to the history file
setopt HIST_IGNORE_ALL_DUPS # rm older duplicate from history
setopt HIST_IGNORE_SPACE # dont put to history if ^ is a space
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt NO_CLOBBER # warning if file exists ('cat /dev/null > ~/.zshrc')
setopt AUTO_CD # if a command is a folder, cd into it
setopt NO_BEEP # avoid "beep"ing
setopt EXTENDED_GLOB
setopt NONOMATCH
autoload zmv # rename

# autocomplete for pmbootstrap
# autoload bashcompinit
# bashcompinit
# eval "$(register-python-argcomplete pmbootstrap)"

REPORTTIME=5  # show report if cmd runs longer than 5 secondes
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

# set color of leading ::
if [ ${UID} == 1000 ]; then # normal user
  PCOL=${PINK}
  SYM="::"
elif [ ${UID} == 0 ]; then # root
  PCOL=${RED}
  SYM="ROOT"
else
  PCOL=${BLUE}
  SYM="::"
fi

# show ip if connected via ssh
if [ ${SSH_CONNECTION} ]; then
  SSH="[${SSH_CONNECTION%% *}]";
else
  SSH="";
fi

# show exit code
EXITCODE="%(?..%?%1v )"
PS2='`%_> ' # secondary prompt, printed when the shell needs more information to complete a command.
PS3='?# ' # selection prompt used within a select loop.
PS4='+%N:%i:%_> ' # the execution trace prompt (setopt xtrace). default: '+%N:%i>'

autoload -Uz vcs_info
setopt PROMPT_SUBST

# show info if in git repo

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

# Show commit/push/pull status
if [[ -n ${remote} ]] ; then
  ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
  (( ${ahead} )) && gitstatus+=( "${ahead}↑" )

  behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
  (( ${behind} )) && gitstatus+=( "${behind}↓" )

  (( !${ahead} && !${behind} )) && gitstatus+=( "≈" )

  hook_com[branch]="${hook_com[branch]}]${(j:/:)gitstatus}"
else
  hook_com[branch]="${hook_com[branch]}]${gitstatus}"
fi
}

# Virtual env
VENV=""
if [[ ${VIRTUAL_ENV} ]]; then
  VENV="(${VIRTUAL_ENV:t})"
fi


case ${TERM} in
  (termite*|xterm*|rxvt*|screen*)
    print -Pn "\e]0;:: %~\a"
    precmd() {
      vcs_info
      print -Pn "\e]0;:: %~\a"
    }
    local CMD1=${${1}//\%/%%}
    preexec() { print -Pn "\e]0;:: ${CMD1}\a" }
    ;;
esac

# Put everything together
PROMPT='${RED}${EXITCODE}${WHITE}${PCOL}${SYM}${SSH}${VENV}${NO_COLOUR} %40<...<%B%~%b%<< ${vcs_info_msg_0_}'
# }}}


# completion {{{

fpath+=~/.zsh/zfunc
zmodload -i zsh/complist
autoload -Uz compinit
compinit

# use cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# completers order
zstyle ':completion:*' completer _expand _complete _prefix _approximate

# add a space after word completed by _prefix
zstyle ':completion:*:prefix:*' add-space true

# verbose descriptions
zstyle ':completion:*' verbose yes

# list-colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 'format' style
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:messages' format "- %d -"
zstyle ':completion:*:corrections' format "- %d (errors: %e) -"
zstyle ':completion:*:warnings' format "- no matches: %d -"

# options with no descriptions will display the description of their arguments
zstyle ':completion:*' auto-description "argument: %d"

# group-name
# the empty string will make zsh use tag names for the group name
zstyle ':completion:*' group-name ''

# sections
# man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
# dict entries
zstyle ':completion:*:words' separate-sections true

# list-separator
zstyle ':completion:*' list-separator '#'

# tolerate errors
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle -e ':completion:*:correct:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 2 )) )'

# Always use menu completion
# select=<N>
zstyle ':completion:*' menu select

# when completing parameters, prefer expanding exact matches over completing
# longer parameter names, but still offer them
zstyle ':completion:*:expand:*' accept-exact continue

# processes completion (e.g. kill)
# if sorted, then --forest becomes useless
zstyle ':completion:*:*:kill:*:processes' sort false
zstyle ':completion:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
zstyle ':completion:*:processes' command 'ps --forest -au${USER} -o pid,time,cmd | grep -v "ps .* pid,time,cmd"'

# disable hostname completion
zstyle ':completion:*' hosts off

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

# disable spelling correction for these programs
#
alias cp='nocorrect rsync -av --progress'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias rm='nocorrect rm'

alias cal='cal -w -m'
alias feh='feh -x -d --scale-down'
alias serve='python -m http.server'
alias ls='exa --git --long --header --group-directories-first'
alias mpv='mpv --save-position-on-quit'
alias pacaur='pacaur --color always'
alias pacman='sudo pacman'
alias r='rsync -Ph'
alias tmux='tmux new-session -A -s main'
alias sub="subliminal download -s -l en -w 4"
alias sxiv="sxiv-rifle"
alias wiki='nvim -c WikiIndex'
# }}}

# suffix-aliases {{{
alias -s jpg=sxiv
alias -s md=nvim
alias -s mkd=nvim
alias -s pdf=zathura
alias -s png=sxiv
alias -s ps=zathura
alias -s txt=nvim
# }}}

# global aliases {{{
alias -g H='--help | less'
alias -g L=' | less'
# }}}

# unpack everything
alias ex=aunpack
compdef '_files -g "*.ace *.gz *.tgz *.bz2 *.tbz *.zip *.ZIP *.rar *.tar *.lha *.7z"' aunpack

# functions {{{

# mkdir if neccessary && cd into it
compdef mcd=cd
mcd() {
  mkdir -p "${1}" 2> /dev/null; cd "${1}"
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

# When a line is killed, put it in the history anyway
TRAPINT() {
  # Store the current buffer in the history.
  zle &&
    [[ ${HISTNO} -eq ${HISTCMD} ]] && # only if we're not back in the history
  print -s -r -- ${BUFFER}

  # Return the default exit code so zsh aborts the current command.
  return ${1}
}

# fzf
export FZF_DEFAULT_OPTS='--height 10%'
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

showmyips() {
  ip addr show | egrep -o 'inet ([0-9]{1,3}\.?){4}' | cut -d " " -f 2
  curl --silent https://api.ipify.org
  echo
}

nextmovie() {
  CMDS=$(grep -E "^mpv [^ ]|:[0-9: ];mpv [^ ]" "${HISTFILE}" | tail -n 1 | sed -e 's/^.*mpv //g')
  FOLDER=$(dirname $CMDS)
  FILE=$(basename $CMDS)
  BASE=$(find ~ -maxdepth 3 -wholename "*${FOLDER}")
  NEXT=$(/usr/bin/ls -1 "${BASE}"/^*.(srt|txt)(.) | grep -A 1 ${FILE} | tail -n 1)

  if [[ $# == 0 ]]; then
    print -s -r -- "mpv ${NEXT}"
    fc -W
    mpv "${NEXT}"
  else
    echo "Last: ${CMDS}"
    echo "Next: ${NEXT}"
  fi
}

# Update packages
pub() {
  dist=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2)
  if [[ "${dist}" =~ "arch" ]]; then
    # Show latest news
    curl --silent "https://www.archlinux.org/feeds/news/" | \
      tr -d '\n\r' | \
      sed 's/<\/item>/<\/item>\n/g' | \
      sed -r 's/.*<title>(.*)<\/title>.*archlinux.org,([0-9]{4}-[0-9]{2}-[0-9]{2}).*/\2 \1/' | \
      head -3 | recode html..ascii
    echo
    echo Press enter for update
    read
    yay -Syu
    rehash
    if [ $(df --output=avail / | tail -1) -lt 5000000 ];then
      echo :: Deleting pacman cache
      # remove pacman cache if less than 5GB free space
      yes | yay -q -Scc &> /dev/null
    fi
  elif [[ "${dist}" =~ "ubuntu|debian" ]]; then
    sudo apt-get update
    sudo apt-get -d dist-upgrade
    sudo apt-get autoclean
  fi
}

# markdown to pdf
md2pdf () {
  pandoc -V papersize:a4 -o ${1:r}.pdf ${1}
  echo Created ${1:r}.pdf
}

# Download lorem ipsum picture
lorempic () {
  wget http://lorempixel.com/640/480/cats/${1} -O $1:l.jpg
}

weather() {
  curl wttr.in
}

# whiten scan
whiteboard () {
  convert ${1} -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 ${2};
  optipng -o7 ${2};
}

# show various hashes of file
hashes () {
  gpg --print-md '*' "${1}"
}

clang-format-diff () {
  clang-format "${1}" | diff "${1}" - | colordiff
}

# show disk usage
dus () {
  # dus $folder $depth
  du -h --max-depth "${2:-1}" "${1:-.}" | sort -h
}

# get SHA256 of server certificate
servercert () {
  msmtp --serverinfo --tls --tls-certcheck=off --port 587 --host="${1}" | grep SHA256 | sed -e 's/^.*SHA256: //'
}

# github.com/rupa/z
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

calc () {
  echo "scale=4; ${@}" | bc -l
}

hrefs () {
  lynx -nonumbers -dump -hiddenlinks=listonly "${1}"
}

# recursive pull all git repos
pullall () {
  find . -maxdepth 2 -type d -name .git -exec sh -c "echo :: \"{}\" | sed -e 's/.git//'; cd \"{}\"/../ && git pull" \;
}

newerthan () {
  folder=${1:-.}
  ago=${2:-"1 day ago"}
  find "${folder}" -newermt "${ago}" -type f -print
}

imgrename () {
  folder=${1}
  exiftool -fileOrder DateTimeOriginal -extension jpg -ignoreMinorErrors '-FileName<CreateDate' -d %%.4nC-%Y%m%d-%H%M.%%le "${folder}"
}

aria() {
  echo Downloading "$#" files...
  for f in "$@"; do
    aria2c -c -x 4 --summary-interval=0 --console-log-level=warn "${f}"
  done
}

# move $3 newest files from $1 to $2: mvn ~/source ~/dest 5
mvn() {
  mv "$1"/*(.om[1,"$3"]) "$2"
}

# }}}

# ls_colors
if [[ -f  "$HOME/.local/share/dircolors/solarized256dark" ]]; then
  eval `dircolors $HOME/.local/share/dircolors/solarized256dark`
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
start_conda() {
  __conda_setup="$('/home/grml/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/home/grml/.miniconda3/etc/profile.d/conda.sh" ]; then
      . "/home/grml/.miniconda3/etc/profile.d/conda.sh"
    else
      export PATH="/home/grml/.miniconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup
}
# <<< conda initialize <<<

