# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
source ~/.nvm/nvm.sh
alias sudo='sudo env PATH=$PATH:$NVM_BIN'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias .='pwd'
alias so='source'
alias vi='vim'
alias chkconfig='sysv-rc-conf'
