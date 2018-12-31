#!/bin/bash

PROCCESS_NAME=ako_run
BUNDLE="/home/jf712/.rbenv/shims/bundle"


count=`ps aux | grep $PROCCESS_NAME | grep -v grep | wc -l`

if [ $count = 1 ]; then
  echo "proccess found!"
  user=`ps aux | grep $PROCCESS_NAME | grep -v grep | awk '{print $1}'`
  if [ $user = "jf712" ]; then
    # boku
    ps aux | grep $PROCCESS_NAME | grep -v grep | awk '{print "kill -9", $2}' | sh
    cd /home/jf712/projects/ako2; $BUNDLE exec ruby ako_run.rb
  fi
else
  echo "proccess NOT found!"
  cd /home/jf712/projects/ako2; $BUNDLE exec ruby ako_run.rb
fi

