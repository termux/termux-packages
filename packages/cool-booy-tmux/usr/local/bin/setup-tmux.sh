#!/bin/bash
# tmux configuration setup
echo 'set -g status-bg "#2E3440"' > ~/.tmux.conf
echo 'set -g status-fg "#E5E9F0"' >> ~/.tmux.conf
echo 'set -g status-interval 1' >> ~/.tmux.conf
echo 'set -g status-left-length 50' >> ~/.tmux.conf
echo 'set -g status-right-length 50' >> ~/.tmux.conf
echo 'set -g status-left "#[fg=#81A1C1]📅 #[fg=#7F00FF]%Y-%m-%d #[fg=#008000]%A #[fg=#E0115F]%H:%M:%S"' >> ~/.tmux.conf
echo 'set -g status-right "#[fg=#A3BE8C]🔋#[fg=#E5E9F0] #(battery_percentage) #[fg=#2AAA8A]Load: #[fg=#FFC000]#(uptime)#[fg=#88C0D0] ⚙️"' >> ~/.tmux.conf

if ! grep -q 'if [ -z "$TMUX" ]; then' ~/.bashrc; then
    echo 'if [ -z "$TMUX" ]; then' >> ~/.bashrc
    echo '  tmux' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
fi

echo -e "\033[38;5;12m🎉 Tmux Configuration Setup Complete..! 🎉\n🌟 SL Android Official ™\n💻 Package Developed by IM COOL BOOY 🌟\033[0m"

source ~/.bashrc
