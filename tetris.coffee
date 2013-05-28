# Copyright 2013 Henrik Mühe, henrik.muehe@gmail.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

width=10
height=15
sz=30
R=Raphael if Raphael?
M=Math
txt=null

# A tetris piece superclass
class P
	# initialize all values
	constructor: ->
		@shape=@bshape
		@blocks=[]
		@xb=0
		@yb=0
	# Rotate this piece right, changing its shape
	rotateRight: =>
		n=[]
		for row in [0..@shape[0].length-1]
			r=[]
			for col in [0..@shape.length-1]
				r.push @shape[@shape.length - col - 1][row]
			n.push r
		@shape=n
		this
	# Draw this piece onto a raphael canvas after a bounds check
	draw: (c)=>
		@xb=M.max(0,@xb)
		@xb=M.min(width-@shape[0].length,@xb)
		b.remove() for b in @blocks
		for y,row of @shape
			for x,col of row
				if col==1
					x=1.0*x
					y=1.0*y
					b=c.rect((@xb+x)*sz,(+@yb+y)*sz,sz,sz)
					b.attr({"fill":@color,"stroke":"#000"})
					@blocks.push b
	# Move piece to the left
	moveLeft: => @xb-=1; this
	# Move piece to the right
	moveRight: => @xb+=1; this
	# Move piece down one step
	down: => @yb+=1; this
	# Create a copy of this piece
	clone: =>
		p=new @constructor()
		p.xb=@xb;
		p.yb=@yb
		p.shape=@shape
		p
	# Create an array of coordinates occupied by this piece
	bounds: =>
		ba=[]
		for y,row of @shape
			for x,col of row
				if col==1
					ba.push [x*1.0+@xb,y*1.0+@yb]
		ba
	# Remove all blocks of this piece from their canvas
	remove: => b.remove() for b in @blocks

# Create subclasses for all 7 tetris pieces
class PI extends P
	bshape: [[1,1,1,1]]
	color: 'cyan'
class PJ extends P
	bshape: [[1,1,1],[0,0,1]]
	color: 'blue'
class PL extends P
	bshape: [[1,1,1],[1,0,0]]
	color: 'orange'
class PO extends P
	bshape: [[1,1],[1,1]]
	color: 'yellow'
class PS extends P
	bshape: [[0,1,1],[1,1,0]]
	color: 'green'
class PZ extends P
	bshape: [[1,1,0],[0,1,1]]
	color: 'purple'
class PT extends P
	bshape: [[0,1,0],[1,1,1]]
	color: 'red'

# Create a collection for easy instanciation
pieces=[PI,PT,PO,PJ,PL,PS,PZ]

