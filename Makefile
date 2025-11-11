all: gen out/style.css out/favicon.png
	killall -USR1 dillo || true

gen:
	buggy

out/%: static/%
	cp $^ $@
