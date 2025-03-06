# DotFiles
Configs (and supporting files) for .zshrc, .bashrc, .vimrc, gpg.conf .tmux.conf sshd_conf that I run. These are almost all customizations I've picked up over time from others.

## Install and Update
Install or update config files by running `install.zsh`.  

## Script Actions
### Files / Dirs Backed Up
-  Existing .zshrc, .bashrc, & .vimrc files and .asciiArt, .vim, .zsh-autosuggestions, .zsh-syntax-highlighting dirs (and files within) are backed up (if they existed) in Users home directory `~/`
   ```
   ~/.zshrc.bkup/.zshrc.<isoDateTime>.bkup 
   ~/bashrc.bkup/bashrc.<isoDateTime>.bkup
   ~/bashrc.bkup/bashrc.<isoDateTime>.bkup
   ~/.vimrc.bkup/.vimrc.<isoDateTime>.bkup
   ~/vim.bkup/vim.<isoDateTime>.bkup/
   ~/.asciiArt.bkup/.asciiArt.<isoDateTime>.bkup/
   ~/.gnupg/gpg.conf.bkup.gpg.conf.<isoDateTime>.bkup 
   ~/.zsh/.zsh-syntax-highlighting.<isoDateTime>.bkup/
   ~/.zsh/.zsh-autosuggestions.<isoDateTime>.bkup/
   ~/.tmux.conf.bkup/.tmux.conf.<isoDateTime>.bkup/
   /etc/ssh/sshd_conf.bkup/sshd_conf.<isoDateTime.bkup/
   ```
### Files / Dirs Added
-  Users home dir `~/` 
   ```
   .zshrc
   .bashrc
   .vimrc
   .vim/
   .asciiArt/
   .gnupg/gpg.conf
   .zsh-syntax-highlighting/
   .zsh-autosuggestions/
   .tmux.conf
   ```
- Other Directories
  '''
  /etc/ssh/sshd_conf
  '''
