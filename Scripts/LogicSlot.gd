extends Resource
class_name LogicSlot

enum Type { COMBAT, MOVEMENT, BEHAVIOR }

@export var name: String = "Lógica Vacía"
@export var type: Type = Type.COMBAT
@export var texture: Texture2D # Icono para la UI
@export var cooldown: float = 0.5

var _last_execution_time: float = -1000.0

## Esta función será sobrescrita por los scripts de lógica específicos.
## 'actor' es la Entidad que está ejecutando esta lógica.
func execute(_actor: CharacterBody2D):
	pass

func can_execute() -> bool:
	var current_time = Time.get_ticks_msec() / 1000.0
	return (current_time - _last_execution_time) >= cooldown

func mark_executed():
	_last_execution_time = Time.get_ticks_msec() / 1000.0
