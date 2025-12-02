# Copyright 2026 @ Jeff3DAnimation
@icon('../icons/logger.svg')
@tool
class_name CrispyLogSettings
extends Node

## [b][Logging Level][/b][br]
## We want to ensure that we can see and state what kind of message our message
## is. Important for filtering, notification and more.
enum LoggingLevel {
    NONE            = 0,
    TRACE           = 1,
    VERBOSE         = 2,
    DEBUG           = 3,
    SYSTEM          = 4,
    INFO            = 5,
    SUCCESS         = 6,
    WARNING         = 7,
    ERROR           = 8,
    CRITICAL        = 9,
    FATAL           = 10,
    ASSERT          = 11,
    NETWORK         = 12,
    PERFORMANCE     = 13,
}

# Constant values, please don't modify these.
const base: String = "CrispyLog/"       ## Base setting location value.
const cat_color: String = "Colors/"     ## Category named [b]Colors[/b].
const cat_avail: String = "Available/"  ## Category named [b]Available[/b].
const cat_level: String = "Levels/"     ## Category named [b]Levels[/b].
const prnt_stack_: String = base + cat_avail + "print_the_stack"
const enable_cnsl: String = base + cat_avail + "print_to_console"
const enable_logs: String = base + cat_avail + "write_to_log"
const enable_isot: String = base + cat_avail + "use_iso_time"
const color_pairs: String = base + cat_color + "color_pairs"
const dft_cnsl_lg: String = base + cat_level + "default_log"
const dft_file_lg: String = base + cat_level + "default_file_log"

## Color format[br]
## Simply, we want to visualize the messages in clear formats.
const MSG_COLORS: Dictionary[String, Color] = {
    "trace"         : "#000000FF",
    "verbose"       : "#A7B7DDFF",
    "debug"         : "#AAFFAAFF",
    "system"        : "#CCCCCCFF",
    "info"          : "#FFFFAAFF",
    "success"       : "#00FF00FF",
    "warning"       : "#FFA000FF",
    "error"         : "#FF8888FF",
    "critical"      : "#FF0000FF",
    "assert"        : "#FFFFFFFF",
    "network"       : "#0000FFFF",
    "performance"   : "#00AAAAFF",
}

## Creates the settings for this tool in:[br]
## [code]Project > Project Settings > General > CrispyLog[/code][br][br]
static func create_settings() -> void:
    if not ProjectSettings.has_setting(color_pairs):
        ProjectSettings.set_setting(color_pairs, MSG_COLORS)
        ProjectSettings.add_property_info({
            "name"          : color_pairs,
            "type"          : TYPE_DICTIONARY,
            "hint"          : PROPERTY_HINT_NONE,
            "usage"         : PROPERTY_USAGE_READ_ONLY,
            "category"      : "Colors"
        })
    if not ProjectSettings.has_setting(prnt_stack_):
        ProjectSettings.set_setting(prnt_stack_, false)
        ProjectSettings.add_property_info({
            "name"          : prnt_stack_,
            "type"          : TYPE_BOOL,
            "hint"          : PROPERTY_HINT_NONE,
            "usage"         : PROPERTY_USAGE_DEFAULT,
            "category"      : "Available"
        })
    if not ProjectSettings.has_setting(enable_cnsl):
        ProjectSettings.set_setting(enable_cnsl, true)
        ProjectSettings.add_property_info({
            "name"          : enable_cnsl,
            "type"          : TYPE_BOOL,
            "hint"          : PROPERTY_HINT_NONE,
            "usage"         : PROPERTY_USAGE_DEFAULT,
            "category"      : "Available"
        })
    if not ProjectSettings.has_setting(enable_logs):
        ProjectSettings.set_setting(enable_logs, true)
        ProjectSettings.add_property_info({
            "name"          : enable_logs,
            "type"          : TYPE_BOOL,
            "hint"          : PROPERTY_HINT_NONE,
            "usage"         : PROPERTY_USAGE_DEFAULT,
            "category"      : "Available"
        })
    if not ProjectSettings.has_setting(enable_isot):
        ProjectSettings.set_setting(enable_isot, false)
        ProjectSettings.add_property_info({
            "name"          : enable_isot,
            "type"          : TYPE_BOOL,
            "hint"          : PROPERTY_HINT_NONE,
            "usage"         : PROPERTY_USAGE_DEFAULT,
            "category"      : "Available"
        })
    if not ProjectSettings.has_setting(dft_cnsl_lg):
        ProjectSettings.set_setting(dft_cnsl_lg, LoggingLevel.INFO)
        ProjectSettings.add_property_info({
            "name"          : dft_cnsl_lg,
            "type"          : TYPE_INT,
            "hint"          : PROPERTY_HINT_ENUM,
            "hint_string"   : ",".join(LoggingLevel.keys()),
            "usage"         : PROPERTY_USAGE_DEFAULT,
            "category"      : "Levels"
        })
    if not ProjectSettings.has_setting(dft_file_lg):
        ProjectSettings.set_setting(dft_file_lg, LoggingLevel.DEBUG)
        ProjectSettings.add_property_info({
            "name"          : dft_file_lg,
            "type"          : TYPE_INT,
            "hint"          : PROPERTY_HINT_ENUM,
            "hint_string"   : ",".join(LoggingLevel.keys()),
            "usage"         : PROPERTY_USAGE_DEFAULT,
            "category"      : "Levels"
        })
    ProjectSettings.save()
    
