# basic pages that will always exist:

# Maybe we want to override this?
OUTDIR=output
DATADIR=/home/getty/projects/lib-data

pages=$(OUTDIR)/quotes/index.html $(OUTDIR)/quips/index.html \
  $(OUTDIR)/links/index.html $(OUTDIR)/category/index.html \
  $(OUTDIR)/index.html

static_tgt=$(OUTDIR)/static/jquery.js \
  $(OUTDIR)/static/main.css \
  $(OUTDIR)/static/quotes.js

# We find all the stuff we want to generate...
quotes_src=$(wildcard $(DATADIR)/quotes/*)
quips_src=$(wildcard $(DATADIR)/quips/*)
links_src=$(wildcard $(DATADIR)/links/*)
works_src=$(notdir $(wildcard $(DATADIR)/works/*/*))
cats_src=comics fascicles poems stories

# and figure out what the $(OUTDIR) file will be called by matching
# on the input file.
quotes_tgt=$(quotes_src:$(DATADIR)/quotes/%=$(OUTDIR)/quotes/%/index.html)
quips_tgt=$(quips_src:$(DATADIR)/quips/%=$(OUTDIR)/quips/%/index.html)
links_tgt=$(links_src:$(DATADIR)/links/%=$(OUTDIR)/links/%/index.html)
cats_tgt=$(cats_src:%=$(OUTDIR)/category/%/index.html)

# I'm doing this manually for now.

# this is kind of gross---the problem is that I do want to store
# 'works' (other writing) inside directories that correspond to their
# kind, but don't want that in the output, so I can't straightforwardly
# use patsubst like above: I'd have to write something like
# works_src:$(DATADIR)/works/*/%=$(OUTDIR)/%/index.html
# which doesn't work. I could also filter out all the known kinds of
# works through other wildcard magic. instead, I just shell out to sed.
works_tgt=$(works_src:%=$(OUTDIR)/%/index.html)


all: $(pages) $(quotes_tgt) $(quips_tgt) $(links_tgt) $(works_tgt) \
  $(cats_tgt) $(static_tgt)

# A lot of these are boringly similar: probably should come up with a way of abstracting
# this common pattern, but, y'know, Make...

$(OUTDIR)/quotes/index.html: $(DATADIR)/quotes/* templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $(DATADIR) all >$@

$(OUTDIR)/quips/index.html: $(DATADIR)/quotes/* templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quip.sh $(DATADIR) all >$@

$(OUTDIR)/links/index.html: $(DATADIR)/links/* templates/link.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/link.sh $(DATADIR) all >$@

$(OUTDIR)/quotes/%/index.html: $(DATADIR)/quotes/% templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $(DATADIR) $< >$@

$(OUTDIR)/quips/%/index.html: $(DATADIR)/quips/% templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $(DATADIR) $< >$@

$(OUTDIR)/links/%/index.html: $(DATADIR)/links/% templates/link.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/link.sh $(DATADIR) $< >$@

$(OUTDIR)/%/index.html: $(DATADIR)/works/*/% templates/textpage.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/work.sh $(DATADIR) $< >$@

$(OUTDIR)/category/%/index.html: $(DATADIR)/works/% $(DATADIR)/works/%/* templates/worklist.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/category.sh $(DATADIR) $< >$@

$(OUTDIR)/category/index.html: templates/worklist.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/all-categories.sh $(DATADIR) >$@

$(OUTDIR)/index.html: $(OUTDIR)/index/index.html
	cp $< $@

$(OUTDIR)/static/%: static/%
	mkdir -p `dirname $@`
	cp $< $@

clean:
	rm -rf $(OUTDIR)
