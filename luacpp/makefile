
.PHONY: dist copy clean filelist.txt

dist: all filelist.txt copy clean

filelist.txt:
	find . -name "*.lua" > $@

copy: filelist.txt
	tar cf - -T filelist.txt | (cd ../dist; tar xvf -)



subdirs = EDGELUA SCRIPTS WIDGETS

-include makefile.include
