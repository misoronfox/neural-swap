extends Node

signal hosts_updated(previous: Entity, current: Entity)

var current_host: Entity = null
var previous_host: Entity = null

func jump_to_entity(target: Entity):
	if current_host == target: return
	
	previous_host = current_host
	possess(target)
	hosts_updated.emit(previous_host, current_host)

func possess(new_host: Entity):
	if current_host:
		current_host.is_possessed = false
		current_host.modulate = Color.WHITE
	
	current_host = new_host
	current_host.is_possessed = true
	current_host.modulate = Color(0.5, 1.5, 0.5)
	
	print("Virus habitando: ", current_host.name)

## Realiza un intercambio basado en el TIPO de lógica (Combat, Movement, Behavior)
func perform_swap_by_type(type: LogicSlot.Type):
	if not previous_host or not current_host: return
	
	# Aseguramos que ambos tengan arrays de tamaño 3 para evitar errores de índice
	_ensure_brain_size(previous_host)
	_ensure_brain_size(current_host)
	
	# Buscamos los índices donde cada entidad tiene ese tipo de lógica
	var idx_prev = _get_index_for_type(previous_host, type)
	var idx_curr = _get_index_for_type(current_host, type)
	
	# Intercambiamos los recursos
	var temp_slot = previous_host.brain_slots[idx_prev]
	previous_host.brain_slots[idx_prev] = current_host.brain_slots[idx_curr]
	current_host.brain_slots[idx_curr] = temp_slot
	
	print("¡SWAP por TIPO (", type, ")! entre ", previous_host.name, " y ", current_host.name)
	hosts_updated.emit(previous_host, current_host)

func _ensure_brain_size(entity: Entity):
	while entity.brain_slots.size() < 3:
		entity.brain_slots.append(null)

func _get_index_for_type(entity: Entity, type: LogicSlot.Type) -> int:
	# 1. Intentar encontrar un slot existente de ese tipo
	for i in range(entity.brain_slots.size()):
		var slot = entity.brain_slots[i]
		if slot and slot.type == type:
			return i
	
	# 2. Si no hay ninguno, usar un índice por defecto según el tipo
	var default_idx = 0
	match type:
		LogicSlot.Type.COMBAT: default_idx = 0
		LogicSlot.Type.BEHAVIOR: default_idx = 1
		LogicSlot.Type.MOVEMENT: default_idx = 2
	
	# Aseguramos que el índice por defecto no se pase del tamaño actual (aunque _ensure_brain_size ya ayuda)
	return clampi(default_idx, 0, entity.brain_slots.size() - 1)
