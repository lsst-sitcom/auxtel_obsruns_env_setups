#!/usr/bin/env bash
# This script should be executed (not sourced!) from a Nublado terminal.
# It clones (ssh) and creates the branches for each repo

# This script is not ready to be run yet

# Ticket associated with this run
TICKET='DM-34844'
# Commit message to open the branch
MESSAGE="Initial Branch Creation for 2022-05B AuxTel Support. Empty commit with no content changed"


PACKAGES=('lsst-ts/ts_observatory_control' 'lsst-ts/ts_observing_utilities' 'lsst-ts/ts_standardscripts' 'lsst-ts/ts_externalscripts' 'lsst-ts/cwfs' 'lsst/atmospec')
 
# directory where repos are to be created
REPOS="/tmp/setup_branches/"

# Check if the directory exists
if [ -d $REPOS ]; then
  printf "Directory "$REPOS" exists. Remove directory and contents and re-run.\n"
  exit 1
fi
# Start cloning and setting up packages
printf 'Repositories will cloned and setup in the directory:'$REPOS"\n"
mkdir -v ${REPOS}

for pkg in "${PACKAGES[@]}"
do
 printf "Preparing $pkg branch \n"
  cd $REPOS
  git clone git@github.com:$pkg.git
  pkg_name=$(echo $pkg | cut -d "/" -f2)
  printf "pkg_name is $pkg_name \n"
  cd $REPOS/$pkg_name
  git fetch --all
  if git show-ref tickets/$TICKET ; then
    printf "tickets/$TICKET branch exists. Moving to next package \n"
    continue
  fi
  git checkout -b tickets/${TICKET}
  git commit -m "$MESSAGE" --allow-empty
  git push --set-upstream origin tickets/$TICKET
  echo "$pkg branch preparation completed \n"
done






# cd ~/develop
# git clone git@github.com:lsst-ts/ts_observing_utilities.git
# cd ts_observing_utilities
# git checkout -b tickets/DM-34581
# git commit -m "Initial Branch Creation for 2022-05 AuxTel Support"
# git push --set-upstream origin tickets/DM-34581

# cd ~/develop
# git clone git@github.com:lsst-ts/ts_standardscripts.git
# cd ts_standardscripts
# git checkout -b tickets/DM-34581
# git commit -m "Initial Branch Creation for 2022-05 AuxTel Support"
# git push --set-upstream origin tickets/DM-34581

# cd ~/develop
# git clone git@github.com:lsst-ts/ts_externalscripts.git
# cd ts_externalscripts
# git checkout -b tickets/DM-34581
# git commit -m "Initial Branch Creation for 2022-05 AuxTel Support"
# git push --set-upstream origin tickets/DM-34581