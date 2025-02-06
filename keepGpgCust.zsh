#!/bin/zsh
#
#
# Script expects two arguements.  $1 is the current gpg.conf file path
# and $2 is the new gpg.conf file path
#

curGpgConf=$1
newGpgConf=$2

function saveDefaultKey {
  curGpgConf=$1
  newGpgConf=$2
  defaultKey=()
  #Default Key
  while IFS=$'\\' read -r line; do
    defaultKey+=("$line")
  done < <(grep  "default-key" $curGpgConf) 
  sed -r -i "s| *#* *default-key .*|${(j:\n:)defaultKey}|g" $newGpgConf 
}

function saveTrustedKey {
  curGpgConf=$1
  newGpgConf=$2
  trustedKey=()
  #Default Key
  while IFS=$'\\' read -r line; do
    trustedKey+=("$line")
  done < <(grep  "trusted-key" $curGpgConf)
  sed -r -i "s| *#* *trusted-key .*|${(j:\n:)trustedKey}|g" $newGpgConf 
}


function saveGroups {
  curGpgConf=$1
  newGpgConf=$2
  groups=()
  while IFS=$'\\' read -r line; do
    groups+=("$line")
  done < <(grep -E ' *#* *group .+ *=' $curGpgConf)
  sed -r -i "s| *#* *group .+ *=.*|${(j:\n:)groups}|g" $newGpgConf 
}


function saveKeyServers {
  curGpgConf=$1
  newGpgConf=$2
  curKeyServers=()
  newKeyServers=()
  newKeyServersLN=()

  #get current active key servers (not commented out)
  while IFS=$'\\' read -r line; do
    curKeyServers+=("$line")
  done < <(grep -E '^ *keyserver' $curGpgConf)
  #get new key servers (all)
  while IFS=$'\\' read -r line; do
    IFS=: read -r first rest <<< "$line"
    newKeyServers+=("$rest")
    newKeyServersLN+=("$first")
  done < <(grep -n -E ' *#* *keyserver' $newGpgConf)
  
  if [[ ${#curKeyServers[@]} -gt 0 ]] ; then
    for curKeyServer in ${curKeyServers[@]} ; do
      flgKeyInNew=false
      for newKeyServer in ${newKeyServers[@]} ; do
        if [[ $newKeyServer =~ $curKeyServer ]] ; then
          sed -r -i "s|$newKeyServer|$curKeyServer|g" $newGpgConf 
          flgKeyInNew=true
        fi
      done
      if [[ $flgKeyInNew == false ]] ; then
        response="g"
        while [[ ! ( $response =~ ^[yYNn]$ ) ]] ; do 
          echo "${curKeyServer} is not included in the new key servers list. " \
            "Would you like to continue using it? (Y/N)"
          read response
          if [[ ! ( $response =~ ^[YyNn]$ ) ]] ; then
            echo "Invalid response."
          fi
        done
        if [[ $response =~ ^[Yy]$ ]] ; then
          # Add cur keyserver to new file
          sed -i "${newKeyServersLN[1]}i ${curKeyServer}" $newGpgConf
          #
        fi
      fi
    done
  fi
}


highChoice=15
choice=16

while [[ $choice -gt $highChoice ]] ; do
  echo "Would you like to keep any of the below gpg.conf settings from your existing gpg.conf file?\n" \
    "Enter the sum of the option #'s to select them.\n" \
    "  0.   None\n" \
    "  1.   Default Key\n" \
    "  2.   Trusted Key\n" \
    "  4.   Key Groups\n" \
    "  8.   Key Servers\n" \
    "  15.  All" 
  read choice
  if [[ $choice -gt $highChoice ]] ; then
    echo "Invalid Choice.  Please enter a valid choice."
  fi
done

case $choice in
  1)
    saveDefaultKey $curGpgConf $newGpgConf 
    ;;
  2)
    saveTrustedKey $curGpgConf $newGpgConf 
    ;;
  3)
    saveDefaultKey $curGpgConf $newGpgConf 
    saveTrustedKey $curGpgConf $newGpgConf 
    ;;
  4)
    saveGroups $curGpgConf $newGpgConf 
    ;;
  5)
    saveDefaultKey $curGpgConf $newGpgConf 
    saveGroups $curGpgConf $newGpgConf 
    ;;
  6)
    saveGroups $curGpgConf $newGpgConf 
    saveTrustedKey $curGpgConf $newGpgConf 
    ;;
  7)
    saveDefaultKey $curGpgConf $newGpgConf 
    saveGroups $curGpgConf $newGpgConf 
    saveTrustedKey $curGpgConf $newGpgConf 
    ;;  
  8)
    saveKeyServers $curGpgConf $newGpgConf
    ;;
  9)
    saveKeyServers $curGpgConf $newGpgConf
    saveDefaultKey $curGpgConf $newGpgConf 
    ;;
  10)
    saveKeyServers $curGpgConf $newGpgConf
    saveTrustedKey $curGpgConf $newGpgConf 
    ;;
  11)
    saveKeyServers $curGpgConf $newGpgConf
    saveDefaultKey $curGpgConf $newGpgConf 
    saveTrustedKey $curGpgConf $newGpgConf 
    ;;
  12)
    saveKeyServers $curGpgConf $newGpgConf
    saveGroups $curGpgConf $newGpgConf 
    ;;
  13)
    saveKeyServers $curGpgConf $newGpgConf
    saveDefaultKey $curGpgConf $newGpgConf 
    saveGroups $curGpgConf $newGpgConf 
    ;;

  14)
    saveKeyServers $curGpgConf $newGpgConf
    saveTrustedKey $curGpgConf $newGpgConf 
    saveGroups $curGpgConf $newGpgConf 
    ;;
  15)
    saveKeyServers $curGpgConf $newGpgConf
    saveDefaultKey $curGpgConf $newGpgConf 
    saveGroups $curGpgConf $newGpgConf 
    saveTrustedKey $curGpgConf $newGpgConf 
    ;;

  *)
    ;;
esac
