extends Node
class_name Consts


const LEVEL_SIZES := [
	Vector2(30, 30),
	Vector2(35, 35),
	Vector2(40, 40),
	Vector2(45, 45),
	Vector2(50, 50),
	Vector2(30, 30)
]
const LEVEL_ROOM_COUNTS := [5, 7, 9, 12, 15, 2]
const LEVEL_ENEMY_COUNTS := [7, 12, 16, 21, 28, 0]

const MAX_LOOT_COST_ON_LEVEL := [0, 1, 2, 3, 4, 4]
const MAX_MODIFIER_COST_ON_LEVEL := [0, 0, 1, 1, 2, 2]

const FIRST_MODIFIER_CHANCE_ON_LEVEL := [0.33, 0.5, 0.75, 1, 1, 1]
const SECOND_MODIFIER_CHANCE_ON_LEVEL := [0, 0, 0.15, 0.15, 0.3, 0.5]
const ANCIENT_CHANCE_ON_LEVEL := [0, 0, 0, 0.1, 0.1, 0.1]
