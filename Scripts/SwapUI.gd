extends Control

# Definimos el orden de las categorías en la UI: 0=Combat, 1=Behavior, 2=Movement
const UI_TYPE_ORDER = [
	LogicSlot.Type.COMBAT,
	LogicSlot.Type.BEHAVIOR,
	LogicSlot.Type.MOVEMENT
]

@onready var target_container = find_child("TargetSlots")
@onready var origin_container = find_child("OriginSlots")
@onready var panel = find_child("PanelContainer")

func _ready():
	if panel: panel.hide()
	VirusManager.hosts_updated.connect(_on_hosts_updated)

func _on_hosts_updated(previous: Entity, current: Entity):
	if not current: return
	if panel: panel.show()
	update_ui(previous, current)

func update_ui(previous: Entity, current: Entity):
	for i in range(UI_TYPE_ORDER.size()):
		var type = UI_TYPE_ORDER[i]
		
		# Actualizar Target (Actual)
		var target_node = find_child("TargetSlot" + str(i))
		if target_node:
			_set_slot_info(target_node, _find_slot_of_type(current, type))
			
		# Actualizar Origin (Anterior)
		if previous:
			var origin_node = find_child("OriginSlot" + str(i))
			if origin_node:
				_set_slot_info(origin_node, _find_slot_of_type(previous, type))

func _find_slot_of_type(entity: Entity, type: LogicSlot.Type) -> LogicSlot:
	if not entity: return null
	for slot in entity.brain_slots:
		if slot and slot.type == type:
			return slot
	return null

func _set_slot_info(node: Node, slot: LogicSlot):
	var label = node.find_child("Label")
	if label:
		label.text = slot.name if slot else "Vacío"
	
	var icon = node.find_child("TextureRect")
	if icon:
		icon.texture = slot.texture if slot else null

func _unhandled_input(event):
	if not panel or not panel.visible: return
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1: _on_slot_clicked(0)
			KEY_2: _on_slot_clicked(1)
			KEY_3: _on_slot_clicked(2)

func _on_slot_clicked(ui_index: int):
	# Mapeamos el índice de la UI al Tipo real de lógica
	var type_to_swap = UI_TYPE_ORDER[ui_index]
	VirusManager.perform_swap_by_type(type_to_swap)
