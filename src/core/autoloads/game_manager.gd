extends Node
class_name GameManagerMain

# ==========================================
# ДАНІ СТАНУ (STATE DATA)
# ==========================================
var capital: int = 5000000
var day: int = 1
var month: int = 1
var year: int = 1970

# ==========================================
# ВУЗЛИ (NODES)
# ==========================================
var day_timer: Timer

# ==========================================
# ЖИТТЄВИЙ ЦИКЛ (LIFECYCLE)
# ==========================================
func _ready() -> void:
	# 1. Підписка на події системи збереження
	EventBus.game_loaded.connect(_on_game_loaded)
	
	# 2. Ініціалізація математичного ядра часу (1 ігровий день = 2 реальні секунди)
	day_timer = Timer.new()
	day_timer.wait_time = 2.0
	day_timer.autostart = true
	day_timer.timeout.connect(_on_day_timeout)
	add_child(day_timer)
	
	# 3. Відкладена відправка початкових даних в UI 
	# (call_deferred гарантує, що UI вже встиг завантажитись перед відправкою)
	call_deferred("_broadcast_initial_state")

# ==========================================
# МАКРОЕКОНОМІЧНА ЛОГІКА ТА ЧАС (CORE LOGIC)
# ==========================================
func _broadcast_initial_state() -> void:
	EventBus.capital_updated.emit(capital)
	EventBus.date_updated.emit(_get_formatted_date())

func _on_day_timeout() -> void:
	_advance_time()

func _advance_time() -> void:
	day += 1
	if day > 30: # Спрощена економічна модель: 30 днів у місяці
		day = 1
		month += 1
		if month > 12:
			month = 1
			year += 1
			
	# Відправляємо оновлену дату в EventBus
	EventBus.date_updated.emit(_get_formatted_date())

func _get_formatted_date() -> String:
	# Форматування рядка у вигляді ДД.ММ.РРРР (наприклад: 01.01.1970)
	return "%02d.%02d.%d" % [day, month, year]

# ==========================================
# ПУБЛІЧНЕ API (PUBLIC API) - ДЛЯ ІНШИХ МОДУЛІВ
# ==========================================
func add_capital(amount: int) -> void:
	capital += amount
	EventBus.capital_updated.emit(capital)

func spend_capital(amount: int) -> bool:
	if capital >= amount:
		capital -= amount
		EventBus.capital_updated.emit(capital)
		return true
	return false

func _on_game_loaded() -> void:
	# Коли SaveManager завантажить дані, він викличе цей метод
	# Поки що просто оновлюємо UI
	_broadcast_initial_state()
