#!/bin/sh -l

REPO_COUNT=$(curl -s https://api.github.com/users/$1/repos | jq .[].full_name | wc -l)

curl -s https://api.github.com/users/$1/repos | jq .[].languages_url | while read dump
do
	echo curl -s $dump | awk '/:/ { gsub(/\"/,"");gsub(/:/,"");gsub(/,/,""); print;}' 
done > BUFF

awk '{ print $1 }' BUFF | sort | uniq | while read uniq_lang
do
	awk '/'"$uniq_lang"'/ { a=a+$2 } END { print '"$uniq_lang"', a }'
done

echo "Hello $1, you have $REPO_COUNT repos under your name"



