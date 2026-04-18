extends Node

func _ready() -> void:
	# Жорстка перевірка наявності всіх глобальних систем
	assert(EventBus != null, "КРИТИЧНА ПОМИЛКА: EventBus не знайдено в Autoload!")
	assert(GameManager != null, "КРИТИЧНА ПОМИЛКА: GameManager не знайдено в Autoload!")
	assert(SaveManager != null, "КРИТИЧНА ПОМИЛКА: SaveManager не знайдено в Autoload!")
	
	print("SYSTEM BOOTSTRAPPER: Усі макросистеми успішно ініціалізовано.")