## Deletes the settings for this tool in:[br]
## [code]Project > Project Settings > General > CrispyLog[/code][br][br]
static func delete_settings() -> void:
    var all_keys: Array = ProjectSettings.get_property_list()
    var result: Array[String] = []
    for prop in all_keys:
        if !prop.has("name"):
            continue
        var name: String = prop["name"]
        if !name.contains(base):
            continue
        result.append(name)
    for each in result:
        ProjectSettings.clear(each)

## [b]!!DO NOT USE THIS DIRECTLY!![/b][br][br]
##
## Get the color setting from [code]ProjectSettings[/code]. When received,
## translate data and attain the related hex code.[br][br]
##
## [param value]: ([member LoggingLevel] or [member int]) Takes in an enum.[br]
## Returns a string. If valid, we the hex. Otherwise we get
## [code]Invalid Request[/code][br][br]
##
## Example:[br]
## [code]
## var temp: String = _get_color_setting(LevelLogging.DEBUG)
## print(temp) # returns "#AAFFAAFF"
## [/code]
static func _get_color_setting(value: LoggingLevel) -> String:
    var all_keys: Array = ProjectSettings.get_property_list()
    var result: Dictionary[String, Color]
    for prop in all_keys:
        if !prop.has("name"):
            continue
        var name: String = prop["name"]
        if name != color_pairs:
            continue
        result = ProjectSettings.get_setting(name)
    if return_enum_name(value) in result.keys():
        return result[return_enum_name(value)].to_html()
    return "Invalid request"

## Get the color setting from [code]ProjectSettings[/code]. When received,
## translate data and attain the related hex code.[br][br]
##
## [param value]: ([member LoggingLevel] or [member int]) Takes in an enum.[br]
## Returns a string. If valid, we the hex. Otherwise we get
## [code]Invalid Request[/code][br][br]
##
## Example:[br]
## [code]
## var temp: String = get_color(LevelLogging.DEBUG)
## print(temp) # returns "#AAFFAAFF"
## [/code]
static func get_color(value: LoggingLevel) -> String:
    return _get_color_setting(value)

## Returns a [member bool] as the value of whether we print stack.
static func get_print_stack_enabled() -> bool:
    return ProjectSettings.get_setting(prnt_stack_)
    
## Returns a [member bool] as the value of whether we write to the console.
static func get_write_to_console_enabled() -> bool:
    return ProjectSettings.get_setting(enable_cnsl)

## Returns a [member bool] as the value of whether we write to logs.
static func get_write_to_logs_enabled() -> bool:
    return ProjectSettings.get_setting(enable_logs)

## Returns a [member bool] as the value of whether we use iso time.[br][br]
##
## Default is false.
static func get_iso_time_enabled() -> bool:
    return ProjectSettings.get_setting(enable_isot)

## Return the enumerator value as a string.[br][br]
##
## [param value]: ([member LoggingLevel] or [member int]) Takes in an enum.
static func return_enum_name(value: LoggingLevel) -> String:
    return LoggingLevel.keys()[value].to_lower()

## Return the current enumerator value as a int.
static func return_current_log_enum() -> int:
    return ProjectSettings.get_setting(dft_cnsl_lg)

## Return the current enumerator value as a int.
static func return_current_file_enum() -> int:
    return ProjectSettings.get_setting(dft_file_lg)
