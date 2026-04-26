extends LogicSlot
class_name CowardlyBehavior

func execute(actor: CharacterBody2D):
	var entity = actor as Entity
	if not entity: return
	
	if entity.current_target and is_instance_valid(entity.current_target):
		var target_pos = entity.current_target.global_position
		var my_pos = entity.global_position
		var distance = my_pos.distance_to(target_pos)
		
		# Decidir Movimiento: Siempre intentar ALEJARSE
		var dir_x = -1 if target_pos.x > my_pos.x else 1
		entity.move_direction = Vector2(dir_x, 0)
		print("[%s] ¡PELIGRO! %s cerca (dist: %.1f). Huyendo en direccion: %d" % [entity.name, entity.current_target.name, distance, dir_x])
	else:
		if entity.move_direction != Vector2.ZERO:
			print("[%s] Zona segura. Dejando de huir." % entity.name)
		entity.move_direction = Vector2.ZERO
