# CrispyLog
 A Godot 4.4.x+ based logging tool that works for games and applications, alike. Tool is intended to create reeadable, traceable logs that help track-down common issues in your application while provided verbose logging features.

## How to Use this Plugin

### !! Note, if the settings changed are annoying and you want to revert, de-enable and re-enable the plugin to restore settings to the original settings.

- Download and place into this directory:
  - `res://addons/` so it should look like `res://addons/CrispyLog`
- Go to `Project -> Project Settings -> Plugins`
 - Enable the plugin by checking the `On` checkbox - it will look like below
 -  [x] On | CrispyLog | x.x.x | Jeff Miller
- Go to `General -> CrispyLog`
 - Open `Color Pairs` Dictionary
 - If you don't like a particular color, you can change it here.
- You can change the `Default Print` to which ever classification you might like.
 - Available Enums:
   - `Trace`
   - `Verbose`
   - `Debug`
   - `System`
   - `Info` (Defaults to this)
   - `Success`
   - `Warning`
   - `Error`
   - `Critical`
   - `Fatal`
   - `Assert`
   - `Network`
   - `Performance`
- Once installed you can call the following commands
  - Trace Level
    - `p.t(message: String)`
    - `p.trc(message: String)`
    - `p.trace(message: String)`
  - Verbose Level
    - `p.v(message: String)`
    - `p.vrb(message: String)`
    - `p.verbose(message: String)`
  - Debug Level
    - `p.d(message: String)`
    - `p.dbg(message: String)`
    - `p.debug(message: String)`
  - System Level
    - `p.s(message: String)`
    - `p.sys(message: String)`
    - `p.system(message: String)`
  - Info Level
    - `p.i(message: String)`
    - `p.log(message: String)`
    - `p.info(message: String)`
  - Success Level
    - `p.y(message: String)`
    - `p.yes(message: String)`
    - `p.success(message: String)`
  - Warning Level
    - `p.w(message: String)`
    - `p.wrn(message: String)`
    - `p.warning(message: String)`
  - Error Level
    - `p.e(message: String)`
    - `p.err(message: String)`
    - `p.error(message: String)`
  - Critical Level
    - `p.c(message: String)`
    - `p.crt(message: String)`
    - `p.critical(message: String)`
  - Fatal Level
    - `p.f(message: String)`
    - `p.ftl(message: String)`
    - `p.fatal(message: String)`
  - Assert Level
    - `p.a(message: String, assertion: bool)`
    - `p.asrt(message: String, assertion: bool)`
    - `p.assrt(message: String, assertion: bool)`
  - Network Level
    - `p.n(message: String)`
    - `p.net(message: String)`
    - `p.network(message: String)`
  - Performance Level
    - `p.p(message: String)`
    - `p.prf(message: String)`
    - `p.performance(message: String)`

## How the plugin works

For those who are more tech-saavy...

The plugin installs two globals:
- `sf` for settings functionality
- `p` for print

`sf` is used by all scripts in the plugin to attain the Log Level `enum`erator and Color Pair `Dictionary` keys and values. Any `private` functions or variables are underscored and are provided with callouts in the docstring to not be used directly.

Example:
```gdscript
static func _log_message(message: String,
                         level: sf.LoggingLevel = sf.LoggingLevel.INFO,
                         assertion: bool = true) -> void:
    # ...
```
This function is privatized. You *CAN* use it directly, but I highly recommend not as it will add more code to your project or potentially break currently placed functionality. If you want to use it directly, along with other functions or variables that are privatized in certain scripts, you can either create a `global` to reference the script or place it in the scene and reference that object.

For example, you could create an empty Node, assign the script, call the Node and then call the relative function or variable from another script when referencing that Node.

Example scene:
```
Scene
 |_Node       (named A)
    |_Script  (named log_message.gd) # contains function _log_message(message)
```
```gdscript
# From player.gd script
func _ready() -> void:
    A.LogMessage._log_message("hello world", sf.LoggingLevel.Debug, true)
    # Long winded and requires a lot of set up. 
    # Result displays in a green color:
    # DEBUG	[2025/12/02/02:26:57]	[player: _ready]
    #        hello world
    #
    # vs.
    #
    var date: String = "{year}/{month}/{day}/{hour}_{minute}_{second}".format(
        Time.get_datetime_dict_from_system(true)
    )
    print("DEBUG [%s] [%s] hello world" % [str(date), self.name])
    # Even longer-winded with special coloration. 
    # Result displays in a white color (default):
    # DEBUG [2025/12/2/2_32_55] [player] hello world
    #
    # vs.
    #
    p.d("hello world")
    # Works without having to implement anything special.
    # Result displays in a green color:
    # DEBUG	[2025/12/02/02:26:57]	[player: _ready]
    #        hello world
    #
```

## Logs

Log files save in Documents directory, regardless of system.
- Windows / Posix:
  - `C:\Users\[UserName]\Documents\.logs\[appname]\[year]\[month]\[day]\[hour_minute_second].log`
- Mac / Linux / Unix:
  - `~/Documents/.logs/[appname]/[year]/[month]/[day]/[hour_minute_second].log`
