# res://scripts/ui/I18nManager.gd
extends Node

const CSV_PATH: String = "res://ui/i18n/ui_text.csv"
const DEFAULT_LANG: String = "en"

var _translations: Dictionary = {}        # { lang_code: { id: text } }
var _available_langs: Array = []
var _current_lang: String = ""

func _ready() -> void:
	_load_ui_text(CSV_PATH)
	_register_translations()
	var cfg: ConfigFile = ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		var saved: String = cfg.get_value("settings", "language", "")
		if saved != "":
			set_locale(saved)
			return
	set_locale(DEFAULT_LANG)

# API publique
func set_locale(code: String) -> void:
	if not _translations.has(code):
		push_warning("I18nManager: locale '%s' introuvable, fallback sur %s" % [code, DEFAULT_LANG])
		code = DEFAULT_LANG
	_current_lang = code
	TranslationServer.set_locale(code)

func get_locale() -> String:
	return _current_lang

func get_available_languages() -> Array:
	return _available_langs.duplicate()

func translate(id: String) -> String:
	if _current_lang != "" and _translations.has(_current_lang) and _translations[_current_lang].has(id):
		var t_text: String = _translations[_current_lang][id]
		if t_text != "":
			return t_text
	if _translations.has(DEFAULT_LANG) and _translations[DEFAULT_LANG].has(id):
		return _translations[DEFAULT_LANG][id]
	return id

# Lecture CSV (FileAccess pour Godot 4)
func _load_ui_text(path: String) -> void:
	_translations.clear()
	_available_langs.clear()
	var f: FileAccess = FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("I18nManager: impossible d'ouvrir %s" % path)
		return
	if f.eof_reached():
		f.close()
		push_error("I18nManager: fichier vide %s" % path)
		return
	var header_line: String = f.get_line()
	var header: Array = _parse_csv_line(header_line)
	if header.size() < 2:
		f.close()
		push_error("I18nManager: header invalide dans %s" % path)
		return
	for i in range(1, header.size()):
		var code: String = header[i].strip_edges()
		if code == "": 
			continue
		_translations[code] = {}
		_available_langs.append(code)
	while not f.eof_reached():
		var row_line: String = f.get_line()
		if row_line.strip_edges() == "":
			continue
		var row: Array = _parse_csv_line(row_line)
		if row.size() < 1:
			continue
		var key: String = row[0].strip_edges()
		if key == "":
			continue
		for j in range(1, header.size()):
			var code2: String = header[j].strip_edges()
			if code2 == "":
				continue
			var text: String = ""
			if j < row.size():
				text = row[j]
			# assure que la sous-dictionnaire existe
			if not _translations.has(code2):
				_translations[code2] = {}
			_translations[code2][key] = text
	f.close()

func _register_translations() -> void:
	for lang_code_key in _translations.keys():
		var lang_code: String = String(lang_code_key)
		var t: Translation = Translation.new()
		t.locale = lang_code # CRITICAL: Définir la locale de l'objet Translation
		var map: Dictionary = _translations[lang_code]
		for key_obj in map.keys():
			var key_str: String = String(key_obj)
			var text: String = map[key_str]
			if text == "":
				continue
			t.add_message(key_str, text)
		TranslationServer.add_translation(t)

# Parser CSV robuste (guillemets, doubles guillemets)
func _parse_csv_line(line: String) -> Array:
	var cols: Array = []
	var cur: String = ""
	var in_quotes: bool = false
	var i: int = 0
	while i < line.length():
		var c: String = line[i]
		if c == '"':
			if in_quotes and i + 1 < line.length() and line[i + 1] == '"':
				cur += '"'
				i += 1
			else:
				in_quotes = not in_quotes
		elif c == ',' and not in_quotes:
			cols.append(cur)
			cur = ""
		else:
			cur += c
		i += 1
	cols.append(cur)
	for k in range(cols.size()):
		cols[k] = cols[k].strip_edges()
	return cols
