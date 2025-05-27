extends Control

## Signal for end of game
signal gameWon

## Provides access to nodes
@onready var Main = $"/root/Main"
@onready var Shops = $"/root/Main/Shops"
@onready var Clicker = $"/root/Main/Clicker"

## Constants
const costIncrease = 1.1
const upgradeEffects = [1, 1.05, 100, 1.1, 100000, 2]

func _ready() -> void:
	Clicker.animation_frame(Main.elementProgress - 1)

## Updates the displayed costs and totals for upgrades
func update_display():
	var text
	var switch = 1
	
	for index in 6:
		if switch > 0:
			text = " protons"
		else:
			text = " neutrons"
		switch *= -1
		_tinnitus_text_change(index, Shops.as_scientific_string(Main.upgradePrices[index]) + text)
		_stomach_text_change(index, Shops.as_scientific_string(Main.upgrades[index]))

## Input the index and a string to display on that button's cost
## index starts at 0
func _tinnitus_text_change(index, text):
	
	match index:
		0:
			$ScrollContainer/VBoxContainer/Bones1/Ear_drums/Tinnitus.text = text
		1:
			$ScrollContainer/VBoxContainer/Bones2/Ear_drums/Tinnitus.text = text
		2:
			$ScrollContainer/VBoxContainer/Bones3/Ear_drums/Tinnitus.text = text
		3:
			$ScrollContainer/VBoxContainer/Bones4/Ear_drums/Tinnitus.text = text
		4: 
			$ScrollContainer/VBoxContainer/Bones5/Ear_drums/Tinnitus.text = text
		5:
			$ScrollContainer/VBoxContainer/Bones6/Ear_drums/Tinnitus.text = text

## Input the index and a string to display on that button's upgrades bought
## index starts at 0
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

## Greys out any buttons for upgrades the player can't afford
func _process(delta: float) -> void:
	# if upgrade price is smaller than number of protons, ungrey the box
	if Main.numbers("smaller_than_proton", Main.upgradePrices[0]):
		$ScrollContainer/VBoxContainer/Bones1/Hair.visible = false
	else:
		$ScrollContainer/VBoxContainer/Bones1/Hair.visible = true
	
	# if upgrade price is smaller than number of neutrons, ungrey the box
	if Main.numbers("smaller_than_neutron", Main.upgradePrices[1]):
		$ScrollContainer/VBoxContainer/Bones2/Hair.visible = false
	else:
		$ScrollContainer/VBoxContainer/Bones2/Hair.visible = true
	
	# if upgrade price is smaller than number of protons, ungrey the box
	if Main.numbers("smaller_than_proton", Main.upgradePrices[2]):
		$ScrollContainer/VBoxContainer/Bones3/Hair.visible = false
	else:
		$ScrollContainer/VBoxContainer/Bones3/Hair.visible = true
	
	# if upgrade price is smaller than number of neutrons, ungrey the box
	if Main.numbers("smaller_than_neutron", Main.upgradePrices[3]):
		$ScrollContainer/VBoxContainer/Bones4/Hair.visible = false
	else:
		$ScrollContainer/VBoxContainer/Bones4/Hair.visible = true
	
	# if upgrade price is smaller than number of protons, ungrey the box
	if Main.numbers("smaller_than_proton", Main.upgradePrices[4]):
		$ScrollContainer/VBoxContainer/Bones5/Hair.visible = false
	else:
		$ScrollContainer/VBoxContainer/Bones5/Hair.visible = true
	
	# if upgrade price is smaller than number of neutrons, ungrey the box
	if Main.numbers("smaller_than_neutron", Main.upgradePrices[5]):
		$ScrollContainer/VBoxContainer/Bones6/Hair.visible = false
	else:
		$ScrollContainer/VBoxContainer/Bones6/Hair.visible = true

## Input a button index for which an upgrade should be bought.
## Index starts at 0.
func upgrade(index):
	
	match index:
		
		# Upgrades using protons for elements per second
		0,2,4:
			# check balance and remove used protons
			if !Main.numbers("bigger_than_proton",Main.upgradePrices[index]):
			#if Main.protonTotal >= Main.upgradePrices[index]:
				Main.numbers("add_to_proton", 0-Main.upgradePrices[index])
				#Main.protonTotal -= Main.upgradePrices[index]
				
				# applies the effect of the upgrade
				Main.elemPerSec += upgradeEffects[index]
				
				upgrade_management(index, " protons")
		
		# Upgrades using neutrons for elements per click
		1,3,5:
			
			# check balance and remove used neutrons
			#if Main.neutronTotal >= Main.upgradePrices[index]:
			if !Main.numbers("bigger_than_neutron",Main.upgradePrices[index]):
				#Main.neutronTotal -= Main.upgradePrices[index]
				Main.numbers("add_to_neutron", 0-Main.upgradePrices[index])
				
				# applies the effect of the upgrade
				Main.elemPerClick *= upgradeEffects[index]
				upgrade_management(index, " neutrons")

## Input the index and " protons" or " neutrons".
## Handles upgrade totals, text changes, cost increses, and elementProgress.
func upgrade_management(index, text):
	
	# increases the price
	Main.upgrades[index] += 1
	Main.upgradePrices[index] *= costIncrease
	
	# handles displayed price numbers
	_tinnitus_text_change(index, Shops.as_scientific_string(Main.upgradePrices[index]) + text)
	_stomach_text_change(index, Shops.as_scientific_string(Main.upgrades[index]))
	
	# adds to total upgrades
	Main.upgradesTotal += 1
	Main.elementProgress = floor(Main.upgradesTotal/10) + 1
	if Main.elementProgress >= 70:
		gameWon.emit()
		Main.elementProgress = 69
	Clicker.animation_frame(Main.elementProgress - 1)


#   Handles button signals and activates function
#

func _on_bones_button_down_1() -> void:
	upgrade(0)

func _on_bones_button_down_2() -> void:
	upgrade(1)

func _on_bones_button_down_3() -> void:
	upgrade(2)


func _on_bones_button_down_4() -> void:
	upgrade(3)


func _on_bones_button_down_5() -> void:
	upgrade(4)


func _on_bones_button_down_6() -> void:
	upgrade(5)
