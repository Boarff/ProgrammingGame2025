extends Node2D
var clickerScene = preload("res://Scenes/clicker.tscn")
var shopsScene = preload("res://Scenes/shops.tscn")

#var protonTotal = 1000000000000
#var neutronTotal = 1000000000000

var time = 0

var elementProgress = 1

var elemPerSec = 0
var elemPerClick = 1

var upgrades = [0, 0, 0, 0, 0, 0]
var upgradePrices = [100, 150, 50000, 700000, 85000000, 50000000000]
var upgradesTotal = 0


var protonDecimal = 0
var neutronDecimal = 0
var protonMagnitude = 0
var neutronMagnitude = 0

# function for handling everything to do with the stored proton and neutron amounts
func _numbers(switch, regularNumber = null, decimal = null, magnitude = null):
	#_debug()
	var negativeness = 1
	# if a normal number is inputted, converts it to scientific notation
	if regularNumber != null:
		# the script cant handle zero, so this handles that
		if regularNumber == 0:
			magnitude = 0
			decimal = 0
		else:
			# the conversion script can't deal with negative numbers, so this handles that
			negativeness = regularNumber / abs(regularNumber)
			regularNumber *= negativeness
			# log in godot is ln
			# ln(x) / ln(10) = log10(x)
			# finds magnitude of number
			magnitude = int( floor( log(regularNumber) / log(10) ) )
			# turns number into decimal
			decimal = regularNumber/pow(10,magnitude)
			# if number was negative, makes this happen
			decimal *= negativeness
		
		# debugging to make sure the script works
		#print("")
		#print("regularNumber conversion")
		#print(regularNumber)
		#print(magnitude)
		#print(decimal)
	
	# handles the different uses of the function
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
			return str(roundedDec) + "e+" + str(protonMagnitude)
		"get_neutron_text":
			var roundedDec = float(round(neutronDecimal*100))/100
			return str(roundedDec) + "e+" + str(neutronMagnitude)
		# adds the inputed number to the stored number
		"add_to_proton":
			# if magnitude of added number >= magnitude of stored number
			if magnitude >= protonMagnitude:
				# stored decimal set to added decimal + stored decimal adjusted to magnitude diff
				protonDecimal = decimal + (protonDecimal / pow(10,magnitude - protonMagnitude))
			else:
				# adds added dec, but adjusted to diff in magnitude
				protonDecimal += decimal / pow(10,protonMagnitude - magnitude)
			
			if !(1<=protonDecimal || protonDecimal<10):
				var changedMag = floor(log(protonDecimal)/log(10))
				if changedMag <=0:
					changedMag -= 1
				protonMagnitude += changedMag
				protonDecimal /= pow(10,changedMag)
			
			#if protonDecimal < 1 && protonDecimal != 0:
			#	protonMagnitude -= 1
			#	protonDecimal *= 10
			#elif protonDecimal >= 10:
			#	protonMagnitude += 1
			#	protonDecimal *= 0.1
		"add_to_neutron":
			if magnitude >= neutronMagnitude:
				neutronDecimal = decimal + (neutronDecimal / pow(10,magnitude - neutronMagnitude))
			else:
				neutronDecimal += decimal / pow(10,neutronMagnitude - magnitude)
			
			if neutronDecimal < 1 && neutronDecimal != 0:
				neutronMagnitude -= 1
				neutronDecimal *= 10
			elif neutronDecimal >= 10:
				neutronMagnitude += 1
				neutronDecimal *= 0.1
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


func _on_debug_timer_timeout() -> void:
	time += 1
	#_debug()
	
func _debug():
	print("")
	print(time)
	print("protonDec " + str(protonDecimal))
	print("protonMag " + str(protonMagnitude))
	print("neutronDec " + str(neutronDecimal))
	print("neutronMag " + str(neutronMagnitude))
