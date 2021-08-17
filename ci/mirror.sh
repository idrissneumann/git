#!/bin/bash

REPO_PATH="/home/centos/training_git/"

cd "${REPO_PATH}" && git pull origin main || :
git push github main 
git pusg pgitlab main
exit 0
