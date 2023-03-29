#!/usr/bin/env bash
# This script should be executed (not sourced!) from bare metal machine
# only authorized users can run this
# run as:
# sudo -u obsenv bash /net/obs-env/repos/auxtel_obsruns_env_setups/bash/lsst/sitcom/2023/env_versioning_setup-obsrun-2023-04A.sh 
# after running the package clone and setup script.
# This script assigns the tag for each package

# set to exit when any command fails
set -e

# The packages to be modified are installed in the following folder
# It is strongly recommended NOT to modify this
REPOS="/net/obs-env/auto_base_packages/"

# Declare the weekly as it's used often and is just convenient
weekly_tag="tags/w.2023.09"

printf '\nSetting up lsst-dm/atmospec \n'
checkout_path="main"
cd $REPOS
cd atmospec
git fetch --all
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

printf '\nSetting up lsst-sitcom/summit_utils \n'
checkout_path=$weekly_tag
cd $REPOS
cd summit_utils
git fetch --all
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

printf '\nSetting up lsst-sitcom/summit_extras \n'
checkout_path=$weekly_tag
cd $REPOS
cd summit_extras
git fetch --all
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

printf '\nSetting up lsst-ts/cwfs \n'
checkout_path="master"
cd $REPOS
cd cwfs
git fetch --all
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

printf '\nSetting up lsst-ts/ts_wep \n'
checkout_path="tags/v6.0.1"
cd $REPOS
cd ts_wep
git fetch --all
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

printf '\nSetting up lsst-ts/ts_observatory_control \n'
checkout_path="tags/v0.24.3"
cd $REPOS
cd ts_observatory_control
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

printf '\nSetting up lsst-ts/ts_externalscripts \n'
checkout_path="tickets/DM-38260"
cd $REPOS
cd ts_externalscripts
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

printf '\nSetting up lsst-ts/ts_observing_utilities \n'
checkout_path="develop"
cd $REPOS
cd ts_observing_utilities
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

printf '\nSetting up lsst-ts/ts_standardscripts \n'
checkout_path="develop"
cd $REPOS
cd ts_standardscripts
git checkout $checkout_path
# only hard reset and pull if not using a tag
if [[ $checkout_path != *"tags"* ]]; then
git reset origin/$checkout_path --hard
git pull
fi

# Cloning completed
printf '\nPackage branch/tag checkout completed successfully\n'
