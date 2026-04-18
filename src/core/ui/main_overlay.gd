extends CanvasLayer

# --- ПОСИЛАННЯ НА ВУЗЛИ (NODE REFERENCES) ---
@onready var date_label: Label = $MarginContainer/HBoxContainer/DateLabel
@onready var capital_label: Label = $MarginContainer/HBoxContainer/CapitalLabel
@onready var save_button: Button = $MarginContainer/HBoxContainer/SaveButton

func _ready() -> void:
	# 1. Підписка на глобальні події (EventBus)
	EventBus.date_updated.connect(_on_date_updated) # Змінено назву тут
	EventBus.capital_updated.connect(_on_capital_updated)
	
	# 2. Підписка на натискання кнопки
	save_button.pressed.connect(_on_save_button_pressed)
	
	# 3. Ініціалізація стартових значень інтерфейсу
	date_label.text = "Дата: Завантаження..."
	capital_label.text = "Капітал: $0"

# --- ОБРОБНИКИ ПОДІЙ (EVENT HANDLERS) ---

func _on_date_updated(new_date: String) -> void: # Змінено назву тут
	date_label.text = "Дата: " + new_date

func _on_capital_updated(new_capital: int) -> void:
	capital_label.text = "Капітал: $" + str(new_capital)

func _on_save_button_pressed() -> void:
	SaveManager.save_game()
	
	save_button.text = "Збережено!"
	await get_tree().create_timer(1.5).timeout
	save_button.text = "Зберегти гру"
