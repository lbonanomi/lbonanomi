#!/bin/sh -l


REPO_COUNT=$(curl -s https://api.github.com/users/$1/repos | jq .[].full_name | wc -l)
echo "Hello $1, you have $REPO_COUNT repos under your name"
time=$(date)
echo "::set-output name=time::$time"


