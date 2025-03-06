#!/bin/zsh
############################################################
# install.zsh 
############################################################
# Purpose: Install .zshrc, .bashrc, & .vimrc .tmux.conf 
# gpg.conf sshd_conf and their support files
#
# Author: artfulKraken 
# Version: 0.1.3
# Date: 2025-02-20
#
# Adds or replaces config files and supporting dirs/files
# (listed above).
# Files are saved in folder they reside in as 
# <filename>.bkup/<filename>.<isoDateTime>.bkup
# Dirs are saved in folder they reside in as 
# <dirname>.bkup/<dirname>.<isoDateTime>.bkup 
# shellrc file ie (.bashrc or .zshrc) must be sourced 
# ie cmd: source zsh.rc or shell restarted before use.
#
############################################################

############################################################
# Configuration                                            #
############################################################
# Set script to use standard zsh parameters
emulate -LR zsh

############################################################
# General variables                                        #
############################################################
# Terminal Text colors for user feedback.
# colors for echo options
declare -A C
C[colErr]='\033[0;31m'   #'0;31' is Red's ANSI color code.  Used to notify user of failed operations or inputs.
C[colSuccess]='\033[0;32m'   #'0;32' is Green's ANSI color code.  Used to notify user of successful operations.
C[colQuest]='\033[1;33m'   #'1;32' is Yellow's ANSI color code. Used to denote question to user.
C[colNotice]='\033[0;34m'   #'0;34' is Blue's ANSI color code.  Used to update user on progress and next steps, without confirming success.
C[NC]='\033[0m'  #returns to default color.  Used in any other situations.

############################################################
# Functions                                                #
############################################################

############################################################
# Help function
Help()
{
   # Display Help
   echo "Description of script."
   echo
   echo "Syntax: scriptName [-h]"
   echo "options:"
   echo
   echo "h               Print this Help."
   echo "w               Info Colors used to notify user during script"
   echo "u <userName>    Installs config files for the supplied user. If u option is not provided" \
     ", installs for current user.  <userName> must be supplied with u option. Currently does not " \
     "work with mac."
   echo "p <port>        Specifies port to use for ssh in sshd_config file. Uses standard port 22" \
     "if p option is not used.  <port> must be supplied with u option."
}

############################################################
# Main program                                             #
############################################################

# Confirm script is being run as root (sudo)
if [ "$EUID" -ne 0 ]
  then echo "Please use sudo to run as root"
  exit
fi

# path to this script
scriptPath="${0:a:h}"
# add functions to fpath and autoload functions
fpath=( "${scriptPath}/zFunctions" "${fpath[@]}" )
autoload -Uz sshdUpdate

# RegEx pattern to ensure valid port number 1-65535.  Does not confirm if port already in use.
portRegEx="^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9][0-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9]|[1-9])$"
# Get the options if provided
while getopts "hu:p:w:" option; do
  case $option in
      
    h) # Print to screen help file and exit
      Help
      exit 0
      ;;
    p)
      port=$OPTARG
      while [[ ! ( $port =~ $portRegEx )  ]] ; do
        echo "${C[colErr]}Invalid Port number.  Please enter a valid port (1 - 65535) to use for ssh.${C[NC]}g"
        read port
      done
      port=${port}
      ;;
    w)
      C=$OPTARG
      ;;
    u)
      user=$OPTARG
      # Currently does not work with mac.  exit script if mac and -u option.
      if [[ $OSTYPE =~ 'darwin' ]] ; then
        echo "-u user option is not currently compatable with macOS.  Please login to the user" \
          " account you would like to update and run the script from there."
        exit 2
      fi
      # get non-system users (id > 1000).
      IFS=$'\n' users=$(grep -P -e "^[^:]*:[^:]*:(?!65534)[1-9][0-9]{3}" /etc/passwd | cut -d ":" -f1)

      # check if supplied user is in non-system users
      flgUserFound=false
      # repeat giving interactive shell user the oportunity to change user name to valid response
      while [[ $flgUserFound == false ]] ; do
        # loop through users array to compare user
        for u in $users ;  do
          if [[ $u == $user ]] ; then
            flgUserFound=true
          fi
        done
        if [[ $flgUserFound == false ]] ; then
          echo "${C[colErr]}You must enter a valid username with the -u option.  Please enter a valid user${C[NC]}g"
          read user
        fi
      done
      ;;
    \?) # Invalid option
      echo "${C[colErr]}Error: ${option} is invalid.  Skipping ${option}${C[NC]}g"
      ;;
  esac
