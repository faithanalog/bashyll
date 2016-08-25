#!/bin/bash
postid="$1"

echo -n "Unpublish $postid? [y/N] "
read confirm
if [[ "$confirm" = "y" ]]; then
    rm "public/posts/$postid.html"
    rm "source/post_date/$postid"
    rm "source/post_blurb/$postid"
    rm "source/post_content/$postid.html"
    sed -i "\%${postid}% { d }" source/post_list
    ./makeIndices.sh
fi
