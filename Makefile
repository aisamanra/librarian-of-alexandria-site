# The set of basic pages we want to generate
pages=$(OUTDIR)/quotes/index.html $(OUTDIR)/quips/index.html \
  $(OUTDIR)/links/index.html $(OUTDIR)/category/index.html \
  $(OUTDIR)/scraps/index.html $(OUTDIR)/index.html

# The static files we just need to copy
static_tgt=$(OUTDIR)/static/jquery.js \
  $(OUTDIR)/static/main.css \
  $(OUTDIR)/static/quotes.js

# (We should generate this list another way, but it's unlikely to
# change with any regularity)
cats_src=comics fascicles poems stories

# We find all the stuff we want to generate...
quotes_src=$(wildcard $(DATADIR)/quotes/*)
quips_src=$(wildcard $(DATADIR)/quips/*)
links_src=$(wildcard $(DATADIR)/links/*)
scraps_src=$(wildcard $(DATADIR)/scraps/*)
works_src=$(notdir $(wildcard $(DATADIR)/works/*/*))

# and figure out what the $(OUTDIR) file will be called by matching
# on the input file.
quotes_tgt=$(quotes_src:$(DATADIR)/quotes/%=$(OUTDIR)/quotes/%/index.html)
quips_tgt=$(quips_src:$(DATADIR)/quips/%=$(OUTDIR)/quips/%/index.html)
links_tgt=$(links_src:$(DATADIR)/links/%=$(OUTDIR)/links/%/index.html)
scraps_tgt=$(scraps_src:$(DATADIR)/scraps/%=$(OUTDIR)/scraps/%/index.html)
cats_tgt=$(cats_src:%=$(OUTDIR)/category/%/index.html)

works_tgt=$(works_src:%=$(OUTDIR)/%/index.html)

# ------------------------------------------------------------------------------

all: $(pages) $(quotes_tgt) $(quips_tgt) $(links_tgt) $(works_tgt) $(scraps_tgt) \
  $(cats_tgt) $(static_tgt)

# ------------------------------------------------------------------------------

# A lot of these are boringly similar: probably should come up with a way of abstracting
# this common pattern, but, y'know, Make...

# These are the list page views:

$(OUTDIR)/quotes/index.html: $(DATADIR)/quotes/* templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $(DATADIR) all >$@

$(OUTDIR)/quips/index.html: $(DATADIR)/quips/* templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quip.sh $(DATADIR) all >$@

$(OUTDIR)/links/index.html: $(DATADIR)/links/* templates/link.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/link.sh $(DATADIR) all >$@

$(OUTDIR)/scraps/index.html: $(DATADIR)/scraps/* templates/scrap.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/scrap.sh $(DATADIR) all >$@

# ------------------------------------------------------------------------------

# These are the individual element pages:

$(OUTDIR)/quotes/%/index.html: $(DATADIR)/quotes/% templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $(DATADIR) $< >$@

$(OUTDIR)/quips/%/index.html: $(DATADIR)/quips/% templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $(DATADIR) $< >$@

$(OUTDIR)/links/%/index.html: $(DATADIR)/links/% templates/link.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/link.sh $(DATADIR) $< >$@

$(OUTDIR)/scraps/%/index.html: $(DATADIR)/scraps/% templates/scrap.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/scrap.sh $(DATADIR) $< >$@

# ------------------------------------------------------------------------------

# These are the works-related pages:
# (It was important to me to stick the works at the root instead of in
# subdirs pertaining to their category.)

$(OUTDIR)/%/index.html: $(DATADIR)/works/*/% templates/textpage.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/work.sh $(DATADIR) $< >$@

$(OUTDIR)/category/%/index.html: $(DATADIR)/works/% $(DATADIR)/works/%/* templates/list.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/category.sh $(DATADIR) $< >$@

$(OUTDIR)/category/index.html: templates/list.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/all-categories.sh $(DATADIR) >$@

# ------------------------------------------------------------------------------

$(OUTDIR)/index.html: $(OUTDIR)/index/index.html
	cp $< $@

$(OUTDIR)/static/%: static/%
	mkdir -p `dirname $@`
	cp $< $@

clean:
	rm -rf $(OUTDIR)
