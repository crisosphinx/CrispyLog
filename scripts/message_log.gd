# Copyright 2026 @ Jeff3DAnimation
tool
class_name MessageLog
extends Node

# Global blueprint
var log_blueprint = null

# Logging blueprint class
class LogBlueprint:

	const _LOG_FORMAT = "{level}\t[{time}]\t[{location}]\n\t\t{message}"

	var _user_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	var _log_path = "%s/.logs/%s.log" % [
		_user_dir,
		ProjectSettings.get_setting("application/config/name")
	]

	var _location = ""
	var _file = null
	var _owner = null

	func log_format_getter():
		return _LOG_FORMAT

	func log_level_getter():
		return sf.return_current_log_enum()

	func file_log_level_getter():
		return sf.return_current_file_enum()

	func log_path_getter():
		return _log_path

	func location_getter():
		return _location

	func file_getter():
		return _file

	func file_path_getter():
		if _file:
			return _file.get_path()
		return ""

	func owner_getter():
		return _owner

	func owner_setter(value):
		_owner = value

	func log_path_setter(value):
		_log_path = value

	func location_setter(value):
		_location = value

	func get_datetime(format_for_file := false):
		var now = OS.get_datetime(true)

		if sf.get_iso_time_enabled():
			return "%04d-%02d-%02dT%02d:%02d:%02d" % [
				now.year, now.month, now.day,
				now.hour, now.minute, now.second
			]

		if format_for_file:
			return "%04d/%02d/%02d/%02d_%02d_%02d" % [
				now.year, now.month, now.day,
				now.hour, now.minute, now.second
			]

		return "%04d/%02d/%02d_%02d:%02d:%02d" % [
			now.year, now.month, now.day,
			now.hour, now.minute, now.second
		]

	func _get_caller_function_name(file_name_only := false, obj := null):
		var stack = get_stack()
		if stack.size() >= 2:
			var caller = stack[stack.size() - 1]
			var src = caller.source.get_file().get_basename()
			var fnc = caller.function
			if file_name_only:
				return src
			if obj:
				return "%s | %s: %s" % [obj.name, src, fnc]
			return "%s: %s" % [src, fnc]
		return "Unknown"

	func _get_formatted_message(message, log_level, file_name_only := false, obj := null):
		return _LOG_FORMAT.format({
			"message": message,
			"location": _get_caller_function_name(file_name_only, obj),
			"time": get_datetime(),
			"level": "%-5s" % sf.LoggingLevel.keys()[log_level]
		})

	func _print_message(log_level, message, assertion := true):
		if log_level != sf.LoggingLevel.FATAL and sf.get_write_to_console_enabled():
			print(message)

		match log_level:
			sf.LoggingLevel.WARNING:
				push_warning(message)
			sf.LoggingLevel.ERROR, sf.LoggingLevel.CRITICAL:
				push_error(message)
			sf.LoggingLevel.FATAL:
				push_error(message)
				printerr(message)
				if _owner and _owner.get_tree():
					_owner.get_tree().quit()
			sf.LoggingLevel.ASSERT:
				assert(assertion)
			_:
				pass

	func _remove_bbc(message):
		message = message.replace("\n\t\t", "")
		return message

	func write_logs(message):
		if not sf.get_write_to_logs_enabled():
			return
		if not _file:
			load_file()
		_file.store_line(message)
		_file.flush()

	func log_message(message, log_level := sf.LoggingLevel.INFO,
					 assertion := true, file_name_only := false, obj := null):
		var msg = _get_formatted_message(message, log_level,
										file_name_only, obj)
		if log_level_getter() <= log_level:
			_print_message(log_level, msg, assertion)
		if file_log_level_getter() <= log_level:
			write_logs(_remove_bbc(msg))

	func _get_log_path():
		var base = _log_path.get_basename()
		var ext = _log_path.get_extension()
		var time = get_datetime(true)
		if Engine.is_editor_hint():
			return "%s/editor_%s.%s" % [base, time, ext]
		return "%s/%s.%s" % [base, time, ext]

	func load_file():
		var filename = _get_log_path()
		var dir = Directory.new()
		dir.make_dir_recursive(filename.get_base_dir())
		_file = File.new()
		_file.open(filename, File.WRITE)

# Initialize
func _init():
	log_blueprint = LogBlueprint.new()
	log_blueprint.owner_setter(self)

# Static helper
static func type_to_name(v):
	match typeof(v):
		TYPE_NIL: return "Nil"
		TYPE_BOOL: return "Bool"
		TYPE_INT: return "Int"
		TYPE_REAL: return "Float"
		TYPE_STRING: return "String"
		TYPE_VECTOR2: return "Vector2"
		TYPE_VECTOR3: return "Vector3"
		TYPE_OBJECT: return "Object"
		_: return "Unknown"

# Helpers (instance methods)
func _format_in_msg(value):
	var in_val = type_to_name(value)
	var tab_amt = "\t\t\t"
	return "[%s]%s| %s" % [in_val, tab_amt, value]

func _log_message(message, level := sf.LoggingLevel.INFO,
				  obj := null, file_name_only := false,
				  assertion := true):
	if not log_blueprint:
		return
	var msg = _format_in_msg(message)
	log_blueprint.log_message(msg, level, assertion, file_name_only, obj)

# Static console clear
static func _clear_console():
	print("\f")

func call_thread_safe(method_name: String, message, level, obj=null, file_name_only=false, assertion=true):
	call(method_name, message, level, obj, file_name_only, assertion)

# Logging entry points
func _trace(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.TRACE, obj, file_name_only)

func _verbose(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.VERBOSE, obj, file_name_only)

func _debug(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.DEBUG, obj, file_name_only)

func _info(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.INFO, obj, file_name_only)

func _sys(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.SYSTEM, obj, file_name_only)

func _success(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.SUCCESS, obj, file_name_only)

func _warning(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.WARNING, obj, file_name_only)

func _error(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.ERROR, obj, file_name_only)

func _critical(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.CRITICAL, obj, file_name_only)

func _fatal(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.FATAL, obj, file_name_only)

func _assert(message, assertion, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.ASSERT, obj, file_name_only, assertion)

func _network(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.NETWORK, obj, file_name_only)

func _performance(message, obj := null, file_name_only := false):
	call_thread_safe("_log_message", message,
		sf.LoggingLevel.PERFORMANCE, obj, file_name_only)
