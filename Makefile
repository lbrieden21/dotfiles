DIR=$(HOME)/dotfiles

all: symlinks install_vimplug install_fzf

symlinks:
	@for file in bash/bashrc bash/bash_profile bash/inputrc vim/vim vim/vimrc git/gitconfig git/gitignore_global .screenrc .tmux.conf bin; do \
		dest="$${file##*/}"; \
		if [ "$$dest" = "bin" ]; then \
			target="$$dest"; \
		elif [ "$$(expr substr "$$dest" 1 1)" = "." ]; then \
			target="$$dest"; \
		else \
			target=".$$dest"; \
		fi; \
		if [ -L "$$HOME/$$target" ] && [ "$$(readlink $$HOME/$$target)" = "$(DIR)/$$file" ]; then \
			echo "Symlink for $$HOME/$$target already correctly set, skipping."; \
			continue; \
		elif [ -e "$$HOME/$$target" ]; then \
			echo "Backing up existing $$HOME/$$target to $$HOME/$$target.bak"; \
			mv -v "$$HOME/$$target" "$$HOME/$$target.bak"; \
		fi; \
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

set_locale:
	@set -e; \
	if [ "$$(locale 2>/dev/null | awk -F= '/^LANG=/{print $$2}' | tr -d '"')" = "en_US.UTF-8" ]; then \
		echo "Locale already set (LANG=en_US.UTF-8); nothing to do."; \
	else \
		sudo sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen; \
		sudo locale-gen; \
		sudo update-locale LANG=en_US.UTF-8; \
	fi
