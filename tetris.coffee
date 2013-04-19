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

$(window).focus()
width=10
height=15
size=30
$("#g").css("width",size*width)
$("#g").css("height",size*height)
$("#n").css("width",size*4)
$("#n").css("height",size*4)
R=Raphael
M=Math
G=R("g")
N=R("n")
txt=null

# A tetris piece superclass
class P
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
	# Draw this piece onto a raphael canvas after a bounds check
	draw: (c)=>
		@xbase=M.max(0,@xbase)
		@xbase=M.min(width-@shape[0].length,@xbase)
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
	l: => @xbase-=1; this
	# Move piece to the right
	r: => @xbase+=1; this
	# Move piece down one step
	down: => @ybase+=1; this
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
	constructor: ->
		@init()
		@tick()
		@toggle()
	# Resets the game
	init: =>
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
		@tick()
		@draw()
	# Run a collision check for piece p
	check: (p)=>
		for b in p.bounds()
			return false if b[1] >= height
			return false if @m[b[1]][b[0]]!=null
		true
	# One game tick, moves current piece down, creates a fresh piece, triggers board redraw and checks game over condition
	tick: =>
		# drop active piece one step
		if @p!=null
			if @check(@p.clone().down())
				@p.down()
			else
				@persist(@p);
				@p.remove()
				@draw()
				@p=null
		if @p==null
			# add piece if there is no active one
			@p=@next
			return @gameover() if @p!=null and not @check(@p)
			@next=new pieces[M.floor(M.random()*pieces.length)]()
		# refresh game c
		@p.draw(G) if @p
		@next.draw(N)
	# Drops a piece down until it is persisted
		# We just tick as long as the piece has not been refreshed
	drop: =>
		if @i&&@i!=null
			@tick();@tick() while @p.ybase!=0
	# Move current piece left if possible
	l: =>
		if @check(@p.clone().l())
			@p.l()
			@p.draw(G)
	# Move current piece right if possible
	r: =>
		if @check(@p.clone().r())
			@p.r()
			@p.draw(G)
	# Rotate current piece right if possible
	rotR: =>
		if @check(@p.clone().rotR())
			@p.rotR()
			@p.draw(G)
	# Rotate current piece left if possible
	rotL: => @rotR() for [1..3]
	# Persist piece into the game state. This essentially makes it a static block instead of a moving piece
	persist: (p)=>
		@m[coord[1]][coord[0]]=p.color for coord in p.bounds()
	# Game over handler
	gameover: =>
		@toggle()
		txt=G.text(0.5*width*size,2*size,"game over\n⏎ to start")
		txt.attr({"font-size":"30pt"})
		@init()
	# Redraw game board and check for fully filled rows which will be cleaned and added to the high score
	draw: =>
		# Remove all blocks
		b.remove() for b in @blocks
		# Check how many rows the player erased
		rowsKilled=0
		for y,row of @m
			full=true
			for x,col of row
				full=false if col==null
			if full
				rowsKilled+=1
				@m.splice(y,1)
				@m.unshift []
				@m[0].push null for i in [1..width]
		# High score computation, score is exponential w.r.t. the number of lines killed in one step
		@score+=M.pow(2,rowsKilled-1)*1000 if rowsKilled>0
		$("#s").html(@score)
		# Redraw game board
		for y,row of @m
			for x,col of row
				if col!=null
					b=G.rect((x*1.0)*size,(y*1.0)*size,size,size)
					b.attr("fill",col)
					b.attr("stroke","#000")
					@blocks.push b
	# toggles pause
	toggle: =>
		if @i&&@i!=null
			clearInterval(@i)
			@i=null
		else
			@i=setInterval(@tick,1000)
		if txt!=null
			txt.remove()
			txt=null

# Instance of the game and key handlers
i=new Game()
k={}
k[13]=i.toggle
k[37]=i.l
k[39]=i.r
k[38]=i.rotR
k[40]=i.rotL
k[32]=i.drop
$(document).keydown (e) ->
	if(k[e.which])
		k[e.which]()
