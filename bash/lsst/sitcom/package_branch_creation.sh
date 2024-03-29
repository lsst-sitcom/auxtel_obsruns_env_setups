#!/usr/bin/env bash
# This script clones (ssh) and creates the branches for each repo

# Ticket associated with this run
TICKET='DM-38260'
# Commit message to open the branch
MESSAGE="Initial Branch Creation for 2023-03B AuxTel Support. Empty commit with no content changes."

PACKAGES=('lsst-ts/ts_observatory_control' 'lsst-ts/ts_observing_utilities' 'lsst-ts/ts_standardscripts' 'lsst-ts/ts_externalscripts' 'lsst-ts/cwfs' 'lsst/atmospec' 'lsst-sitcom/summit_utils' 'lsst-sitcom/summit_extras')
 
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

### Just keep this for safe keeping as it is what the above was meant to replicate
# cd ~/develop
# git clone git@github.com:lsst-ts/ts_observing_utilities.git
# cd ts_observing_utilities
# git checkout -b tickets/DM-34581
# git commit -m "Initial Branch Creation for 2022-05 AuxTel Support"
# git push --set-upstream origin tickets/DM-34581
