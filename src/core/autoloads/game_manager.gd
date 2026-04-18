extends Node

var current_capital: int = 0
var current_day: int = 1

func _ready() -> void:
	# Підписуємось на запити фінансових змін
	EventBus.request_capital_change.connect(_on_request_capital_change)
	
	# Ініціалізуємо початковий стан UI
	call_deferred("_initialize_ui_state")

func _initialize_ui_state() -> void:
	EventBus.capital_updated.emit(current_capital)

func _on_request_capital_change(amount: int) -> void:
	current_capital += amount
	EventBus.capital_updated.emit(current_capital)
