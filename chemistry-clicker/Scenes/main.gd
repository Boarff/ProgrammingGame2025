extends Node2D

## for debug timer
var time = 0

## Access to nodes
@onready var Scroll = $Shops/Scroll
@onready var Clicker = $Clicker

## Paths for file storage
var elementProgressPath = "user://elementProgress.save"
var elemPerSecPath = "user://elemPerSec.save"
var elemPerClickPath = "user://elemPerClick.save"
var protonDecimalPath = "user://protonDecimal.save"
var neutronDecimalPath = "user://neutronDecimal.save"
var protonMagnitudePath = "user://protonMagnitude.save"
var neutronMagnitudePath = "user://neutronMagnitude.save"
var upgradesPath = "user://upgrades.save"
var upgradePricesPath = "user://upgradePrices.save"
var upgradesTotalPath = "user://upgradesTotal.save"


## Active variables
var elementProgress = 1
var elemPerSec = 0
var elemPerClick = 1
var protonDecimal = 0
var neutronDecimal = 0
var protonMagnitude = 0
var neutronMagnitude = 0
var upgrades = [0, 0, 0, 0, 0, 0]
var upgradePrices = [100, 150, 50000, 700000, 85000000, 50000000000]
var upgradesTotal = 0

## on scene ready
func _ready() -> void:
	$Save.visible = true
	$Load.visible = true
	$YouWin.visible = false
	Scroll.gameWon.connect(_on_game_won)

## hides save and load, and shows win message
func _on_game_won():
	$Save.visible = false
	$Load.visible = false
	$YouWin.visible = true

## Loads saved game
func _on_load_button_down() -> void:
	elementProgress = load_file(elementProgressPath, 1)
	elemPerSec = load_file(elemPerSecPath, 0)
	elemPerClick = load_file(elemPerClickPath, 1)
	protonDecimal = load_file(protonDecimalPath, 0)
	neutronDecimal = load_file(neutronDecimalPath, 0)
	protonMagnitude = load_file(protonMagnitudePath, 0)
	neutronMagnitude = load_file(neutronMagnitudePath, 0)
	upgrades = load_file(upgradesPath, [0, 0, 0, 0, 0, 0])
	upgradePrices = load_file(upgradePricesPath, [100, 150, 50000, 700000, 85000000, 50000000000])
	upgradesTotal = load_file(upgradesTotalPath, 0)
	
	Scroll.update_display()
	elementProgress = floor(upgradesTotal/10) + 1
	Clicker.animation_frame(elementProgress - 1)
	

## Returns given file as variable
func load_file(filePath, defaultValue):
	if FileAccess.file_exists(filePath):
		var file = FileAccess.open(filePath, FileAccess.READ)
		var fileValue = file.get_var()
		if fileValue != null:
			return fileValue
		else:
			print("empty file: " + str(filePath))
			return defaultValue
	else:
		print("no such file: " + str(filePath))
		return defaultValue

## Saves the game
func _on_button_button_down() -> void:
	save_file(elementProgressPath, elementProgress)
	save_file(elemPerSecPath, elemPerSec)
	save_file(elemPerClickPath, elemPerClick)
	save_file(protonDecimalPath, protonDecimal)
	save_file(neutronDecimalPath, neutronDecimal)
	save_file(protonMagnitudePath, protonMagnitude)
	save_file(neutronMagnitudePath, neutronMagnitude)
	save_file(upgradesPath, upgrades)
	save_file(upgradePricesPath, upgradePrices)
	save_file(upgradesTotalPath, upgradesTotal)

## Saves given file with given input
func save_file(filePath, input):
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	file.store_var(input)



