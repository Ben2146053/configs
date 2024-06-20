# ~/.config/fish/config.fish

set fish_greeting ""

if status is-interactive
end

# Set FZF default command to use `fd` for finding files
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

function colorstuff
    while read -l input
        switch $input
            case "*error*"
                set_color red
                echo $input
                set_color normal
            case "*warning*"
                set_color yellow
                echo $input
                set_color normal
            case "*success*"
                set_color green
                echo $input
                set_color normal
            case "*info*"
                set_color blue
                echo $input
                set_color normal
            case "*"
                echo $input
        end
    end
end

set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/Downloads/nvim-linux64/bin $PATH
set -gx PATH $PATH $HOME/.linkerd2/bin
set -gx KUBECONFIG "/home/ben/Downloads/k8s-services-kubeconfig.yaml"
set -gx VISUAL nvim
set -gx EDITOR nvim
set -x DESIRED_MEM 24576
set -x PROTOC /usr/bin/protoc
set -x CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG true

alias nvim_c='cd ~/.config/nvim/ && nvim'
alias tmux_c='nvim ~/Documents/compass/tools/tmux/tmux-startup.sh'
alias fish_c='nvim ~/.config/fish/config.fish'
alias alacritty_c='nvim ~/.config/alacritty/alacritty.toml'
alias compass='cd ~/Documents/compass/'
alias core='cd ~/Documents/compass/core/'
alias git_compass='cd ~/Documents/compass/ && lazygit'
alias compass_services='cd ~/Documents/compass-services/'
