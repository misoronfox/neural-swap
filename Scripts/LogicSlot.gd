extends Resource
class_name LogicSlot

enum Type { ATTACK, MOVEMENT, PASSIVE, UTILITY }

@export var name: String = "Lógica Vacía"
@export var type: Type = Type.ATTACK
@export var cooldown: float = 1.0
@export var damage: int = 10
@export var jump_force: float = -400.0 # Útil para lógica de movimiento
@export var texture: Texture2D # Icono para la UI
