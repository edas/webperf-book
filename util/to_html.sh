#!/bin/bash

if [ -f ../export/html/index.html ]; then
    rm ../export/html/index.html
fi
if [ -f ../export/html/style.css ]; then
    rm ../export/html/style.css
fi

# if [ -f ../export/html/*.js ]; then
#     rm -r ../export/html/*.js
# fi

if [ -d ../export/html/img ]; then
    rm -r ../export/html/img
fi

pandoc \
    -c style.css  \
    -f markdown \
    -t html \
    --html5 \
    --normalize \
    --smart \
    --standalone \
    --table-of-contents \
    -N \
    --include-in-header=templates/in-header.html \
    --include-before-body=templates/before-body.html \
    --include-after-body=templates/after-body.html \
    -o ../export/html/index.html \
    ../content/*.md \
   

cp templates/style.css ../export/html/
cp -a ../content/img ../export/html/