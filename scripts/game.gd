extends Node2D

const HEROES = preload("res://scripts/hero_data.gd")
const SAVE_PATH := "user://save.json"

var coins: int = 500
var lives: int = 20
var wave: int = 0
var running: bool = false
var enemies: Array[Dictionary] = []
var towers: Array[Dictionary] = []
var hero_index: int = 0
var spawn_timer: float = 0.0
var spawned_this_wave: int = 0
var total_to_spawn: int = 8
var status_text := "Choisis un héros puis construis une tour."
var selected_hero: Dictionary = {}
var hero_list: Array[Dictionary] = []

var ui: CanvasLayer
var info_label: Label
var coin_label: Label
var wave_label: Label
var hero_picker: OptionButton
var start_button: Button
var build_button: Button
var save_button: Button

const PATH_POINTS := [Vector2(0, 220), Vector2(180, 220), Vector2(180, 390),
    Vector2(410, 390), Vector2(410, 150), Vector2(690, 150), Vector2(690, 310), Vector2(960, 310)]

func _ready() -> void:
    hero_list = HEROES.get_heroes()
    selected_hero = hero_list[0]
    _load_save()
    _make_ui()
    queue_redraw()

func _make_ui() -> void:
    ui = CanvasLayer.new()
    add_child(ui)

    var panel := PanelContainer.new()
    panel.position = Vector2(12, 10)
    panel.custom_minimum_size = Vector2(350, 0)
    ui.add_child(panel)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 5)
    panel.add_child(layout)

    var title := Label.new()
    title.text = "KING OF TOUR  •  Prototype 0.1"
    title.add_theme_font_size_override("font_size", 20)
    layout.add_child(title)

    coin_label = Label.new()
    layout.add_child(coin_label)
    wave_label = Label.new()
    layout.add_child(wave_label)

    hero_picker = OptionButton.new()
    for h in hero_list:
        hero_picker.add_item("%s — %s" % [h.name, h.role])
    hero_picker.item_selected.connect(_on_hero_selected)
    layout.add_child(hero_picker)

    var buttons := HBoxContainer.new()
    layout.add_child(buttons)

    start_button = Button.new()
    start_button.text = "Lancer la vague"
    start_button.pressed.connect(_start_wave)
    buttons.add_child(start_button)

    build_button = Button.new()
    build_button.text = "Construire (100)"
    build_button.pressed.connect(_build_tower)
    buttons.add_child(build_button)

    save_button = Button.new()
    save_button.text = "Sauvegarder"
    save_button.pressed.connect(_save_game)
    buttons.add_child(save_button)

    info_label = Label.new()
    info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    info_label.custom_minimum_size = Vector2(320, 54)
    layout.add_child(info_label)
    _refresh_ui()

func _on_hero_selected(index: int) -> void:
    hero_index = index
    selected_hero = hero_list[index]
    status_text = "%s sélectionné : %s." % [selected_hero.name, selected_hero.power]
    _refresh_ui()

func _start_wave() -> void:
    if running:
        status_text = "La vague est déjà en cours."
        _refresh_ui()
        return
    if lives <= 0:
        status_text = "Partie terminée. Recharge la sauvegarde ou recommence."
        _refresh_ui()
        return
    wave += 1
    spawned_this_wave = 0
    total_to_spawn = 8 + wave * 2
    spawn_timer = 0.0
    running = true
    status_text = "Vague %d : défends le royaume !" % wave
    _refresh_ui()

func _build_tower() -> void:
    if coins < 100:
        status_text = "Pas assez de pièces. Gagne une vague pour obtenir des pièces."
        _refresh_ui()
        return
    var spots := [Vector2(100, 130), Vector2(280, 300), Vector2(330, 440),
        Vector2(520, 240), Vector2(590, 90), Vector2(790, 230), Vector2(830, 390)]
    var pos: Vector2 = spots[towers.size() % spots.size()]
    coins -= 100
    towers.append({"pos": pos, "damage": 12, "range": 150.0, "cooldown": 0.0})
    status_text = "Tour construite. Les tours attaquent automatiquement."
    _refresh_ui()
    queue_redraw()

