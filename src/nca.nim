import
  os

import
  utils/[commands, keyhelper]


when defined(sms):
  const twofactor = "sms"
else:
  const twofactor = "push"


const
  description = "WARNING: all cisco anyconnect windows must be closed (ie Not in your dock)"


proc title() {.inline.} =
  echo "NCA Connect (Nim Cisco Anyconnect)"
  echo "----------------------------------"


proc help(msg: string = "") =
  echo description
  echo "Commands:"
  echo ""
  echo "  c, connect         Connect vpn given a [profile]"
  echo "  d, disconnect      Disconnect vpn"
  echo "  p, profiles        Attempt to list profiles"
  echo "  s, status          Determine if you are connected or not"
  echo "  D, delete          Deletes a stored profile from keyring"
  echo ""
  echo "Arguments:"
  echo ""
  echo "  [PROFILE]       The profile to connect to. Default: WGU"
  echo ""
  echo "Examples:"
  echo ""
  echo "  ./nca c"
  echo "  ./nca connect WGU"
  echo "  ./nca connect PROFILE"
  quit(msg, QuitFailure)


proc argparser(): array[2, string] {.raises: [IndexError].}=
  case paramCount():
    of 0:
      help()

    of 1:
      return [paramStr(1), "WGU"]

    of 2:
      return [paramStr(1), paramStr(2)]

    else:
      help("Bad parameter count")


proc sanityCheck() {.inline, raises: [].} =
  if not fileExists("/opt/cisco/anyconnect/bin/vpn"):
    quit("Missing vpn client", QuitFailure)
  if userName == "root":
    quit("Cant run as root.", QuitFailure)


proc handler() {.noconv.} =
  quit("\rUser has called exit via Ctrl+c", QuitFailure)
 

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
      let password = keyGetPassword(profile)
      connect(userName & r"\\n" & password & r"\\n" & twofactor, profile)

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

