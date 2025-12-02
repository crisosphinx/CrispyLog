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
## [param message]: ([member String]) Takes in a message.
func trace(message: String) -> void:
    _ms_log._trace(message)

## Create a verbose message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func verbose(message: String) -> void:
    _ms_log._verbose(message)

## Create a debug message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func debug(message: String) -> void:
    _ms_log._debug(message)
    
## Create a system message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func system(message: String) -> void:
    _ms_log._sys(message)

## Create an info message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func info(message: String) -> void:
    _ms_log._info(message)
    
## Create a success message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func success(message: String) -> void:
    _ms_log._success(message)

## Create a warning message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func warning(message: String) -> void:
    _ms_log._warning(message)

## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func error(message: String) -> void:
    _ms_log._error(message)

## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func critical(message: String) -> void:
    _ms_log._critical(message)
## Error out / halt the software with a fatal message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func fatal(message: String) -> void:
    _ms_log._fatal(message)

## Assert a message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
## something here, it will only be used when you're using
## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].
func assrt(message: String, assertion: bool) -> void:
    _ms_log._assert(message, assertion)

## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func network(message: String) -> void:
    _ms_log._network(message)

## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func performance(message: String) -> void:
    _ms_log._performance(message)

## Use this to temporarily clear the Godot Console. It prints 6 empty lines.
func clear_log() -> void:
    _ms_log._clear_console()

# ===================== Shorthand ============================== #

## [b][Shorthand][/b][br]
## Create a trace message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func trc(message: String) -> void:
    trace(message)

## [b][Shorthand][/b][br]
## Create a verbose message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func vrb(message: String) -> void:
    verbose(message)
    
## [b][Shorthand][/b][br]
## Create a debug message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func dbg(message: String) -> void:
    debug(message)
    
## [b][Shorthand][/b][br]
## Create an info message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func log(message: String) -> void:
    info(message)

## [b][Shorthand][/b][br]
## Create a system message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func sys(message: String) -> void:
    system(message)

## [b][Shorthand][/b][br]
## Create a success message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func yes(message: String) -> void:
    success(message)

## [b][Shorthand][/b][br]
## Create a warning message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func wrn(message: String) -> void:
    warning(message)

## [b][Shorthand][/b][br]
## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func err(message: String) -> void:
    error(message)

## [b][Shorthand][/b][br]
## Create a critical message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func crit(message: String) -> void:
    critical(message)

## [b][Shorthand][/b][br]
## Error out / halt the software with a fatal message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func ftl(message: String) -> void:
    fatal(message)

## [b][Shorthand][/b][br]
## Assert a message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
## something here, it will only be used when you're using
## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].
func asrt(message: String, assertion: bool) -> void:
    assrt(message, assertion)
    
## [b][Shorthand][/b][br]
## Create a network message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func net(message: String) -> void:
    network(message)

## [b][Shorthand][/b][br]
## Create a performance message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func prf(message: String) -> void:
    performance(message)

## [b][Shorthand][/b][br]
## Use this to temporarily clear the Godot Console. It prints 6 empty lines.
func clr() -> void:
    clear_log()

# ===================== Shorterhand ============================ #

## [b][Shorterhand][/b][br]
## Create a trace message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func t(message: String) -> void:
    trace(message)

## [b][Shorterhand][/b][br]
## Create a verbose message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func v(message: String) -> void:
    verbose(message)
    
## [b][Shorterhand][/b][br]
## Create a debug message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func d(message: String) -> void:
    debug(message)
    
## [b][Shorterhand][/b][br]
## Create an info message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func i(message: String) -> void:
    info(message)

## [b][Shorterhand][/b][br]
## Create a system message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func s(message: String) -> void:
    system(message)

## [b][Shorterhand][/b][br]
## Create a success message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func y(message: String) -> void:
    success(message)

## [b][Shorterhand][/b][br]
## Create a warning message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func w(message: String) -> void:
    warning(message)

## [b][Shorterhand][/b][br]
## Create an error message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func e(message: String) -> void:
    error(message)

## [b][Shorterhand][/b][br]
## Create a critical message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func c(message: String) -> void:
    critical(message)

## [b][Shorterhand][/b][br]
## Error out / halt the software with a fatal message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func f(message: String) -> void:
    fatal(message)

## [b][Shorterhand][/b][br]
## Assert a message.[br][br]
##
## [param message]: ([member String]) Takes in a message.[br]
## [param assertion]: ([member bool]) [b][OPTIONAL][/b] If you add
## something here, it will only be used when you're using
## [code]p.assrt[/code], [code]p.asrt[/code] or [code]p.a[/code].
func a(message: String, assertion: bool) -> void:
    assrt(message, assertion)

## [b][Shorterhand][/b][br]
## Create a network message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func n(message: String) -> void:
    network(message)

## [b][Shorterhand][/b][br]
## Create a performance message.[br][br]
##
## [param message]: ([member String]) Takes in a message.
func p(message: String) -> void:
    performance(message)
