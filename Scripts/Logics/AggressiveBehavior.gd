extends LogicSlot
class_name AggressiveBehavior

func execute(actor: CharacterBody2D):
	var entity = actor as Entity
	if not entity: return
	
	if entity.current_target and is_instance_valid(entity.current_target):
		var target_pos = entity.current_target.global_position
		var my_pos = entity.global_position
		var distance = my_pos.distance_to(target_pos)
		
		# 1. Decidir Movimiento
		var dir_x = 1 if target_pos.x > my_pos.x else -1
		entity.move_direction = Vector2(dir_x, 0)
		
		# 2. Decidir Combate
		if distance < 60:
			print("[%s] Objetivo en rango (dist: %.1f). Intentando atacar." % [entity.name, distance])
			if entity.combat_slot and entity.combat_slot.can_execute():
				entity.combat_slot.execute(entity)
				entity.combat_slot.mark_executed()
			elif entity.combat_slot:
				print("[%s] Combate en cooldown." % entity.name)
		else:
			print("[%s] Objetivo lejos (dist: %.1f). Persiguiendo." % [entity.name, distance])
	else:
		if entity.move_direction != Vector2.ZERO:
			print("[%s] Sin objetivo. Deteniendome." % entity.name)
		entity.move_direction = Vector2.ZERO
