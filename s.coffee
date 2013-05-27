e=require 'express'
t=require './t.js'
ex=require('child_process').exec
fs=require('fs')
a=e()
a.use(e.bodyParser());
a.use(e.static(__dirname));
a.post '/h', (req, res)->
	b=req.body
	return if b.n.match /^\s*$/
	g=new t.Game()
	s=g.run(b)
	# Massive race condition ahead!
	fs.appendFileSync('z.txt',s+"\t"+b.n+"\n")
	ex("sort -nr z.txt|head -n25>H")
	res.send ''
a.listen(3000);
