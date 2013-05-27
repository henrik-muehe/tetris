express=require 'express'
tetris=require './tetris.js'
exec=require('child_process').exec
fs=require('fs')

# Build express application
app=express()
app.use express.bodyParser()
app.use express.static(__dirname)

# Called when the game is over and a high score is posted
app.post '/gameover', (req, res)->
	return if !req.body.name? or req.body.name.match /^\s*$/

	# Reevaluate the game
	score=(new tetris.Game()).run req.body.log

	# Save highscore to file (Massive race condition ahead!)
	fs.appendFileSync 'data/all_scores.txt', "#{score}\t#{req.body.name}\n"

	# Sort file
	exec("sort -nr data/all_scores.txt | head -n25 > data/highscore.txt")

	# Send empty response and have the client request the new list seperately
	res.send ''

# Send highscore list to client
app.get '/highscore', (req, res)->
	fs.readFile 'data/highscore.txt', (err,data)-> res.send data

# Start app
app.listen(3000);
