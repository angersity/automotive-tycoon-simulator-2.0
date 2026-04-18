extends Node

const SAVE_PATH: String = "user://save_game.json"

# --- ЛОКАЛЬНИЙ КЕШ СТАНУ ---
# SaveManager не лізе в інші скрипти. Він просто запам'ятовує те, що чує від EventBus.
var _cached_capital: int = 0
var _cached_date: String = "1970-01-01"

func _ready() -> void:
	# Підписуємося на події зміни даних
	EventBus.capital_updated.connect(_on_capital_updated)
	EventBus.date_updated.connect(_on_date_updated)

# --- ОБРОБНИКИ ПОДІЙ ---
func _on_capital_updated(new_capital: int) -> void:
	_cached_capital = new_capital

func _on_date_updated(new_date: String) -> void:
	_cached_date = new_date

# --- СИСТЕМА ЗБЕРЕЖЕННЯ/ЗАВАНТАЖЕННЯ ---
func save_game() -> void:
	var save_data: Dictionary = {
		"capital": _cached_capital,
		"date": _cached_date
	}
	
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		var json_string: String = JSON.stringify(save_data, "\t")
		file.store_string(json_string)
		file.close()
		EventBus.game_saved.emit()
		print("[SaveManager] Гру успішно збережено: ", json_string)
	else:
		printerr("[SaveManager] Критична помилка: не вдалося відкрити файл для запису.")

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		print("[SaveManager] Файл збереження не знайдено. Створюється нова сесія.")
		return {}
		
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file != null:
		var json_string: String = file.get_as_text()
		file.close()
		
		var json: JSON = JSON.new()
		var parse_result: Error = json.parse(json_string)
		if parse_result == OK:
			var data = json.data
			if typeof(data) == TYPE_DICTIONARY:
				print("[SaveManager] Гру успішно завантажено.")
				EventBus.game_loaded.emit()
				return data
		else:
			printerr("[SaveManager] Помилка парсингу JSON збереження.")
			
	return {}
