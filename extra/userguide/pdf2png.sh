#!/bin/sh
gs -q -dPARANOIDSAFER -dBATCH -dNOPAUSE -dNOPROMPT -dMaxBitmap=500000000 -dAlignToPixels=0 -dGridFitTT=0 -sDEVICE=png16m -r300x300 -sOutputFile=temp_page%d.png userguide.pdf
for i in `ls temp_page*.png`
do
	echo $i `echo $i | sed 's/temp_page/userguide_page/g'`
	convert -resize 940 $i `echo $i | sed 's/temp_page/userguide_page/g'`
	rm $i
done
