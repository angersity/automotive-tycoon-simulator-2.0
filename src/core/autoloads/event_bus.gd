extends Node

# Сигнали життєвого циклу гри та UI
signal date_updated(new_date: String)
signal capital_updated(new_capital: int)
signal game_saved()
signal game_loaded()

# Сигнали економічних транзакцій
signal request_capital_change(amount: int)
