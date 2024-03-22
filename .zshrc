export XDG_CONFIG_HOME="$HOME"/.config

## Shell variables

set -o vi

export VISUAL=nvim
export EDITOR=nvim

## Kubectl completion
if which kubectl > /dev/null
then 	
	autoload -Uz compinit
	compinit
	source <(kubectl completion zsh)
fi


## Shell things
if which starship > /dev/null; then eval "$(starship init zsh)"; fi
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh


## 1Password SSH Agentg
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

## ZSH pluginsg
plugins=(aws git kubectl)

## Aliassesg

alias k="kubectl"
alias lab="cd $HOME/lab"
alias billrun="cd $HOME/Documents/billrun"
alias kibrit="cd $HOME/Documents/kibrit"
alias repos="cd $HOME/repos"
alias dot="cd $HOME/repos/github.com/hrahmanov89/dot"
