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
# Version: 0.1.2
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
if [ "$EUID" -ne 0 ]
  then echo "Please use sudo to run as root"
  exit
fi
# Config Files and Directories to install.  DIRS MUST HAVE / AT END OF NAME TO SIGNIFY DIRECTORY
newConfigs=( ".zshrc" ".asciiArt/" ".zsh-syntax-highlighting/" ".zsh-autosuggestions/" ".bashrc" ".vimrc" ".vim/" "sshd_config" "gpg.conf" )

# check if mac or linux os
if [[ $OSTYPE =~ "darwin" ]] ; then
  echo "Remember to check if mac properly uses \$SUDU_USER. if so, simplify without if statement"
  HM_OWNER=$SUDO_USER
else
  HM_OWNER=$SUDO_USER
fi

HM_PATH="/home/${HM_OWNER}"
echo ${HM_PATH}
echo "Home Owner: ${HM_OWNER}"
echo "Root User: ${USER}"

scriptPath=${0:a:h}
echo "script path ${scriptPath}"
# save iso datetime to variable for use in backups
 curDate=$(date -u +"%Y-%m-%dT%H:%M:%S%z")

flgBkUpSuccess=true
flgPathExists=true

declare -A confFile

for config in ${newConfigs} ; do
  if [[ ${config:(-1)} == "/" ]] ; then
    confFile[name]=${config:0:-1}
    confFile[type]="dir"
    confFile[flgType]="-d"
  else
    confFile[name]=${config}
    confFile[type]="file"
    confFile[flgType]="-f"
  fi

  if [ -e "$scriptPath/${confFile[name]}" ] ; then
    echo "${B}Updating ${confFile[name]} file${NoColor}"
    case ${confFile[name]} in
      gpg.conf)
          USERAGENT=$HM_OWNER
          basePath=$HM_PATH/.gnupg
          sudo -u $USERAGENT mkdir -p $HM_PATH/.gnupg
        ;;
      sshd_conf)
        USERAGENT=${USER}
        basePath="/etc/ssh"
        ;;
      *)
        USERAGENT=$HM_OWNER
        basePath=$HM_PATH
        ;;
    esac
    # if file exists
    echo "File: ${confFile[name]}"
    echo "File Owner: ${USERAGENT}"
    echo "Base Path: ${basePath}"
    if [ -e "${basePath}/${confFile[name]}" ]; then
      # Create backup dir if it does not exist.
      sudo -u ${USERAGENT} mkdir -p ${basePath}/${confFile[name]}.bkup
      #move old ${confFile[name]} file to backup
      
      sudo -u ${USERAGENT} mv ${basePath}/${confFile[name]} ${basePath}/${confFile[name]}.bkup/${confFile[name]}.${curDate}.bkup
      
      if [[ $? == 0 ]] ; then
        echo "${G}Backed up ${confFile[name]} ${confFile[type]}${NoColor}" 
      else
        echo "${R}Could not backup ${confFile[name]} ${confFile[type]}.  ${confFile[type]} ${confFile[name]} will not be updated${NoColor}"
        flgBkUPSuccess=false
      fi
    else
      flgPathExists=false
    fi
    # copy new file to user home dir.
    if [[ $flgBkUpSuccess ]] ; then
      sudo -u ${USERAGENT} cp -R ${scriptPath}/${confFile[name]} ${basePath}/ 
      if [[ $? == 0 ]] ; then
        echo "${G}Replaced ${confFile[name]} ${confFile[type]}${NoColor}"
        
        case ${confFile[name]} in 
          gpg.conf)     
            ./keepGpgCust.zsh "${basePath}/${confFile[name]}.bkup/${confFile[name]}.${curDate}.bkup" "${basePath}/${confFile[name]}"
            ;;
          *)
            ;;
        esac  
      else
        echo "${R}Unable to update ${confFile[name]} ${confFile[type]}." 
        if [[ flgPathExists ]] ; then
          sudo -u ${USERAGENT} mv ${basePath}/${confFile[name]}.bkup/${confFile[name]}.${curDate}.bkup ${basePath}/${confFile[name]}
          if [[ $? == 0 ]] ; then
            echo "${G} Your original ${confFile[name]} ${confFile[type]} was placed back at the original location.${NoColor}"
          else
            echo "Your original ${confFile[name]} ${confFile[type]} could not be put back at the original location.${NoColor}"
          fi
        else
          echo "${B}Original ${confFile[name]} ${confFile[type]} did not exist.  No changes were made to ${confFile[name]}${NoColor}"
        fi
      fi
    fi
    flgBkUpSuccess=true
    flgPathExists=true
  else
    echo "${R}No ${confFile[name]} ${confFile[type]} in Git folder.  Skipping ${confFile[name]} updates${NoColor}"
  fi
done
