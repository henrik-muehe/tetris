all: tetris.html

tetris.html: tetris.jade
	jade tetris.jade

stats:
	(cat *.coffee | ./compact.sh ; cat tetris.jade | grep -v h1 | grep -v body | grep -v float | grep -v script | grep -v include ) | wc -c

deploy:
#	rm -f H h z.txt ; wget -q http://henrikm85-tetris.nodejitsu.com/z ; cp z.txt H
	jitsu deploy