func _process(delta: float) -> void:
    if not running:
        return
    spawn_timer -= delta
    if spawned_this_wave < total_to_spawn and spawn_timer <= 0.0:
        _spawn_enemy()
        spawned_this_wave += 1
        spawn_timer = max(0.45, 1.2 - wave * 0.025)

    for enemy in enemies:
        var target: Vector2 = PATH_POINTS[min(int(enemy.path_index) + 1, PATH_POINTS.size() - 1)]
        var direction := target - enemy.pos
        if direction.length() < 3.0:
            enemy.path_index += 1
            if enemy.path_index >= PATH_POINTS.size() - 1:
                enemy.dead = true
                lives -= 1
            continue
        enemy.pos += direction.normalized() * enemy.speed * delta

    for tower in towers:
        tower.cooldown = max(0.0, float(tower.cooldown) - delta)
        if tower.cooldown > 0.0:
            continue
        for enemy in enemies:
            if enemy.dead:
                continue
            if tower.pos.distance_to(enemy.pos) <= float(tower.range):
                enemy.hp -= int(tower.damage)
                tower.cooldown = 0.65
                if enemy.hp <= 0:
                    enemy.dead = true
                    coins += 8
                break

    enemies = enemies.filter(func(e): return not e.dead)
    if spawned_this_wave >= total_to_spawn and enemies.is_empty():
        running = false
        coins += 50 + wave * 10
        status_text = "Vague %d terminée ! Bonus gagné : %d pièces." % [wave, 50 + wave * 10]
        _save_game()
    if lives <= 0:
        running = false
        status_text = "Le royaume est tombé. Recharge la sauvegarde pour réessayer."
    _refresh_ui()
    queue_redraw()

func _spawn_enemy() -> void:
    enemies.append({
        "pos": PATH_POINTS[0],
        "path_index": 0,
        "hp": 35 + wave * 8,
        "max_hp": 35 + wave * 8,
        "speed": 48.0 + min(wave * 1.5, 35.0),
        "dead": false
    })

func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, Vector2(960, 540)), Color("#253b2b"))
    # Chemin épais et clair
    for i in range(PATH_POINTS.size() - 1):
        draw_line(PATH_POINTS[i], PATH_POINTS[i + 1], Color("#bda77b"), 48.0, true)
        draw_line(PATH_POINTS[i], PATH_POINTS[i + 1], Color("#d8c79b"), 3.0, true)
    # Décor simple
    for p in [Vector2(70, 70), Vector2(250, 90), Vector2(360, 80), Vector2(520, 460), Vector2(870, 80), Vector2(900, 450)]:
        draw_circle(p, 18, Color("#356342"))
        draw_circle(p + Vector2(-5, -6), 10, Color("#4c8552"))
    # Tours
    for tower in towers:
        draw_circle(tower.pos, 13, Color("#4b78a8"))
        draw_circle(tower.pos, 7, Color("#a9d5ff"))
    # Ennemis
    for enemy in enemies:
        draw_circle(enemy.pos, 11, Color("#bd4a45"))
        var ratio: float = clamp(float(enemy.hp) / float(enemy.max_hp), 0.0, 1.0)
        draw_rect(Rect2(enemy.pos + Vector2(-14, -19), Vector2(28, 4)), Color("#3a2222"))
        draw_rect(Rect2(enemy.pos + Vector2(-14, -19), Vector2(28 * ratio, 4)), Color("#e66b5f"))
    # Héros sélectionné en bas à gauche
    draw_circle(Vector2(42, 490), 18, Color("#e7c65b"))
    draw_circle(Vector2(42, 490), 10, Color("#fff0a6"))

func _refresh_ui() -> void:
    if not is_instance_valid(info_label):
        return
    coin_label.text = "Pièces : %d    Vies : %d" % [coins, lives]
    wave_label.text = "Vague : %d    Héros disponibles : %d" % [wave, hero_list.size()]
    info_label.text = status_text

func _save_game() -> void:
    var data := {"coins": coins, "lives": lives, "wave": wave}
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(data))
        status_text = "Progression sauvegardée sur le téléphone."
    _refresh_ui()

func _load_save() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        return
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if not file:
        return
    var parsed = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        coins = int(parsed.get("coins", coins))
        lives = int(parsed.get("lives", lives))
        wave = int(parsed.get("wave", wave))
