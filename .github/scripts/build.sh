#!/bin/bash -e

export LC_ALL=ru_RU.UTF-8
export LANG=ru_RU.UTF-8
export LANGUAGE=ru_RU.UTF-8

pushd /etc/ImageMagick-* > /dev/null
sudo sed -i -e s:'</policymap>':"  <policy domain="\""coder"\"" rights="\""read | write"\"" pattern="\""EPS"\"" />\n  <policy domain="\""coder"\"" rights="\""read | write"\"" pattern="\""PDF"\"" />\n</policymap>": policy.xml
popd > /dev/null

find -iname '*.uml' -print0 | xargs -r --null -n 1 java -jar plantuml.jar
find -iname '*.png' | while read i; do
    PDF="${i/.png/.pdf}"
    echo "Converting $i to $PDF"    
    convert "$i" "$PDF"
    pdfcrop "$PDF"
    rm -f "$PDF"
    mv "${i/.png/-crop.pdf}" "$PDF"
done

for i in 1 2 3; do
    pdflatex -interaction=batchmode  main.tex
done
