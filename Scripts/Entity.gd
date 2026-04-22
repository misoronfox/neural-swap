extends CharacterBody2D
class_name Entity

# Propiedades del GDD
@export var is_vip: bool = false
@export var is_static: bool = false
@export var health: float = 100.0
@export var speed: float = 150.0

# El "Cerebro": Un array de 3 slots de lógica
@export var brain_slots: Array[LogicSlot] = [null, null, null]

var is_possessed: bool = false # ¿Está el virus aquí?
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1 # 1 derecha, -1 izquierda

@onready var attack_ray = $AttackRay 
@onready var action_timer = $ActionTimer
@onready var _animated_sprite: AnimatedSprite2D = find_child("AnimatedSprite2D") as AnimatedSprite2D
func _ready():
	if not is_static:
		action_timer.start(1.0) # La IA "piensa" cada segundo
		action_timer.timeout.connect(_on_ai_tick)
		
	if is_vip:
		# Un contorno dorado o un icono sobre la cabeza
		modulate = Color(1.2, 1.2, 0.8) # Un ligero brillo amarillento

func _physics_process(delta):
	# Aplicar gravedad si no es estático
	if not is_static:
		
		if not is_on_floor():
			velocity.y += gravity * delta
		
		# Lógica de movimiento automática (muy simple para empezar)
		if not is_possessed: # Si el virus no está, se mueve por su cuenta
			auto_move()
		
		move_and_slide()
		

func auto_move():
	# Si tiene un slot de movimiento, camina
	var has_movement = false
	for slot in brain_slots:
		if slot and slot.type == LogicSlot.Type.MOVEMENT:
			has_movement = true
			break
	
	if has_movement:
		velocity.x = direction * speed
		# Girar si choca con pared o ve vacío (usando RayCast2D)
		if is_on_wall():
			direction *= -1
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func _on_ai_tick():
	if is_static: return
	
	# Ejecutar una acción aleatoria de sus slots
	var valid_slots = brain_slots.filter(func(s): return s != null)
	if valid_slots.size() > 0:
		var random_slot = valid_slots.pick_random()
		execute_action(random_slot)

func execute_action(slot: LogicSlot):
	match slot.type:
		LogicSlot.Type.ATTACK:
			# --- FRONTEND (Visual) ---
			if _animated_sprite:
				_animated_sprite.play("attack")
			
			# --- BACKEND (Lógica de Daño) ---
			if attack_ray and attack_ray.is_colliding():
				var target = attack_ray.get_collider() # Obtenemos qué chocó
				
				# Verificamos si lo que chocó es una Entidad y tiene vida
				if target.has_method("take_damage"):
					print(name, " golpeó a ", target.name)
					target.take_damage(slot.damage)
		LogicSlot.Type.MOVEMENT:
			if is_on_floor():
				velocity.y = slot.jump_force

func take_damage(amount):
	health -= amount
	# Efecto visual de flash rojo (Hack n' Slash style)
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 0.1)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.1)
	
	if health <= 0:
		die()


func die():
	if is_vip:
		print("¡EL CABALLERO HA CAÍDO!")
		# Aquí podrías llamar a una señal global
		# GameEvents.emit_signal("game_over")
		get_tree().reload_current_scene() 
	else:
		# Efecto de explosión de sangre/partículas antes de morir
		queue_free()


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Avisamos al Manager que queremos saltar aquí
		VirusManager.jump_to_entity(self)
		

func update_visuals():
	if _animated_sprite == null: return

	# 1. Prioridad: Si está atacando, dejamos que la animación termine
	if _animated_sprite.animation == "attack" and _animated_sprite.is_playing():
		return

	# 2. Orientación (Mirar a izquierda o derecha)
	# Si la velocidad es positiva, mira a la derecha. Si es negativa, a la izquierda.
	if velocity.x > 0:
		_animated_sprite.flip_h = false
		if attack_ray: attack_ray.target_position.x = 50 # Apunta a la derecha
	elif velocity.x < 0:
		_animated_sprite.flip_h = true
		if attack_ray: attack_ray.target_position.x = -50 # Apunta a la izquierda

	# 3. Selección de animación según movimiento
	if is_on_floor():
		if abs(velocity.x) > 10: # Si se mueve más que un poquito
			_animated_sprite.play("walk")
		else:
			_animated_sprite.play("idle")
	else:
		# Si no está en el suelo, podrías poner una de "jump"
		pass
