express=require 'express'
tetris=require './tetris.js'
exec=require('child_process').exec
fs=require('fs')

# Build express application
app=express()
app.use express.bodyParser()
app.use express.static(__dirname)

# Load old seeds from disk
openseeds={}
seed_timeout=3600*6*1000

# Called when the game is over and a high score is posted
app.post '/gameover', (req, res)->
	return if !req.body.name? or req.body.name.match /^\s*$/
	log=JSON.parse(req.body.log)

	# Check seed validity
	seed=log[0]
	if !openseeds[seed]? or new Date().getTime()-((+openseeds[seed])) > seed_timeout
		res.send 403,'seed already used or server restart'
	openseeds[seed]=0

	# Reevaluate the game
	score=(new tetris.Game()).run log

	# Save highscore to file (Massive race condition ahead!)
	fs.appendFileSync 'data/all_scores.txt', "#{score}\t#{req.body.name}\n"

	# Sort file
	exec("sort -nr data/all_scores.txt | head -n25 > data/highscore.txt")

	# Send empty response and have the client request the new list seperately
	if score==-1
		res.send 403,'cheater'
	else
		res.send 200,''

# Send highscore list to client
app.get '/highscore', (req, res)->
	fs.readFile 'data/highscore.txt', (err,data)-> res.send data

# Get a random seed
app.get '/seed', (req, res)->
	seed=Math.floor(Math.random()*100000000)
	openseeds[seed]=new Date().getTime()
	res.send "#{seed}"

# Start app
app.listen(3000);
