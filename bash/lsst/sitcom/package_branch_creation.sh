#!/usr/bin/env bash
# This script should be executed (not sourced!) from a Nublado terminal.
# It clones (ssh) and creates the branches for each repo

# This script is not ready to be run yet

git clone git@github.com:lsst-ts/ts_observatory_control.git
cd ts_observatory_control
git checkout -b tickets/DM-34581
git commit -m "Initial Branch Creation for 2022-05 AuxTel Support"
git push --set-upstream origin tickets/DM-34581


git clone git@github.com:lsst-ts/ts_observing_utilities.git
cd ts_observing_utilities
git checkout -b tickets/DM-34581
git commit -m "Initial Branch Creation for 2022-05 AuxTel Support"
git push --set-upstream origin tickets/DM-34581