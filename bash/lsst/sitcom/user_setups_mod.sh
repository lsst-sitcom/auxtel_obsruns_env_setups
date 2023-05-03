#!/usr/bin/env bash
# This script should be executed (not sourced) from a users Nublado account
# it modified their ~/notebooks/.user_setups file to setup the NFS mounted environment

## set to exit when any command fails
#set -e

## Declare repos of interest
## where packages are held on Nublado
##REPOS="/opt/obs_env/auto_base_packages/"
## where file with setup statements are held
#FILE_PATH=$REPOS"auto_env_setup.sh"
#
##check that ~/notebooks/.user_setups exists
#USER_SETUP_PATH=$HOME"/notebooks/.user_setups"
#if [ -a $USER_SETUP_PATH ] && [ -w $USER_SETUP_PATH ]; then
#  # grab line3 of .user_setups for comparison
#  LINE3_OF_EXISTING_FILE=$(sed '3 p' $USER_SETUP_PATH)
#  # declare what we need it to say
#  LINE3="source ${FILE_PATH}"
#  # Check if content is already in .user_setups
#  # FIXME - WHY AREN'T THESE EXACT? WHITESPACE? Wildcards should not be necessary
#  if [[ $LINE3_OF_EXISTING_FILE != *"${LINE3}"* ]]; then
#    printf "Adding source command to auto_env_setup.sh at the top of your ~/notebooks/.user_setups file \n"
#    sed -i "1i$LINE3 \n" $USER_SETUP_PATH
#    sed -i "1i# The first three lines of this file are added automatically by package_setup_obsrun script in $REPOS \n# DO NOT MODIFY OR MOVE" $USER_SETUP_PATH
#  else
#    printf "Source command already at the top of your ~/notebooks/.user_setups file. Skipping.\n"
#  fi
#else
#  printf "No writable .user_setups found in ${USER_SETUP_PATH} \n"
#  printf "Are you sure you're running this on a Nublado instance? \n"
#  printf "Make sure file exists then re-run this script \n"
#  exit 1
#fi
#
#printf "\n ~/notebooks/.user_setup script script completed successfully\n"
#printf "#######################################################################\n"
#printf "WARNING: Ensure no other packages are setup in the .user_setup file \n"
#printf "WARNING: Verify your ospl daemon is running. \n"
#printf "WARNING: RESTART ALL NOTEBOOK KERNELS \n"
#printf "####################################################################### \n"


# # We could also just move their file and replace it with one that we know will work
datestamp=$(date +"%Y-%m-%dT%I:%M:%S")
saved_file_path=$HOME"/notebooks/user_setups-"$datestamp".bak"

# Create the new .user_setups file
# This file contains all the packages that require an eups setup
FILE_PATH=$HOME"/notebooks/.user_setups"
if test -f "$FILE_PATH"; then
  printf "Moving .user_setups file to $saved_file_path \n"
  mv ~/notebooks/.user_setups $saved_file_path
fi

printf "Creating a new ~/notebooks/.user_setups file \n"

# Declare repos of interest
# where packages are held on Nublado
REPOS="/opt/obs_env/auto_base_packages/"
# where file with setup statements are held
REPOS_FILE_PATH=$REPOS"auto_env_setup.sh"

cat <<EOT >> $FILE_PATH
#!/usr/bin/sh bash
# This file is auto generated by the /opt/obs-user/repos/auxtel_obsruns_env_setups/bash/lsst/sitcom/user_setups_mod script. The first three lines are added automatically and source the shared common environment needed to use Notebooks during an observing run. DO NOT overwrite, modify, or move. 
source ${REPOS_FILE_PATH}

# The following three lines are required to use a DDS daemon within a notebook.
export OSPL_HOME=/scratch/opt/OpenSpliceDDS/V6.10.4/HDE/x86_64.linux/
source $OSPL_HOME/release.com
export OSPL_URI=$(python -c "from lsst.ts import ddsconfig; print( (ddsconfig.get_config_dir() / 'ospl-shmem.xml').as_uri())")
 
#  This file is expected to be found in ${HOME}/notebooks/.user_setups
#  It is a shell fragment that will be sourced during kernel startup 
#  when the LSST kernel is started in a JupyterLab environment.  It runs
#  in the user context and can contain arbitrary shell code.  Exported changes
#  in its environment will persist into the JupyterLab Python environment.

EOT

printf '\n New .user_setup file created \n'


