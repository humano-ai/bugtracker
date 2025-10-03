all: gen out/style.css
	killall -USR1 dillo || true

gen:
	buggy

out/style.css: static/style.css
	cp $^ $@
