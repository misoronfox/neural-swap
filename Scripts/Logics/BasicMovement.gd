extends LogicSlot
class_name BasicMovement

@export var jump_chance: float = 0.0 # Opcional: probabilidad de salto por frame
@export var jump_force: float = -400.0

func execute(actor: CharacterBody2D):
	var entity = actor as Entity
	if not entity: return
	
	# --- Lógica de Patrulla ---
	# Caminar en la dirección actual
	entity.velocity.x = entity.direction * entity.speed
	
	# Girar si choca con una pared
	if entity.is_on_wall():
		entity.direction *= -1
	
	# --- Lógica de Salto Opcional ---
	if entity.is_on_floor() and jump_chance > 0 and randf() < jump_chance:
		entity.velocity.y = jump_force
