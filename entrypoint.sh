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

which envsubst

rm STATS
rm BUFF
