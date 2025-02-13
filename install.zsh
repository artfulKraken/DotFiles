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
# Functions                                                #
############################################################
############################################################


############################################################
# any specific functions needed                            #
############################################################
Help()
{
   # Display Help
   echo "Description of script."
   echo
   echo "Syntax: scriptName [-h]"
   echo "options:"
   echo
   echo "h               Print this Help."
   echo "u <userName>    Installs config files for the supplied user. If u option is not provided" \
     ", installs for current user.  <userName> must be supplied with u option." \

   echo "p <port>        Specifies port to use for ssh in sshd_config file. Uses standard port 22" \
     "if p option is not used.  <port> must be supplied with u option."
     

}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Confirm script is being run as root (sudo)
if [ "$EUID" -ne 0 ]
  then echo "Please use sudo to run as root"
  exit
fi

# RegEx pattern to ensure valid port number 1-65535.  Does not confirm if port already in use.
portRegEx="^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9][0-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9]|[1-9])$"
# Get the options if provided
while getopts "hu:p:" option; do
  case $option in
      
    h) # Print to screen help file and exit
        Help
        exit 0
        ;;
    p)
      port=$OPTARG
      while [[ ! ( $port =~ $portRegEx )  ]] ; do
        echo "${R}Invalid Port number.  Please enter a valid port (1 - 65535) to use for ssh.${NoColor}"
        read port
      done
      port="Port ${port}"
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
      IFS=$'\n' users=($(grep -P -e '^[^:]*:[^:]*:(?!65534)[1-9][0-9]{3}' /etc/passwd | cut -d ":" -f1)) 

      # check if supplied user is in non-system users
      flgUserFound=false
      # repeat giving interactive shell user the oportunity to change user name to valid response
      while [[ $flgUserFound == false ]] ; do
        echo "entered while"
        # loop through users array to compare user
        for u in $users ;  do
          if [[ $u == $user ]] ; then
            flgUserFound=true
          fi
        done
        if [[ $flgUserFound == false ]] ; then
          echo "{R}You must enter a valid username with the -u option.  Please enter a valid user${NoColor}"
          read user
        fi
      done
      ;;
    \?) # Invalid option
      echo "${R}Error: ${option} is invalid.  Skipping ${option}${NoColor}"
      ;;
    esac
done

if [[ -z ${user} ]]
  HM_OWNER=$SUDO_USER
else
  HM_OWNER=$user
fi

echo "User: ${user}\nPort: ${port}\nSudo User: $SUDO_USER"
exit 0

# Config Files and Directories to install.  DIRS MUST HAVE / AT END OF NAME TO SIGNIFY DIRECTORY
newConfigs=( ".zshrc" ".asciiArt/" ".zsh-syntax-highlighting/" ".zsh-autosuggestions/" ".bashrc" ".vimrc" ".vim/" "sshd_config" "gpg.conf" )


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
      sshd_config)
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
        
        # Any special modifications per file tyoe
        case ${confFile[name]} in 
          gpg.conf)     
            ./keepGpgCust.zsh "${basePath}/${confFile[name]}.bkup/${confFile[name]}.${curDate}.bkup" "${basePath}/${confFile[name]}"
            ;;
          sshd_config)
            # Update sshd_config port #.  Check if old file had modified port, check if user supplied port.
            # Ask user how to handle based on situation.  

            # confirm if backup file
            if [[ -z ${basePath}/${confFile[name]}.bkup/${confFile[name]}.${curDate}.bkup ]] ; then
              oldPort=  
            else
              # Get old port info
              
              oldPorts=()
              
              while IFS=$'\\' read -r line; do
                oldPorts+=("$line")
              done < <( grep -e "^ *Port " ${basePath}/${confFile[name]}.bkup/${confFile[name]}.${curDate}.bkup )
              if [[ ${#oldPorts[@]} > 1 ]] ; then
                echo "${B}There was more than 1 port entry in your old sshd_config file. Extra Port entries will not be included in the new file${NoColor}"
              fi
              oldPort=${oldPorts[-1]}
            fi
            # Conditions to address
            if [[ -z $port ]] ; then
              # No new port supplied
              if [[ -z $oldPort ]]
                # No port in old sshd_config file
                # no new port, no old port - tell user standard port
                echo "Default Port 22 used for ssh server"
              else
                # Port specified in old sshd_file
                # no new port specified, old port exists - ask if keep old port
                echo "${Y}Your current ssh configuration uses ${oldPort}.  Would you like to keep that port? (y/n)${NoColor}"
                read response
                while [[ ! ($response =~ [YyNn] ) ]] ; do
                  echo "${R}Invalid response.  Would you like to continue using ${oldPort}? (y/n)${NoColor}"
                  read response
                done
                if [[ $Response =~ [Yy] ]] ; then
                  # Replace Port with old port
                  sed -r -i "s|^#Port 22$|${oldPort}|" ${basePath}/${confFile[name]}
                  echo "${G}sshd_config updated to ${oldPort}${NoColor}"
                else
                  echo "${G}Default Port 22 used in sshd_config file${NoColor}"
                fi
              fi
            else
              # New port specified
              if [[ -z $oldPort ]] ; then
                # No old port
                # new port specified, no old port - update and notify
                sed -r -i "s|^#Port 22$|${port}|" ${basePath}/${confFile[name]}
                echo "${G}sshd_config updated to ${oldPort}${NoColor}"
              else
                # Old port specified
                # new port specified, old port exists,  confirm with user if they want to use new or old port.   
                if [[ $port == $oldPort ]]; then
                  # new port and old port are the same.  Update sshd_config
                  sed -r -i "s|^#Port 22$|${oldPort}|" ${basePath}/${confFile[name]}
                  echo "${G}sshd_config updated to ${oldPort}${NoColor}"
                else
                  echo "${Y}You are currently using ${oldPort} and requested to update to ${port}.\n" \
                    "Confirm which port you want to use by entering the number of your choice:\n" \
                    "  1.    Use ${port} \n" \
                    "  2.    Use ${oldPort} \n" \
                    "  3.    Use default Port 22${NoColor}"
                  read response
                  while [[ ! ( $response =~ ^[1-3]$ ) ]] ; do 
                    echo "${R}Invalid choice. Please enter a valid choice 1 - 3.${NoColor}"
                    read response
                  done
                  if [[ $response == 1 ]] ; then
                    # Use New port in sshd_config
                    sed -r -i "s|^#Port 22$|${port}|" ${basePath}/${confFile[name]}
                    echo "sshd_config was updated to ${port}"
                  elif [[ $response == 2]]; then
                    # Use old  port in sshd_config
                    sed -r -i "s|^#Port 22$|${oldPort}|" ${basePath}/${confFile[name]}
                    echo "sshd_config was updated to ${oldPort}"
                  else
                    echo "sshd_config is using default Port 22"
                  fi
                fi
              fi
            fi  
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
