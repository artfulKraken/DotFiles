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
# Version: 0.1.1
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
  echo "${R}You must have root priveleges to run this script. Please re-run it using sudo.${NoColor}"
  exit 100
fi

# save iso datetime to variable for use in backups
curDate=$(date -u +"%Y-%m-%dT%H:%M:%S%z")

# absolute path to this script
scriptPath=${0:a}
scriptPath=$(dirname $scriptPath)

flgBkUpSuccess=true
flgPathExists=true

#.zshrc
if [[ -f $scriptPath/.zshrc ]] ; then
  echo "${B}Updating .zshrc file${NoColor}"

  # if .zshrc file exists
  if [[ -f ~/.zshrc ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ~/.zshrc.bkup
    #move old .zshrc file to backup
    mv ~/.zshrc ~/.zshrc.bkup/.zshrc.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up .zshrc file${NoColor}" 
    else
      echo "${R}Could not backup .zshrc file.  File .zshrc will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new .zshrc file to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp ${scriptPath}/.zshrc ~/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .zshrc file${NoColor}"
    else
      echo "${R}Unable to update .zshrc file." 
      if [[ flgPathExists ]] ; then
        mv ~/.zshrc.bkup/.zshrc.${curDate}.bkup ~/.zshrc
        if [[ $? == 0 ]] ; then
          echo "${G} Your original .zshrc file was placed back at the original location.${NoColor}"
        else
          echo "Your original .zshrc file could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original .zshrc file did not exist.  No changes were made to .zshrc${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No .zshrc file in Git folder.  Skipping .zshrc updates${NoColor}"
fi


#.asciiArt
if [[ -d $scriptPath/.asciiArt ]] ; then
  echo "${B}Updating .asciiArt dir${NoColor}"

  # if .asciiArt dir exists
  if [[ -d ~/.asciiArt ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ~/.asciiArt.bkup
    #move old .asciiArt dir to backup
    mv ~/.asciiArt ~/.asciiArt.bkup/.asciiArt.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up .asciiArt dir${NoColor}" 
    else
      echo "${R}Could not backup .asciiArt dir.  Dir .asciiArt will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new .asciiArt dir to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp ${scriptPath}/.asciiArt ~/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .asciiArt dir${NoColor}"
    else
      echo "${R}Unable to update .asciiArt dir." 
      if [[ flgPathExists ]] ; then
        mv ~/.asciiArt.bkup/.asciiArt.${curDate}.bkup ~/.asciiArt
        if [[ $? == 0 ]] ; then
          echo "${G} Your original .asciiArt dir was placed back at the original location.${NoColor}"
        else
          echo "Your original .asciiArt dir could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original .asciiArt dir did not exist.  No changes were made to .asciiArt${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No .asciiArt dir in Git folder.  Skipping .asciiArt updates${NoColor}"
fi


#zsh-syntax-highlighting
if [[ -d $scriptPath/zsh-syntax-highlighting ]] ; then
  echo "${B}Updating zsh-syntax-highlighting dir${NoColor}"

  # if zsh-syntax-highlighting dir exists
  if [[ -d /usr/share/zsh-syntax-highlighting ]]; then
    # Create backup dir if it does not exist.
    mkdir -p /usr/share/zsh-syntax-highlighting.bkup
    #move old zsh-syntax-highlighting dir to backup
    mv /usr/share/zsh-syntax-highlighting /usr/share/zsh-syntax-highlighting.bkup/zsh-syntax-highlighting.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up zsh-syntax-highlighting dir${NoColor}" 
    else
      echo "${R}Could not backup zsh-syntax-highlighting dir.  Dir zsh-syntax-highlighting will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new zsh-syntax-highlighting dir to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp ${scriptPath}/zsh-syntax-highlighting /usr/share/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced zsh-syntax-highlighting dir${NoColor}"
    else
      echo "${R}Unable to update zsh-syntax-highlighting dir." 
      if [[ flgPathExists ]] ; then
        mv /usr/share/zsh-syntax-highlighting.bkup/zsh-syntax-highlighting.${curDate}.bkup /usr/share/zsh-syntax-highlighting
        if [[ $? == 0 ]] ; then
          echo "${G} Your original zsh-syntax-highlighting dir was placed back at the original location.${NoColor}"
        else
          echo "Your original zsh-syntax-highlighting dir could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original zsh-syntax-highlighting dir did not exist.  No changes were made to zsh-syntax-highlighting${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No zsh-syntax-highlighting dir in Git folder.  Skipping zsh-syntax-highlighting updates${NoColor}"
fi



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

#zsh-autosuggestions
if [[ -d $scriptPath/zsh-autosuggestions ]] ; then
  echo "${B}Updating zsh-autosuggestions dir${NoColor}"

  # if zsh-autosuggestions dir exists
  if [[ -d /usr/share/zsh-autosuggestions ]]; then
    # Create backup dir if it does not exist.
    mkdir -p /usr/share/zsh-autosuggestions.bkup
    #move old zsh-autosuggestions dir to backup
    mv /usr/share/zsh-autosuggestions /usr/share/zsh-autosuggestions.bkup/zsh-autosuggestions.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up zsh-autosuggestions dir${NoColor}" 
    else
      echo "${R}Could not backup zsh-autosuggestions dir.  Dir zsh-autosuggestions will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new zsh-autosuggestions dir to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp ${scriptPath}/zsh-autosuggestions /usr/share/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced zsh-autosuggestions dir${NoColor}"
    else
      echo "${R}Unable to update zsh-autosuggestions dir." 
      if [[ flgPathExists ]] ; then
        mv /usr/share/zsh-autosuggestions.bkup/zsh-autosuggestions.${curDate}.bkup /usr/share/zsh-autosuggestions
        if [[ $? == 0 ]] ; then
          echo "${G} Your original zsh-autosuggestions dir was placed back at the original location.${NoColor}"
        else
          echo "Your original zsh-autosuggestions dir could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original zsh-autosuggestions dir did not exist.  No changes were made to zsh-autosuggestions${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No zsh-autosuggestions dir in Git folder.  Skipping zsh-autosuggestions updates${NoColor}"
fi




#.vimrc
if [[ -f $scriptPath/.vimrc ]] ; then
  echo "${B}Updating .vimrc file${NoColor}"

  # if .vimrc file exists
  if [[ -f ~/.vimrc ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ~/.vimrc.bkup
    #move old .vimrc file to backup
    mv ~/.vimrc ~/.vimrc.bkup/.vimrc.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up .vimrc file${NoColor}" 
    else
      echo "${R}Could not backup .vimrc file.  File .vimrc will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new .vimrc file to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp ${scriptPath}/.vimrc ~/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .vimrc file${NoColor}"
    else
      echo "${R}Unable to update .vimrc file." 
      if [[ flgPathExists ]] ; then
        mv ~/.vimrc.bkup/.vimrc.${curDate}.bkup ~/.vimrc
        if [[ $? == 0 ]] ; then
          echo "${G} Your original .vimrc file was placed back at the original location.${NoColor}"
        else
          echo "Your original .vimrc file could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original .vimrc file did not exist.  No changes were made to .vimrc${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No .vimrc file in Git folder.  Skipping .vimrc updates${NoColor}"
fi


#.vim
if [[ -d $scriptPath/.vim ]] ; then
  echo "${B}Updating .vim dir${NoColor}"

  # if .vim dir exists
  if [[ -d ~/.vim ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ~/.vim.bkup
    #move old .vim dir to backup
    mv ~/.vim ~/.vim.bkup/.vim.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up .vim dir${NoColor}" 
    else
      echo "${R}Could not backup .vim dir.  Dir .vim will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new .vim dir to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp ${scriptPath}/.vim ~/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .vim dir${NoColor}"
    else
      echo "${R}Unable to update .vim dir." 
      if [[ flgPathExists ]] ; then
        mv ~/.vim.bkup/.vim.${curDate}.bkup ~/.vim
        if [[ $? == 0 ]] ; then
          echo "${G} Your original .vim dir was placed back at the original location.${NoColor}"
        else
          echo "Your original .vim dir could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original .vim dir did not exist.  No changes were made to .vim${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No .vim dir in Git folder.  Skipping .vim updates${NoColor}"
fi


#.bashrc
if [[ -f $scriptPath/.bashrc ]] ; then
  echo "${B}Updating .bashrc file${NoColor}"

  # if .bashrc file exists
  if [[ -f ~/.bashrc ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ~/.bashrc.bkup
    #move old .bashrc file to backup
    mv ~/.bashrc ~/.bashrc.bkup/.bashrc.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up .bashrc file${NoColor}" 
    else
      echo "${R}Could not backup .bashrc file.  File .bashrc will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new .bashrc file to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp ${scriptPath}/.bashrc ~/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .bashrc file${NoColor}"
    else
      echo "${R}Unable to update .bashrc file." 
      if [[ flgPathExists ]] ; then
        mv ~/.bashrc.bkup/.bashrc.${curDate}.bkup ~/.bashrc
        if [[ $? == 0 ]] ; then
          echo "${G} Your original .bashrc file was placed back at the original location.${NoColor}"
        else
          echo "Your original .bashrc file could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original .bashrc file did not exist.  No changes were made to .bashrc${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No .bashrc file in Git folder.  Skipping .bashrc updates${NoColor}"
fi


