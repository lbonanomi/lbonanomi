#!/bin/sh -l

export REPO_COUNT=$(curl -s https://api.github.com/users/$1/repos | jq .[].full_name | wc -l)

curl -s https://api.github.com/users/$GITHUB_ACTOR/repos | jq .[].languages_url | tr -d '"' | while read dump
do
	curl -s $dump | awk '/:/ { gsub(/\"/,"");gsub(/:/,"");gsub(/,/,""); print; }' 
done > BUFF

awk '{ print $1 }' BUFF | sort | uniq | while read uniq_lang
do
	awk '$1 == "'$uniq_lang'" { a=a+$2 } END { print "'$uniq_lang'",a }'  BUFF >> STATS
done

which base64

export LANG1_NAME=$(sort -rnk2 STATS | head -1 | awk '{ print $1 }')
export LANG1_BYTES=$(sort -rnk2 STATS | head -1 | awk '{ printf "%i KB\n", $2 / 1024 }')

export LANG2_NAME=$(sort -rnk2 STATS | head -2 | tail -1 | awk '{ print $1 }')
export LANG2_BYTES=$(sort -rnk2 STATS | head -2 | tail -1 | awk '{ printf "%i KB\n", $2 / 1024 }')

export LANG3_NAME=$(sort -rnk2 STATS | head -3 | tail -1 | awk '{ print $1 }')
export LANG3_BYTES=$(sort -rnk2 STATS | head -3 | tail -1 | awk '{ printf "%i KB\n", $2 / 1024 }')

export LANG4_NAME=$(sort -rnk2 STATS | head -4 | tail -1 | awk '{ print $1 }')
export LANG4_BYTES=$(sort -rnk2 STATS | head -4 | tail -1 | awk '{ printf "%i KB\n", $2 / 1024 }')

export LANG5_NAME=$(sort -rnk2 STATS | head -5 | tail -1 | awk '{ print $1 }')
export LANG5_BYTES=$(sort -rnk2 STATS | head -5 | tail -1 | awk '{ printf "%i KB\n", $2 / 1024 }')

export LANG6_NAME=$(sort -rnk2 STATS | head -6 | tail -1 | awk '{ print $1 }')
export LANG6_BYTES=$(sort -rnk2 STATS | head -6 | tail -1 | awk '{ printf "%i KB\n", $2 / 1024 }')

export LANG7_NAME=$(sort -rnk2 STATS | head -7 | tail -1 | awk '{ print $1 }')
export LANG7_BYTES=$(sort -rnk2 STATS | head -7 | tail -1 | awk '{ printf "%i KB\n", $2 / 1024 }')


cat template.svg | envsubst | base64 > label.svg

CURRENT_SHA=$(curl -L -s -u :$TOKEN https://api.github.com/repos/$GITHUB_REPOSITORY/contents/label.svg | jq .sha | tr -d '"' | head -1)
curl -s -u :$TOKEN -X PUT -d '{ "message":"Re-label", "sha":"'$CURRENT_SHA'", "content":"'$(cat label.svg | tr -d '\n\r')'"}' https://api.github.com/repos/$GITHUB_REPOSITORY/contents/label.svg

rm STATS
rm BUFF
