# Copyright 2026 @ Jeff3DAnimation
@icon('../icons/logger.svg')
@tool
class_name MessageLog
extends Node

## Global variable representing [member MessageLog.LogBlueprint].
static var log_blueprint: LogBlueprint

## This class represents the intended blueprint for logging our actions to the
## console and to log files. This is intended to take over [code]print()[/code]
## to provide more verbose feedback. This includes the following information:
##
## - Location of the printed string / log,[br]
## - Date-Time,[br]
## - Any prefixes require,[br]
## - Color associated to the console,[br]
## - Truncated, less verbose, messaging to a log file,[br]
## - Simplified output,[br]
## - Log Level, including:[br]
## [code]  - TRACE,[/code][br]
## [code]  - VERBOSE,[/code][br]
## [code]  - DEBUG,[/code][br]
## [code]  - SYSTEM,[/code][br]
## [code]  - INFO,[/code][br]
## [code]  - SUCCESS,[/code][br]
## [code]  - WARNING,[/code][br]
## [code]  - ERROR,[/code][br]
## [code]  - CRITICAL,[/code][br]
## [code]  - FATAL,[/code][br]
## [code]  - ASSERT,[/code][br]
## [code]  - NETWORK,[/code][br]
## [code]  - PERFORMANCE,[/code][br]
class LogBlueprint:
    ## A signal. Requires:[br][br]
    ##
    ## [param level]: ([member LoggingLevel]) The level to report back as.[br]
    ## [param message]: ([member String]) Stringified message to write.
    signal message_logged(level: sf.LoggingLevel, message: String)

    const _LOG_FORMAT: String = "{level}\t[{time}]\t[{location}]\n\t\t{message}"
    var _user_dir: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
    var _log_path: String = "%s/.logs/%s.log" % [
        _user_dir,
        ProjectSettings.get_setting("application/config/name")
    ]
    var _location: String = ""
    var _file: FileAccess

    ## Reference to the MessageLog node that created this blueprint.[br]
    ## This ensures calls that expect to run on a Node
    ## (print_tree, get_tree().quit()) are forwarded to the actual Node instead
    ## of being invoked on the class object.
    var _owner: Node = null

    ## Returns the log format as a [member String].[br]
    ## Note: This returns ONLY the format. If you want to change it, you must
    ## change the value in code. Please do not modify unless you know what you
    ## are doing.
    func log_format_getter() -> String:
        return _LOG_FORMAT

    ## Returns the level of log regarding our global logging value.
    func log_level_getter() -> int:
        return sf.return_current_log_enum()

    ## Returns the level of log for the [b]file[/b] regarding our global
    ## logging value.
    func file_log_level_getter() -> int:
        return sf.return_current_file_enum()

    ## Returns the log path as a [member String].
    func log_path_getter() -> String:
        return _log_path

    ## Returns the location of the logger being called from as a
    ## [member String], this will often [member func]tion name or
    ## [member class].
    func location_getter() -> String:
        return _location

    ## Returns the file we write logs to as a [member FileAccess].
    func file_getter() -> FileAccess:
        return _file

    ## Returns the location of our file.[br][br]
    ##
    ## Default Location:
    ## [code]/user/documents/.logs/year/month/day/logs.log[/code][br]
    ## or [br]
    ## Default Windows Location
    ## [code]C:/user/documents/.logs/year/month/day/logs.log[/code]
    func file_path_getter() -> String:
        return _file.get_path()

    ## Returns the owner [member Node] (typically the MessageLog Node).
    func owner_getter() -> Node:
        return _owner

    ## Set the owner node (the MessageLog node). This is to ensure the
    ## LogBlueprint knows its owner so Node-specific calls are forwarded
    ## correctly.[br][br]
    ##
    ## [param value]: ([member Node]) Set the owner value / node for the class.
    func owner_setter(value: Node) -> void:
        _print_message(sf.LoggingLevel.SYSTEM,
                       "Set owner to: %s" % value)
        write_logs("Set owner to: %s" % value)
        _owner = value

    ## Set the path to the log we will write.[br][br]
    ##
    ## [param value]: ([member String]) Location for the log to save to.
    func log_path_setter(value: String) -> void:
        _print_message(sf.LoggingLevel.SYSTEM,
                       "Set path of log: %s" % value)
        write_logs("Set path of log: %s" % value)
        _log_path = value

    ## Set the location of the printout (method, file, etc.)[br][br]
    ##
    ## [param value]: ([member String]) Specify the owner function [member self]
    ## or script.
    func location_setter(value: String) -> void:
        _print_message(sf.LoggingLevel.SYSTEM,
                       "Set parent of log: %s" % value)
        write_logs("Set parent of log: %s" % value)
        _location = value

    ## Returns datetime in format of YEAR/MONTH/DAY.[br][br]
    ##
    ## [param format_for_file]: ([member bool]) Specify whether or not to return
    ## a [member String] formatted for file saving or if it is just in the
    ## console.
    func get_datetime(format_for_file: bool = false) -> String:
        var now: Dictionary = Time.get_datetime_dict_from_system(true)
        if sf.get_iso_time_enabled():
            return Time.get_datetime_string_from_datetime_dict(now, false)
        now.day     = "%02d" % now.day
        now.month   = "%02d" % now.month
        now.hour    = "%02d" % now.hour
        now.minute  = "%02d" % now.minute
        now.second  = "%02d" % now.second
        if format_for_file:
            return "{year}/{month}/{day}/{hour}_{minute}_{second}".format(now)
        return "{year}/{month}/{day}_{hour}:{minute}:{second}".format(now)

    ## Get the location / method from where you've called the logger.[br]
    ## If you call it from _input, _input will be returned.[br]
    ## If you call it from _process, _process will be returned.[br][br]
    ##
    ## [param file_name_only]: ([member bool]) (D)Enable whether we return
    ## the file name as a [member String]. Otherwise, we will return the
    ## file name and [member func]tion name instead.[br][br]
    ## Or return "Unknown" if it fails.
    func _get_caller_function_name(file_name_only: bool = false,
                                   obj: Object= null) -> String:
        var stack: Array = get_stack()
        if stack.size() >= 2:
            var caller_data: Dictionary = stack[stack.size()-1]
            var src: String = caller_data.source.get_file().get_basename()
            var fnc: String = caller_data.function
            caller_data.clear()
            if file_name_only and src:
                return src
            else:
                if obj:
                    return "%s | %s: %s" % [obj.name, src, fnc]
                else:
                    return "%s: %s" % [src, fnc]
        return "Unknown"

    ## Get the message format.[br][br]
    ##
    ## [param message]: ([member String]) Takes in a message.[br]
    ## [param log_level]: ([member LoggingLevel] or [member int]) Specifies the
    ## level of log.[br]
    ## [param file_only]: ([member bool]) Default to not using only file
    ## name.[br]
    ## [param obj]: ([member Object]) Recommended to use [member self].
    func _get_formatted_message(message: String,
                                log_level: sf.LoggingLevel,
                                file_name_only: bool = false,
                                obj: Object = null) -> String:
        var msg: String = log_format_getter().format(
        {
            "message": message,
            "location": _get_caller_function_name(file_name_only, obj),
            "time": get_datetime(),
            "level": sf.LoggingLevel.keys()[log_level].rpad(5, " ")
        })
        return msg

    ## Internal helper to call print stack trace / print tree trace / quit on
    ## the owner node if available.[br][br]
    ##
    ## [param stack_trace]: ([member bool]) Do we print the stack trace?[br]
    ## [param tree_trace]: ([member bool]) Do we print the tree call?[br]
    ## [param b_quit]: ([member bool]) Do we quit after running this code?
    func _forward_node_calls(stack_trace: bool = false,
                             tree_trace: bool = false,
                             b_quit: bool = false) -> void:
        var main: MainLoop = Engine.get_main_loop()
        if _owner:
            if (stack_trace or sf.get_print_stack_enabled() and
                _owner.has_method("print_tree")):
                _owner.print_stack()
            elif stack_trace or sf.get_print_stack_enabled():
                print_stack()
            if tree_trace and _owner.has_method("print_tree"):
                _owner.print_tree()
            elif tree_trace:
                if main and main.has_method("print_tree"):
                    main.print_tree()
            if b_quit:
                if _owner and _owner.get_tree():
                    _owner.get_tree().quit()
                else:
                    if main and main.has_method("quit"):
                        main.quit()
        else:
            if stack_trace or sf.get_print_stack_enabled():
                print_stack()
            if tree_trace:
                if main and main.has_method("print_tree"):
                    main.print_tree()
            if b_quit:
                if main and main.has_method("quit"):
                    main.quit()

    ## Print messages to the console from the stack. Forward the node calls to
    ## the stack as well.[br][br]
    ##
    ## [param log_level]: ([member LoggingLevel] or [member int]) Specifies the
    ## level of log.[br]
    ## [param message]: ([member String]) Takes in a message.[br]
    ## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
    ## something here, it will only be used when you're using
    ## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].
    func _print_message(log_level: sf.LoggingLevel, message: String,
                        assertion: bool = true) -> void:
        if (log_level != sf.LoggingLevel.FATAL and
            sf.get_write_to_console_enabled()):
            print_rich("[color=%s]%s[/color]" %
                       [sf.get_color(log_level), message])
        match log_level:
            sf.LoggingLevel.TRACE:
                if sf.get_print_stack_enabled():
                    _forward_node_calls(true, true, false)
            sf.LoggingLevel.VERBOSE:
                if sf.get_print_stack_enabled():
                    _forward_node_calls(true, true, false)
            sf.LoggingLevel.SYSTEM:
                if sf.get_print_stack_enabled():
                    _forward_node_calls(true, false, false)
            sf.LoggingLevel.DEBUG:
                if sf.get_print_stack_enabled():
                    _forward_node_calls(true, false, false)
            sf.LoggingLevel.INFO:
                pass
            sf.LoggingLevel.SUCCESS:
                pass
            sf.LoggingLevel.WARNING:
                push_warning(message)
                _forward_node_calls(true, true, false)
            sf.LoggingLevel.ERROR:
                push_error(message)
                _forward_node_calls(true, true, false)
            sf.LoggingLevel.CRITICAL:
                push_error(message)
                _forward_node_calls(true, true, false)
            sf.LoggingLevel.FATAL:
                push_error(message)
                printerr(message)
                _forward_node_calls(true, true, true)
            sf.LoggingLevel.ASSERT:
                assert(assertion)
                if sf.get_print_stack_enabled():
                    _forward_node_calls(true, false, false)
            sf.LoggingLevel.NETWORK:
                if sf.get_print_stack_enabled():
                    _forward_node_calls(true, true, false)
            sf.LoggingLevel.PERFORMANCE:
                pass
            _:
                print_rich(message)

    ## Removes Bulletin Board Code. It also removes the double tab.[br][br]
    ##
    ## [param message]: ([member String]) Takes in a message.[br]
    ## Returns a string.
    func _remove_bbc(message: String) -> String:
        var l_idx: int = message.find("[", 27)
        while l_idx >= 0:
            var r_idx: int = message.find("]", 27)
            message = message.erase(l_idx, r_idx - l_idx + 1)
            l_idx = message.find("[", 27)
        message = message.replace("\n\t\t", "")
        return message

    ## Write message to log.[br][br]
    ##
    ## [param message]: ([member String]) Takes in a message.
    func write_logs(message: String) -> void:
        if not sf.get_write_to_logs_enabled():
            return
        if not _file:
            load_file()             # If we don't have a file added, create it.
        _file.store_line(message)   # Store line in file
        _file.flush()               # Flush the buffer

    ## Log the message to the console and log[br][br]
    ##
    ## [param message]: ([member String]) Takes in a message.[br]
    ## [param log_level]: ([member LoggingLevel] or [member int]) Specifies log
    ## level. This is compared against the log enum in settings which is
    ## the most maximum level of log to print to screen.[br]
    ## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
    ## something here, it will only be used when you're using
    ## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].[br]
    ## [param obj]: ([member Object]) Recommended to use [member self].[br]
    ## [param file_name_only]: ([member bool]) Use only the file name.
    func log_message(message: String,
                     log_level: int = sf.LoggingLevel.INFO,
                     assertion: bool = true,
                     file_name_only: bool = false,
                     obj: Object = null) -> void:
        var msg: String = _get_formatted_message(message, log_level,
                                                 file_name_only, obj)
        if file_log_level_getter() <= log_level:
            if (OS.get_main_thread_id() != OS.get_thread_caller_id() &&
                log_level == sf.LoggingLevel.DEBUG):
                print_rich(("[%d] Cannot retrieve debug info outside the
                            main thread:\n\t%s") %
                            [OS.get_thread_caller_id(), msg])
                return
            emit_signal("message_logged", log_level, msg)
            _print_message(log_level, msg, assertion)
        if sf.return_current_file_enum() <= log_level:
            write_logs(_remove_bbc(msg))

    ## Get the path to the log file.[br][br]
    ##
    ## Returns the log path as a [member String].
    func _get_log_path() -> String:
        var path_array: Array = _log_path.rsplit(".", true, 1)
        var time: String = get_datetime(true)
        if Engine.is_editor_hint():
            return  "%s/editor_%s.%s" % [path_array[0], time, path_array[1]]
        return "%s/%s.%s" % [path_array[0], time, path_array[1]]

    ## Create the log file and recursively create its directory.[br]
    ## Set the internal value [member _file] as the actively opened log.
    func load_file() -> void:
        var filename: String = _get_log_path()
        DirAccess.make_dir_recursive_absolute(filename.get_base_dir())
        _file = FileAccess.open(filename, FileAccess.WRITE)

## Initalize class and set default information.
func _init() -> void:
    log_blueprint = LogBlueprint.new()
    log_blueprint.owner_setter(self)

## Attain the input object, format it to a string and return.[br][br]
##
## [param value]: ([member Variant]) Takes in a message or object.[br]
static func _format_in_msg(value: Variant) -> String:
    var in_val: String = type_string(typeof(value))
    var tabs_needed = len(in_val) / 3
    # var char_length = len(in_val) % 3
    var tab_amt: String
    match tabs_needed:
        0:
            tab_amt = "\t\t\t\t\t"
        1:
            tab_amt = "\t\t\t\t"
        2:
            tab_amt = "\t\t\t"
        3:
            tab_amt = "\t\t"
        4:
            tab_amt = "\t"
        5:
            tab_amt = ""
    return "[%s]%s| %s" % [in_val, tab_amt, value]

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param level]: ([member LoggingLevel] or [member int]) Specifies log
## level.[br]\
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.[br]
## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
## something here, it will only be used when you're using
## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].
static func _log_message(message: Variant,
                         level: sf.LoggingLevel = sf.LoggingLevel.INFO,
                         obj: Object = null,
                         file_name_only: bool = false,
                         assertion: bool = true) -> void:
    if !log_blueprint:
        return
    var msg: String = _format_in_msg(message)
    log_blueprint.log_message(msg, level, assertion, file_name_only, obj)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.clr()[/code][br]
