extends CanvasLayer
class_name MainOverlay

# ==========================================
# ПОСИЛАННЯ НА ВУЗЛИ (NODE REFERENCES)
# ==========================================
@onready var date_label: Label = $UIRoot/TopMargin/TopBar/DateLabel
@onready var capital_label: Label = $UIRoot/TopMargin/TopBar/CapitalLabel
@onready var save_button: Button = $UIRoot/TopMargin/TopBar/SaveButton

# ==========================================
# ЖИТТЄВИЙ ЦИКЛ (LIFECYCLE)
# ==========================================
func _ready() -> void:
	# 1. Підписка на події макросистем (Делегування)
	EventBus.capital_updated.connect(_on_capital_updated)
	EventBus.date_updated.connect(_on_date_updated)
	EventBus.game_saved.connect(_on_game_saved)
	
	# 2. Підключення локальних сигналів UI
	save_button.pressed.connect(_on_save_button_pressed)
	
	# 3. Ініціалізація базового стану UI
	date_label.text = "Дата: Завантаження..."
	capital_label.text = "Капітал: Завантаження..."

# ==========================================
# ОБРОБНИКИ СИГНАЛІВ (SIGNAL HANDLERS)
# ==========================================
func _on_capital_updated(new_capital: int) -> void:
	# Форматування числа з роздільником (наприклад: 1 500 000) - базова реалізація
	capital_label.text = "Капітал: $" + str(new_capital)

func _on_date_updated(new_date: String) -> void:
	date_label.text = "Дата: " + new_date

func _on_save_button_pressed() -> void:
	# Виклик глобального менеджера для збереження стану
	save_button.disabled = true
	save_button.text = "Збереження..."
	SaveManager.save_game()

func _on_game_saved() -> void:
	# Візуальний зворотний зв'язок для гравця
	save_button.text = "Збережено!"
	
	# Створення асинхронного таймера для скидання тексту кнопки
	await get_tree().create_timer(2.0).timeout
	
	save_button.text = "Зберегти Гру"
	save_button.disabled = false
