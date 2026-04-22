extends "res://Scripts/Entity.gd"

@onready var health_bar = $CanvasLayer/ProgressBar

func _ready():
	health_bar.max_value = health
	health_bar.value = health
	VirusManager.jump_to_entity(self)

func take_damage(amount):
	super.take_damage(amount) # Llama al daño de Entity.gd
	health_bar.value = health



func _physics_process(delta):
	# Esto obliga a Godot a ejecutar también el código de Entity.gd
	super._physics_process(delta)
	super.update_visuals()
