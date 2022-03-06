### Setup Shell variables ###
set -gx GPG_TTY (tty)
set -gx EDITOR vim
set -gx VISUAL vim
set -gx PAGER most
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

### Aliases ###
alias ll="ls -ahl"
alias k="kubectl"
alias kx="kubectx"
alias kn="kubens"
alias t="tree -ah --du"
alias ag="command ag --hidden"
alias wiki="vim -c VimwikiIndex"

### Functions ###
function pdf --description 'Render a PDF in the Terminal'
    pdftotext -layout $argv - | less
end

function up --description 'Update the system'
    switch (uname)
        case Darwin
            brew update && \
            brew upgrade && \
            brew cleanup
        case Linux
            sudo apt update && \
            sudo apt upgrade && \
            sudo apt autoremove
        case '*'
            echo "Your OS" (uname) "is not supported by this script"
    end
end

function kernel --description 'Show installed and available kernel versions'
    switch (uname)
        case Darwin
            echo "Installed:" (uname -v | awk -F '[ :]' '{print $4}')
            echo "Available: please run 'softwareupdate -l' for available updates"
        case Linux
            echo "Installed:" (uname -v | awk '{print $5}')
            echo "Available:" (apt-cache show linux-image-cloud-amd64/unstable | grep Version | awk '{print $2}')
            echo "Last updated:" (apt-get changelog linux-image-cloud-amd64/unstable | grep -e "^ --" | head -n 1 | awk -F '  ' '{print $2}')
        case '*'
            echo "Your OS" (uname) "is not supported by this script"
    end
end

function deheic --description 'Un-HEIC received pictures'
    pushd ~/Downloads

    set -l u_heic *.HEIC
    set -l l_heic *.heic

    if test (count $u_heic) -gt 0
        mogrify -format jpg *.HEIC
        rm *.HEIC
    end

    if test (count $l_heic) -gt 0
        mogrify -format jpg *.heic
        rm *.heic
    end

    popd
end

function asciiart --description 'Pretty print cool ASCII art'
    echo -n $argv | \
    figlet -w $COLUMNS -f lean | \
    tr ' _/' './\\'
end

function gu --description 'Update local git projects'
    for dir in ~/Development/*/
        pushd $dir

        set project (basename (pwd))
        set branch (git branch --show-current)
        set changes (git status --porcelain | wc -l | sed -e 's/^[ ]*//')

        if contains $branch master main ; and test $changes -eq 0
            set_color --bold green
            echo "Pulling "$project
            set_color normal
            git pull
        else
            set_color --bold red
            echo "Skipping "$project" at "$branch" with "$changes" uncommitted changes"
            set_color normal
        end
        echo "-----------------------------------------------------------------"
        popd
    end
end

function git-clone-user --description 'Clone all first 100 repos of a user'
    curl -s "https://api.github.com/users/$argv[1]/repos?per_page=100" | jq -r ".[].git_url" | xargs -L1 git clone
end

### Fish config ###
set -g fish_greeting

fish_vi_key_bindings

function fish_mode_prompt --description 'Print the current Vim mode'
    switch $fish_bind_mode
        case default
            set_color --bold red
            echo "[N]"
        case insert
            set_color --bold green
            echo "[I]"
        case replace_one
            set_color --bold green
            echo "[R]"
        case visual
            set_color --bold magenta
            echo "[V]"
    end

    set_color normal
    printf " "
end
