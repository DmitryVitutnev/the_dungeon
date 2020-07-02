extends Node


func _ready() -> void:
	randomize()

"""
This function parses strings like
1d6+2d4+1
then rolls needed values and returns result
"""
func from_string(string : String) -> int:
	var parts = string.split("+")
	var result = 0
	for p in parts:
		if p.find("d") == -1:
			result += p.to_int()
		else:
			var sub_parts = p.split("d")
			var number = sub_parts[0].to_int()
			var dice = sub_parts[1].to_int()
			result += dx(number, dice)
	return result


func from_d_to_interval(string : String) -> String:
	var parts := string.split("+")
	var min_v := 0
	var max_v := 0
	for p in parts:
		if p.find("d") == -1:
			min_v += p.to_int()
			max_v += p.to_int()
		else:
			var sub_parts = p.split("d")
			var number = sub_parts[0].to_int()
			var dice = sub_parts[1].to_int()
			min_v += number
			max_v += number * dice
	var result
	if min_v == max_v:
		result = str(min_v)
	else:
		result = str(min_v) + "-" + str(max_v)
	return result


func d2(number : int) -> int:
	return dx(number, 2)


func d3(number : int) -> int:
	return dx(number, 3)


func d4(number : int) -> int:
	return dx(number, 4)


func d6(number : int) -> int:
	return dx(number, 6)


func d8(number : int) -> int:
	return dx(number, 8)


func d10(number : int) -> int:
	return dx(number, 10)


func d20(number : int) -> int:
	return dx(number, 20)


func d100(number : int) -> int:
	return dx(number, 100)


func dx(number : int, x : int) -> int:
	var result := 0
	for i in range(number):
		result += 1 + randi() % x
	return result
