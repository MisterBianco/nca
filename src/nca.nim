import
  os,
  strformat,
  terminal

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
  version = "0.0.2"
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

proc help(msg: string) =
  echo description
  echo fmt"{green}Commands{reset}:"
  echo ""
  echo "  connect         Connect vpn given a [profile]"
  echo "  disconnect      Disconnect vpn"
  echo "  profiles        Attempt to list profiles"
  echo "  delete          Deletes a stored profile from keyring"
  echo ""
  echo fmt"{yellow}Arguments{reset}:"
  echo ""
  echo "  [PROFILE]       The profile to connect to. Default: WGU"
  echo ""
  echo fmt"{yellow}Examples{reset}:"
  echo ""
  echo "  ./nca connect WGU"
  echo "  ./nca connect PROFILE"
  echo ""
  echo fmt"{red}Error{reset}: " & msg

  quit(QuitFailure)


proc argparser(): array[2, string] =
  case paramCount():
    of 0:
      help("Bad command | example: nca connect [PROFILE]")
    of 1:
      return [paramStr(1), "WGU"]
    of 2:
      return [paramStr(1), paramStr(2)]
    else:
      help("Bad parameter count")


proc sanityCheck(): bool {.inline.} =
  return fileExists("/opt/cisco/anyconnect/bin/vpn") and userName != "root"


proc handler() {.noconv.} =
  echo "User has called exit via Ctrl+c"
  quit 0
 

when isMainModule:
  setControlCHook(handler)
  title()
  if not sanityCheck():
    echo "Missing vpn client."
    quit(QuitFailure)

  let 
    args = argparser()
  
    command = args[0]
    profile = args[1]

  case command:
    of "connect":
      var password = keyGetPassword(profile)
      echo connect(userName & r"\\n" & password & r"\\npush", profile)

    of "disconnect":
      disconnect()

    of "profiles":
      profiles()

    of "delete":
      keyDeletePassword(profile)

    else:
      help("Bad command: " & command)

