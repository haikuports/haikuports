#!/bin/bash
# Lints all the recipes created / modified since upstream HEAD.
git remote add real_origin https://github.com/haikuports/haikuports.git || true
git fetch real_origin

files=$(git diff $(git rev-parse --abbrev-ref HEAD) real_origin/master --numstat | awk '{print $3}')
for file in $files; do
	if [ -e "$file" ] && [[ "$file" == *recipe ]]; then
		baseName=$(basename $file)
		portName=${baseName::-7}
		haikuporter $@ --lint $portName
		if [ $? -ne 0 ]; then exit 1; fi
	fi
done
