#!/bin/bash

if [ -f ../export/html/index.html ]; then
    rm ../export/html/index.html
fi
if [ -f ../export/html/style.css ]; then
    rm ../export/html/style.css
fi
if [ -d ../export/html/img ]; then
    rm -r ../export/html/img
fi

pandoc \
    -c style.css  \
    -f markdown \
    -t html \
    --normalize \
    --smart \
    --standalone \
    --table-of-contents \
    --include-in-header=templates/in-header.html \
    --include-before-body=templates/before-body.html \
    --include-after-body=templates/after-body.html \
    -o ../export/html/index.html \
    ../content/chap00-avant-propos.md \
    ../content/chap01-users-really-respond-to-speed.md \
    ../content/chap02-premiers-concepts.md \
    ../content/chap03-travailler-avec-les-caches-http.md

cp templates/style.css ../export/html/
cp -a ../content/img ../export/html/