#!/usr/bin/env bash
# This script should be executed (not sourced!) from a Nublado terminal
# to clone and setup the packages needed to configure the
# Nublado environment to use methods from
# rapid_analysis, such as bestEffortISR
# it's required to run the latiss_align_and_take_sequence
# and the latiss_cwfs_align scripts

# set to exit when any command fails
set -e

# This script is ONLY to be used for the AuxTel run of 2021-06-07
source ${LOADSTACK}

## Verify the proper build cycle is used
LSST_IMAGE='w_2021_26_c0021.000'

printf "This run uses the image of ${LSST_IMAGE}\n"

RVAL=$(echo $JUPYTER_IMAGE_SPEC | cut -d ':'  -f 2)
if [[ $RVAL == *"${LSST_IMAGE}"* ]]; then
  printf "Nublado image is correct\n"
else
  printf "Nublado image is incorrect. You have ${RVAL} but need ${LSST_IMAGE}. Exiting\n"
  exit 1
fi

# Verify the proper jupyter build is being used
REQUIRED_BUILD='lsst-scipipe-0.6.0'
if [ ${LSST_CONDA_ENV_NAME} == ${REQUIRED_BUILD} ]; then
  printf "Conda environment is Correct\n"
else
  printf "Conda environment is incorrect. You have ${LSST_CONDA_ENV_NAME} but need ${REQUIRED_BUILD}."
  printf "Are you running the right container? \n"
  exit 1
fi

# If running from Nublado instance than only use the following
setup lsst_distrib

## Verify the proper lsst_distrib is loaded
LSST_DISTRIB_VER='w_2021_26'

RVAL=$(eups list lsst_distrib)
if [[ $RVAL == *"${LSST_DISTRIB_VER}"* ]]; then
  printf "Nublado weekly is correct\n"
else
  printf "Nublado weekly is incorrect. You have ${RVAL} but need ${LSST_DISTRIB_VER}. Exiting\n"
  exit 1
fi

# The packages will be cloned and installed in the following folder
# It is strongly recommended NOT to modify this
REPOS=$HOME"/auto-op-env-packages/"

# Check if the directory exists
if [ -d $REPOS ]; then
  printf "Directory "$REPOS" exists. Remove directory and contents and re-run.\n"
  exit 1
fi
# Start cloning and setting up packages
echo 'Repositories will cloned and setup in the directory:'$REPOS"\n"
mkdir -v ${REPOS}

# Check if folders are already present before installing
printf 'Setting up lsst-dm/Spectractor \n'
cd $REPOS
git clone https://github.com/lsst-dm/Spectractor.git
cd Spectractor
git checkout tickets/DM-29598
git reset origin/tickets/DM-29598 --hard
git pull
pip install -r requirements.txt
pip install -e .

#printf '\nSetting up lsst-dm/obs_base \n'
#cd $REPOS
#git clone https://github.com/lsst/obs_base.git
#cd obs_base
#setup -j -r .
#git fetch --all
#git checkout tickets/DM-26719
#git reset origin/tickets/DM-26719 --hard
#git pull
#scons opt=3 -j 4

printf '\nSetting up lsst-dm/obs_lsst \n'
cd $REPOS
git clone https://github.com/lsst/obs_lsst.git
cd obs_lsst
setup -j -r .
git fetch --all
git checkout tickets/DM-30932
git reset origin/tickets/DM-30932 --hard
git pull
scons opt=3 -j 4

printf '\nSetting up lsst-dm/atmospec \n'
cd $REPOS
git clone https://github.com/lsst-dm/atmospec.git
cd atmospec
setup -j -r .
git fetch --all
#git checkout tickets/DM-26719
git reset origin/master --hard
git pull
scons opt=3 -j 4

printf '\nSetting up lsst-sitcom/rapid_analysis \n'
cd $REPOS
git clone https://github.com/lsst-sitcom/rapid_analysis.git
cd rapid_analysis
setup -j -r .
scons opt=3 -j 4
git fetch --all
git checkout tickets/DM-30925
git reset origin/tickets/DM-30925 --hard
git pull

printf '\nSetting up bxin/cwfs \n'
cd $REPOS
git clone https://github.com/bxin/cwfs.git
cd cwfs
git fetch --all
setup -j -r .
scons