# Actual game class implementing the big game board
class Game
	# Constructs a new tetris game
	constructor: (@G,@N,@S)->
		if @G
			@G=R(@G.attr("id"))
			@N=R(@N.attr("id"))
		@init()
		if @G
			@tick()
			@toggle()
	# Resets the game
	init: =>
		@n=-1
		b.remove() for b in @blocks if @blocks
		@score=0
		@blocks=[]
		@p.remove() if @p
		@p=null
		@next.remove() if @next
		@next=null
		@m=[]
		for r in [0..height-1]
			@m[r]=[]
			for col in [0..width-1]
				@m[r][col]=null
		if @G
			$.ajax
				url: '/seed'
				async: false
				success: (data,status,xhr)=>
					@log=[+data]
					console.log @log
					@Q=new Nonsense(@log[0])
					@tick()
					@draw()
					@gS()
	# Run a collision check for piece p
	check: (p)=>
		for b in p.bounds()
			return false if b[1]>=height
			return false if @m[b[1]][b[0]]?
		true
	# One game tick, moves current piece down, creates a fresh piece, triggers board redraw and checks game over condition
	tick: =>
		# drop active piece one step
		if @p?
			if @check(@p.clone().down())
				@p.down()
			else
				@persist(@p.bounds(),@p.color);
				@log.push [@p.xb,@p.yb]
				@p.remove()
				@draw()
				@p=null
		if !@p?
			# add piece if there is no active one
			@p=@next
			@p.xb=3 if @p?
			if @p?
				return @gameover() if !@check(@p)
				@log.push @n
			@n=@Q.uint32()%pieces.length;
			@next=new pieces[@n]()
		# refresh game c
		@p.draw(@G) if @p?
		@next.draw(@N)
	# Drops a piece down until it is persisted
	# We just tick as long as the piece has not been refreshed
	drop: =>
		if @i?
			@tick();@tick() while @p.yb!=0
	# Move current piece left if possible
	moveLeft:=>
		if @check(@p.clone().moveLeft())
			@p.moveLeft()
			@p.draw(@G)
	# Move current piece right if possible
	moveRight:=>
		if @check(@p.clone().moveRight())
			@p.moveRight()
			@p.draw(@G)
	# Rotate current piece right if possible
	rotateRight: =>
		if @check(@p.clone().rotateRight())
			@p.rotateRight()
			@p.draw(@G)
			@log.push 'R'
	# Rotate current piece left if possible
	rotateLeft: => @rotateRight() for [1..3]
	# Persist piece into the game state. This essentially makes it a static block instead of a moving piece
	persist: (b,c)=>
		@m[coord[1]][coord[0]]=c for coord in b
	# Load highscore
	gS:=>$.get '/highscore',(d)-> $("#h").text(d)
	# Game over handler
	gameover: =>
		@toggle()
		$.post '/gameover',
			name: $.trim(prompt("Please enter your name:"))
			log: JSON.stringify(@log)
		.done => @gS()
		txt=@G.text(0.5*width*sz,2*sz,@score+"\ngame over\nhit ⏎")
		txt.attr({"font-size":"30pt","font-family":"Courier"}) #STYLE_ONLY
		@init()
	# Redraw game board and check for fully filled rows which will be cleaned and added to the high score
	draw: =>
		# Check how many rows the player erased
		rowsKilled=0
		for y,row of @m
			full=true
			for x,col of row
				full=false if !col?
			if full
				rowsKilled+=1
				@m.splice(y,1)
				@m.unshift []
				@m[0].push null for i in [1..width]
		# High score computation, score is exponential w.r.t. the number of lines killed in one step
		@score+=M.pow(2,rowsKilled-1)*1000 if rowsKilled>0
		if @G
			# Remove all blocks
			b.remove() for b in @blocks
			# Redraw game board
			@S.html(@score)
			for y,row of @m
				for x,col of row
					if col?
						b=@G.rect((x*1.0)*sz,(y*1.0)*sz,sz,sz)
						b.attr("fill",col)
						b.attr("stroke","#000") #STYLE_ONLY
						@blocks.push b
	# toggles pause
	toggle: =>
		if @i?
			clearInterval(@i)
			@i=null
		else
			@i=setInterval(@tick,1000)
		if txt?
			txt.remove()
			txt=null
	# play a history and compute its score
	dump: =>
		for y,row of @m
			process.stdout.write '|'
			for x,c of row
				if c?
					process.stdout.write c[0]
				else
					process.stdout.write ' '
			console.log '|'
		console.log '|++++++++++|'
	run: (log) =>
		p=0
		a=log
		n=require('./libs/nonsense.js')
		@Q=new n(a.shift())
		for i in a
			if i[1]?
				p.xb=i[0]
				p.yb=i[1]
				if not @check(p)
					console.log "<<<<<<< CHEATER DUMP"
					@dump()
					console.log "CHEATER DUMP >>>>>>>"
					return -1
				@persist(p.bounds(),p.color)
				@draw()
			else if i=="R"
				p.rotateRight()
			else
				i=@Q.uint32()%pieces.length;
				p=new pieces[i]()
		@score

r=exports ? this
r.Game=Game
