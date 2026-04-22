extends LogicSlot
class_name BasicAttack

@export var damage: int = 20

func execute(actor: CharacterBody2D):
	var entity = actor as Entity
	if not entity: return
	
	# --- Visuals ---
	# We use the internal reference from the entity
	if entity._animated_sprite:
		entity._animated_sprite.play("attack")
	
	# --- Logic ---
	# We check the RayCast already set up in the entity
	if entity.attack_ray and entity.attack_ray.is_colliding():
		var target = entity.attack_ray.get_collider()
		if target.has_method("take_damage"):
			print(entity.name, " (BasicAttack) hit ", target.name, " for ", damage)
			target.take_damage(damage)
