screensize = 425
white = "#ffffff"
black = "#000000"

# Set background
bg = new BackgroundLayer 
	backgroundColor: white

# Mask layer
mask = new Layer
	width: 500
	height: 650
	color: white
	#image: "images/Frame.png"
mask.center()

# watch frame 
imageLayer = new Layer
	width: 500, height: 680
	image: "images/Frame3.png"
	opacity: 1
imageLayer.center()

# vibrate animation layer
vibrate = new Layer
	width: 128, height: 290
	rotation: 39
	opacity: 0
	x: 50 
	y: 50
	image: "images/vibrate5.png"
vibrate2 = new Layer
	width: 128, height: 290
	rotation: 219
	opacity: 0
	x: 490 
	y: 400
	image: "images/vibrate5.png"



# Create PageComponent for pagination
page = new PageComponent
	superLayer: mask 
	width: screensize
	height: screensize
	backgroundColor: black
# 	scrollHorizontal: false
	scrollVertical: false
page.center()


# First layer
first = new Layer 
	superLayer: page.content
	width: screensize
	height: screensize
	backgroundColor: black
	opacity: 1
	image:"images/title2.png"
first.states.add
	tutorial:
        image: "images/tutorial.png"
    gestureon:
        image: "images/gestureon.png"
        opacity: 1
    gestureoff:
        image: "images/gestureoff.png"
        opacity: 1

# For animation background
back = new Layer 
	width: screensize
	height: screensize
	backgroundColor: "#FFA500"
	#FFA500 orange
	#00ff00 green
	opacity: 0
	x: 2*screensize - 5

# Second Layer
second = new Layer 
	width: screensize
	height: screensize
	backgroundColor: black
	opacity: 1
	x: -2000
	image:"images/main.png"

third = new Layer 
	width: screensize
	height: screensize
	backgroundColor: black
	opacity: 1
	x: 3000
	image:"images/voiceinput.png"
third.states.add
	inputted:
        image: "images/inputted.png"
    direction:
    	image: "images/direction3.png"
third.states.add
    turn:
        image: "images/turnright.png"
third.states.add
	signala:
        image: "images/signalright.png"
	again:
		image: "images/direction4.png"
third.states.add
    turnb:
        image: "images/turnleft.png" 
third.states.add
	signalb:
        image: "images/signalb.png"
	arrived:
		image: "images/arrived3.png"

fourth = new Layer
	width: screensize
	height: screensize
	backgroundColor: black
	opacity: 1
	x: 3000
	image:"images/stop.png"
fourth.states.add
    done:
    	image: "images/done.png"


# second.animate
# 	properties:
# 		image: "images/signal1.png"
# 		rotationZ: 360
# 		opacity:0
# 	time:1
# 	repeat:100
# second.on Events.AnimationEnd, ->
#     this.animate
#         properties:
# #             image: "images/signal1b.png"
# 		rotationZ: 360
#         time: 1

anim = new Animation
	layer: third
	properties:
#         rotationZ: 360
# 		image: "images/tutorial2.png"
		opacity:0
	time: 0.25
anim.on "end", ->
#     third.rotationZ = 0 # need to reset to zero so we can animate to 360 again
    third.opacity = 1
    anim.start()

anim2 = new Animation
	layer: vibrate
	properties:
		opacity:0
	time: 0.5
anim2.on "end", ->
    vibrate.opacity = 1
    anim2.start()
anim3 = new Animation
	layer: vibrate2
	properties:
		opacity:0
	time: 0.5
anim3.on "end", ->
    vibrate2.opacity = 1
    anim3.start()



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
		
# show tutorial after title
first.on Events.Click, ->
	if first.states.state == "default"
		first.states.switch("tutorial")
		second.superLayer = page.content
		second.x = screensize - 1
		back.superLayer = page.content
		third.superLayer = page.content
		third.x = 2*screensize - 4

# remove tutorial page when swiped
second.on Events.MouseOver, ->
	if second.states.state == "default" and first.states.state == "tutorial"
		first.states.switch("gestureon")
second.on Events.MouseOut, ->
	if second.states.state == "default" and first.states.state == "tutorial"
		first.states.switch("gestureon")

# turn on/off gesture button
first.on Events.Click, ->
	if first.states.state == "gestureoff"
		first.states.switch("gestureon")
	else if first.states.state == "gestureon"
		first.states.switch("gestureoff")

# enter destination by voice or phone
third.on Events.Click, ->
	if third.states.state == "default"
		third.states.switch("inputted")
	else if third.states.state == "inputted"
		#page.scrolltolayer does not work
		third.states.switch("direction")
		fourth.x = 3*screensize - 7
		fourth.superLayer = page.content
		page.scrollX = 2*screensize - 5
	else if third.states.state == "direction"
		third.states.switch("turn")
		anim2.start()
		anim3.start()
	else if third.states.state == "turn"
		anim2.stop()
		anim3.stop()
		vibrate.opacity = 0
		vibrate2.opacity = 0
		if first.states.state == "gestureoff"
			third.states.switch("again")
			anim.stop()
			third.opacity = 1
			back.opacity = 0
		else
			third.states.switch("signala")
			anim.start()
			back.opacity = 1
	else if third.states.state == "signala"
		third.states.switch("again")
		anim.stop()
		third.opacity = 1
		back.opacity = 0
	else if third.states.state == "again"
		third.states.switch("turnb")
		anim2.start()
		anim3.start()
	else if third.states.state == "turnb"
		anim2.stop()
		anim3.stop()
		vibrate.opacity = 0
		vibrate2.opacity = 0
		if first.states.state == "gestureoff"
			third.states.switch("arrived")
			anim.stop()
			back.opacity = 0
			third.opacity = 1
		else
			third.states.switch("signalb")
			anim.start()
			back.opacity = 1
	else if third.states.state == "signalb"
		third.states.switch("arrived")
		anim.stop()
		back.opacity = 0
		third.opacity = 1
		fourth.states.switch("done")
		first.superLayer = 0
		first.x = 2000
		second.superLayer = 0
		second.x = 2000
		page.scrollX = 0
# 	else if third.states.state == "arrived"
		# return to second main

# stop direction, back to input
fourth.on Events.Click, ->
	# remove fourth
	fourth.x = 2000
	fourth.superLayer = 0
	fourth.states.switch("default")
	# make third to not inputted
	third.states.switch("default")
	# show first
	first.superLayer = page.content
	first.x = 0
	# show second
	second.superLayer = page.content
	second.x = screensize - 1
	# scroll back to third
	page.scrollX = 2*screensize - 5

