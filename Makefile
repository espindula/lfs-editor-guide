BASEDIR=~/lfs-editors-guide-output
CHUNK_QUIET=1
PDF_OUTPUT=LFS-EDITORS-GUIDE.pdf
NOCHUNKS_OUTPUT=LFS-EDITORS-GUIDE.html
LFSXSL=stylesheets

ifdef V
  Q =
else
  Q = @
endif



lfs:
	@echo "Generating chunked XHTML files..."  
	$(Q)xsltproc --xinclude \
                --nonet \
                -stringparam chunk.quietly $(CHUNK_QUIET) \
                -stringparam base.dir $(BASEDIR)/ \
                $(LFSXSL)/lfs-chunked.xsl \
                index.xml

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
                index.xml

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
                index.xml

	$(Q)tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true

	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g" $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	@echo "File is $(BASEDIR)/$(NOCHUNKS_OUTPUT)"

validate:
	$(Q)xmllint --noout --nonet --xinclude --postvalid index.xml
