class_name MainOverlay
extends CanvasLayer

# ==============================================================================
# КОМПОНЕНТИ ІНТЕРФЕЙСУ
# ==============================================================================
@onready var capital_label: Label = $MarginContainer/HBoxContainer/CapitalLabel
@onready var date_label: Label = $MarginContainer/HBoxContainer/DateLabel
@onready var save_button: Button = $MarginContainer/HBoxContainer/SaveButton

# ==============================================================================
# ЖИТТЄВИЙ ЦИКЛ (LIFECYCLE)
# ==============================================================================
func _ready() -> void:
	_initialize_ui()
	_connect_signals()

# ==============================================================================
# ПРИВАТНІ МЕТОДИ (PRIVATE METHODS)
# ==============================================================================
func _initialize_ui() -> void:
	# Ініціалізація початкових значень (fallback).
	# Коли GameManager буде генерувати дані при старті, EventBus оновить їх автоматично.
	capital_label.text = "Капітал: $0"
	date_label.text = "Дата: 01.01.1970"

func _connect_signals() -> void:
	# Підключення до кнопок UI
	save_button.pressed.connect(_on_save_button_pressed)
	
	# Підключення до глобального EventBus для реактивного оновлення UI
	if EventBus.has_signal("capital_changed"):
		EventBus.capital_changed.connect(_on_capital_changed)
	else:
		push_warning("MainOverlay: Сигнал 'capital_changed' не знайдено у EventBus.")
		
	if EventBus.has_signal("time_advanced"):
		EventBus.time_advanced.connect(_on_time_advanced)
	else:
		push_warning("MainOverlay: Сигнал 'time_advanced' не знайдено у EventBus.")

# ==============================================================================
# ОБРОБНИКИ ПОДІЙ (SIGNAL CALLBACKS)
# ==============================================================================
func _on_capital_changed(new_capital: int) -> void:
	capital_label.text = "Капітал: $" + str(new_capital)

func _on_time_advanced(new_date: String) -> void:
	date_label.text = "Дата: " + new_date

func _on_save_button_pressed() -> void:
	# Захист від подвійного натискання (Debouncing UI)
	save_button.disabled = true
	save_button.text = "Збереження..."
	
	# Викликаємо менеджер збереження
	SaveManager.save_game()
	
	# Імітуємо коротку затримку для зворотного зв'язку користувачу, 
	# використовуючи SceneTreeTimer, щоб розблокувати кнопку
	await get_tree().create_timer(0.5).timeout
	save_button.text = "Зберегти гру"
	save_button.disabled = false
