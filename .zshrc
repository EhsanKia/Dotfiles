# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME=""  # ZSH theme name
ENABLE_CORRECTION="true"  # command auto-correction.
HIST_STAMPS="yyyy-mm-dd"  # Execution timestamp format

# Setup plugins
plugins=(zsh-autosuggestions zsh-completions dircycle history python sudo wd)
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# Pure theme
fpath+=$HOME/.oh-my-zsh/themes/pure
autoload -U promptinit; promptinit
prompt pure

# Set default editors
export EDITOR='micro'

# Setup history
setopt share_history
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.history
setopt APPEND_HISTORY

# Install fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

############# ALIASES ###############
alias t="tmux new-session -A -s main"
alias zshrc="$EDITOR ~/.zshrc"

########## HACKS / FIXES ############

# Better word navigation(?)
export WORDCHARS="${WORDCHARS:s#/#}"

# This speed up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# https://github.com/sindresorhus/pure/issues/184
function zle-line-init zle-keymap-select {
	zle .reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# make tmux-yank work?
bindkey -e


########## CUSTOM BINDINGS ###########
# Fix HOME and END key
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line

# ctrl+backspace and ctrl+del to delete word
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# bind zsh-autocomplete to ctrl+space
bindkey '^ ' autosuggest-accept

# Up/down history search after typing a prefix
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search


# Keep at the end of .zshrc to wrap all created widgets
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

