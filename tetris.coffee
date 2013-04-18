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
size=30
$("#game").css("width",size*width)
$("#game").css("height",size*height)
$("#next").css("width",size*4)
$("#next").css("height",size*4)
R=Raphael
c=R("game","100%","100%")
next=R("next","100%","100%")

# A tetris piece superclass
class Piece
	# initialize all values
	constructor: ->
		@shape=@bshape
		@blocks=[]
		@xbase=0
		@ybase=0
	# Rotate this piece right, changing its shape
	rotR: =>
		n=[]
		for row in [0..@shape[0].length-1]
			r=[]
			for col in [0..@shape.length-1]
				r.push @shape[@shape.length - col - 1][row]
			n.push r
		@shape=n
		this
	# Rotate piece left, implemented using right rotation
	rotL: =>
		@rotR() for x in [0..2]
		this
	# Draw this piece onto a raphael canvas after a bounds check
	draw: (c)=>
		@xbase=Math.max(0,@xbase)
		@xbase=Math.min(width-@shape[0].length,@xbase)
		b.remove() for b in @blocks
		for y,row of @shape
			for x,col of row
				if col==1
					x=1.0*x
					y=1.0*y
					b=c.rect((@xbase+x)*size,(+@ybase+y)*size,size,size)
					b.attr("fill", @color)
					b.attr("stroke", "#000")
					@blocks.push b
	# Move piece to the left
	l: =>
		@xbase-=1
		this
	# Move piece to the right
	r: =>
		@xbase+=1
		this
	# Move piece down one step
	down: =>
		@ybase+=1
		this
	# Create a copy of this piece
	clone: =>
		p=new this.constructor()
		p.xbase=@xbase;
		p.ybase=@ybase
		p.shape=@shape
		p
	# Create an array of coordinates occupied by this piece
	bounds: =>
		ba=[]
		for y,row of @shape
			for x,col of row
				if col==1
					ba.push [x*1.0+@xbase,y*1.0+@ybase]
		ba
	# Remove all blocks of this piece from their canvas
	remove: =>
		b.remove() for b in @blocks

# Create subclasses for all 7 tetris pieces
class PI extends Piece
	bshape: [[1,1,1,1]]
	color: 'cyan'
class PJ extends Piece
	bshape: [[1,1,1],[0,0,1]]
	color: 'blue'
class PL extends Piece
	bshape: [[1,1,1],[1,0,0]]
	color: 'orange'
class PO extends Piece
	bshape: [[1,1],[1,1]]
	color: 'yellow'
class PS extends Piece
	bshape: [[0,1,1],[1,1,0]]
	color: 'green'
class PZ extends Piece
	bshape: [[1,1,0],[0,1,1]]
	color: 'purple'
class PT extends Piece
	bshape: [[0,1,0],[1,1,1]]
	color: 'red'

# Create a collection for easy instanciation
pieces=[PI,PT,PO,PJ,PL,PS,PZ]

# Actual game class implementing the big game board
class Game
	# Constructs a new tetris game
	constructor: ->
		@init()
		@tick()
		setInterval(@tick,1000)
	# Resets the game
	init: =>
		b.remove() for b in @blocks if @blocks
		@score=0
		@blocks=[]
		@piece.remove() if @piece
		@piece=null
		@next.remove() if @next
		@next=null
		@matrix=[]
		for row in [0..height-1]
			@matrix[row]=[]
			for col in [0..width-1]
				@matrix[row][col]=null
		@tick()
		@draw()
	# Run a collision check for piece p
	check: (p)=>
		for b in p.bounds()
			return false if b[1] >= height
			return false if @matrix[b[1]][b[0]]!=null
		true
	# One game tick, moves current piece down, creates a fresh piece, triggers board redraw and checks game over condition
	tick: =>
		# drop active piece one step
		if @piece!=null
			if @check(@piece.clone().down())
				@piece.down()
			else
				@persist(@piece);
				@piece.remove()
				@draw()
				@piece=null
		if @piece==null
			# add piece if there is no active one
			@piece=@next
			return @gameover() if @piece!=null and not @check(@piece)
			@next=new pieces[Math.floor(Math.random()*pieces.length)]()
		# refresh game c
		@piece.draw(c) if @piece
		@next.draw(next)
	# Drops a piece down until it is persisted
	drop: =>
		# We just tick as long as the piece has not been refreshed
		@tick();@tick() while @piece.ybase!=0
	# Move current piece left if possible
	l: =>
		if @check(@piece.clone().l())
			@piece.l()
			@piece.draw(c)
	# Move current piece right if possible
	r: =>
		if @check(@piece.clone().r())
			@piece.r()
			@piece.draw(c)
	# Rotate current piece left if possible
	rotL: =>
		if @check(@piece.clone().rotL())
			@piece.rotL()
			@piece.draw(c)
	# Rotate current piece right if possible
	rotR: =>
		if @check(@piece.clone().rotR())
			@piece.rotR()
			@piece.draw(c)
	# Persist piece into the game state. This essentially makes it a static block instead of a moving piece
	persist: (p)=>
		@matrix[coord[1]][coord[0]]=p.color for coord in p.bounds()
	# Game over handler
	gameover: =>
		alert "game over"
		@init()
	# Redraw game board and check for fully filled rows which will be cleaned and added to the high score
	draw: =>
		# Remove all blocks
		b.remove() for b in @blocks
		# Check how many rows the player erased
		rowsKilled=0
		for y,row of @matrix
			full=true
			for x,col of row
				full=false if col==null
			if full
				rowsKilled+=1
				@matrix.splice(y,1)
				@matrix.unshift []
				@matrix[0].push null for i in [1..width]
		# High score computation, score is exponential w.r.t. the number of lines killed in one step
		@score+=Math.pow(2,rowsKilled-1)*1000 if rowsKilled>0
		$("#score").html(@score)
		# Redraw game board
		for y,row of @matrix
			for x,col of row
				continue if col==null
				b=c.rect((x*1.0)*size,(y*1.0)*size,size,size)
				b.attr("fill",col)
				b.attr("stroke","#000")
				@blocks.push b

# Instance of the game and key handlers
g=new Game()
$(document).keydown (e) ->
	switch e.which
		when 37 then g.l()
		when 39 then g.r()
		when 38 then g.rotR()
		when 40 then g.rotL()
		when 32 then g.drop()
