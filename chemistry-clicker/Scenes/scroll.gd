extends Control

# provides access to main and shops for changing variables
@onready var Main = $"/root/Main"
@onready var Shops = $"/root/Main/Shops"
@onready var Clicker = $"/root/Main/Clicker"

# constants for easy changing of price increase or effects
const costIncrease = 1.1
const upgradeEffects = [1, 1.05, 1000, 1.5, 5000000, 5]

# Function for changing the displayed costs.
func _laceration_text_change(index, text):
	match index:
		0:
			$ScrollContainer/VBoxContainer/Bones1/Ear_drums/Laceration.text = text
		1:
			$ScrollContainer/VBoxContainer/Bones2/Ear_drums/Laceration.text = text
		2:
			$ScrollContainer/VBoxContainer/Bones3/Ear_drums/Laceration.text = text
		3:
			$ScrollContainer/VBoxContainer/Bones4/Ear_drums/Laceration.text = text
		4: 
			$ScrollContainer/VBoxContainer/Bones5/Ear_drums/Laceration.text = text
		5:
			$ScrollContainer/VBoxContainer/Bones6/Ear_drums/Laceration.text = text

# Function for changing the displayed total upgrades bought
func _stomach_text_change(index, text):
	match index:
		0:
			$ScrollContainer/VBoxContainer/Bones1/Stomach.text = text
		1:
			$ScrollContainer/VBoxContainer/Bones2/Stomach.text = text
		2:
			$ScrollContainer/VBoxContainer/Bones3/Stomach.text = text
		3:
			$ScrollContainer/VBoxContainer/Bones4/Stomach.text = text
		4: 
			$ScrollContainer/VBoxContainer/Bones5/Stomach.text = text
		5:
			$ScrollContainer/VBoxContainer/Bones6/Stomach.text = text

# Function to handle purchases of upgrades
func _upgrade(index):
	match index:
		
		# Upgrades using protons for elements per second
		0,2,4:
			# check balance and remove used protons
			if !Main._numbers("bigger_than_proton",Main.upgradePrices[index]):
			#if Main.protonTotal >= Main.upgradePrices[index]:
				Main._numbers("add_to_proton", 0-Main.upgradePrices[index])
				#Main.protonTotal -= Main.upgradePrices[index]
				
				# applies the effect of the upgrade
				Main.elemPerSec += upgradeEffects[index]
				
				upgradeManagement(index, " protons")
		
		# Upgrades using neutrons for elements per click
		1,3,5:
			
			# check balance and remove used neutrons
			#if Main.neutronTotal >= Main.upgradePrices[index]:
			if !Main._numbers("bigger_than_neutron",Main.upgradePrices[index]):
				#Main.neutronTotal -= Main.upgradePrices[index]
				Main._numbers("add_to_neutron", 0-Main.upgradePrices[index])
				
				# applies the effect of the upgrade
				Main.elemPerClick *= upgradeEffects[index]
				upgradeManagement(index, " neutrons")


func upgradeManagement(index, text):
	
	# increases the price
	Main.upgrades[index] += 1
	Main.upgradePrices[index] *= costIncrease
	
	# handles displayed price numbers
	_laceration_text_change(index, Shops._as_scientific_string(Main.upgradePrices[index]) + text)
	_stomach_text_change(index, Shops._as_scientific_string(Main.upgrades[index]))
	
	# adds to total upgrades
	Main.upgradesTotal += 1
	Main.elementProgress = floor(Main.upgradesTotal/10) + 1
	Clicker._animation_frame(Main.elementProgress - 1)


###
###   Handles button signals and activates function
###

func _on_bones_button_down_1() -> void:
	_upgrade(0)
	

func _on_bones_button_down_2() -> void:
	_upgrade(1)

func _on_bones_button_down_3() -> void:
	_upgrade(2)


func _on_bones_button_down_4() -> void:
	_upgrade(3)


func _on_bones_button_down_5() -> void:
	_upgrade(4)


func _on_bones_button_down_6() -> void:
	_upgrade(5)
