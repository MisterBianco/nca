import
  os,
  strformat,
  terminal,
  strutils

import
  utils/keyhelper,
  utils/commands

const
  green = ansiForegroundColorCode(fgGreen)
  yellow = ansiForegroundColorCode(fgYellow)
  red = ansiForegroundColorCode(fgRed)
  bold = ansiStyleCode(styleBright)
  reset = ansiResetCode

const
  version = readFile("VERSION").strip()
  description = fmt"""
Tired of entering your password everytime your computer falls asleep
or after some time has passed but dont want to make security mad?
Just want to be able to use your keychain to store your password?
Hey lady have I got a deal for you. 

-- {bold}{red}WARNING{reset}: {bold}all cisco anyconnect windows must be closed (ie {red}Not{reset}{bold} in your dock){reset}
"""

proc title() {.inline.} =
  echo fmt"{red}NCA {green}Connect{reset} ({yellow}Nim Cisco Anyconnect{reset}) | {version}"
  echo "-----------------------------------------"

proc help(msg: string = "") =
  echo description
  echo fmt"{green}Commands{reset}:"
  echo ""
  echo "  c, connect         Connect vpn given a [profile]"
  echo "  d, disconnect      Disconnect vpn"
  echo "  p, profiles        Attempt to list profiles"
  echo "  s, status          Determine if you are connected or not"
  echo "  D, delete          Deletes a stored profile from keyring"
  echo ""
  echo fmt"{yellow}Arguments{reset}:"
  echo ""
  echo "  [PROFILE]       The profile to connect to. Default: WGU"
  echo ""
  echo fmt"{yellow}Examples{reset}:"
  echo ""
  echo "  ./nca c"
  echo "  ./nca connect WGU"
  echo "  ./nca connect PROFILE"
  if msg != "":
    echo ""
    echo fmt"{red}Error{reset}: " & msg

  quit(QuitFailure)


proc argparser(): array[2, string] =
  case paramCount():
    of 0:
      help()
    of 1:
      return [paramStr(1), "WGU"]
    of 2:
      return [paramStr(1), paramStr(2)]
    else:
      help("Bad parameter count")


proc sanityCheck() {.inline.} =
  if not fileExists("/opt/cisco/anyconnect/bin/vpn"):
    echo "Missing vpn client"
    quit(QuitFailure)
  if userName == "root":
    echo "Cant run as root."
    quit(QuitFailure)


proc handler() {.noconv.} =
  echo "User has called exit via Ctrl+c"
  quit 0
 

when isMainModule:
  setControlCHook(handler)

  title()
  sanityCheck()

  let 
    args = argparser()
  
    command = args[0]
    profile = args[1]

  case command:
    of "c", "connect":
      var password = keyGetPassword(profile)
      connect(userName & r"\\n" & password & r"\\npush", profile)
    of "d", "disconnect":
      disconnect()
    of "p", "profiles":
      profiles()
    of "D", "delete":
      keyDeletePassword(profile)
    of "s", "status":
      status()

    else:
      help("Bad command: " & command)

