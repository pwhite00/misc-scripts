#!/usr/bin/env bash
#
# - used in a forked repo to reset local master to current upstream master
#
#
#
############################################################################

echo "Restting local master to upstream/master and setting you up to push that too your origin/master"
git fetch upstream master
git checkout master
git reset --hard upstream/master
git status
git log

echo "If status is clear then you can  run the following command to push updated master to origin"
echo "If this is NOT clean DO NOT push the changes"
echo "git push origin --force"
