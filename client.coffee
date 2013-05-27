$(window).focus()

# Instance of the game and key handlers
instance=new window.Game($(".g"),$(".n"),$(".s"))
keymap=
	13: instance.toggle
	37: instance.moveLeft
	39: instance.moveRight
	38: instance.rotateRight
	40: instance.rotateLeft
	32: instance.drop

$(window).keydown (e)->
	func=keymap[e.which];
	if func?
		func()
		false
