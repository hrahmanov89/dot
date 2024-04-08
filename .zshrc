export XDG_CONFIG_HOME="$HOME"/.config
autoload -Uz compinit
compinit


export PATH=$PATH":/Users/hrahmanov/.local/bin"
## Source additional local script which contain secrets

source "$HOME/.local.sh"

## Shell variables

set -o vi

export VISUAL=nvim
export EDITOR=nvim

## Kubectl completion
if type kubectl &> /dev/null
then 	
	source <(kubectl completion zsh)
fi


## Shell things
if which starship > /dev/null; then eval "$(starship init zsh)"; fi

source "$XDG_CONFIG_HOME"/.zsh/plugins/zsh-autosuggestion/zsh-autosuggestions.zsh
source "$XDG_CONFIG_HOME"/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
alias 12go="cd $HOME/Documents/12go"
alias sb="/Users/hrahmanov/Library/CloudStorage/GoogleDrive-shirbala@gmail\.com/My\ Drive/my-sb/rhz"
alias vim="nvim"

#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm

#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

