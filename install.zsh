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
  if [[ -f ${HOME}/.zshrc ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ${HOME}/.zshrc.bkup
    #move old .zshrc file to backup
    mv ${HOME}/.zshrc ${HOME}/.zshrc.bkup/.zshrc.${curDate}.bkup
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
    cp ${scriptPath}/.zshrc ${HOME}/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .zshrc file${NoColor}"
    else
      echo "${R}Unable to update .zshrc file." 
      if [[ flgPathExists ]] ; then
        mv ${HOME}/.zshrc.bkup/.zshrc.${curDate}.bkup ${HOME}/.zshrc
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
  if [[ -d ${HOME}/.asciiArt ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ${HOME}/.asciiArt.bkup
    #move old .asciiArt dir to backup
    mv ${HOME}/.asciiArt ${HOME}/.asciiArt.bkup/.asciiArt.${curDate}.bkup
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
    cp -r ${scriptPath}/.asciiArt ${HOME}/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .asciiArt dir${NoColor}"
    else
      echo "${R}Unable to update .asciiArt dir." 
      if [[ flgPathExists ]] ; then
        mv ${HOME}/.asciiArt.bkup/.asciiArt.${curDate}.bkup ${HOME}/.asciiArt
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


#.zsh-syntax-highlighting
if [[ -d $scriptPath/.zsh-syntax-highlighting ]] ; then
  echo "${B}Updating .zsh-syntax-highlighting dir${NoColor}"

  # if .zsh-syntax-highlighting dir exists
  if [[ -d ${HOME}/.zsh-syntax-highlighting ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ${HOME}/.zsh-syntax-highlighting.bkup
    #move old .zsh-syntax-highlighting dir to backup
    mv ${HOME}/.zsh-syntax-highlighting ${HOME}/.zsh-syntax-highlighting.bkup/.zsh-syntax-highlighting.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up .zsh-syntax-highlighting dir${NoColor}" 
    else
      echo "${R}Could not backup .zsh-syntax-highlighting dir.  Dir .zsh-syntax-highlighting will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new .zsh-syntax-highlighting dir to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp -r ${scriptPath}/.zsh-syntax-highlighting ${HOME}/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .zsh-syntax-highlighting dir${NoColor}"
    else
      echo "${R}Unable to update .zsh-syntax-highlighting dir." 
      if [[ flgPathExists ]] ; then
        mv ${HOME}/.zsh-syntax-highlighting.bkup/.zsh-syntax-highlighting.${curDate}.bkup ${HOME}/.zsh-syntax-highlighting
        if [[ $? == 0 ]] ; then
          echo "${G} Your original .zsh-syntax-highlighting dir was placed back at the original location.${NoColor}"
        else
          echo "Your original .zsh-syntax-highlighting dir could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original .zsh-syntax-highlighting dir did not exist.  No changes were made to .zsh-syntax-highlighting${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No .zsh-syntax-highlighting dir in Git folder.  Skipping .zsh-syntax-highlighting updates${NoColor}"
fi


#.zsh-autosuggestions
if [[ -d $scriptPath/.zsh-autosuggestions ]] ; then
  echo "${B}Updating .zsh-autosuggestions dir${NoColor}"

  # if .zsh-autosuggestions dir exists
  if [[ -d ${HOME}/.zsh-autosuggestions ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ${HOME}/.zsh-autosuggestions.bkup
    #move old .zsh-autosuggestions dir to backup
    mv ${HOME}/.zsh-autosuggestions ${HOME}/.zsh-autosuggestions.bkup/.zsh-autosuggestions.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up .zsh-autosuggestions dir${NoColor}" 
    else
      echo "${R}Could not backup .zsh-autosuggestions dir.  Dir .zsh-autosuggestions will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new .zsh-autosuggestions dir to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp -r ${scriptPath}/.zsh-autosuggestions ${HOME}/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .zsh-autosuggestions dir${NoColor}"
    else
      echo "${R}Unable to update .zsh-autosuggestions dir." 
      if [[ flgPathExists ]] ; then
        mv ${HOME}/.zsh-autosuggestions.bkup/.zsh-autosuggestions.${curDate}.bkup ${HOME}/.zsh-autosuggestions
        if [[ $? == 0 ]] ; then
          echo "${G} Your original .zsh-autosuggestions dir was placed back at the original location.${NoColor}"
        else
          echo "Your original .zsh-autosuggestions dir could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original .zsh-autosuggestions dir did not exist.  No changes were made to .zsh-autosuggestions${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No .zsh-autosuggestions dir in Git folder.  Skipping .zsh-autosuggestions updates${NoColor}"
fi


#.vimrc
if [[ -f $scriptPath/.vimrc ]] ; then
  echo "${B}Updating .vimrc file${NoColor}"

  # if .vimrc file exists
  if [[ -f ${HOME}/.vimrc ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ${HOME}/.vimrc.bkup
    #move old .vimrc file to backup
    mv ${HOME}/.vimrc ${HOME}/.vimrc.bkup/.vimrc.${curDate}.bkup
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
    cp ${scriptPath}/.vimrc ${HOME}/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .vimrc file${NoColor}"
    else
      echo "${R}Unable to update .vimrc file." 
      if [[ flgPathExists ]] ; then
        mv ${HOME}/.vimrc.bkup/.vimrc.${curDate}.bkup ${HOME}/.vimrc
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
  if [[ -d ${HOME}/.vim ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ${HOME}/.vim.bkup
    #move old .vim dir to backup
    mv ${HOME}/.vim ${HOME}/.vim.bkup/.vim.${curDate}.bkup
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
    cp -r ${scriptPath}/.vim ${HOME}/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .vim dir${NoColor}"
    else
      echo "${R}Unable to update .vim dir." 
      if [[ flgPathExists ]] ; then
        mv ${HOME}/.vim.bkup/.vim.${curDate}.bkup ${HOME}/.vim
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
  if [[ -f ${HOME}/.bashrc ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ${HOME}/.bashrc.bkup
    #move old .bashrc file to backup
    mv ${HOME}/.bashrc ${HOME}/.bashrc.bkup/.bashrc.${curDate}.bkup
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
    cp ${scriptPath}/.bashrc ${HOME}/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced .bashrc file${NoColor}"
    else
      echo "${R}Unable to update .bashrc file." 
      if [[ flgPathExists ]] ; then
        mv ${HOME}/.bashrc.bkup/.bashrc.${curDate}.bkup ${HOME}/.bashrc
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


#gpg.conf
if [[ -f $scriptPath/gpg.conf ]] ; then
  echo "${B}Updating gpg.conf file${NoColor}"
  # create .gnugp folder (if it doesn't exist) if gpg has not been run yet.
  mkdir -p ${HOME}/.gnugp
  # if gpg.conf file exists
  if [[ -f ${HOME}/.gnupg/gpg.conf ]]; then
    # Create backup dir if it does not exist.
    mkdir -p ${HOME}/.gnupg/gpg.conf.bkup
    #move old gpg.conf file to backup
    mv ${HOME}/.gnupg/gpg.conf ${HOME}/.gnupg/gpg.conf.bkup/gpg.conf.${curDate}.bkup
    if [[ $? == 0 ]] ; then
      echo "${G}Backed up gpg.conf file${NoColor}" 
    else
      echo "${R}Could not backup gpg.conf file.  File gpg.conf will not be updated${NoColor}"
      flgBkUPSuccess=false
    fi
  else
    flgPathExists=false
  fi
  # copy new gpg.conf file to user home dir.
  if [[ $flgBkUpSuccess ]] ; then
    cp ${scriptPath}/gpg.conf ${HOME}/.gnupg/ 
    if [[ $? == 0 ]] ; then
      echo "${G}Replaced gpg.conf file${NoColor}"
      ./keepGpgCust.zsh "${HOME}/.gnupg/gpg.conf.bkup/gpg.conf.${curDate}.bkup" "${HOME}/.gnupg/gpg.conf"
    else
      echo "${R}Unable to update gpg.conf file." 
      if [[ flgPathExists ]] ; then
        mv ${HOME}/.gnupg/gpg.conf.bkup/gpg.conf.${curDate}.bkup ${HOME}/.gnupg/gpg.conf
        if [[ $? == 0 ]] ; then
          echo "${G} Your original gpg.conf file was placed back at the original location.${NoColor}"
        else
          echo "Your original gpg.conf file could not be put back at the original location.${NoColor}"
        fi
      else
        echo "${B}Original gpg.conf file did not exist.  No changes were made to gpg.conf${NoColor}"
      fi
    fi
  fi
  flgBkUpSuccess=true
  flgPathExists=true
else
  echo "${R}No gpg.conf file in Git folder.  Skipping gpg.conf updates${NoColor}"
fi

