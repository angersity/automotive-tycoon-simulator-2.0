class_name GarageController
extends Control

@onready var repair_button: Button = $Background/CenterContainer/VBoxContainer/RepairButton

# Статично типізована нагорода за клік
var repair_reward: int = 100

func _ready() -> void:
	# Забезпечуємо відмовостійкість: перевіряємо чи існує кнопка перед підключенням
	assert(repair_button != null, "CRITICAL ERROR: RepairButton node not found in GarageView")
	
	repair_button.pressed.connect(_on_repair_button_pressed)

func _on_repair_button_pressed() -> void:
	# Маршрутизуємо генерацію капіталу через глобальну шину подій
	EventBus.request_capital_change.emit(repair_reward)