## Handles all the interactions with proton and neutron numbers
## switch = choose what the function should do
## options include: set; get; get_text; add_to; smaller_than; bigger_than
## ... _proton or _neutron
##
## regularNumber = what is sounds like, input a normal number
##
## decimal, magnitude = scientific notation, input a converted number
## ( less taxing )
func numbers(switch, regularNumber = null, decimal = null, magnitude = null):
	
	
	# if a normal number is inputted, converts it to scientific notation
	if regularNumber != null:
		
		# the script cant handle zero, so this handles that
		if regularNumber == 0:
			magnitude = 0
			decimal = 0
		else:
			
			# the conversion script can't deal with negative numbers, so this handles that
			var negativeness = regularNumber / abs(regularNumber)
			regularNumber *= negativeness
			
			#  log in godot is ln
			#  ln(x) / ln(10) is the same as log10(x)
			#  finds magnitude of number usin log10
			magnitude = int( floor( log(regularNumber) / log(10) ) )
			
			# turns number into decimal
			decimal = regularNumber/pow(10,magnitude)
			
			# if number was negative, makes this happen
			decimal *= negativeness
	
	# Massive switch statement for different uses of the function
	match switch:
		# sets the number to the input number
		"set_proton":
			protonDecimal = decimal
			protonMagnitude = magnitude
		"set_neutron":
			neutronDecimal = decimal
			neutronMagnitude = magnitude
		# returns the numbers in string form for display
		"get_proton_text":
			# x100, then round, then /100 for 2 decimal places (1.23)
			var roundedDec = float(round(protonDecimal*100))/100
			return str(roundedDec) + "e+" + str(int(round(protonMagnitude)))
		"get_neutron_text":
			var roundedDec = float(round(neutronDecimal*100))/100
			return str(roundedDec) + "e+" + str(int(round(neutronMagnitude)))
		# adds the inputed number to the stored number
		"add_to_proton":
			# if magnitude of added number >= magnitude of stored number
			if magnitude >= protonMagnitude:
				# stored decimal set to added decimal + stored decimal adjusted to magnitude diff
				protonDecimal = decimal + (protonDecimal / pow(10,magnitude - protonMagnitude))
				protonMagnitude = magnitude
			else:
				# adds added dec, but adjusted to diff in magnitude
				protonDecimal += decimal / pow(10,protonMagnitude - magnitude)
			
			var roundedDecimal = round(protonDecimal*1000)/1000
			
			# if decimal is 0.9 or 10 or somthng
			if (1>protonDecimal || roundedDecimal>=10)&&(protonDecimal!=0):
				# finds the magnitude of the decimal
				var changedMag = floor(log(roundedDecimal)/log(10))
				
				#debugging
				#print("")
				#print(time)
				#print("changedMag " + str(changedMag))
				
				# applies change to correct format
				protonMagnitude += changedMag
				protonDecimal /= pow(10,changedMag)
			
		"add_to_neutron":
			if magnitude >= neutronMagnitude:
				neutronDecimal = decimal + (neutronDecimal / pow(10,magnitude - neutronMagnitude))
				neutronMagnitude = magnitude
			else:
				neutronDecimal += decimal / pow(10,neutronMagnitude - magnitude)
			
			var roundedDecimal = round(neutronDecimal*1000)/1000
			
			if (1>neutronDecimal || roundedDecimal>=10)&&(neutronDecimal!=0):
				var changedMag = floor(log(roundedDecimal)/log(10))
				
				neutronMagnitude += changedMag
				neutronDecimal /= pow(10,changedMag)
		# compares inputted number to stored number
		"smaller_than_proton":
			if magnitude == protonMagnitude:
				return decimal < protonDecimal
			else:
				return magnitude < protonMagnitude
		"smaller_than_neutron":
			if magnitude == neutronMagnitude:
				return decimal < neutronDecimal
			else:
				return magnitude < neutronMagnitude
		"bigger_than_proton":
			if magnitude == protonMagnitude:
				return decimal > protonDecimal
			else:
				return magnitude > protonMagnitude
		"bigger_than_neutron":
			if magnitude == neutronMagnitude:
				return decimal > neutronDecimal
			else:
				return magnitude > neutronMagnitude

## Automatic debugging if needed
func _on_debug_timer_timeout() -> void:
	time += 1
	#_debug()

## Prints variables for debugging
func _debug():
	print("")
	print(time)
	print("protonDec " + str(protonDecimal))
	print("protonMag " + str(protonMagnitude))
	print("neutronDec " + str(neutronDecimal))
	print("neutronMag " + str(neutronMagnitude))
