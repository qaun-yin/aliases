#!/bin/bash

# TMUX install script

cd || exit 1
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf .tmux.conf
cp .tmux/.tmux.conf.local .