done
if [[ -z ${user} ]] ; then
  HM_OWNER=$SUDO_USER
else
  HM_OWNER=$user
fi

# Config Files and Directories to install.  DIRS MUST HAVE / AT END OF NAME TO SIGNIFY DIRECTORY
newConfigs=( ".zshrc" ".asciiArt/" ".zsh-syntax-highlighting/" ".zsh-autosuggestions/" ".bashrc" ".vimrc" ".vim/" ".tmux.conf" "sshd_config" "gpg.conf" )


HM_PATH="/home/${HM_OWNER}"

# save iso datetime to variable for use in backups
 curDate=$(date -u +"%Y-%m-%dT%H:%M:%S%z")

flgBkUpSuccess=true
flgPathExists=true

declare -A confFile

for config in ${newConfigs} ; do
  flgBkUpDir=false

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
    echo "${C[colNotice]}Updating ${confFile[name]} file${C[NC]}g"
    case ${confFile[name]} in
      gpg.conf)
          USERAGENT=$HM_OWNER
          basePath="$HM_PATH/.gnupg"
          sudo -u $USERAGENT mkdir -p "$HM_PATH/.gnupg"
        ;;
      sshd_config)
        USERAGENT=${USER}
        basePath="/etc/ssh"
        ;;
      *)
        USERAGENT=$HM_OWNER
        basePath="$HM_PATH"
        ;;
    esac
    
    # Set variables for file/dir, backup file/dir and backup dir
    confFilePath="${newSshdFile}"
    bkUpConfFilePath="${newSshdFile}.bkup/${confFile[name]}.${curDate}.bkup"
    bkUpConfLoc="${newSshdFile}.bkup"
    
    # if file exists
    if [ -e "${newSshdFile}" ]; then
      # Create backup dir if it does not exist.
      sudo -u ${USERAGENT} mkdir -p "${bkUpConfLoc}"
      if [[ $? == 0 ]] ; then
        flgBkUpDir=true
      fi
      #move old ${confFile[name]} file to backup
      
      sudo -u ${USERAGENT} mv "${newSshdFile}" "${bkUpConfFilePath}"
      
      if [[ $? == 0 ]] ; then
        echo "${C[colSuccess]}Backed up ${confFile[name]} ${confFile[type]}${C[NC]}g" 
      else
        echo "${C[colErr]}Could not backup ${confFile[name]} ${confFile[type]}.  ${confFile[type]} ${confFile[name]} will not be updated${C[NC]}g"
        flgBkUPSuccess=false
      fi
    else
      flgPathExists=false
    fi
    # copy new file to user home dir.
    if [[ $flgBkUpSuccess ]] ; then
      sudo -u ${USERAGENT} cp -R "${scriptPath}/${confFile[name]}" "${basePath}/"
      if [[ $? == 0 ]] ; then
        echo "${C[colSuccess]}Replaced ${confFile[name]} ${confFile[type]}${C[NC]}g"
        
        # Any special modifications per file type
        case ${confFile[name]} in 
          gpg.conf)
            if [[ flgBkUpDir == true ]] ; then     
              ./keepGpgCust.zsh  "${bkUpConfFilePath}" "${newSshdFile}"
            fi
            ;;
          sshd_config)
            sshdUpdate -p $port -n "${newSshdFile}" -c "${bkUpConfFilePath}"
            ;;
          *)
            ;;
        esac  
      else
        echo "${C[colErr]}Unable to update ${confFile[name]} ${confFile[type]}.${C[NC]}" 
        if [[ flgPathExists ]] ; then
          sudo -u ${USERAGENT} mv "${bkUpConfFilePath}"
          if [[ $? == 0 ]] ; then
            echo "${C[colSuccess]} Your original ${confFile[name]} ${confFile[type]} was placed back at the original location.${C[NC]}g"
          else
            echo "Your original ${confFile[name]} ${confFile[type]} could not be put back at the original location.${C[NC]}g"
          fi
        else
          echo "${C[colNotice]}Original ${confFile[name]} ${confFile[type]} did not exist.  No changes were made to ${confFile[name]}${C[NC]}g"
        fi
      fi
    fi
    flgBkUpSuccess=true
    flgPathExists=true
  else
    echo "${C[colErr]}No ${confFile[name]} ${confFile[type]} in Git folder.  Skipping ${confFile[name]} updates${C[NC]}g"
  fi
done
