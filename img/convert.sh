#! /bin/sh

convert -resize x80 *.png *.png
convert -resize x80 *.jpeg *.jpeg
# not sure why this is a thing
rm uga-*.png
# making transparent images is hard...
# http://www.imagemagick.org/script/command-line-options.php#transparent
