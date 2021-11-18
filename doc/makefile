ASCIIDOCTOR = asciidoctor

EXTENSIONSDIR = ~/asciidoctor/extensions/lib 
EXTENSIONSDIR2 = ~/asciidoctor/local

ASCIIDOCTORFLAGS += -I $(EXTENSIONSDIR) -I $(EXTENSIONSDIR2) -r view-result-docinfoprocessor -r man-inline-macro-local -r asciidoctor-diagram -r tree-block-macro 
#-r asciidoctor-mathematical # -r mathematical-treeprocessor -r mathoid-treeprocessor

ASCIIDOCTORVARS += -a data-uri -a imagesdir=`pwd`/images -a stylesdir=css # -a stylesheet=asciidoctor-wide.css
ASCIIDOCTORVARS += -a revdate="${shell date +'%x'}"


all: rc720.html rcGui.html

%.html: %.adoc
	$(ASCIIDOCTOR) $(ASCIIDOCTORFLAGS) $(ASCIIDOCTORVARS) -a single -o $@ $<
