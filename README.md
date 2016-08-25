#Bash Static Blog Generator

Static blog generator written with bash and pandoc. Small pages, fast load
times and 100% cachable content.

While the name is a reference to the Jekyll site generator, the workflow is
entirely unrelated. Bashyll was chosen as a name not just to reference Jekyll,
but because BASHyll looks sort of like BASHell if you squint hard enough, and
this project uses the Bourne-Again SHell.

An blog using this project, which may serve as an example blog, can be found at
https://github.com/unknownloner/ukl.me

#Table Of Contents

* [Rationale](#rationale)
  * [Why Bash?](#why-bash)
  * [Why Solarized?](#why-solarized)
  * [Why is the CSS included inline?](#why-is-the-css-included-inline)
  * [Why isn't anything minified?](#why-isnt-anything-minified)
* [Installation](#installation)
* [Usage](#usage)
  * [Post Format](#post-format)
  * [Syntax Highlighting](#syntax-highlighting)
  * [Including Images And Other Custom Content](#including-images-and-other-custom-content)
  * [Content Control Scripts](#content-control-scripts)
    * [publish](#publish)
    * [unpublish](#unpublish)
    * [idUnpublish](#idunpublish)
    * [makeBlog](#makeblog)
    * [makeIndices](#makeindices)
    * [regenPosts](#regenposts)
    * [generatePostHtml](#generateposthtml)
    * [getPostTitle](#getposttitle)
    * [getPostID](#getpostid)
  * [Modifying Templates And Themes](#modifying-templates-and-themes)
* [Internal File Structure](#internal-file-structure)




#Rationale

There's a lot of good static site generators out there these days, but most of
them require an external language to installed to use, and are far more complex
than necessary for a simple blog with static post content. This project aims to
provide an easy to use static blog generator, with minimal dependencies.


##Why Bash?

Originally, this project started simply as an experiment, under the
assumption that writing a blog generator would be more difficult than it ended
up being. However, bash does have the advantage of being available on most unix
systems already, and it turns out that bash works pretty painlessly as a
templating language (see `makePost` for an example of this).


##Why Solarized?

I know a lot of people don't like low-contrast color schemes like Solarized. I'm
working on putting together a new higher-contrast color scheme to use as the
default, and for my blog, but since Solarized is the color scheme I use on my
blog right now, it's also what I'm including in the first upload of this
project.


##Why is the CSS included inline?

CSS is included inline on each page to reduce a full page load to a single HTTP
request (excluding images). This allows the page to be fully rendered quicker,
because the browser only has to make one round trip before it can calculate all
styles for the page. Including the width and height of your images in your
markdown will further improve page speed, as the images will not cause page
reflows when loaded.

Because the CSS is included inline, blog users are encouraged to keep site
styles minimal. It might be a good idea to asynchronously load syntax
highlighting CSS rather than including it inline, as that should not cause a
page reflow once loaded.


##Why isn't anything minified?

GZIP does a very good job of compressing posts as it is, and the difference
in size between minified and unminified content is minimal. Even without gzip,
page sizes are pretty small anyway, and would be immediately dwarfed by any
images included. In short, it's a non-issue, and would add unnecessary
complexity.




#Installation

    1. Install pandoc. This package can be found in the repositiories of many
       Linux distributions.

    2. Clone this repository to wherever you want your blog to exist.

    3. Modify `source/header.html` and `source/footer.html` to match your needs



#Usage

Because this is a static site generator, you can use any web server you want
to host your site. Simply use `public/` as the root directory of your site, and
follow the documentation below for instructions on how to generate pages.


##Post Format

Posts are written in Markdown, and processed using pandoc. See pandoc's
documentation at http://pandoc.org/MANUAL.html#pandocs-markdown for further
details


##Syntax Highlighting

Pandoc will wrap code with syntax-highlighting HTML if you provide a language
name with your code block like so:

    ```javascript
    function add2(x) {
        return x + 2;
    }
    ```

However, there is no CSS included to properly style these at this time. A default
syntax highlighting stylesheet is planned for the future, but in the meantime you
can use one of the style sheets found at the following link, or create your own
based on them. https://github.com/jgm/highlighting-kate/tree/master/css


##Including Images And Other Custom Content

Because pandoc allows you to write arbitrary HTML directly in your markdown, you
may simply write the HTML required for your custom content. In the case of
images, you can also use pandoc's image link syntax, as demonstrated below.

    ![Alt text here](/img/some_image.png)

It may be best to create a folder within the `public/` folder to contain static
content you wish to include in your posts.


##Content Control Scripts

All control is done using the provided shell scripts. However, before we begin,
it is important to note that it is *imperative* that you do not modify the first
line of the page's markdown file after initially publishing it, as the post ID
used internally is derived from the title of a post, which in turn is derived
from the first line in the post file. Modifying your post's title after
publshing it will cause `publish` to treat the post as if it were a new post,
rather than an edited post. Therefore if you've made a mistake in your post's
title, unpublish the old post before fixing the mistake and publishing the
fixed one.


###publish

`publish` takes a path to the markdown file you wish to publish. You should
your markdown files in the `posts` folder for the blog system to work.

`publish` will generate metadata used by the other scripts, and generate HTML
in the `public/` folder. Publishing an existing post will allow you to edit that
post. The post date will remain the same, while the content will be updated.

    Syntax:
        ./publish <path-to-post>

    Example:
        ./publish posts/HelloWorld.md


###unpublish

`unpublish` takes a path to the markdown file containing the source of the
post you wish to unpublish. It will remove the generated HTML, as well as the
post metadata stored in the `source/` folder, and then regenerate the index
pages.

    Syntax:
        ./unpublish <path-to-post>

    Example:
        ./unpublish posts/HelloWorld.md


###idUnpublish

`idUnpublish` does all the heavy lifting of unpublishing your post, and is
infact used by `unpublish`. It takes a post ID as an argument rather than a
file name.

    Syntax:
        ./idUnpublish <post-id>

    Example:
        ./idUnpublish hello-world


###makeBlog

`makeBlog` executes regenPosts and makeIndices. This is useful for
updating pages after modifying CSS in the `source/` folder, or if you've deleted
your content in the `public/` folder. It's recommended to use this rather than
running `makeIndices` and `regenPosts` separately, simply because it's
more convenient to do.

    Syntax:
        ./makeBlog

    Example:
        ./makeBlog


###makeIndices

`makeIndices` is used to generate the `index.html` and `posts.html` pages.
The `index.html` page lists the five most recent posts, while `posts.html`
lists all posts on the site. This script does not need to be executed manually
under normal circumstances.

    Syntax:
        ./makeIndices

    Example:
        ./makeIndices


###regenPosts

`regenPosts` will regenerate the HTML for all published posts. This requires
the post markdown files still exist in `posts/`. This script does not need to be
executed manually under normal circumstances.

    Syntax:
        ./regenPosts

    Example:
        ./regenPosts


###generatePostHtml

`generatePostHtml` generates the HTML for the content of a post, before it is
converted to a full page with the post template. This script does not need to be
executed manually under normal circumstances.

    Syntax:
        ./generatePostHtml <input-file> <post-id>

    Example:
        ./generatePostHtml posts/HelloWorld.md hello-world


###getPostTitle

`getPostTitle` reads the first line of a post's content from STDIN and
extracts the title from that line by removing any leading '#' characters.

    Syntax:
        ./getPostTitle

    Example:
        ./getPostTitle < posts/HelloWorld.md


###getPostID

`getPostID` reads the title of a post from STDIN, replaces spaces with
dashes, converts the title to lowercase, and writes the result to STDOUT

    Sytax:
        ./getPostID

    Example:
        ./getPostTitle < posts/HelloWorld.md | ./getPostID



##Modifying Templates and Themes

Templating, like everything else, is done using bash. Feel free to modify
`makePost` and `makeIndex` to change the resulting HTML to suit your
needs.

However, simpler modifications may be done by editing `source/header.html` and
`source/footer.html`. These posts are automatically inserted above and below the
HTML of your posts and your index pages.

If you wish to change the CSS of your site, see the `source/css` folder. The
default templates include `source/css/post.css` on post pages,
`source/css/index.css` on index pages, and `source/css/site.css` on both types
of pages.



#Internal File Structure

Below is the file structure of the project, excluding script files.

    .
    ├── posts ------------------ Markdown files for all posts
    │
    ├── public ----------------- Public site root directory
    │   │
    │   └── posts -------------- Generated post HTML
    │
    └── source ----------------- Data used to generate the HTML
        │
        ├── css ---------------- Site CSS styles
        │   │
        │   ├── index.css ------ Included on index pages
        │   ├── post.css ------- Included on post pages
        │   └── site.css ------- Included on all pages
        │
        ├── footer.html -------- HTML included at the top of all site bodies
        │
        ├── header.html -------- HTML included at the bottom of all site bodies
        │
        ├── post_blurb --------- Post blurbs displayed on index pages
        │
        ├── post_content ------- Raw post HTML content before templating
        │
        ├── post_date ---------- Dates posts were posted on
        │
        ├── post_list ---------- File containing a list of all post IDs in
        │                        reverse chronological (newest to oldest)
        │
        └── post_title --------- Post titles
