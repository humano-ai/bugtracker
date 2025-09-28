issues=$(shell printf '%s\n' [0-9]* | sort -nr)
out=.out
html_issues=$(patsubst %, $(out)/%/index.html, $(issues))
any_issues=$(patsubst %, $(out)/%/.row.html, $(issues))
open_issues=$(patsubst %, $(out)/%/.row.open.html, $(issues))
css_input=src/style.css
css=$(out)/style.css

all: $(css) $(html_issues) $(any_issues) $(open_issues) $(out)/index.html $(out)/any.html
	@killall -USR1 dillo || true

$(out)/issues:
	printf '%d\n' $(issues) > $@

$(out)/%/index.html: %/index.md %/* src/mkissue.sh src/issue.awk
	@mkdir -p $(out)/$*
	src/mkissue.sh $*/index.md > $@

$(out)/%/.row.open.html: %/index.md src/mkrow.sh src/issue-entry.awk
	@mkdir -p $(out)/$*
	src/mkrow.sh $* $*/index.md open > $@

$(out)/%/.row.html: %/index.md src/mkrow.sh src/issue-entry.awk
	@mkdir -p $(out)/$*
	src/mkrow.sh $* $*/index.md > $@

$(out)/index.html: $(open_issues) src/mkindex.sh
	@echo rebuild open index
	@src/mkindex.sh $(open_issues) > $@

$(out)/any.html: $(any_issues) src/mkindex.sh
	@echo rebuild any index
	@src/mkindex.sh $(any_issues) > $@


$(css): $(css_input)
	@mkdir -p $(out)/
	@cp $^ $@

new:
	@src/mknew.sh

#fetch:
#	@python src/export.py