## - [code]p.clear_log()[/code][br]
##
## Use this to temporarily clear the Godot Console. It prints 6 empty lines.
## To be more specific, this flushes the console.
static func _clear_console() -> void:
    print("\f")

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.t(message)[/code][br]
## - [code]p.trc(message)[/code][br]
## - [code]p.trace(message)[/code][br]
##
## Create a trace message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _trace(message: Variant, obj: Object = null,
            file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.TRACE, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.v(message)[/code][br]
## - [code]p.vrb(message)[/code][br]
## - [code]p.verbose(message)[/code][br][br]
##
## Create a verbose message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _verbose(message: Variant, obj: Object = null,
              file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.VERBOSE, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.d(message)[/code][br]
## - [code]p.dbg(message)[/code][br]
## - [code]p.debug(message)[/code][br][br]
##
## Create a debug message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _debug(message: Variant, obj: Object = null,
            file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.DEBUG, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.i(message)[/code][br]
## - [code]p.log(message)[/code][br]
## - [code]p.info(message)[/code][br][br]
##
## Create an info message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _info(message: Variant, obj: Object = null,
           file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.INFO, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.s(message)[/code][br]
## - [code]p.sys(message)[/code][br]
## - [code]p.system(message)[/code][br][br]
##
## Create a system message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _sys(message: Variant, obj: Object = null,
          file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.SYSTEM, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.y(message)[/code][br]
