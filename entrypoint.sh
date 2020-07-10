#!/bin/sh -l

REPO_COUNT=$(curl -s https://api.github.com/users/$1/repos | jq .[].full_name | wc -l)

curl -s https://api.github.com/users/$1/repos | jq .[].languages_url | tr -d '"' | while read dump
do
	curl -s $dump | awk '/:/ { gsub(/\"/,"");gsub(/:/,"");gsub(/,/,""); print; }' 
done > BUFF

awk '{ print $1 }' BUFF | sort | uniq | while read uniq_lang
do
	awk '$1 == "'$uniq_lang'" { a=a+$2 } END { print "'$uniq_lang'",a }'  BUFF >> STATS
done

echo "Hello $1, you have $REPO_COUNT repos under your name"

echo "I WANT ENVSUBST SO BADLY"
which envsubst

ls -l

export LANG1_NAME=$(sort -rnk2 STATS | head -1 | awk '{ print $1 }')
export LANG1_BYTES=$(sort -rnk2 STATS | head -1 | awk '{ print $2 }')

export LANG2_NAME=$(sort -rnk2 STATS | head -2 | tail -1 | awk '{ print $1 }')
export LANG2_BYTES=$(sort -rnk2 STATS | head -2 | tail -1 | awk '{ print $2 }')

export LANG3_NAME=$(sort -rnk2 STATS | head -3 | tail -1 | awk '{ print $1 }')
export LANG3_BYTES=$(sort -rnk2 STATS | head -3 | tail -1 | awk '{ print $2 }')

export LANG4_NAME=$(sort -rnk2 STATS | head -4 | tail -1 | awk '{ print $1 }')
export LANG4_BYTES=$(sort -rnk2 STATS | head -4 | tail -1 | awk '{ print $2 }')

export LANG5_NAME=$(sort -rnk2 STATS | head -5 | tail -1 | awk '{ print $1 }')
export LANG5_BYTES=$(sort -rnk2 STATS | head -5 | tail -1 | awk '{ print $2 }')

export LANG6_NAME=$(sort -rnk2 STATS | head -6 | tail -1 | awk '{ print $1 }')
export LANG6_BYTES=$(sort -rnk2 STATS | head -6 | tail -1 | awk '{ print $2 }')

export LANG7_NAME=$(sort -rnk2 STATS | head -7 | tail -1 | awk '{ print $1 }')
export LANG7_BYTES=$(sort -rnk2 STATS | head -7 | tail -1 | awk '{ print $2 }')


cat label.svg | envsubst 


rm STATS
rm BUFF
