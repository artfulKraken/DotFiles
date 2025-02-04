# DotFiles
Configs (and supporting files for .zshrc, .bashrc, .vimrc that I run. These are almost all customizations I've picked up over time from others.

## Install
Install config files by running `sudo install.zsh`.  Must have root priveledeges to run script.

## Script Actions
### Files / Dirs Backed Up
-  Existing .zshrc, .bashrc, & .vimrc files and .asciiArt and .vim dirs (and files within) are backed up (if they existed) in Users home directory `~/`
   ```
   ~/.zshrc.bkup/.zshrc.<isoDateTime>.bkup 
   ~/bashrc.bkup/bashrc.<isoDateTime>.bkup
   ~/bashrc.bkup/bashrc.<isoDateTime>.bkup
   ~/.vimrc.bkup/.vimrc.<isoDateTime>.bkup
   ~/vim.bkup/vim.<isoDateTime>.bkup/
   ~/.asciiArt.bkup/.asciiArt.<isoDateTime>.bkup/
   ```
-  Existing zsh-syntax-highlighting and zsh-autosuggestions dirs are backed up in `/usr/share/zsh.bkup`
   ```
   /usr/share/zshbackup/zsh-syntax-highlighting.<isoDateTime>.bkup/
   /usr/share/zshbackup/zsh-autosuggestions.<isoDateTime>.bkup/
   ```
### Files / Dirs Added
-  Users home dir `~/` 
   ```
   .zshrc
   .bashrc
   .vimrc
   .vim/
   .asciiArt/
   ```
-  `/usr/share/`
   ```
   zsh-syntax-highlighting/
   zsh-autosuggestions
   ```
