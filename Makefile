# basic pages that will always exist:

pages=output/quotes/index.html output/quips/index.html \
  output/links/index.html output/category/index.html \
  output/index.html

# We find all the stuff we want to generate...
quotes_src=$(wildcard data/quotes/*)
quips_src=$(wildcard data/quips/*)
links_src=$(wildcard data/links/*)
works_src=$(wildcard data/works/*/*)
cats_src=comics fascicles poems stories

# and figure out what the output file will be called by matching
# on the input file.
quotes_tgt=$(quotes_src:data/quotes/%=output/quotes/%/index.html)
quips_tgt=$(quips_src:data/quips/%=output/quips/%/index.html)
links_tgt=$(links_src:data/links/%=output/links/%/index.html)
cats_tgt=$(cats_src:%=output/category/%/index.html)

# I'm doing this manually for now.

# this is kind of gross---the problem is that I do want to store
# 'works' (other writing) inside directories that correspond to their
# kind, but don't want that in the output, so I can't straightforwardly
# use patsubst like above: I'd have to write something like
# works_src:data/works/*/%=output/%/index.html
# which doesn't work. I could also filter out all the known kinds of
# works through other wildcard magic. instead, I just shell out to sed.
works_tgt=$(shell ( echo $(works_src) | sed -e 's/data\/works\/[A-Za-z0-9_-]*\/\([A-Za-z0-9_-]*\)/output\/\1\/index.html/g') )

# Maybe we want to override this?
OUTDIR=output

all: $(pages) $(quotes_tgt) $(quips_tgt) $(links_tgt) $(works_tgt) \
  $(cats_tgt)

# A lot of these are boringly similar: probably should come up with a way of abstracting
# this common pattern, but, y'know, Make...

$(OUTDIR)/quotes/index.html: data/quotes/* templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh all >$@

$(OUTDIR)/quips/index.html: data/quotes/* templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quip.sh all >$@

$(OUTDIR)/links/index.html: data/links/* templates/link.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/link.sh all >$@

$(OUTDIR)/quotes/%/index.html: data/quotes/% templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $< >$@

$(OUTDIR)/quips/%/index.html: data/quips/% templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $< >$@

$(OUTDIR)/links/%/index.html: data/links/% templates/link.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/link.sh $< >$@

$(OUTDIR)/%/index.html: data/works/*/% templates/textpage.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/work.sh $< >$@

$(OUTDIR)/category/%/index.html: data/works/% data/works/%/* templates/worklist.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/category.sh $< >$@

$(OUTDIR)/category/index.html: templates/worklist.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/all-categories.sh >$@

$(OUTDIR)/index.html: $(OUTDIR)/index/index.html
	cp $< $@

clean:
	rm -rf $(OUTDIR)
