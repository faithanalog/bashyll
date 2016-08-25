#!/bin/bash
echo "
<html>
    <head>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <title>$TITLE</title>
        <style>
            $(cat source/css/site.css)
            $(cat source/css/post.css)
        </style>
    </head>
    <body>
        $(cat source/header.html)
        <div class='content-body'>
            $(cat "$POST")
        </div>
        $(cat source/footer.html)
    </body>
</html>
"
