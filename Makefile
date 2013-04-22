all: tetris.html

tetris.html: tetris.jade
	jade tetris.jade

stats:
	(cat *.coffee | ./compact.sh ; cat tetris.jade | grep -v h1 | grep -v body | grep -v float | grep -v script | grep -v include ) | wc -c
