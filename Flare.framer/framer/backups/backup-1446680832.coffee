screensize = 425

# Set background
bg = new BackgroundLayer 
	backgroundColor: "#ffffff"

mask = new Layer
	width: 500
	height: 650
	image: "images/Frame.png"
mask.center()

# Create PageComponent
page = new PageComponent
	superLayer: mask 
	width: screensize
	height: screensize
# 	scrollHorizontal: false
	scrollVertical: false
page.center()	




# title page
title = new Layer 
	superLayer: page.content
	width: screensize
	height: screensize
	backgroundColor: "#000000"
	opacity: 1
	image:"images/title2.png"
title.states.add
	tutorial:
        image: "images/tutorial2.png"
    stateB:
        x: 200
        opacity: 1

back = new Layer 
	superLayer: page.content
	width: screensize
	height: screensize
	backgroundColor: "#FFA500"
	#FFA500 orange
	#00ff00 green
	opacity: 0
	x: screensize - 1

direction = new Layer 
	superLayer: page.content
	width: screensize
	height: screensize
	backgroundColor: "#000000"
	opacity: 1
	x: screensize - 1
	image:"images/estimate2.png"
direction.states.add
    turn:
        image: "images/turn2.png"
direction.states.add
	signala:
        image: "images/signalright.png"
        # animate this
	again:
		image: "images/estimate2.png"
direction.states.add
    turnb:
        image: "images/turn3.png" 
direction.states.add
	signalb:
        image: "images/signalb.png"
        # animate this
	arrived:
		image: "images/arrived3.png"
	

	
	
# direction.animate
# 	properties:
# 		image: "images/signal1.png"
# 		rotationZ: 360
# 		opacity:0
# 	time:1
# 	repeat:100
# direction.on Events.AnimationEnd, ->
#     this.animate
#         properties:
# #             image: "images/signal1b.png"
# 		rotationZ: 360
#         time: 1

anim = new Animation
	layer: direction
	properties:
#         rotationZ: 360
# 		image: "images/tutorial2.png"
		opacity:0
	time: 0.25


anim.on "end", ->
    direction.rotationZ = 0 # need to reset to zero so we can animate to 360 again
    direction.opacity = 1
    anim.start()




# Staging
page.currentPage.opacity = 1

# Update pages
# page.on "change:currentPage", ->
# 	page.previousPage.animate 
# 		properties:
# 			opacity: 0.3
# 		time: 0.4
# 		
# 	page.currentPage.animate 
# 		properties:
# 			opacity: 1
# 		time: 0.4
		
title.on Events.Click, ->
# 	print "click"
	title.states.switch("tutorial")


direction.on Events.Click, ->
	if direction.states.state == "default"
		direction.states.switch("turn")
	else if direction.states.state == "turn"
		direction.states.switch("signala")
		anim.start()
		back.opacity = 1
	else if direction.states.state == "signala"
		direction.states.switch("again")
		anim.stop()
		direction.opacity = 1
		back.opacity = 0
	else if direction.states.state == "again"
		direction.states.switch("turnb")
	else if direction.states.state == "turnb"
		direction.states.switch("signalb")
		anim.start()
		back.opacity = 1
	else if direction.states.state == "signalb"
		direction.states.switch("arrived")
		anim.stop()
		back.opacity = 0
		direction.opacity = 1


# watch frame 
imageLayer = new Layer
	width: 500, height: 680
	image: "images/Frame3.png"
imageLayer.center()