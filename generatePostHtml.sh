#!/bin/bash
# $1 = Input file
# $2 = Post ID

#Convert post from markdown to HTML
#Encloses all tables in divs with class table-wrapper, which is
#used to add scroll bars to tables that are wider than the text,
#rather than having them extend past the text. This especially
#helps on mobile because otherwise it's possible to zoom out from
#the text.
pandoc -f markdown -t html "$1" \
    | sed 's#<table>#<div class="table-wrapper"><table>#g;
           s#</table>#</table></div>#g' \
    > "source/post_content/$2.html"
