extends LogicSlot
class_name BasicAttack

@export var damage: int = 20

func execute(actor: CharacterBody2D):
	var entity = actor as Entity
	if not entity: return
	
	# --- Visuals ---
	if entity._animated_sprite:
		entity._animated_sprite.play("attack")
	
	# --- Logic ---
	if entity.attack_ray:
		if entity.attack_ray.is_colliding():
			var target = entity.attack_ray.get_collider()
			if target.has_method("take_damage"):
				print("[%s] ¡GOLPE! %s impacta a %s con %d de daño." % [entity.name, name, target.name, damage])
				target.take_damage(damage)
			else:
				print("[%s] Ataque bloqueado o contra objeto no danable (%s)." % [entity.name, target.name])
		else:
			print("[%s] Ataque al aire (sin colision)." % entity.name)
