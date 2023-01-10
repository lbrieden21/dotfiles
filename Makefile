DIR=~/dotfiles

all: symlinks install_vimplug install_fzf

symlinks:
	@ln -sf $(DIR)/bash/bash_profile ~/.bash_profile
	@ln -sf $(DIR)/bash/inputrc ~/.inputrc
	@ln -nsf $(DIR)/vim/vim ~/.vim
	@ln -sf $(DIR)/vim/vimrc ~/.vimrc
	@ln -sf $(DIR)/git/gitconfig ~/.gitconfig
	@ln -sf $(DIR)/git/gitignore_global ~/.gitignore_global
	@ln -sf $(DIR)/.screenrc ~/.screenrc
	@ln -sf $(DIR)/.tmux.conf ~/.tmux.conf
	@ln -sf $(DIR)/bin ~/bin

install_vimplug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

gitTools:
	git clone git@github.com:paulirish/git-recent.git $(DIR)/git-clones/git-recent/
	ln -s $(DIR)/git-clones/git-recent/git-recent $(DIR)/bin/
	git clone git@github.com:paulirish/git-open.git $(DIR)/git-clones/git-open/
	ln -s $(DIR)/git-clones/git-open/git-open $(DIR)/bin/

install_fzf:
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
