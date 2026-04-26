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
	
	# Intercambiamos los recursos según el tipo
	match type:
		LogicSlot.Type.COMBAT:
			var temp = previous_host.combat_slot
			previous_host.combat_slot = current_host.combat_slot
			current_host.combat_slot = temp
		LogicSlot.Type.BEHAVIOR:
			var temp = previous_host.behavior_slot
			previous_host.behavior_slot = current_host.behavior_slot
			current_host.behavior_slot = temp
		LogicSlot.Type.MOVEMENT:
			var temp = previous_host.movement_slot
			previous_host.movement_slot = current_host.movement_slot
			current_host.movement_slot = temp
	
	print("¡SWAP por TIPO (", type, ")! entre ", previous_host.name, " y ", current_host.name)
	hosts_updated.emit(previous_host, current_host)
