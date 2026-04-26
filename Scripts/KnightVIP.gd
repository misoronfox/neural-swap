extends "res://Scripts/Entity.gd"

@onready var health_bar = $CanvasLayer/ProgressBar

func _ready():
	health_bar.max_value = health
	health_bar.value = health
	VirusManager.jump_to_entity(self)

	super._ready()

func take_damage(amount):
	super.take_damage(amount) # Llama al daño de Entity.gd
	health_bar.value = health

func _on_ai_tick():
	print("KingVIP ontick")
	# Sensor: Encontrar al enemigo más cercano
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = null
	var min_dist = 10000.0
	
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy is Entity:
			var dist = global_position.distance_to(enemy.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_enemy = enemy
	
	current_target = closest_enemy
	
	super._on_ai_tick()

func _physics_process(delta):
	# Esto obliga a Godot a ejecutar también el código de Entity.gd
	super._physics_process(delta)