printf '\nSetting up lsst-ts/ts_observatory_control \n'
cd $REPOS
git clone https://github.com/lsst-ts/ts_observatory_control.git
cd ts_observatory_control
git fetch --all
git checkout tickets/DM-31307
git reset origin/tickets/DM-31307 --hard
git pull
setup -j -r .

printf '\nSetting up lsst-ts/ts_externalscripts \n'
cd $REPOS
git clone https://github.com/lsst-ts/ts_externalscripts.git
cd ts_externalscripts
git fetch --all
git checkout develop
git reset origin/develop --hard
git pull
setup -j -r .

printf '\nSetting up lsst-ts/ts_observing_utilities \n'
cd $REPOS
git clone https://github.com/lsst-ts/ts_observing_utilities.git
cd ts_observing_utilities
git fetch --all
git checkout develop
git reset origin/develop --hard
git pull
setup -j -r .

printf '\nSetting up lsst-ts/ts_standardscripts \n'
cd $REPOS
git clone https://github.com/lsst-ts/ts_standardscripts.git
cd ts_standardscripts
git fetch --all
git checkout develop
git reset origin/develop --hard
git pull
setup -j -r .

# Cloning completed

# Create file that will be *sourced* at the beginning of .user_setups
# This file contains all the packages that require an eups setup
FILE_PATH=$REPOS"auto_env_setup.sh"
if [ -d $FILE_PATH ]; then
  printf "auto_env_setup.sh file already exists in "$REPOS". Removing. \n"
  rm -f $FILE_PATH
fi

printf "Creating a new auto_env_setup.sh in: ${REPOS} \n"

cat <<EOT >> $FILE_PATH
#!/usr/bin/env bash
# This file is auto generated by the package_setup_obsrun scripts.
# It is sourced by the ~/notebooks/.user_setups file
# Do not modify!

EOT

printf "setup -j rapid_analysis -r "$REPOS"rapid_analysis \n" >> $FILE_PATH
printf "setup -j obs_lsst -r "$REPOS"obs_lsst \n" >> $FILE_PATH
#printf "setup -j obs_base -r "$REPOS"obs_base \n" >> $FILE_PATH
printf "setup -j atmospec -r "$REPOS"atmospec \n" >> $FILE_PATH
printf "setup -j ts_externalscripts -r "$REPOS"ts_externalscripts \n" >> $FILE_PATH
printf "setup -j ts_standardscripts -r "$REPOS"ts_standardscripts \n" >> $FILE_PATH
printf "setup -j ts_observatory_control -r "$REPOS"ts_observatory_control \n" >> $FILE_PATH
printf "setup -j ts_observing_utilities -r "$REPOS"ts_observing_utilities \n" >> $FILE_PATH
printf "setup -j cwfs -r "$REPOS"cwfs \n" >> $FILE_PATH


#check that ~/notebooks/.user_setups exists
USER_SETUP_PATH=$HOME"/notebooks/.user_setups"
if [ -a $USER_SETUP_PATH ] && [ -w $USER_SETUP_PATH ]; then
  # grab line3 of .user_setups for comparison
  LINE3_OF_EXISTING_FILE=$(sed '3 p' $USER_SETUP_PATH)
  # declare what we need it to say
  LINE3="source ${FILE_PATH}"
  # Check if content is already in .user_setups
  # FIXME - WHY AREN'T THESE EXACT? WHITESPACE? Wildcards should not be necessary
  if [[ $LINE3_OF_EXISTING_FILE != *"${LINE3}"* ]]; then
    printf "Adding source command to auto_env_setup.sh at the top of your ~/notebooks/.user_setups file \n"
    sed -i "1i$LINE3 \n" $USER_SETUP_PATH
    sed -i "1i# The first three lines of this file are added automatically by package_setup_obsrun script in $REPOS \n# DO NOT MODIFY OR MOVE" $USER_SETUP_PATH
  else
    printf "Source command already at the top of your ~/notebooks/.user_setups file. Skipping.\n"
  fi
else
  printf "No writable .user_setups found in ${USER_SETUP_PATH} \n"
  printf "Are you sure you're running this on a Nublado instance? \n"
  printf "Make sure file exists then re-run this script \n"
  exit 1
fi


printf "\nPackage setup script completed successfully\n"
printf "####################################################################################\n"
printf "WARNING: RESTART ALL NOTEBOOK KERNELS \n"
printf "WARNING: Verify no packages are being overwritten (setup) in your .user_setups file. \n"
printf "WARNING: Verify your ospl daemon is running. \n"
printf "#################################################################################### \n"
