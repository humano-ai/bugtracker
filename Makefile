all: gen out/style.css out/favicon.png
	killall -USR1 dillo || true

gen:
	mkdir -p out
	for d in [0-9]*; do \
		[ -d "$$d" ] || continue; \
		mkdir -p "out/$$d"; \
		./src/mkissue.sh "$$d/index.md" > "out/$$d/index.html"; \
	done
	{ for d in [0-9]*; do [ -f "$$d/index.md" ] && ./src/mkrow.sh "$$d" "$$d/index.md" open; done; } | ./src/mkindex.sh > out/index.html
	{ for d in [0-9]*; do [ -f "$$d/index.md" ] && ./src/mkrow.sh "$$d" "$$d/index.md" ''; done; } | ./src/mkindex.sh > out/any.html
	for p in $$(find . -maxdepth 2 -name index.md -print | xargs awk '/^Project: / { sub("Project: ", ""); print; nextfile }' | sort -u); do \
		{ for d in [0-9]*; do [ -f "$$d/index.md" ] && ./src/mkrow.sh "$$d" "$$d/index.md" '' "$$p"; done; } | ./src/mkindex.sh > "out/$$p.html"; \
	done
	for a in $$(find . -maxdepth 2 -name index.md -print | xargs awk '/^Assignee: / { sub("Assignee: ", ""); print; nextfile }' | sort -u); do \
		{ for d in [0-9]*; do [ -f "$$d/index.md" ] && ./src/mkrow.sh "$$d" "$$d/index.md" '' '' "$$a"; done; } | ASSIGNEE_FILTER="$$a" ./src/mkindex.sh > "out/assignee-$$a.html"; \
		for p in $$(find . -maxdepth 2 -name index.md -print | xargs awk '/^Project: / { sub("Project: ", ""); print; nextfile }' | sort -u); do \
			{ for d in [0-9]*; do [ -f "$$d/index.md" ] && ./src/mkrow.sh "$$d" "$$d/index.md" '' "$$p" "$$a"; done; } | ASSIGNEE_FILTER="$$a" ./src/mkindex.sh > "out/assignee-$$a-$$p.html"; \
		done; \
	done

out/%: static/%
	mkdir -p out
	cp $^ $@
