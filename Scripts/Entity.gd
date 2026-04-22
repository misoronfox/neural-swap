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
	if is_static: return
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# El virus no controla el movimiento, la IA lo hace a través de los slots
	# El movimiento ocurre cada frame para que sea fluido
	execute_slot_by_type(LogicSlot.Type.MOVEMENT)
	
	move_and_slide()
	update_visuals()

func _on_ai_tick():
	if is_static: return
	
	# La lógica de comportamiento y combate puede correr en un timer
	# para no saturar y dar "ritmo" a la batalla
	execute_slot_by_type(LogicSlot.Type.BEHAVIOR)
	execute_slot_by_type(LogicSlot.Type.COMBAT)

func execute_slot_by_type(type: LogicSlot.Type):
	for slot in brain_slots:
		if slot and slot.type == type:
			slot.execute(self)

func take_damage(amount):
	health -= amount
	# Efecto visual de flash rojo (Hack n' Slash style)
	var tween = create_tween()
	# Intentar obtener Sprite2D o AnimatedSprite2D para el flash
	var visual = find_child("Sprite2D")
	if not visual: visual = _animated_sprite
	
	if visual:
		tween.tween_property(visual, "modulate", Color.RED, 0.1)
		tween.tween_property(visual, "modulate", Color.WHITE, 0.1)
	
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
