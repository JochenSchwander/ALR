#!/bin/bash
#
# gitwait - watch file and git commit all changes as they happen
#

while true; do
  echo "test" >> test.txt
  git commit -a -m 'autocommit on change'
  git pull
  git push

done