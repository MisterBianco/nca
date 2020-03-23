import shell # DSL for shell commands

proc connect*(connStr: string, profile: string): string =
  shellAssign:
    result = pipe:
      printf ($connStr)
      "/opt/cisco/anyconnect/bin/vpn -s connect" ($profile)

proc disconnect*() =
  shell:
    one:
      "/opt/cisco/anyconnect/bin/vpn disconnect"

proc profiles*() =
  shell:
    pipe:
      "/opt/cisco/anyconnect/bin/vpn hosts"
      """grep ">""""
      """cut -d " " -f 6"""
