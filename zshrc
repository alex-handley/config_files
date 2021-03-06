# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


alias freshstart="rake db:drop && rake db:create && rake db:migrate && rake db:seed && rake db:test:prepare"
alias migrate="rake db:migrate db:test:prepare"
alias remigrate="rake db:migrate && rake db:migrate:redo && rake db:schema:dump db:test:prepare"
alias remongrate="rake mongoid:migrate && rake mongoid:migrate:redo"
alias svnprecommit="git svn rebase && rake features && rake test"
alias hgprecommit="hg pull && rake features && rake test"
alias g="git"
alias tu="ruby_test unit"
alias tf="ruby_test functional"
alias s="bundle exec rspec"
alias cuc="bundle exec cucumber"
alias sm="ruby_spec models"
alias sc="ruby_spec controllers"
alias ti="ruby_test integration"
alias hgdi="hg diff --color=always --git | less -r"
alias hgrev="hg revert --no-backup"
alias hgclean="hg status | grep -e '^\\?' | sed 's/^\\?//' | xargs -t rm -f"
alias gi="gem install"
alias giv="gem install -v"
alias gci="git pull --rebase && rake && git push"
alias tlf="tail -f"
alias eydeploy="ey deploy -e \${\$(pwd):t}_staging"
alias eypending="git log \$(ey ssh \"cat /data/\${\$(pwd):t}/current/REVISION\" -e \${\$(pwd):t}_production)..origin/master"
alias hdeploy="git push staging master && heroku rake db:migrate --app \${\$(pwd):t}-staging"
alias hconsole="heroku console --app \${\$(pwd):t}-staging"
alias b="bundle"
alias be="bundle exec"
alias vi="/usr/local/bin/vim"
alias apipending="git log --pretty=oneline --abbrev-commit \"$(curl -s https://api.junglescout.com/api/am_i_alive | jq -r '.message')..master\""

# Case insensitive globbing
setopt NO_CASE_GLOB

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/Users/alexhandley/.local/bin:$PATH"

# Fixes bug with commit signing
# https://dev.gnupg.org/T3412
# https://github.com/keybase/keybase-issues/issues/1712
GPG_TTY=$(tty)
export GPG_TTY
