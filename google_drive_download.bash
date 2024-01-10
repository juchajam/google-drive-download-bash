#!/bin/bash

proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url="$(echo ${1/$proto/})"
file_id="$(echo $url | grep / | cut -d/ -f4)"
file_name=$(curl $1 | grep -Po "'title':.*'isItemTrashed'" | awk -F "title: " '{split($1, a, ": '\''"); print a[2]}' | awk -F "isItemTrashed" '{split($1, a, "'\'', "); print a[1]}')
curl -sc /tmp/cookie "https://drive.google.com/uc?export=download&id=${file_id}" > /dev/null
code="$(awk '/_warning_/ {print $NF}' /tmp/cookie)"
curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${code}&id=${file_id}" -o "${file_name}"
