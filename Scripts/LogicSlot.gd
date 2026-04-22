extends Resource
class_name LogicSlot

enum Type { COMBAT, MOVEMENT, BEHAVIOR }

@export var name: String = "Lógica Vacía"
@export var type: Type = Type.COMBAT
@export var texture: Texture2D # Icono para la UI

## Esta función será sobrescrita por los scripts de lógica específicos.
## 'actor' es la Entidad que está ejecutando esta lógica.
func execute(_actor: CharacterBody2D):
	pass
