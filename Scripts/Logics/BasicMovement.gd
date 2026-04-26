extends LogicSlot
class_name BasicMovement

@export var jump_chance: float = 0.0 # Opcional: probabilidad de salto por frame
@export var jump_force: float = -400.0

func execute(actor: CharacterBody2D):
	var entity = actor as Entity
	if not entity: return
	
	# Si el cerebro (behavior) ha definido una dirección, la seguimos
	if entity.move_direction != Vector2.ZERO:
		var prev_vel_x = entity.velocity.x
		entity.velocity.x = entity.move_direction.x * entity.speed
		
		# Log solo si cambia de dirección de movimiento significativa
		if sign(prev_vel_x) != sign(entity.velocity.x) and abs(entity.velocity.x) > 0:
			print("[%s] Cambiando rumbo segun el Cerebro (x: %.1f)" % [entity.name, entity.velocity.x])
		
		if entity.move_direction.x > 0: entity.direction = 1
		elif entity.move_direction.x < 0: entity.direction = -1
	else:
		# Fallback: Patrulla básica si no hay dirección del cerebro
		var prev_dir = entity.direction
		entity.velocity.x = entity.direction * entity.speed
		
		# Girar si choca con una pared
		if entity.is_on_wall():
			entity.direction *= -1
			print("[%s] Obstaculo detectado. Girando patrulla a: %d" % [entity.name, entity.direction])
	
	# --- Lógica de Salto Opcional ---
	if entity.is_on_floor() and jump_chance > 0 and randf() < jump_chance:
		print("[%s] ¡Salto impulsivo!" % entity.name)
		entity.velocity.y = jump_force
