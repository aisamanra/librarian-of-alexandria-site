allquotes=$(wildcard data/quotes/*)
allquips=$(wildcard data/quips/*)
alllinks=$(wildcard data/links/*)
allworks=$(wildcard data/works/*/*)
OUTDIR=output

all: output/quotes/index.html \
  $(allquotes:data/quotes/%.yaml=output/quote/%/index.html) \
  $(allquips:data/quips/%.yaml=output/quip/%/index.html) \
  $(alllinks:data/links/%.yaml=output/link/%/index.html)

$(OUTDIR)/quotes/index.html: data/quotes/* templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh all >$@

$(OUTDIR)/quips/index.html: data/quotes/* templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quip.sh all >$@

$(OUTDIR)/links/index.html: data/links/* templates/link.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/link.sh all >$@

$(OUTDIR)/quote/%/index.html: data/quotes/%.yaml templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $< >$@

$(OUTDIR)/quip/%/index.html: data/quips/%.yaml templates/quote.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/quote.sh $< >$@

$(OUTDIR)/link/%/index.html: data/links/%.yaml templates/link.mustache templates/main.mustache
	mkdir -p `dirname $@`
	bin/link.sh $< >$@
