#!/bin/bash

title="$(./getPostTitle.sh < "$1")"
postid="$(echo $title | ./getPostID.sh)"
./unpublish.sh "$postid"
