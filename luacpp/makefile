
.PHONY: dist debug copy clean filelist.txt

debug: MAKEVARS="DEBUG=-DDEBUG"
debug: all filelist.txt copy clean

dist: all filelist.txt copy clean

filelist.txt:
	find . -name "*.lua" > $@
	find . -name "*.png" >> $@

copy: filelist.txt
	tar cf - -T filelist.txt | (cd ../dist; tar xvf -)

constants:
	awk '/^#[ ]*define/ {print $$(NF-1) " = nil;"}' constants.h > ../lib/symbols.lua
#	awk '/^#[ ]*define/ {print $$(NF-1) " = nil;"}' global.h    >> ../lib/symbols.lua
	grep -e "^#[ ]*define" global.h | awk '{print $$2 " = nil;"}' >> ../lib/symbols.lua

subdirs = EDGELUA SCRIPTS WIDGETS

-include makefile.include
