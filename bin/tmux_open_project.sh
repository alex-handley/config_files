#!/bin/bash
# Thanks Jelmer!
# https://github.com/jelmersnoeck/dotfiles/blob/d7b7dbba8fb5f3198f43acb686d866e48c68da96/.bin/tmux_open_project.sh

function lowercase()
{
    if [ -n "$1" ]; then
        echo "$1" | tr "[:upper:]" "[:lower:]"
    else
        cat - | tr "[:upper:]" "[:lower:]"
    fi
}

function split_string()
{
    if [[ ! -n $1 ]] || [[ ! -n $2 ]]; then
        echo '[usage]: split_string "," "this, is, a, string"'
    fi

    STR_ARRAY=(`echo $2 | sed -e "s/\\$1//g"`)

    for x in "${STR_ARRAY[@]}"
    do
        echo "> [$x]"
    done
}

function open_tmux_session()
{
    path=$1
    project=$2

    # editor window
    tmux new-session -s $project -n editor -d
    tmux send-keys -t $project "cd -P $path/$project" C-m
    tmux send-keys -t $project "vim" C-m

    # database window
    tmux new-window -n database -t $project
    tmux send-keys -t $project:2 "cd $path/$project" C-m
    if [ -f $path/$project/dbshell ]; then
        tmux send-keys -t $project:2 "./dbshell" C-m
    fi

    # shell window
    tmux new-window -n shell -t $project
    tmux send-keys -t $project:3 "cd $path/$project" C-m
    tmux send-keys -t $project:3 "git st" C-m

    # If this is a project that contains a vagrant file, create a vagrant
    # window.
    if [ -f $path/$project/Vagrantfile ]; then
        tmux new-window -n vagrant -t $project
        tmux send-keys -t $project:4 "cd $path/$project" C-m
        tmux send-keys -t $project:4 "vagrant ssh" C-m
    fi

    # select the editor and attach to the session
    tmux select-window -t $project:1
}

function attach_to_tmux_session()
{
    project=$1

    echo -n "$(tput setaf 11)Do you want to attach to the $(tput sgr0)$(tput bold)$project$(tput sgr0)$(tput setaf 11) session? $(tput sgr0)$(tput bold)(y/n)$(tput sgr0)$(tput setaf 11):$(tput sgr0) "
    read switchToSession

    if [ $(lowercase $switchToSession) == "y" ]; then
        tmux attach -t $project
    else
        exit 1
    fi
}


# Define our project working directory
path="$HOME/code"

# Get the project from a given parameter, or query the user if none was provided
if [ "$1" == "" ]; then
    echo "$(tput setaf 11)What project do you want to open?$(tput sgr0)"
    echo -n "$(tput sgr0)$(tput bold)$path/$(tput sgr0)"
    read project
else
    project=$1
fi

tmux has-session -t $project > /dev/null 2>&1

# A session with that name already exists
if [ $? == 0 ]; then
    echo "$(tput setaf 9)A session with that name is already running.$(tput sgr0)"
    attach_to_tmux_session $project
# Session name is free, open a new one
else
    open_tmux_session $path $project
    attach_to_tmux_session $project
fi

