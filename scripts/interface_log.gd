# Copyright 2026 @ Jeff3DAnimation
tool
extends Node

# Message Logger
#
# This class is what we call to get the hidden messaging functions.
# Do not call MessageLog directly if you plan on using the built-in
# shorthand functionality.
var _ms_log = null

# On the start of the game / experience, populate the scene appropriately.
func _ready():
	var ms_log = Node.new()  # Create a node to append a script to
	var scrpt = load("res://addons/CrispyLog/scripts/message_log.gd")
	add_child(ms_log)
	ms_log.set_script(scrpt)
	_ms_log = ms_log  # Hack so we can eval the class here
	ms_log = null

# ===================== Full names ===================== #

func trace(message, obj := null, file_name_only := false):
	_ms_log._trace(message, obj, file_name_only)

func verbose(message, obj := null, file_name_only := false):
	_ms_log._verbose(message, obj, file_name_only)

func debug(message, obj := null, file_name_only := false):
	_ms_log._debug(message, obj, file_name_only)

func system(message, obj := null, file_name_only := false):
	_ms_log._sys(message, obj, file_name_only)

func info(message, obj := null, file_name_only := false):
	_ms_log._info(message, obj, file_name_only)

func success(message, obj := null, file_name_only := false):
	_ms_log._success(message, obj, file_name_only)

func warning(message, obj := null, file_name_only := false):
	_ms_log._warning(message, obj, file_name_only)

func error(message, obj := null, file_name_only := false):
	_ms_log._error(message, obj, file_name_only)

func critical(message, obj := null, file_name_only := false):
	_ms_log._critical(message, obj, file_name_only)

func fatal(message, obj := null, file_name_only := false):
	_ms_log._fatal(message, obj, file_name_only)

func assrt(message, assertion, obj := null, file_name_only := false):
	_ms_log._assert(message, assertion, obj, file_name_only)

func network(message, obj := null, file_name_only := false):
	_ms_log._network(message, obj, file_name_only)

func performance(message, obj := null, file_name_only := false):
	_ms_log._performance(message, obj, file_name_only)

func clear_log():
	_ms_log._clear_console()

# ===================== Shorthand ===================== #

func trc(message, obj := null, file_name_only := false):
	trace(message, obj, file_name_only)

func vrb(message, obj := null, file_name_only := false):
	verbose(message, obj, file_name_only)

func dbg(message, obj := null, file_name_only := false):
	debug(message, obj, file_name_only)

func log(message, obj := null, file_name_only := false):
	info(message, obj, file_name_only)

func sys(message, obj := null, file_name_only := false):
	system(message, obj, file_name_only)

func yes(message, obj := null, file_name_only := false):
	success(message, obj, file_name_only)

func wrn(message, obj := null, file_name_only := false):
	warning(message, obj, file_name_only)

func err(message, obj := null, file_name_only := false):
	error(message, obj, file_name_only)

func crit(message, obj := null, file_name_only := false):
	critical(message, obj, file_name_only)

func ftl(message, obj := null, file_name_only := false):
	fatal(message, obj, file_name_only)

func asrt(message, assertion, obj := null, file_name_only := false):
	assrt(message, assertion, obj, file_name_only)

func net(message, obj := null, file_name_only := false):
	network(message, obj, file_name_only)

func prf(message, obj := null, file_name_only := false):
	performance(message, obj, file_name_only)

func clr():
	clear_log()

# ===================== Shorterhand ===================== #

func t(message, obj := null, file_name_only := false):
	trace(message, obj, file_name_only)

func v(message, obj := null, file_name_only := false):
	verbose(message, obj, file_name_only)

func d(message, obj := null, file_name_only := false):
	debug(message, obj, file_name_only)

func i(message, obj := null, file_name_only := false):
	info(message, obj, file_name_only)

func s(message, obj := null, file_name_only := false):
	system(message, obj, file_name_only)

func y(message, obj := null, file_name_only := false):
	success(message, obj, file_name_only)

func w(message, obj := null, file_name_only := false):
	warning(message, obj, file_name_only)

func e(message, obj := null, file_name_only := false):
	error(message, obj, file_name_only)

func c(message, obj := null, file_name_only := false):
	critical(message, obj, file_name_only)

func f(message, obj := null, file_name_only := false):
	fatal(message, obj, file_name_only)

func a(message, assertion, obj := null, file_name_only := false):
	assrt(message, assertion, obj, file_name_only)

func n(message, obj := null, file_name_only := false):
	network(message, obj, file_name_only)

func p(message, obj := null, file_name_only := false):
	performance(message, obj, file_name_only)
