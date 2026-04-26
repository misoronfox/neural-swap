extends "res://Scripts/Entity.gd"

var target: Entity = null

func _on_ai_tick():
	# Buscar al VIP en el área de detección (Sensores)
	var bodies = $DetectionArea.get_overlapping_bodies()
	for body in bodies:
		if body is Entity and body.is_vip:
			target = body
			current_target = body # Sincronizamos con el estado de Entity
			break
	
	# En lugar de ejecutar lógica aquí, dejamos que behavior_slot orqueste
	# si es que existe. Si no existe, podemos tener un comportamiento por defecto.
	super._on_ai_tick()

# Nota: Si queremos que el behavior_slot sea realmente intercambiable, 
# la lógica de "perseguir y atacar" debería estar en un recurso LogicSlot de tipo BEHAVIOR.
