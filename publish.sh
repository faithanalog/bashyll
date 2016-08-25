#!/bin/bash
file="$1"

title="$(./getPostTitle.sh < "$file")"

#Gets the blurb for the post.
#1. Skip the title line
#2. Filter out empty lines
#3. Replace newlines with spaces
#4. Take the first 200 characters
#5. Remove the last word to prevent partial words
#6. Add "..."
blurb="$(tail -n +2 < "$file" \
    | awk '/[^\s]+/' \
    | tr '\n' ' ' \
    | head -c 200 \
    | sed -r 's/\s[^\s]+$//g')..."

date="$(date '+%b %d, %Y')"

#Replace spaces with dashes in the title, and lowercase it
postid="$(echo $title | ./getPostID.sh)"

echo "ID: $postid"
echo "Title: $title"
echo "Date: $date"
echo ""

if grep "$postid" "source/post_list" &> /dev/null; then
    echo -n "Post exists with ID '$postid'. Update post? [y/N] "
    read confirm_post
    if [[ "$confirm_post" != "y" ]]; then
        exit 1
    fi
else
    echo -n "Are you sure you want to post '$title'? [y/N] "
    read confirm_post
    if [[ "$confirm_post" != "y" ]]; then
        exit 1
    else
        echo -n $title > "source/post_title/$postid"
        echo -n $date > "source/post_date/$postid"
        echo $postid >> "source/post_list"
    fi
fi

#Regenerate blurb when editing posts
echo -n $blurb > "source/post_blurb/$postid"
./generatePostHtml.sh "$file" "$postid"

POST="source/post_content/$postid.html" \
TITLE="$title"
    ./makePost.sh > "./public/posts/$postid.html"

./makeIndices.sh
