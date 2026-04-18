# PROJECT STATE DOCUMENT: ЕКОНОМІЧНИЙ СИМУЛЯТОР АВТОМОБІЛЕБУДУВАННЯ

## 1. ФУНДАМЕНТАЛЬНА АРХІТЕКТУРА ТА ПАРАДИГМИ (CORE RULES)
### 1.1. Багатомовна Інтеграція (Polyglot Architecture)
- **GDScript 2.0:** Логіка ігрового процесу, UI, FSM, координація макросистем. Сувора статична типізація.
- **C# (.NET 8.0):** Важкі обчислення (термодинаміка, ШІ, аеродинаміка).

### 1.2. Патерни та Інженерні Практики
- **Custom Resources:** Дані запчастин та константи зберігаються у .tres файлах.
- **Event Bus:** Весь обмін даними між модулями йде через глобальний синглтон.
- **Debouncing:** Оптимізація UI елементів для зменшення навантаження на Main Thread.
- **JSON Serialization:** Збереження стану гравця у форматі JSON (user://).
- **WorkerThreadPool:** Асинхронні обчислення та завантаження ресурсів.

## 2. ГЛОБАЛЬНА ТОПОЛОГІЯ ФАЙЛОВОЇ СИСТЕМИ
| Каталог у res:// | Архітектурне Призначення | Типи Файлів |
| --- | --- | --- |
| /addons/ | Плагіни (PhantomCamera, LimboAI). | .gd, .tscn, .bin |
| /assets/ | Сирі ресурси (моделі, текстури). | .glb, .png, .wav |
| /data/ | Статичні дані, дерева технологій. | .tres, .res, .json |
| /src/ | Кодова база (core, modules, entities). | .gd, .cs, .tscn |
| /themes/ | Стилізація інтерфейсу. | .tres, .ttf |

## 3. МАКРОСИСТЕМИ ПРОЄКТУ (AUTOLOADS / SINGLETONS)
| Назва | Шлях до файлу | Статус | Архітектурна Відповідальність |
| --- | --- | --- | --- |
| Event Bus | `res://src/core/autoloads/event_bus.gd` | [x] | Глобальний маршрутизатор подій (сигнали економіки, часу та збереження). |
| Game Manager | `res://src/core/autoloads/game_manager.gd` | [x] | Керування ігровим часом (1 день = 2с), капіталом та станом сесії. |
| Save Manager | `res://src/core/autoloads/save_manager.gd` | [x] | JSON-серіалізація стану (капітал, дата) у `user://save_game.json`. |
| System Bootstrapper | `res://src/core/autoloads/system_bootstrapper.gd` | [x] | Детермінована ініціалізація та жорстка перевірка (assert) Autoloads. |
| HR Manager | `res://src/core/autoloads/hr_manager.gd` | [ ] | Управління персоналом та генерація RP. |
| Research Manager | `res://src/core/autoloads/research_manager.gd` | [ ] | Управління Деревом Технологій. |
| Market Simulator | `res://src/core/autoloads/market_simulator.gd` | [ ] | Математичний рушій попиту та конкуренції. |
| Lighting Manager | `res://src/core/autoloads/lighting_manager.gd` | [ ] | Управління рендерингом та освітленням. |

## 4. СТАТУС ФУНКЦІОНАЛЬНИХ МОДУЛІВ (FEATURE MODULES)
### 4.1. Модуль "Гараж" (res://src/modules/garage/)
- **Статус:** Не розпочато
- **Компоненти:** `garage_controller.gd`, `contract_generator.gd`, `clicker.gd`.

### 4.2. Модуль "Інженерний Комплекс: Кузов" (res://src/modules/car_designer/)
- **Статус:** Не розпочато
- **Компоненти:** `car_project_state.gd`, `morph_controller.gd`.

## 5. ПОТОЧНИЙ КОНТЕКСТ СЕСІЇ (CURRENT WORKING CONTEXT)
### 5.1. Досягнення Сесії
- Створено та впроваджено `Save Manager`: реалізовано механізм збереження та завантаження через JSON.
- Оновлено `EventBus`: додано сигнали `game_saved` та `game_loaded`.
- Оновлено `SystemBootstrapper`: додано верифікацію `SaveManager` при старті.
- Вирішено проблему "Identifier not declared" шляхом виправлення порядку Autoload та перезавантаження кешу редактора.

### 5.2. Файли у Розробці
- `res://src/core/autoloads/save_manager.gd`
- `res://src/core/autoloads/event_bus.gd`
- `res://src/core/autoloads/system_bootstrapper.gd`

### 5.3. Блокери та Технічний Борг
- **UI:** Відсутня візуальна індикація збереження/завантаження (гравець бачить це лише в консолі).
- **Механіка:** Збереження наразі лише автоматичне при старті (load) та ручне через код; потрібно додати тригери збереження (наприклад, кнопка або автозбереження щомісяця).

### 5.4. Наступний Крок (Immediate Next Step)
Створити базовий **Main UI Overlay** (`res://src/core/ui/main_overlay.tscn`). Реалізувати панель статусу, яка відображатиме поточний капітал та дату в реальному часі, підписавшись на сигнали `EventBus`. Додати кнопку "Зберегти", яка викликатиме `SaveManager.save_game()`.