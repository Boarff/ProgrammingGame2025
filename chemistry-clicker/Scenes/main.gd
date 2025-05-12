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

func _numbers(switch, regularNumber = null, decimal = null, magnitude = null):
	
	if regularNumber != null:
		magnitude = int( floor( log(regularNumber) / log(10) ) )
		decimal = regularNumber/pow(10,magnitude)
	
	match switch:
		"set_proton":
			protonDecimal = decimal
			protonMagnitude = magnitude
		"set_neutron":
			neutronDecimal = decimal
			neutronMagnitude = magnitude
		"get_proton_text":
			var roundedDec = (int(round(protonDecimal*1000)))/1000
			return str(roundedDec) + "e+" + str(protonMagnitude)
		"get_neutron_text":
			var roundedDec = (int(round(neutronDecimal*1000)))/1000
			return str(roundedDec) + "e+" + str(neutronMagnitude)
		"add_to_proton":
			if magnitude >= protonMagnitude:
				protonDecimal += decimal * pow(10,magnitude - protonMagnitude)
			else:
				protonDecimal += decimal * pow(10,protonMagnitude - magnitude)
			
			if protonDecimal > 1:
				protonMagnitude -= 1
				protonDecimal *= 10
			elif protonDecimal >= 10:
				protonMagnitude += 1
				protonDecimal *= 0.1
		"add_to_neutron":
			if magnitude >= neutronMagnitude:
				neutronDecimal += decimal * pow(10,magnitude - neutronMagnitude)
			else:
				neutronDecimal += decimal * pow(10,neutronMagnitude - magnitude)
			
			if neutronDecimal > 1:
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
	print("")
	print(time)
	print("protonDec " + str(protonDecimal))
	print("protonMag " + str(protonMagnitude))
	print("")
	print("neutronDec " + str(neutronDecimal))
	print("neutronMag " + str(neutronMagnitude))
