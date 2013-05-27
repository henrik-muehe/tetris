all: tetris.html client.js server.js tetris.js
	mkdir -p data/

tetris.html: $(wildcard *.jade)
	./node_modules/jade/bin/jade tetris.jade

%.js: %.coffee
	./node_modules/coffee-script/bin/coffee -c $<

stats:
	(cat *.coffee | ./compact.sh ; cat tetris.jade | grep -v h1 | grep -v body | grep -v float | grep -v script | grep -v include ) | wc -c

clean:
	rm -f *.js
