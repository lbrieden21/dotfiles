DIR=~/dotfiles

all: symlinks install_vimplug install_fzf

symlinks:
	@for file in bash/bash_profile bash/inputrc vim/vim vim/vimrc git/gitconfig git/gitignore_global .screenrc .tmux.conf bin; do \
		dest="$${file##*/}"; \
		# Remove extra dot if already present in the file name \
		first_char=$$(expr substr "$$dest" 1 1); \
		if [ "$$first_char" = "." ]; then \
			target="$$dest"; \
		else \
			target=".$$dest"; \
		fi; \
		# Check if the destination exists and is not already a correct symlink \
		if [ -L "$$HOME/$$target" ] && [ "$$(readlink $$HOME/$$target)" = "$(DIR)/$$file" ]; then \
			echo "Symlink for $$HOME/$$target already correctly set, skipping."; \
			continue; \
		elif [ -e "$$HOME/$$target" ]; then \
			echo "Backing up existing $$HOME/$$target to $$HOME/$$target.bak"; \
			mv -v "$$HOME/$$target" "$$HOME/$$target.bak"; \
		fi; \
		# Check if it is a directory \
		if [ "$$file" = "vim/vim" ] || [ "$$file" = "bin" ]; then \
			ln -nsf "$(DIR)/$$file" "$$HOME/$$target"; \
		else \
			ln -sf "$(DIR)/$$file" "$$HOME/$$target"; \
		fi; \
		echo "Created symlink for $$HOME/$$target -> $(DIR)/$$file"; \
	done

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
