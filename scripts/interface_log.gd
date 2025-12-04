# Copyright 2026 @ Jeff3DAnimation
@icon('../icons/logger.svg')
@tool
extends Node

## [b]Message Logger[/b][br][br]
##
## This class is what we call to get the hidden messaging functions.[br]
## Do not call [member MessageLog] directly if you plan on using the built-in
## shorthand functionality as prescribed by this entire plug-in.
static var _ms_log: MessageLog

## On the start of the game / experience, populate the scene appropriately.
func _ready() -> void:
    var ms_log: Node = Node.new()  ## Create a node to append a script to.
    var scrpt: Script = preload("res://addons/CrispyLog/scripts/message_log.gd")
    self.add_child(ms_log)
    ms_log.set_script(scrpt)
    _ms_log = ms_log  # Hack so we can eval the class here
    ms_log = null

## Create a trace message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func trace(message: String,
           obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._trace(message, obj, file_name_only)

## Create a verbose message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func verbose(message: String,
             obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._verbose(message, obj, file_name_only)

## Create a debug message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func debug(message: String,
           obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._debug(message, obj, file_name_only)
    
## Create a system message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func system(message: String,
            obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._sys(message, obj, file_name_only)

## Create an info message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func info(message: String,
          obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._info(message, obj, file_name_only)
    
## Create a success message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func success(message: String,
             obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._success(message, obj, file_name_only)

## Create a warning message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func warning(message: String,
             obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._warning(message, obj, file_name_only)

## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func error(message: String,
           obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._error(message, obj, file_name_only)

## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func critical(message: String,
              obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._critical(message, obj, file_name_only)

## Error out / halt the software with a fatal message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func fatal(message: String,
           obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._fatal(message, obj, file_name_only)

## Assert a message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
## something here, it will only be used when you're using
## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func assrt(message: String, assertion: bool,
           obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._assert(message, assertion, obj, file_name_only)

## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func network(message: String,
             obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._network(message, obj, file_name_only)

## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func performance(message: String,
                 obj: Object = null, file_name_only: bool = false) -> void:
    _ms_log._performance(message, obj, file_name_only)

## Use this to temporarily clear the Godot Console. It prints 6 empty lines.
func clear_log() -> void:
    _ms_log._clear_console()

# ===================== Shorthand ============================== #

## [b][Shorthand][/b][br]
## Create a trace message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func trc(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    trace(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Create a verbose message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func vrb(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    verbose(message, obj, file_name_only)
    
## [b][Shorthand][/b][br]
## Create a debug message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func dbg(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    debug(message, obj, file_name_only)
    
## [b][Shorthand][/b][br]
## Create an info message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func log(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    info(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Create a system message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func sys(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    system(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Create a success message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func yes(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    success(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Create a warning message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func wrn(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    warning(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func err(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    error(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Create a critical message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func crit(message: String,
          obj: Object = null, file_name_only: bool = false) -> void:
    critical(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Error out / halt the software with a fatal message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func ftl(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    fatal(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Assert a message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
## something here, it will only be used when you're using
## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func asrt(message: String, assertion: bool,
          obj: Object = null, file_name_only: bool = false) -> void:
    assrt(message, assertion, obj, file_name_only)
    
## [b][Shorthand][/b][br]
## Create a network message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func net(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    network(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Create a performance message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func prf(message: String,
         obj: Object = null, file_name_only: bool = false) -> void:
    performance(message, obj, file_name_only)

## [b][Shorthand][/b][br]
## Use this to temporarily clear the Godot Console. It prints 6 empty lines.
func clr() -> void:
    clear_log()

# ===================== Shorterhand ============================ #

## [b][Shorterhand][/b][br]
## Create a trace message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func t(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    trace(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Create a verbose message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func v(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    verbose(message, obj, file_name_only)
    
## [b][Shorterhand][/b][br]
## Create a debug message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func d(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    debug(message, obj, file_name_only)
    
## [b][Shorterhand][/b][br]
## Create an info message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func i(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    info(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Create a system message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func s(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    system(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Create a success message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func y(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    success(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Create a warning message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func w(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    warning(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func e(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    error(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Create a critical message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func c(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    critical(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Error out / halt the software with a fatal message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func f(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    fatal(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Assert a message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
## something here, it will only be used when you're using
## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func a(message: String, assertion: bool,
       obj: Object = null, file_name_only: bool = false) -> void:
    assrt(message, assertion, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Create a network message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func n(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    network(message, obj, file_name_only)

## [b][Shorterhand][/b][br]
## Create a performance message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param obj]: ([member Object]) Defaults to null - recommended "self".[br]
## [param file_name_only]: ([member bool]) Use only the file name.
func p(message: String,
       obj: Object = null, file_name_only: bool = false) -> void:
    performance(message, obj, file_name_only)
