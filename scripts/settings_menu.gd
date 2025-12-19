# Copyright 2026 @ Jeff3DAnimation
tool
class_name CrispyLogSettings
extends Node

# Logging levels
enum LoggingLevel {
	NONE = 0,
	TRACE = 1,
	VERBOSE = 2,
	DEBUG = 3,
	SYSTEM = 4,
	INFO = 5,
	SUCCESS = 6,
	WARNING = 7,
	ERROR = 8,
	CRITICAL = 9,
	FATAL = 10,
	ASSERT = 11,
	NETWORK = 12,
	PERFORMANCE = 13,
}

# Constant values, please don't modify these.
const base = "CrispyLog/"
const cat_color = "Colors/"
const cat_avail = "Available/"
const cat_level = "Levels/"

const prnt_stack_ = base + cat_avail + "print_the_stack"
const enable_cnsl = base + cat_avail + "print_to_console"
const enable_logs = base + cat_avail + "write_to_log"
const enable_isot = base + cat_avail + "use_iso_time"

const color_pairs = base + cat_color + "color_pairs"
const dft_cnsl_lg = base + cat_level + "default_log"
const dft_file_lg = base + cat_level + "default_file_log"

# Color format
const MSG_COLORS = {
	"trace": "#000000FF",
	"verbose": "#A7B7DDFF",
	"debug": "#AAFFAAFF",
	"system": "#CCCCCCFF",
	"info": "#FFFFAAFF",
	"success": "#00FF00FF",
	"warning": "#FFA000FF",
	"error": "#FF8888FF",
	"critical": "#FF0000FF",
	"assert": "#FFFFFFFF",
	"network": "#0000FFFF",
	"performance": "#00AAAAFF",
}

# Creates the settings for this tool
static func create_settings():
	var lls = ",".join(LoggingLevel.keys())

	if not ProjectSettings.has_setting(color_pairs):
		ProjectSettings.set_setting(color_pairs, MSG_COLORS)

	if not ProjectSettings.has_setting(prnt_stack_):
		ProjectSettings.set_setting(prnt_stack_, false)

	if not ProjectSettings.has_setting(enable_cnsl):
		ProjectSettings.set_setting(enable_cnsl, true)

	if not ProjectSettings.has_setting(enable_logs):
		ProjectSettings.set_setting(enable_logs, true)

	if not ProjectSettings.has_setting(enable_isot):
		ProjectSettings.set_setting(enable_isot, false)

	if not ProjectSettings.has_setting(dft_cnsl_lg):
		ProjectSettings.set_setting(dft_cnsl_lg, LoggingLevel.INFO)

	if not ProjectSettings.has_setting(dft_file_lg):
		ProjectSettings.set_setting(dft_file_lg, LoggingLevel.DEBUG)

	# COLOR PAIRS
	ProjectSettings.add_property_info({
		"name": color_pairs,
		"type": TYPE_DICTIONARY,
		"category": "Colors"
	})

	# BOOLEANS
	ProjectSettings.add_property_info({
		"name": prnt_stack_,
		"type": TYPE_BOOL,
		"category": "Available"
	})

	ProjectSettings.add_property_info({
		"name": enable_cnsl,
		"type": TYPE_BOOL,
		"category": "Available"
	})

	ProjectSettings.add_property_info({
		"name": enable_logs,
		"type": TYPE_BOOL,
		"category": "Available"
	})

	ProjectSettings.add_property_info({
		"name": enable_isot,
		"type": TYPE_BOOL,
		"category": "Available"
	})

	# ENUM LEVELS
	ProjectSettings.add_property_info({
		"name": dft_cnsl_lg,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": lls,
		"category": "Levels"
	})

	ProjectSettings.add_property_info({
		"name": dft_file_lg,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": lls,
		"category": "Levels"
	})

	ProjectSettings.save()

# Deletes the settings for this tool
static func delete_settings():
	var all_keys = ProjectSettings.get_property_list()
	var result = []

	for prop in all_keys:
		if not prop.has("name"):
			continue
		var name = prop["name"]
		if not name.find(base) != -1:
			continue
		result.append(name)

	for each in result:
		ProjectSettings.clear(each)

# Internal: get color from ProjectSettings
static func _get_color_setting(value):
	var all_keys = ProjectSettings.get_property_list()
	var result = {}

	for prop in all_keys:
		if not prop.has("name"):
			continue
		var name = prop["name"]
		if name == color_pairs:
			result = ProjectSettings.get_setting(name)
			break

	var key = return_enum_name(value)
	if result.has(key):
		return result[key].to_html()

	return "Invalid request"

# Public color getter
static func get_color(value):
	return _get_color_setting(value)

# Settings getters
static func get_print_stack_enabled():
	if ProjectSettings.has_setting(prnt_stack_):
		return ProjectSettings.get_setting(prnt_stack_)
	return false

static func get_write_to_console_enabled():
	if ProjectSettings.has_setting(enable_cnsl):
		return ProjectSettings.get_setting(enable_cnsl)
	return false

static func get_write_to_logs_enabled():
	if ProjectSettings.has_setting(enable_logs):
		return ProjectSettings.get_setting(enable_logs)
	return false

static func get_iso_time_enabled():
	if ProjectSettings.has_setting(enable_isot):
		return ProjectSettings.get_setting(enable_isot)
	return false

# Enum helpers
static func return_enum_name(value):
	return LoggingLevel.keys()[value].to_lower()

static func return_current_log_enum():
	return ProjectSettings.get_setting(dft_cnsl_lg)

static func return_current_file_enum():
	return ProjectSettings.get_setting(dft_file_lg)
