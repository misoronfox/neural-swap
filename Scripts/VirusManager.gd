extends Node

var current_host: Entity = null

func jump_to_entity(target: Entity):
	if current_host == target: return # Ya estamos aquí
	
	if current_host == null:
		# Primer salto (al inicio del juego)
		possess(target)
	else:
		# Realizar el Neural Swap (Intercambio obligatorio)
		perform_swap(current_host, target)
		possess(target)

func possess(new_host: Entity):
	# Quitar estado al anterior
	if current_host:
		current_host.is_possessed = false
		current_host.modulate = Color.WHITE # Color normal
	
	# Aplicar estado al nuevo
	current_host = new_host
	current_host.is_possessed = true
	current_host.modulate = Color(0.5, 1.5, 0.5) # Tinte verde "virus"
	
	print("Virus habitando: ", current_host.name)

func perform_swap(origin: Entity, target: Entity):
	# Elegimos un slot aleatorio de cada uno para intercambiar
	# Según tu GDD, esto es obligatorio para saltar.
	var slot_idx_origin = randi() % 3
	var slot_idx_target = randi() % 3
	
	var temp_slot = origin.brain_slots[slot_idx_origin]
	origin.brain_slots[slot_idx_origin] = target.brain_slots[slot_idx_target]
	target.brain_slots[slot_idx_target] = temp_slot
	
	print("¡SWAP! Intercambiado slot ", slot_idx_origin, " por ", slot_idx_target)
