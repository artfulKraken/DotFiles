#!/bin/zsh
############################################################
############################################################
############################################################
# install.zsh 
############################################################
############################################################
# Purpose: Install .zshrc, .bashrc, & .vimrc and their 
#   support files
#
# Author: artfulKraken 
# Version: 1.0.1
# Date: 2025-02-03
#
# Adds or replaces zsh, bash, vim config files and supporting dirs/files.
# Files are saved in folder they reside in as <filename>.bkup/<filename>.<isoDateTime>.bkup
# Dirs are saved in folder they reside in as <dirname>.bkup/<dirname>.<isoDateTime>.bkup 
# shellrc file ie (.bashrc or .zshrc) must be sourced ie cmd: source zsh.rc or shell restarted before use.
#
############################################################
############################################################

############################################################
############################################################
# Configuration                                            #
############################################################
############################################################

# Set script to use standard zsh parameters
emulate -LR zsh

############################################################
# General variables                                        #
############################################################
# Terminal Text colors for user feedback.
# colors for echo options
R='\033[0;31m'   #'0;31' is Red's ANSI color code.  Used to notify user of failed operations or inputs.
G='\033[0;32m'   #'0;32' is Green's ANSI color code.  Used to notify user of successful operations.
Y='\033[1;33m'   #'1;32' is Yellow's ANSI color code. Used to denote question to user.
B='\033[0;34m'   #'0;34' is Blue's ANSI color code.  Used to update user on progress and next steps, without confirming success.
NoColor='\033[0m'  #returns to default color.  Used in any other situations.

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

## Check if running as root/sudo/admin.  If not, warn user to rerun as sudo and exit.
if [[ $EUID -ne 0 ]]; then
  echo "${R}You must hae  root priveleges to run this script. Please re-run it using sudo.${NoColor}"
  exit 100
fi

# save iso datetime to variable for use in backups
curDate=$(date -u +"%Y-%m-%dT%H:%M:%S%z")

# absolute path to this script
scriptPath=${0:a}
scriptPath=$(dirname $scriptPath)


#.zshrc
# if .zshrc file exists
if [[ -f ~/.zshrc ]]; then
  # Create backup dir if it does not exist.
  mkdir -p ~/.zshrc.bkup
  #move old .zshrc file to backup
  mv ~/.zshrc ~/.zshrc.bkup/.zshrc.${curDate}.bkup
  echo "${G}Backed up .zshrc file${NoColor}" 
fi
# copy new .zshrc file to user home dir.
cp ${scriptPath}/.zshrc ~/ 
echo "${G}Replaced .zshrc file${NoColor}"

#ascii art
# if .asciiArt dir exists
if [[ -d ~/.asciiArt ]]; then
  # Create backup dir if it does not exist
    mkdir -p ~/.asciiArt.bkup
  # put dated .asciiArt dir in backup folder.
  mv ~/.asciiArt ~/.asciiArt.bkup/.asciiArt.${curDate}.bkup
  echo "${G}Backed up .asciiArt dir${NoColor}"
fi
# copy new .asciiArt dir to user home dir.
cp -r ${scriptPath}/.asciiArt ~/.asciiArt 
echo "${G}Replaced .asciiArt dir${NoColor}"


# zsh syntax highlighting
# if zsh syntac highlighting exists
if [[ -d /usr/share/zsh-syntax-highlighting ]]; then
  #Create backup dir if it does not exist
  sudo mkdir -p /usr/share/zsh.bkup
  # put dated syntax highlighting dir in backup dir
  sudo mv /usr/share/zsh-syntax-highlighting /usr/share/zsh.bkup/zsh-syntax-highlighting.${curDate}.bkup
  echo "${G}Backed up zsh-syntax-highlighting dir${NoColor}"
fi
sudo cp -r ${scriptPath}/zsh-syntax-highlighting /usr/share/zsh-syntax-highlighting
echo "${G}Replaced zsh-syntax-highlighting dir${NoColor}"


# zsh autosuggestions
# if zsh autosuggestions exists
if [[ -d /usr/share/zsh-autosuggestions ]]; then
  #Create backup folder if it doesn't exist. 
  sudo mkdir -p /usr/share/zsh.bkup
  # put dated syntax highlighting dir in backup dir
  sudo mv /usr/share/zsh-autosuggestions /usr/share/zsh.bkup/zsh-autosuggestions.${curDate}.bkup
  echo "${G}Backed up zsh-autosuggestions dir${NoColor}"
fi
sudo cp -r ${scriptPath}/zsh-autosuggestions /usr/share/zsh-autosuggestions
echo "${G}Replaced zsh-autosuggestions dir${NoColor}"

# .vimrc
# if .vimrc  exists
if [[ -f ~/.vimrc ]]; then
  # Create backup dir if it doesn't already exist
  mkdir -p ~/.vim.bkup
  # put dated syntax highlighting dir in backup dir
  mv ~/.vimrc ~/.vim.bkup/.vimrc.${curDate}.bkup
  echo "${G}Backed up .vimrc ${NoColor}"
fi
cp -r ${scriptPath}/.vimrc ~/.vimrc
echo "${G}Replaced .vimrc${NoColor}"

# .vim Dir
# if .vim dir  exists
if [[ -d ~/.vim ]]; then
  #create backup dir if it does not exist
  mkdir -p ~/.vim.bkup
  # put dated syntax highlighting dir in backup dir
  mv ~/.vim ~/.vim.bkup/.vim.${curDate}.bkup
  echo "${G}Backed up .vim dir ${NoColor}"
fi
cp -r ${scriptPath}/.vim ~/.vim
echo "${G}Replaced .vim${NoColor}"


#.bashrc
# if .bashrc file exists
if [[ -f ~/.bashrc ]]; then
  # Create backup dir if it does not exist.
  mkdir -p ~/.bashrc.bkup
  #move old .zshrc file to backup
  mv ~/.bashrc ~/.bashrc.bkup/.bashrc.${curDate}.bkup
  echo "${G}Backed up .bashrc dir ${NoColor}"
fi
# copy new .zshrc file to user home dir.
cp ${scriptPath}/.bashrc ~/ 
echo "${G}Replaced .bashrc${NoColor}"
