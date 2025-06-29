extends Control

## List of possible amount of neutrons each element can give.
##
## Index is number of neutrons in the atom;
## returns array of possible neutrons;
## not completely accurate to real life.
var nuclidesDict = {
	1: [0,1],
	2: [1,2],
	3: [3,4],
	4: [5,6],
	5: [6,5],
	6: [6,7],
	7: [8,7],
	8: [8,9,10],
	9: [10,11],
	10: [10,11,12],
	11: [12,13],
	12: [12,13,14],
	13: [14,15],
	14: [14,15,16],
	15: [16,17],
	16: [18,20,16,17],
	17: [20,18],
	18: [20,22],
	19: [22,20],
	20: [24,22,23],
	21: [24,25],
	22: [28,26,27,24,25],
	23: [28,29],
	24: [28,30,29],
	25: [30,31],
	26: [30,32,31],
	27: [32.33],
	28: [34,32,33,36],
	29: [34,36],
	30: [36,38,37],
	31: [38,40],
	32: [40,38,42,41],
	33: [42,43],
	34: [42,44,43],
	35: [44,46],
	36: [46,48,44,47],
	37: [48,49],
	38: [50,48,49],
	39: [50,51],
	40: [50,51,52],
	41: [52,53],
	42: [52,54,53,55],
	43: [55,56],
	44: [54,56,55,58,57],
	45: [58,59],
	46: [58,60,59,62],
	47: [60,62],
	48: [62,64,63],
	49: [64,65],
	50: [64,66,65,68,67,70,69],
	51: [70,72],
	52: [70,72,74,73],
	53: [74,75],
	54: [74,76,75,78,77],
	55: [78,79],
	56: [78,80,79,81,82],
	57: [82,83],
	58: [83,84],
	59: [84,85],
	60: [85,86],
	61: [86,87],
	62: [88,89],
	63: [89,90],
	64: [92,93,94],
	65: [94,95],
	66: [97,98],
	67: [98,99],
	68: [99,100],
	69: [100,101],
}

## Provides access to nodes.
@onready var Main = $".."
@onready var clicker = $"../Clicker"
@onready var Scroll = $Scroll
@onready var protDisplay = $Protons/ProtNum
@onready var neutDisplay = $Neutrons/NeutNum
@onready var EpClick = $EpClick/EpCNum
@onready var EpSecond = $EpSecond/EpSNum

## on scene load
func _ready() -> void:
	Scroll.gameWon.connect(_on_game_won)

## despawns the scene
func _on_game_won():
	queue_free()

## Every frame, adjusts the displayed numbers.
func _process(delta: float) -> void:
	protDisplay.text = Main.numbers("get_proton_text")
	neutDisplay.text = Main.numbers("get_neutron_text")
	EpClick.text = as_scientific_string(Main.elemPerClick)
	EpSecond.text = as_scientific_string(Main.elemPerSec)

## Adds to proton and neutron the amount a click should.
func on_clicker_click():
	
	#setting a variable to the amount ot add, so debugging is easy if needed
	var addtoproton = Main.elementProgress * Main.elemPerClick
	var addtoneutron = nuclidesDict[int(Main.elementProgress)].pick_random() * Main.elemPerClick
	# calling the function from the main script to change the numbers
	Main.numbers("add_to_proton", addtoproton )
	Main.numbers("add_to_neutron", addtoneutron )

## Input a normal number, get back a string in form:
## 1.234e+5
## 3 significant figures.
func as_scientific_string(number):
	
	# can't handle zero
	if number == 0:
		return "0.0e+0"
	else:
		# can't handle negative numbers
		var negativeness = 1
		if number < 0:
			negativeness = -1
			number = number * -1
		# rounds to x significant figures
		var sigFig = 3
		var length = int(floor( log(number) / log(10) ))
		var decimal = round( number / (pow(10,length - sigFig)) ) / pow(10,sigFig)
		
		# returns the overall string
		return (str(decimal*negativeness) + "e+" + str(length))

## Every second, adds EpS * elementProgress to totals
func _on_per_second_timeout() -> void:
	#setting a variable to the amount to add, so debugging is easy if needed
	var addtoproton = Main.elementProgress * Main.elemPerSec
	var addtoneutron = nuclidesDict[int(Main.elementProgress)].pick_random() * Main.elemPerSec
	# calling the function from the main script to change the numbers
	Main.numbers("add_to_proton", addtoproton )
	Main.numbers("add_to_neutron", addtoneutron )
