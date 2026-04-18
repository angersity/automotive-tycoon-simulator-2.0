extends Node
class_name GlobalEventBus

# --- СИГНАЛИ СИСТЕМИ ЧАСУ ---
signal date_updated(new_date: String)

# --- СИГНАЛИ ЕКОНОМІКИ ---
signal capital_updated(new_capital: int)

# --- СИГНАЛИ ЗБЕРЕЖЕННЯ/ЗАВАНТАЖЕННЯ ---
signal game_saved()
signal game_loaded()
