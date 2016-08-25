#!/bin/bash

indexLength="$1"
if [[ -z "$indexLength" ]]; then
    indexLength=5
fi
if [[ "$indexLength" = "all" ]]; then
    indexLength="$(wc -l < source/post_list)"
fi

function postList() {
    #Get post list in reverse order and retrieve the last $indexLength posts
    #Generates HTML for them with the title and blurbs
    #Then removes the last two lines of the output to delete the extra <hr/>
    cat source/post_list \
        | perl -e 'print reverse <>' \
        | head -n "$indexLength" \
        | while read postid; do
            #Escape single quotes
            link="$(echo "posts/$postid.html" | sed "s/'/\\&#39;/g")"
            echo "
                <h2 class='post-title'>
                    <a href='$link'>
                        $(cat "source/post_title/$postid")
                    </a>
                </h2>
                <h5>$(cat "source/post_date/$postid")</h5>
                <p class='post-blurb'>
                    <a href='$link'>
                        $(cat "source/post_blurb/$postid")
                    </a>
                </p>
                <hr/>
            "
        done \
        | head -n '-2'
}

echo "
<html>
    <head>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <title>Noven</title>
        <style>
            $(cat source/css/site.css)
            $(cat source/css/index.css)
        </style>
    </head>
    <body>
        $(cat source/header.html)
        <div class='content-body'>
            $(postList)
        </div>
        $(cat source/footer.html)
    </body>
</html>
"
