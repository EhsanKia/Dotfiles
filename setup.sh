# Run in home
cd ~

# Some color macros
function green { echo -e "\033[0;32m$1\033[0m"; }
function yellow { echo -e "\033[0;33m$1\033[0m"; }

# Install tools needed for the rest of the script
green "Installing some tools..."
apt update -y -qq && apt upgrade -y -qq
apt install curl git -y -qqq

# Fetch dotfiles from git
green "Downloading dotfiles"
git clone https://github.com/EhsanKia/Dotfiles ~/.dotfiles

# Install micro editor
if [ -f /usr/bin/micro ]; then
	yellow "micro is already installed"
else
	green "Installing micro..."
	curl https://getmic.ro | bash
	mv ./micro /usr/bin/micro
	ln -s ~/.dotfiles/micro-settings.json ~/.config/micro/settings.json
	ln -s ~/.dotfiles/micro-bindings.json ~/.config/micro/bindings.json
fi

# Install and setup TMUX
if [ -f ~/.tmux.conf ]; then
	yellow "TMUX is already installed"
else
	green "Installing TMUX"
	apt install tmux -y
	ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
	
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install and setup zsh/oh-my-zsh
if [ -f /usr/bin/zsh ]; then
	yellow "ZSH is already installed"
else
	green "Installing ZSH..."
	apt install zsh -y
	ln -s ~/.dotfiles/.zshrc ~/.zshrc

	yellow "Setting zsh as default shell"
	chsh -s /usr/bin/zsh

	# Install syntax highlighting
	apt install zsh-syntax-highlighting -y
fi

if [ -d ~/.oh-my-zsh ]; then
	yellow "Oh-My-ZSH is already installed"
else
	green "Installing Oh-My-ZSH..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	
	# Install theme
	mkdir -p "$HOME/.zsh"
	git clone https://github.com/sindresorhus/pure "$HOME/.oh-my-zsh/themes/pure"

	# Install some plugins
	git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-completions "$HOME/.oh-my-zsh/plugins/zsh-completions"
fi

if [ -d ~/.fzf ]; then
	yellow "FZF is already installed"
else
	green "Installing fzf..."

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --all --no-bash > /dev/null
fi

green "Installing remaining packages"
apt install -y -qqq \
	python3-pip ipython3 \
	build-essential \
	netcat
	
