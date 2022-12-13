BASEDIR=~/lfs-editors-guide-output
CHUNK_QUIET=1
PDF_OUTPUT=LFS-EDITORS-GUIDE-pt_br.pdf
NOCHUNKS_OUTPUT=LFS-EDITORS-GUIDE-pt_br.html
LFSXSL=stylesheets

ifdef V
  Q =
else
  Q = @
endif

default: lfs

help:
	@echo ""
	@echo "make <parameters> <targets>"
	@echo ""
	@echo "Parameters:"
	@echo "  BASEDIR=<dir>        Put the output in directory <dir>."
	@echo "                       Defaults to '~/lfs-editors-guide-output'."
	@echo ""
	@echo "  V=<val>              If <val> is a non-empty value, all"
	@echo "                       steps to produce the output is shown."
	@echo "                       Default is unset."
	@echo ""
	@echo "Targets:"
	@echo "  help                 Show this help text."
	@echo ""
	@echo "  default              Executes the default target which is"
	@echo "                       currently 'lfs'."
	@echo ""
	@echo "  lfs                  Builds the HTML pages of the book."
	@echo ""
	@echo "  pdf                  Builds the PDF representation of the book."
	@echo "                       'fop' must be installed to work."
	@echo ""
	@echo "                       Parameter PDF_OUTPUT=<filename> controls"
	@echo "                       the name of the PDF file."
	@echo ""
	@echo "  nochunks             Builds the book as a one-pager. The output"
	@echo "                       is a large single HTML page containing the"
	@echo "                       whole book."
	@echo ""
	@echo "                       Parameter NOCHUNKS_OUTPUT=<filename> controls"
	@echo "                       the name of the HTML file."
	@echo ""
	@echo "  validate             Runs validation checks on the XML files."
	@echo ""

lfs:
	@echo "Generating chunked XHTML files..."  
	$(Q)xsltproc --xinclude \
                --nonet \
                -stringparam chunk.quietly $(CHUNK_QUIET) \
                -stringparam base.dir $(BASEDIR)/ \
                $(LFSXSL)/lfs-chunked.xsl \
                index-pt_br.xml

	$(Q)mkdir -p                   $(BASEDIR)/stylesheets
	$(Q)cp $(LFSXSL)/lfs-xsl/*.css $(BASEDIR)/stylesheets
	$(Q)cd $(BASEDIR)/; sed -i -e "s@../stylesheets@stylesheets@g" *.html

	$(Q)mkdir -p        $(BASEDIR)/images
	$(Q)cp images/*.png $(BASEDIR)/images
	$(Q)cd $(BASEDIR)/; sed -i -e "s@../images@images@g" *.html

	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do \
	  tidy -config tidy.conf $$filename; \
	  true; \
	done;

	@echo "Running Tidy and obfuscate.sh on chunked XHTML..."  
	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do \
	  sed -i -e "s@text/html@application/xhtml+xml@g" $$filename; \
	done;

	@echo "Files are in $(BASEDIR)"

pdf:
	@echo "Generating pdf..."
	$(Q)xsltproc --xinclude \
                --nonet \
                --output $(BASEDIR)/lfs-pdf.fo \
                $(LFSXSL)/lfs-pdf.xsl \
                index-pt_br.xml

	$(Q)sed -i -e "s/inherit/all/" $(BASEDIR)/lfs-pdf.fo
	$(Q)fop $(BASEDIR)/lfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT)
	$(Q)rm $(BASEDIR)/lfs-pdf.fo
	@echo "File is $(BASEDIR)/$(PDF_OUTPUT)"

nochunks:
	@echo "Generating nochunks XHTML file..."  
	$(Q)xsltproc --xinclude \
                --nonet    \
                -stringparam profile.condition html    \
                --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
                $(LFSXSL)/lfs-nochunks.xsl             \
                index-pt_br.xml

	$(Q)tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true

	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g" $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	@echo "File is $(BASEDIR)/$(NOCHUNKS_OUTPUT)"

validate:
	$(Q)xmllint --noout --nonet --xinclude --postvalid index-pt_br.xml
