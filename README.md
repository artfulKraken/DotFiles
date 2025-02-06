# DotFiles
Configs (and supporting files) for .zshrc, .bashrc, .vimrc, gpg.conf that I run. These are almost all customizations I've picked up over time from others.

## Install
Install config files by running `sudo install.zsh`.  Must have root priveledeges to run script.

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
   .zsh/.zsh-syntax-highlighting.<isoDateTime>.bkup/
   .zsh/.zsh-autosuggestions.<isoDateTime>.bkup/
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
   ```
