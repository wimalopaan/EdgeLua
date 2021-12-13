
.PHONY: dist debug copy clean filelist.txt

debug: MAKEVARS="DEBUG=-DDEBUG"
debug: all filelist.txt copy clean

tiny: MAKEVARS="SELECT_TINY=-DSELECT_TINY"
tiny: all filelist.txt copytiny clean

tinydebug: MAKEVARS="SELECT_TINY=-DSELECT_TINY" "DEBUG=-DDEBUG"
tinydebug: all filelist.txt copytiny clean

dist: all filelist.txt copy clean 

filelist.txt:
	find . -name "*.lua" > $@
	find . -name "*.png" >> $@

copy: filelist.txt
	tar cf - -T filelist.txt | (mkdir -p ../dist; cd ../dist; tar xvf -)

copytiny: filelist.txt
	tar cf - -T filelist.txt | (mkdir -p ../disttiny; cd ../disttiny; tar xvf -)

constants:
	awk '/^#[ ]*define/ {print $$(NF-1) " = nil;"}' constants.h > ../lib/symbols.lua
#	awk '/^#[ ]*define/ {print $$(NF-1) " = nil;"}' global.h    >> ../lib/symbols.lua
	grep -e "^#[ ]*define" global.h | awk '{print $$2 " = nil;"}' >> ../lib/symbols.lua

subdirs = EDGELUA SCRIPTS WIDGETS

-include makefile.include
