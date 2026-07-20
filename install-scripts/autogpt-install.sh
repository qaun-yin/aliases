#!/bin/bash

# ----------------------- #
# AutoGPT Install & Setup #
# ----------------------- #

## First update your system

sudo apt update
sudo apt upgrade -y

## Next create a new conda env (replace 'autogpt_env' with your desired env name)

ENV_NAME="${1:-autogpt_env}"
conda create --name "$ENV_NAME" python=3.10
conda activate "$ENV_NAME"

## Clone the autogpt repo

git clone https://github.com/Significant-Gravitas/Auto-GPT.git
cd Auto-GPT || exit 1

## Install requirements 

pip install -r requirements.txt
#pip3 install -r requirements.txt

## Create your .env file (used to store your API keys)

cp .env.template .env
echo "Please edit .env file to add your API keys and environment variables"
echo "Run: nano .env"

## Run program (uncomment after configuring .env)

# python -m autogpt
# Or use: python scripts/main.py

