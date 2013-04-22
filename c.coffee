X=window
W=$(X)
W.focus()

# Instance of the game and key handlers
i=new X.Game($(".g"),$(".n"),$(".s"))
k=13:i.toggle,37:i.l,39:i.r,38:i.rotR,40:i.rotL,32:i.drop
W.keydown (e)->
	f=k[e.which];
	if(f)
		f()

# # Allow basic movements with a touch screen device
# t=[0,0]
# W.bind "deviceorientation",->t=[event.beta,event.gamma]
# setInterval ->
# 	if (t[1]<-16)
# 		i.l()
# 	if (t[1]>16)
# 		i.r()
# 	if (t[0]>75)
# 		i.drop()
# ,400
# W.bind "touchstart",->i.rotR()
