extends "res://Scripts/Entity.gd"

var target: Entity = null

func _on_ai_tick():
	# Si estamos poseídos por el jugador, la IA no actúa (el jugador decide o se queda quieto)
	if is_possessed: return 

	# Buscar al VIP en el área de detección
	var bodies = $DetectionArea.get_overlapping_bodies()
	for body in bodies:
		if body is Entity and body.is_vip:
			target = body
			break
	
	if target:
		# Lógica de combate: si está cerca, ataca. Si no, camina hacia él.
		var distance = global_position.distance_to(target.global_position)
		
		if distance < 50: # Distancia de ataque
			execute_action(brain_slots[0]) # Usa su primer slot
		else:
			# Cambiar dirección hacia el objetivo
			direction = 1 if target.global_position.x > global_position.x else -1
	
	super._on_ai_tick() # Ejecuta el resto de la lógica base
