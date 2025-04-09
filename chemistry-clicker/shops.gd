extends Control
# todo: Change to a file later
var protonTotal = 0
var neutronTotal = 0
var elementProgress = 1
# nuclides
var nuclidesDict = {
	1: [0,1],
	2: [1,2],
	3: [3,4],
	4: 5,
	5: [6,5],
	6: [6,7],
	7: [8,7],
	8: [8,9,10],
	9: 10,
	10: [10,11,12],
	11: 12,
	12: [12,13,14],
	13: 14,
	14: [14,15,16],
	15: 16,
	16: [18,20,16,17],
	17: [20,18],
	18: [20,22],
	19: [22,20],
	20: [24,22,23],
	21: 24,
	22: [28,26,27,24,25],
	23: 28,
	24: [28,30,29],
	25: 30,
	26: [30,32,31],
	27: 32,
	28: [34,32,33,36],
	29: [34,36],
	30: [36,38,37],
	31: [38,40],
	32: [40,38,42,41],
	33: 42,
	34: [42,44,43],
	35: [44,46],
	36: [46,48,44,47],
	37: 48,
	38: [50,48,49],
	39: 50,
	40: [50,51,52],
	41: 52,
	42: [52,54,53,55],
	43: 55,
	44: [54,56,55,58,57],
	45: 58,
	46: [58,60,59,62],
	47: [60,62],
	48: [62,64,63],
	49: 64,
	50: [64,66,65,68,67,70,69],
	51: [70,72],
	52: [70,72,74,73],
	53: 74,
	54: [74,76,75,78,77],
	55: 78,
	56: [78,80,79,81,82],
	57: 82,
	58: 82,
	59: 82,
	60: 82,
	61: 84,
	62: [88,89],
	63: 89,
	64: [92,93,94],
	65: 94,
	66: [97,98],
	67: 98,
	68: [99,100],
	69: 100,
}

@onready var protDisplay = $Protons/ProtNum
@onready var neutDisplay = $Neutrons/NeutNum

func _ready():
	var clicker = get_node("/root/Main/Clicker")
	clicker.click.connect(_on_clicker_click)

func _process(delta):
	protDisplay.text = _as_scientific_string(protonTotal)
	neutDisplay.text = _as_scientific_string(neutronTotal)

func _on_clicker_click():
	protonTotal += elementProgress
	neutronTotal += nuclidesDict[elementProgress].pick_random()
	

func _as_scientific_string(number):
	if number == 0:
		return "0.0e+0"
	else:
		var negativeness = 1
		if number < 0:
			negativeness = -1
			number = number * -1
		var sigFig = 3
		var length = int(floor( log(number) / log(10) ))
		var decimal = round( number / (pow(10,length - sigFig)) ) / pow(10,sigFig)
		
		return (str(decimal*negativeness) + "e+" + str(length))