## - [code]p.yes(message)[/code][br]
## - [code]p.success(message)[/code][br][br]
##
## Create a success message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _success(message: Variant, obj: Object = null,
              file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.SUCCESS, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.w(message)[/code][br]
## - [code]p.wrn(message)[/code][br]
## - [code]p.warning(message)[/code][br][br]
##
## Create a warning message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _warning(message: Variant, obj: Object = null,
              file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.WARNING, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.e(message)[/code][br]
## - [code]p.err(message)[/code][br]
## - [code]p.error(message)[/code][br][br]
##
## Create an error message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _error(message: Variant, obj: Object = null,
            file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.ERROR, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.c(message)[/code][br]
## - [code]p.crit(message)[/code][br]
## - [code]p.critical(message)[/code][br][br]
##
## Create an critical message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _critical(message: Variant, obj: Object = null,
               file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.CRITICAL, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.f(message)[/code][br]
## - [code]p.ftl(message)[/code][br]
## - [code]p.fatal(message)[/code][br][br]
##
## Error out / halt the software with a fatal message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _fatal(message: Variant, obj: Object = null,
            file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.FATAL, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.a(message)[/code][br]
## - [code]p.asrt(message)[/code][br]
## - [code]p.assert(message)[/code][br][br]
##
## Assert with a message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param assertion]: ([member bool]) Add your conditional here.[br][br]
##
## Example:[br]
## var cond: bool = (1 == 1)[br]
## _assert('msg', cond)[br][br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _assert(message: Variant, assertion: bool, obj: Object = null,
             file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.ASSERT, obj, file_name_only, assertion)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.n(message)[/code][br]
## - [code]p.net(message)[/code][br]
## - [code]p.network(message)[/code][br][br]
##
## Create a network feedback message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _network(message: Variant, obj: Object = null,
              file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.NETWORK, obj, file_name_only)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Use one of the following:[br]
## - [code]p.p(message)[/code][br]
## - [code]p.prf(message)[/code][br]
## - [code]p.performance(message)[/code][br][br]
##
## Create a performance message.[br][br]
##
## [param message]: ([member Variant]) Takes in a message.[br]
## [param obj]: ([member Object]) Recommended to use [member self].[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func _performance(message: Variant, obj: Object = null,
                  file_name_only: bool = false) -> void:
    call_thread_safe("_log_message", message,
                     sf.LoggingLevel.PERFORMANCE, obj, file_name_only)
